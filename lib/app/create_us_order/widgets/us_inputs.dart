import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_amount_textfield.dart';
import 'package:piapiri_v2/common/widgets/p_quantity_textfield.dart';
import 'package:piapiri_v2/common/widgets/p_us_price_textfield.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsInputs extends StatelessWidget {
  final OrderActionTypeEnum action;
  final AmericanOrderTypeEnum orderType;
  final ScrollController? scrollController;
  final double tradeLimit;
  final num? sellableUnit;
  final num buyableUnit;
  final bool isQuantitative;
  final bool fractionable;
  final TextEditingController stopPriceController;
  final TextEditingController priceController;
  final TextEditingController unitController;
  final TextEditingController amountController;
  final Function(bool isQuantitative)? onSegmentChanged;
  final Function(double stopPrice)? onPriceChanged;
  final Function(double price)? onStopPriceChanged;
  final Function(double amount)? onAmountChanged;
  final Function(num unit)? onUnitChanged;
  final String pattern;

  const UsInputs({
    super.key,
    required this.action,
    required this.orderType,
    this.scrollController,
    required this.tradeLimit,
    this.sellableUnit,
    required this.buyableUnit,
    required this.isQuantitative,
    required this.fractionable,
    required this.stopPriceController,
    required this.priceController,
    required this.unitController,
    required this.amountController,
    this.onSegmentChanged,
    this.onPriceChanged,
    this.onStopPriceChanged,
    this.onAmountChanged,
    this.onUnitChanged,
    this.pattern = '#,##0.00',
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey priceKey = GlobalKey(debugLabel: 'usPrice');
    GlobalKey qtyKey = GlobalKey(debugLabel: 'usQTY');
    GlobalKey amountKey = GlobalKey(debugLabel: 'usAmount');
    GlobalKey stopKey = GlobalKey(debugLabel: 'usStop');
    bool isMarket = orderType == AmericanOrderTypeEnum.market || orderType == AmericanOrderTypeEnum.stop;
    bool isStop = orderType == AmericanOrderTypeEnum.stop || orderType == AmericanOrderTypeEnum.stopLimit;
    return Column(
      children: [
        if (!isMarket || action != OrderActionTypeEnum.buy) ...[
          SizedBox(
            height: 35,
            child: SlidingSegment(
              backgroundColor: context.pColorScheme.card,
              initialSelectedSegment: isQuantitative ? 0 : 1,
              segmentList: [
                PSlidingSegmentItem(
                  segmentTitle: L10n.tr('adet'),
                  segmentColor: context.pColorScheme.secondary,
                ),
                PSlidingSegmentItem(
                  segmentTitle: L10n.tr('tutar'),
                  segmentColor: context.pColorScheme.secondary,
                ),
              ],
              onValueChanged: (p0) => onSegmentChanged?.call(p0 == 0),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (isStop) ...[
          PUsPriceTextfield(
            key: stopKey,
            controller: stopPriceController,
            title: L10n.tr('stop_price'),
            pattern: stopPriceController.text.startsWith('0') ? pattern : '#,##0.00',
            onTapPrice: scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
              context,
              stopKey,
                      scrollController!,
            ),
            onPriceChanged: (price) => onStopPriceChanged?.call(price),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (!isMarket) ...[
          PUsPriceTextfield(
            key: priceKey,
            controller: priceController,
            pattern: priceController.text.startsWith('0') ? pattern : '#,##0.00',
            onTapPrice: scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
              context,
              priceKey,
                      scrollController!,
            ),
            onPriceChanged: (price) => onPriceChanged?.call(price),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
        if (isQuantitative) ...[
          PQuantityTextfield(
            key: qtyKey,
            controller: unitController,
            action: action,
            autoFocus: false,
            subtitle:
                '${action == OrderActionTypeEnum.buy ? '${L10n.tr('alinabilir_adet')}:' : '${L10n.tr('satilabilir_adet')}:'} ${action == OrderActionTypeEnum.buy ? MoneyUtils().fromReadableMoney(priceController.text) == 0 ? '-' : '~$buyableUnit' : MoneyUtils().readableMoney(sellableUnit ?? 0, pattern: MoneyUtils().getPatternByUnitDecimal(sellableUnit ?? 0))}',
            isError: action == OrderActionTypeEnum.sell &&
                sellableUnit != null &&
                MoneyUtils().fromReadableMoney(unitController.text) > sellableUnit!,
            errorText: action == OrderActionTypeEnum.sell &&
                    sellableUnit != null &&
                    MoneyUtils().fromReadableMoney(unitController.text) > sellableUnit!
                ? L10n.tr('insufficient_transaction_unit')
                : null,
            onTapSubtitle: () {
              num unit = action == OrderActionTypeEnum.buy ? buyableUnit : (sellableUnit ?? 0);
              unitController.text = MoneyUtils().readableMoney(
                unit,
                pattern: MoneyUtils().getPatternByUnitDecimal(unit),
              );
              onUnitChanged?.call(unit);
            },
            onTapQuantity: scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
              context,
              qtyKey,
                      scrollController!,
            ),
            isDoubleMode: fractionable,
            onUnitChanged: (unit) => onUnitChanged?.call(unit),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ] else ...[
          PAmountTextfield(
            key: amountKey,
            controller: amountController,
            action: action,
            pattern: pattern,
            currency: CurrencyEnum.dollar,
            isError: action == OrderActionTypeEnum.buy &&
                sellableUnit != null &&
                MoneyUtils().fromReadableMoney(amountController.text) > tradeLimit,
            errorText: '',
            onTapAmount: scrollController == null
                ? null
                : () => KeyboardUtils().scrollOnFocus(
              context,
              amountKey,
                      scrollController!,
            ),
            onAmountChanged: (amount) => onAmountChanged?.call(amount),
          ),
        ],
      ],
    );
  }
}
