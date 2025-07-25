import 'package:design_system/components/exchange_overlay/model/market_overlay_model.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketOverlayButton extends StatefulWidget {
  final MarketOverlayModel selectedOverlayModel;
  final bool isOverlayVisible;
  final Function onTap;
  const MarketOverlayButton({
    super.key,
    required this.selectedOverlayModel,
    required this.isOverlayVisible,
    required this.onTap,
  });

  @override
  State<MarketOverlayButton> createState() => _MarketOverlayButtonState();
}

class _MarketOverlayButtonState extends State<MarketOverlayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: context.pColorScheme.lightHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: IntrinsicWidth(
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.pColorScheme.secondary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  widget.selectedOverlayModel.assetPath,
                  package: DesignImagesPath.package,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Text(
                  widget.selectedOverlayModel.label,
                  style: context.pAppStyle.labelMed18primary,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                  widget.isOverlayVisible ? DesignImagesPath.chevron_up : DesignImagesPath.chevron_down,
                  package: DesignImagesPath.package,
                  colorFilter: ColorFilter.mode(context.pColorScheme.primary, BlendMode.srcIn),
                  width: 19,
                  height: 19,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
