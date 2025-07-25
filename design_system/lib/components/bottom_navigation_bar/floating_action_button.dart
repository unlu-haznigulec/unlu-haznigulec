import 'package:design_system/components/exchange_overlay/widgets/darken_backgorund.dart';
import 'package:design_system/components/exchange_overlay/widgets/show_case_view.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PFloatingAction extends StatelessWidget {
  final void Function()? onPressed;
  final bool? isOverlayVisible;
  final ShowCaseViewModel? showCase;
  const PFloatingAction({
    super.key,
    this.onPressed,
    this.isOverlayVisible,
    this.showCase,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: showCase != null
          ? ShowCaseView(
              showCase: showCase!,
              targetRadius: BorderRadius.circular(
                Grid.xxl,
              ),
              tooltipBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Grid.m),
                topRight: Radius.circular(Grid.m),
                bottomLeft: Radius.circular(Grid.m),
                bottomRight: Radius.circular(Grid.xs),
              ),
              targetPadding: const EdgeInsets.all(
                Grid.s,
              ),
              tooltipPosition: TooltipPosition.top,
              child: DarkenBackgorund(
                isDarken: isOverlayVisible ?? false,
                borderRadius: 100,
                child: SizedBox(
                  height: 68,
                  width: 68,
                  child: FloatingActionButton(
                    backgroundColor: context.pColorScheme.primary,
                    shape: const CircleBorder(),
                    onPressed: onPressed,
                    child: Image.asset(
                      DesignImagesPath.piapiriCombinedShape,
                      height: 23,
                      width: 28,
                      color: context.pColorScheme.lightHigh,
                    ),
                  ),
                ),
              ),
            )
          : DarkenBackgorund(
              isDarken: isOverlayVisible ?? false,
              borderRadius: 100,
              child: SizedBox(
                height: 68,
                width: 68,
                child: FloatingActionButton(
                  backgroundColor: context.pColorScheme.primary,
                  shape: const CircleBorder(),
                  onPressed: onPressed,
                  child: Image.asset(
                    DesignImagesPath.piapiriCombinedShape,
                    height: 23,
                    width: 28,
                    color: context.pColorScheme.lightHigh,
                  ),
                ),
              ),
            ),
    );
  }
}
