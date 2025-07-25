import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';

class PCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? backgroundColor;
  final double? height;
  final double? width;

  const PCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.backgroundColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Checkbox(
        key: const Key(BenefitsKeys.benefitsCheckbox),
        value: value,
        onChanged: onChanged,
        activeColor: context.pColorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Grid.xs,
          ),
        ),
      ),
    );
  }
}

class PCheckboxRow extends StatelessWidget {
  final bool value;
  final String? label;
  final Widget? labelWidget;
  final ValueChanged<bool?>? onChanged;
  final TextStyle? lableStyle;
  final bool removeCheckboxPadding;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;

  const PCheckboxRow({
    Key? key,
    required this.value,
    this.label,
    this.labelWidget,
    this.onChanged,
    this.lableStyle,
    this.removeCheckboxPadding = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.padding,
  })  : assert(onChanged != null || (label == null || labelWidget == null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        key: key,
        onTap: onChanged != null
            ? () {
                onChanged!(!value);
              }
            : null,
        child: Container(
          color: context.pColorScheme.transparent,
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: <Widget>[
              SizedBox(
                width: removeCheckboxPadding ? 24 : null,
                height: removeCheckboxPadding ? 24 : null,
                child: PCheckbox(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
              Flexible(
                child: Container(
                  padding: padding ??
                      EdgeInsetsDirectional.only(
                        start: removeCheckboxPadding ? Grid.s : Grid.xs,
                        end: Grid.m,
                        bottom: Grid.s,
                      ),
                  child: label != null
                      ? Text(
                          label!,
                          style: lableStyle ?? context.pAppStyle.labelReg14textPrimary,
                        )
                      : labelWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
