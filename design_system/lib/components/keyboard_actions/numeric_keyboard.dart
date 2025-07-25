import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_custom.dart';

const double kKeyboardHeight = 250;
double kKeyboardBottomPadding = 34;

class NumpadKeyboard extends StatelessWidget with KeyboardCustomPanelMixin<String> implements PreferredSizeWidget {
  final bool showSeparator;
  final ValueNotifier<String> cNotifier;

  NumpadKeyboard({
    Key? key,
    required this.cNotifier,
    this.showSeparator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double rows = 4;
    const double columns = 3;
    const double vGap = 2 * Grid.m + 3 * Grid.s;
    const double hGap = 2 * Grid.m + 4 * Grid.s;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double itemWidth = (screenWidth - hGap) / columns;
    const double itemHeight = (kKeyboardHeight - vGap) / rows;
    return Container(
      height: kKeyboardHeight,
      width: screenWidth,
      padding: const EdgeInsets.all(Grid.m),
      color: context.pColorScheme.backgroundColor,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Grid.s,
        runSpacing: Grid.s,
        children: [
          numKey(
            context,
            value: '1',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '2',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '3',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '4',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '5',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '6',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '7',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '8',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          numKey(
            context,
            value: '9',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          Visibility(
            visible: showSeparator,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: separatorKey(
              context,
              itemWidth: itemWidth,
              itemHeight: itemHeight,
            ),
          ),
          numKey(
            context,
            value: '0',
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
          backspace(
            context,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
          ),
        ],
      ),
    );
  }

  Widget numKey(
    BuildContext context, {
    required String value,
    required double itemWidth,
    required double itemHeight,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: context.pColorScheme.transparent,
        minimumSize: Size(itemWidth, itemHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.xl),
        ),
        backgroundColor: context.pColorScheme.backgroundColor,
      ),
      onPressed: () {
        updateValue('${notifier.value}$value');
      },
      child: Text(
        value,
        style: context.pAppStyle.labelReg30iconPrimary,
      ),
    );
  }

  Widget backspace(
    BuildContext context, {
    required double itemWidth,
    required double itemHeight,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: context.pColorScheme.transparent,
        minimumSize: Size(itemWidth, itemHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.xl),
        ),
        backgroundColor: context.pColorScheme.backgroundColor,
      ),
      onPressed: () {
        if (notifier.value.isNotEmpty) {
          updateValue(notifier.value.substring(0, notifier.value.length - 1));
        }
      },
      child: Icon(
        Icons.backspace_outlined,
        size: Grid.l,
        color: context.pColorScheme.iconPrimary,
      ),
    );
  }

  Widget separatorKey(
    BuildContext context, {
    required double itemWidth,
    required double itemHeight,
  }) {
    final String locale = Intl.defaultLocale ?? 'tr';
    final String separator = locale == 'tr' ? ',' : '.';
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: context.pColorScheme.transparent,
        minimumSize: Size(itemWidth, itemHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Grid.xl),
        ),
        backgroundColor: context.pColorScheme.backgroundColor,
      ),
      onPressed: () {
        if (notifier.value.contains(separator)) {
          return;
        }
        if (notifier.value.isEmpty) {
          updateValue('0$separator');
          return;
        }
        updateValue('${notifier.value}$separator');
      },
      child: Text(
        separator,
        style: context.pAppStyle.labelReg30iconPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kKeyboardHeight + kKeyboardBottomPadding,
      );

  @override
  ValueNotifier<String> get notifier => cNotifier;
}
