import 'package:design_system/components/dropdown/dropdown_model.dart';
import 'package:design_system/components/selection_control/radio_select.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final List<DropdownModel> items;
  final Function(dynamic, String) onChanged;
  final T? selectedValue;
  final bool hasBorder;
  final Widget selectedWidget;
  final Widget? hint;
  final bool isExpanded;
  final String? title;
  final Color fillColor;
  final Color titleColor;
  final Color iconColor;
  final TextStyle? titleTextStyle;
  final TextStyle? valueTextStyle;
  final double? width;
  final double? maxHeight;
  final MenuItemStyleData? menuItemStyleData;
  final Widget? titleSuffixIcon;
  final double? dropdownHeight;
  final Offset? offset;

  const DropdownWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.hasBorder = false,
    required this.selectedWidget,
    this.hint,
    this.isExpanded = false,
    this.title,
    this.fillColor = Colors.transparent,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
    this.titleTextStyle,
    this.valueTextStyle,
    this.width,
    this.maxHeight,
    this.menuItemStyleData,
    this.titleSuffixIcon,
    this.dropdownHeight,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(
          color: hasBorder ? Theme.of(context).dividerColor : Colors.transparent,
          width: 0.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(
                top: titleSuffixIcon != null ? Grid.xs : Grid.s,
                left: Grid.s,
              ),
              child: SizedBox(
                // height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: titleTextStyle ??
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontFamily: 'Inter-Medium',
                                  letterSpacing: 0.5,
                                ),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: Grid.xs,
                        bottom: Grid.xs,
                      ),
                      child: titleSuffixIcon ?? const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          DropdownButton2(
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down_rounded,
              ),
              openMenuIcon: Icon(Icons.arrow_drop_up_rounded),
            ),
            style: valueTextStyle,
            value: selectedValue,
            menuItemStyleData: menuItemStyleData ?? const MenuItemStyleData(),
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: selectedWidget,
                );
              }).toList();
            },
            buttonStyleData: ButtonStyleData(
              height: dropdownHeight ?? 50,
              padding: EdgeInsets.only(
                left: width != null ? Grid.m : 0,
              ),
            ),
            hint: hint ?? const SizedBox.shrink(),
            isExpanded: isExpanded,
            underline: const SizedBox(),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: context.pColorScheme.transparent,
              ),
              offset: offset ?? Offset.zero,
              width: width,
              maxHeight: maxHeight ?? MediaQuery.of(context).size.height * .4,
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.value,
                    child: Row(
                      children: [
                        RadioSelectedIcon(isSelected: item.value == selectedValue),
                        if (item.icon != null) ...[
                          const SizedBox(
                            width: Grid.s,
                          ),
                          item.icon!,
                          const SizedBox(
                            width: Grid.s,
                          ),
                        ],
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 10,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              onChanged(value, items.firstWhere((element) => element.value == value).name);
            },
          ),
        ],
      ),
    );
  }
}
