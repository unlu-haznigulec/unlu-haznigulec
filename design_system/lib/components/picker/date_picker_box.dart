import 'package:design_system/components/picker/date_pickers.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerBox extends StatelessWidget {
  final String label;
  final IconData suffixIcon;
  final DateTime? initialDate;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback? onDatePickerTap;
  final String? error;

  const DatePickerBox({
    Key? key,
    required this.label,
    this.suffixIcon = StreamlineIcons.calendar,
    this.initialDate,
    this.maximumDate,
    this.minimumDate,
    required this.onChanged,
    this.onDatePickerTap,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        onDatePickerTap?.call();
        return showPDatePicker(
          context: context,
          initialDate: initialDate,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          onChanged: (DateTime? pickedDate) {
            if (pickedDate != null) {
              onChanged.call(pickedDate);
            }
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(Grid.s),
            decoration: BoxDecoration(
              color: context.pColorScheme.lightHigh,
              border: Border.all(
                color: error != null ? context.pColorScheme.critical : context.pColorScheme.iconPrimary.shade300,
              ),
              borderRadius: BorderRadius.circular(Grid.xs),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.s + Grid.xs + Grid.xxs,
                        height: lineHeight125,
                        color: error != null ? context.pColorScheme.critical : context.pColorScheme.darkMedium,
                      ),
                    ),
                    const SizedBox(height: Grid.xs),
                    Text(
                      _formattedDate(initialDate) ?? '',
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.m,
                        color: context.pColorScheme.darkHigh,
                        height: lineHeight150,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: Grid.xs, bottom: Grid.xs),
                  child: Icon(
                    suffixIcon,
                    color: context.pColorScheme.darkMedium,
                    size: Grid.m,
                  ),
                ),
              ],
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: Grid.xs, start: Grid.s),
              child: Text(
                error!,
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.s + Grid.xs + Grid.xxs,
                  color: context.pColorScheme.critical,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String? _formattedDate(DateTime? date) => date == null ? null : DateFormat('d MMM yyyy', 'en').format(date);
}
