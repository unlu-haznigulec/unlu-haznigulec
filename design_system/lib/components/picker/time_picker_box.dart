import 'package:design_system/components/picker/date_pickers.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class TimePickerBox extends StatelessWidget {
  final String label;
  final IconData suffixIcon;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final VoidCallback? onTimePickerTap;

  const TimePickerBox({
    Key? key,
    required this.label,
    this.suffixIcon = StreamlineIcons.arrow_down_1,
    this.initialTime,
    required this.onChanged,
    this.onTimePickerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        onTimePickerTap?.call();
        return showPTimePicker(
          context: context,
          initialTime: initialTime,
          onChanged: (TimeOfDay? pickedTime) {
            if (pickedTime != null) {
              onChanged.call(pickedTime);
            }
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Grid.s),
        decoration: BoxDecoration(
          color: context.pColorScheme.lightHigh,
          border: Border.all(color: context.pColorScheme.stroke.shade300),
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
                    color: context.pColorScheme.darkMedium,
                    height: lineHeight125,
                  ),
                ),
                const SizedBox(height: Grid.xs),
                Text(
                  initialTime?.format(context) ?? '',
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
    );
  }
}
