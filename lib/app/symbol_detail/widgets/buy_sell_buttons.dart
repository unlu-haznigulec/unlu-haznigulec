import 'package:design_system/components/button/button.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BuySellButtons extends StatelessWidget {
  final bool isBuyEnabled;
  final bool isSellEnabled;
  final Function() onTapBuy;
  final Function() onTapSell;

  const BuySellButtons({
    super.key,
    this.isBuyEnabled = true,
    this.isSellEnabled = true,
    required this.onTapBuy,
    required this.onTapSell,
  });

  @override
  Widget build(BuildContext context) {
    return generalButtonPadding(
      context: context,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSellEnabled)
          Expanded(
            child: PButton(
              text: L10n.tr('sat'),
              sizeType: PButtonSize.medium,
              variant: PButtonVariant.error,
              onPressed: onTapSell,
            ),
          ),
          if (isBuyEnabled && isSellEnabled)
          const SizedBox(
            width: Grid.s,
          ),
          if (isBuyEnabled)
          Expanded(
            child: PButton(
              text: L10n.tr('al'),
              variant: PButtonVariant.success,
              sizeType: PButtonSize.medium,
              onPressed: onTapBuy,
            ),
          ),
        ],
      ),
    );
  }
}
