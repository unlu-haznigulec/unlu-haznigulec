import 'package:design_system/components/progress_indicator/progress_indicator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

/// Ask to designers and add to color scheme?
class PScrim extends StatelessWidget {
  final bool isEnabled;
  final bool showLoadingIndicator;
  final Widget child;

  final double opacity;
  final Duration speed;
  final Color? color;

  const PScrim({
    Key? key,
    required this.isEnabled,
    this.showLoadingIndicator = false,
    required this.child,
    this.opacity = 0.75,
    this.color,
    this.speed = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isEnabled,
      child: AnimatedContainer(
        duration: speed,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
        foregroundDecoration: BoxDecoration(
          color: (color ?? context.pColorScheme.iconPrimary.shade200).withOpacity(isEnabled ? opacity : 0.0),
        ),
        child: Stack(
          children: [
            child,
            if (showLoadingIndicator && isEnabled)
              PositionedDirectional(
                start: 0,
                top: 0,
                end: 0,
                bottom: 0,
                child: PCircularProgressIndicator(
                  size: Grid.xl,
                  loadingColor: context.pColorScheme.primary.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
