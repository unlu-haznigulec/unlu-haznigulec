import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IndicatorBadge extends StatelessWidget {
  final double height;
  final double? width;
  final String text;
  final bool isUpperCase;
  final bool rounded;
  final bool bold;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  const IndicatorBadge({
    super.key,
    this.text = '',
    this.height = 20,
    this.width,
    this.rounded = false,
    this.bold = false,
    this.isUpperCase = true,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: Grid.s),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.pColorScheme.backgroundColor,
        borderRadius: BorderRadius.circular(rounded ? Grid.s + Grid.xs / 2 : Grid.xs),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          textAlign: TextAlign.center,
          style: bold
              ? context.pAppStyle.interMediumBase
                  .copyWith(fontSize: Grid.m - Grid.xs, color: textColor ?? context.pColorScheme.lightHigh)
              : context.pAppStyle.interRegularBase
                  .copyWith(fontSize: Grid.m - Grid.xs, color: textColor ?? context.pColorScheme.lightHigh),
        ),
      ),
    );
  }
}

class NewFeatureBadge extends StatelessWidget {
  const NewFeatureBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: context.pColorScheme.critical,
        shape: BoxShape.circle,
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final double size;

  const NotificationBadge({Key? key, this.size = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: context.pColorScheme.critical,
            shape: BoxShape.circle,
          ),
          height: size,
          width: size,
        ),
      ],
    );
  }
}
