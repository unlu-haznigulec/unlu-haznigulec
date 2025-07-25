import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';

class PFilterChip extends StatelessWidget {
  final String label;
  final ValueChanged<bool>? onSelected;
  final bool isSelected;
  final Color? selectedTextColor;
  final Color? textColor;
  final Color? backgroundColor;

  const PFilterChip({
    Key? key,
    required this.label,
    this.onSelected,
    required this.isSelected,
    this.selectedTextColor,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      key: const Key(GeneralKeys.pFilterChip),
      showCheckmark: false,
      selectedColor: context.pColorScheme.darkHigh,
      disabledColor: context.pColorScheme.textSecondary,
      backgroundColor: backgroundColor,
      label: Text(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Grid.xs)),
      selected: isSelected,
      labelStyle: context.pAppStyle.interMediumBase.copyWith(
        fontSize: Grid.m - Grid.xxs,
        letterSpacing: 1,
        height: lineHeight125,
        color: isSelected == false
            ? (textColor ?? context.pColorScheme.darkHigh)
            : (selectedTextColor ?? context.pColorScheme.lightHigh),
      ),
      onSelected: onSelected,
    );
  }
}

class PFilterChipList extends StatelessWidget {
  final List<PFilterChip> children;

  const PFilterChipList({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Grid.s,
      children: children,
    );
  }
}

class PHorizontalFilterChipList extends StatelessWidget {
  final List<PFilterChip> children;
  final EdgeInsets padding;
  final Color backgroundColor;

  const PHorizontalFilterChipList({
    Key? key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Grid.m,
      vertical: Grid.xs,
    ),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: padding,
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: Grid.s,
          children: children,
        ),
      ),
    );
  }
}

class PActionChip extends StatelessWidget {
  final Widget? icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PActionChip({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        label,
        style: context.pAppStyle.interMediumBase.copyWith(
          fontSize: Grid.m - Grid.xxs,
          letterSpacing: 1,
          height: lineHeight125,
          color: foregroundColor ?? context.pColorScheme.primary.shade500,
        ),
      ),
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? context.pColorScheme.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Grid.xs)),
      side: BorderSide(color: foregroundColor ?? context.pColorScheme.primary.shade500),
      labelPadding: const EdgeInsets.only(right: Grid.s),
      avatar: icon != null
          ? IconTheme(
              data: IconThemeData(color: foregroundColor ?? context.pColorScheme.primary.shade500),
              child: icon!,
            )
          : null,
    );
  }
}
