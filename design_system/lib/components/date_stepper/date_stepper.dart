import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PDateStepper extends StatelessWidget {
  final String topText;
  final String bottomText;
  final TextStyle? textStyle;

  const PDateStepper({
    Key? key,
    this.topText = '',
    this.bottomText = '',
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: Grid.s,
              height: Grid.s,
              child: CircleAvatar(
                backgroundColor: context.pColorScheme.stroke.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(color: context.pColorScheme.lightHigh),
                ),
              ),
            ),
            const SizedBox(width: Grid.s),
            Text(
              topText,
              style: textStyle ?? context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 3),
          child: Container(
            height: 14,
            width: 2,
            color: context.pColorScheme.stroke.shade200,
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: Grid.s,
              height: Grid.s,
              child: CircleAvatar(
                backgroundColor: context.pColorScheme.stroke.shade200,
              ),
            ),
            const SizedBox(width: Grid.s),
            Text(
              bottomText,
              style: textStyle ?? context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            ),
          ],
        ),
      ],
    );
  }
}

class PDateStepperStyle2 extends StatelessWidget {
  final String topText;
  final String bottomText;

  const PDateStepperStyle2({
    Key? key,
    this.topText = '',
    this.bottomText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: context.pColorScheme.lightHigh,
                border: Border.all(color: context.pColorScheme.stroke.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: Grid.s),
            Text(
              topText,
              style: context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 5, bottom: Grid.xs, top: Grid.xs),
          child: Container(
            height: 32,
            width: 2,
            color: context.pColorScheme.stroke,
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: context.pColorScheme.lightHigh,
                border: Border.all(color: context.pColorScheme.stroke.shade300, width: 1.2),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: context.pColorScheme.stroke.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: Grid.s),
            Text(
              bottomText,
              style: context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            ),
          ],
        ),
      ],
    );
  }
}
