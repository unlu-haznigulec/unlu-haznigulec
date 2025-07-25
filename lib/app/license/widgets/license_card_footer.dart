import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class LicenseCardFooter extends StatelessWidget {
  final String title;
  final String text;

  const LicenseCardFooter({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: context.pColorScheme.lightLow,
              ),
        ),
        const SizedBox(
          height: Grid.xs,
        ),
        Text(
          text,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: context.pColorScheme.lightMedium,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}
