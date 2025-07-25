import 'package:design_system/components/chip/chip.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class SymbolSearchChip extends StatelessWidget {
  final String text;
  final String index;
  final bool isSelected;
  final void Function(String index) onSelected;
  const SymbolSearchChip({
    super.key,
    required this.text,
    required this.index,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Grid.xs),
      child: SizedBox(
        height: 23,
        child: PChoiceChip(
          label: text,
          chipSize: ChipSize.small,
          labelStyle: TextStyle(
              color: isSelected ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
              fontSize: 12,
              fontFamily: isSelected ? 'Inter-Medium' : 'Inter-Regular'),
          selected: isSelected,
          selectedColor: context.pColorScheme.secondary,
          backgroundColor: context.pColorScheme.lightHigh,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(vertical: Grid.xs, horizontal: Grid.s + Grid.xs),
          borderSide:
              isSelected ? const BorderSide(color: Colors.transparent) : BorderSide(color: context.pColorScheme.stroke),
          onSelected: (bool selected) {
            onSelected(index);
          },
        ),
      ),
    );
  }
}
