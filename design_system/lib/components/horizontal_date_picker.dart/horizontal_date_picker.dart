import 'dart:math';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _ItemState { disabled, selectable, selected }

class PHorizontalDatePicker extends StatefulWidget {
  final List<DateTime> items;
  final ValueChanged<int> onChanged;
  final PageController controller;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final int? minIndex;
  final int? maxIndex;
  final bool disabled;
  final double aspectRatio;

  const PHorizontalDatePicker({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.aspectRatio = 1,
    this.minIndex,
    this.maxIndex,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.disabled = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PHorizontalDatePickerState();
  }
}

class _PHorizontalDatePickerState extends State<PHorizontalDatePicker> {
  late PageController controller;
  late double pageFraction;
  int? minIndex;
  int? maxIndex;

  @override
  void initState() {
    controller = widget.controller; // If the list is empty and we get -1 we replace it with 0
    pageFraction = controller.initialPage.toDouble();
    _initMinAndMaxIndexes();
    super.initState();
  }

  @override
  void didUpdateWidget(PHorizontalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initMinAndMaxIndexes();
  }

  void _initMinAndMaxIndexes() {
    minIndex = widget.disabled ? controller.initialPage : widget.minIndex ?? 0;
    maxIndex = widget.disabled ? controller.initialPage : widget.maxIndex ?? max(widget.items.length - 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth * controller.viewportFraction;
    final double itemHeight = itemWidth / widget.aspectRatio + 3; // TODO(ozkan): Hack for ios

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            pageFraction = controller.page!;
            if (minIndex != null && pageFraction < minIndex! - 0.9) {
              controller.animateToPage(minIndex!, duration: const Duration(milliseconds: 200), curve: Curves.ease);
            } else if (maxIndex != null && pageFraction > maxIndex! + 0.9) {
              controller.animateToPage(maxIndex!, duration: const Duration(milliseconds: 200), curve: Curves.ease);
            }
          });
        }

        return false;
      },
      child: SizedBox(
        height: itemHeight,
        child: PageView.builder(
          physics: widget.disabled ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final bool isItemSelectable = !widget.disabled && index >= minIndex! && index <= maxIndex!;
            final _ItemState itemState = widget.disabled
                ? _ItemState.disabled
                : (index >= minIndex! && index <= maxIndex!)
                    ? index.toDouble() == pageFraction
                        ? _ItemState.selected
                        : _ItemState.selectable
                    : _ItemState.disabled;
            return InkWell(
              child: _HorizontalPickerItem(
                state: itemState,
                date: widget.items[index],
                height: itemHeight,
                width: itemWidth,
                textColor: !isItemSelectable
                    ? widget.disabledTextColor
                    : index.toDouble() == pageFraction
                        ? widget.selectedTextColor
                        : widget.unselectedTextColor,
              ),
              onTap: () {
                if (isItemSelectable) {
                  pageFraction = index.toDouble();
                  controller.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                }
              },
            );
          },
          onPageChanged: (int index) {
            if (!widget.disabled && index >= minIndex! && index <= maxIndex!) {
              widget.onChanged(index);
            }
          },
          controller: controller,
          itemCount: widget.items.length,
        ),
      ),
    );
  }
}

class _HorizontalPickerItem extends StatelessWidget {
  final DateTime date;
  final Color? textColor;
  final double? height;
  final double? width;
  final _ItemState state;

  const _HorizontalPickerItem({
    Key? key,
    required this.date,
    required this.height,
    required this.width,
    required this.textColor,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat.MMMM('en').format(date).substring(0, 3).toUpperCase(),
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m - Grid.xxs,
                letterSpacing: 1,
                color: state == _ItemState.disabled ? context.pColorScheme.darkLow : context.pColorScheme.darkMedium,
              ),
            ),
            const SizedBox(height: Grid.xs),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state == _ItemState.selected ? context.pColorScheme.primary.shade100 : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: context.pAppStyle.interRegularBase.copyWith(
                    color: state == _ItemState.selected
                        ? context.pColorScheme.primary.shade500
                        : state == _ItemState.selectable
                            ? context.pColorScheme.darkHigh
                            : context.pColorScheme.darkLow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
