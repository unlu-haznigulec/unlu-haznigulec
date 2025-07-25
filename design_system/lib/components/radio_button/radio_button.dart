import 'package:design_system/components/radio_button/radio_selected_button.dart';
import 'package:design_system/components/radio_button/radio_unselected_button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final ValueChanged<T?> onChanged;

  const PRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onChanged(value),
      child: Column(
        children: [
          Row(
            children: [
              _customRadioButton(context),
              const SizedBox(
                width: Grid.xs,
              ),
            ],
          ),
          const SizedBox(
            height: Grid.xs,
          ),
        ],
      ),
    );
  }

  Widget _customRadioButton(BuildContext context) {
    final isSelected = value == groupValue;

    return Row(
      children: [
        if (isSelected) const RadioSelectedButton() else const RadioUnselectedButton(),
        const SizedBox(
          width: Grid.s,
        ),
        Text(
          leading,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: context.pColorScheme.lightHigh,
              ),
        ),
      ],
    );
  }
}
