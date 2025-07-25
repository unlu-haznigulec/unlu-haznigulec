import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/order_validator.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/price_selector.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PPriceTextfield extends StatefulWidget {
  final String? title;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final OrderActionTypeEnum action;
  final Function(double newPrice) onPriceChanged;
  final Function(StopLossTakeProfit sltp)? onSLTPChanged;
  final MarketListModel? marketListModel;
  final Color? backgroundColor;
  final StopLossTakeProfit? stopLossTakeProfit;
  final Function()? onTapPrice;
  final double? currentPrice;
  final int maxDigitAfterSeparator;
  const PPriceTextfield({
    super.key,
    this.title,
    this.controller,
    this.focusNode,
    required this.action,
    required this.onPriceChanged,
    this.onSLTPChanged,
    required this.marketListModel,
    this.backgroundColor,
    this.stopLossTakeProfit,
    this.onTapPrice,
    this.currentPrice,
    this.maxDigitAfterSeparator = 2,
  });

  @override
  State<PPriceTextfield> createState() => _PPriceTextfieldState();
}

class _PPriceTextfieldState extends State<PPriceTextfield> {
  late TextEditingController _priceController;
  late FocusNode _focusNode;
  double limitDown = 0;
  double limitUp = 0;

  @override
  void initState() {
    super.initState();
    _priceController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double priceStep = 0.1;
    String symbolType = '';
    String marketCode = '';
    double price = 0;

    if (widget.marketListModel != null) {
      symbolType = widget.marketListModel!.type;
      marketCode = widget.marketListModel!.marketCode;
      if (stringToSymbolType(symbolType) != SymbolTypes.warrant &&
          stringToSymbolType(symbolType) != SymbolTypes.certificate) {
        if (MoneyUtils().fromReadableMoney(_priceController.text) > widget.marketListModel!.limitUp) {
          priceStep = Utils().getPriceStep(limitUp, symbolType, marketCode, widget.marketListModel!.subMarketCode,
              widget.marketListModel!.priceStep);
        } else if (MoneyUtils().fromReadableMoney(_priceController.text) < widget.marketListModel!.limitDown) {
          priceStep = Utils().getPriceStep(limitDown, symbolType, marketCode, widget.marketListModel!.subMarketCode,
              widget.marketListModel!.priceStep);
        } else {
          priceStep = Utils().getPriceStep(
            MoneyUtils().fromReadableMoney(_priceController.text),
            symbolType,
            marketCode,
            widget.marketListModel!.subMarketCode,
            widget.marketListModel!.priceStep,
          );
        }
        if (widget.marketListModel?.limitDown != null && widget.marketListModel?.limitDown != 0) {
          limitDown = (widget.marketListModel!.limitDown / priceStep).ceil() * priceStep;
          limitDown = double.parse(limitDown.toStringAsFixed(2));
        }
        if (widget.marketListModel?.limitUp != null && widget.marketListModel?.limitUp != 0) {
          limitUp = (widget.marketListModel!.limitUp / priceStep).floor() * priceStep;
          limitUp = double.parse(limitUp.toStringAsFixed(2));
        }
        double newPrice = MoneyUtils().getPrice(widget.marketListModel!, widget.action);
        price = newPrice == 0 ? widget.marketListModel!.basePrice : newPrice;
      }
    }

    return PValueTextfieldWidget(
      controller: _priceController,
      title: widget.title ?? L10n.tr('fiyat'),
      focusNode: _focusNode,
      suffixText: CurrencyEnum.turkishLira.symbol,
      backgroundColor: widget.backgroundColor,
      maxDigitAfterSeperator: widget.maxDigitAfterSeparator,
      prefix: widget.marketListModel == null ||
              stringToSymbolType(symbolType) == SymbolTypes.warrant ||
              stringToSymbolType(symbolType) == SymbolTypes.certificate
          ? null
          : GestureDetector(
              child: SvgPicture.asset(
                height: 17,
                width: 17,
                ImagesPath.sort_up_down,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                _showPriceSteps(
                  price,
                  priceStep,
                  limitUp,
                  limitDown,
                  symbolType,
                  marketCode,
                );
              },
            ),
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          double price = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
          price = OrderValidator.priceValidator(
            context,
            symbolName: widget.marketListModel!.symbolCode,
            price: price,
            limitUp: limitUp,
            limitDown: limitDown,
            type: stringToSymbolType(symbolType),
          );
          _priceController.text = MoneyUtils().readableMoney(price);
          widget.onPriceChanged(price);

          if (widget.stopLossTakeProfit != null) {
            StopLossTakeProfit sltp = OrderValidator.priceToStopLossValidator(
              context,
              price: price,
              limitUp: limitUp,
              limitDown: limitDown,
              action: widget.action,
              stopLossTakeProfit: widget.stopLossTakeProfit!,
              priceStep: Utils().getPriceStep(
                price,
                symbolType,
                marketCode,
                widget.marketListModel!.subMarketCode,
                widget.marketListModel!.priceStep,
              ),
            );
            widget.onSLTPChanged?.call(sltp);
          }
        } else {
          double price = _priceController.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
          if (price == 0) {
            _priceController.text = '';
          }
          widget.onTapPrice?.call();
        }
      },
    );
  }

  void _showPriceSteps(
    double price,
    double priceStep,
    double limitUp,
    double limitDown,
    String symbolType,
    String marketCode,
  ) {
    String pattern = widget.maxDigitAfterSeparator > 2 ? '#,##0.${'0' * widget.maxDigitAfterSeparator}' : '#,##0.00';
    List<double> priceSteps = MoneyUtils().getPriceSteps(
      price: price,
      priceStep: priceStep,
      limitUp: limitUp,
      limitDown: limitDown,
      symbolType: symbolType,
      marketCode: marketCode,
      pattern: pattern,
    );
    PBottomSheet.show(context,
        title: L10n.tr('fiyat'),
        titlePadding: const EdgeInsets.only(
          top: Grid.m,
        ),
        child: PriceSelector(
          priceSteps: priceSteps,
          currentPrice: MoneyUtils().fromReadableMoney(_priceController.text),
          pattern: pattern,
          onPriceChanged: (newPrice) {
            if (newPrice > limitUp) {
              newPrice = limitUp;
            } else if (newPrice < limitDown) {
              newPrice = limitDown;
            }
            _priceController.text = MoneyUtils().readableMoney(newPrice, pattern: pattern);

            widget.onPriceChanged(newPrice);
          },
        ));
  }
}
