import 'package:design_system/components/text_field/money_input_formatter.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';

class QuickPortfolioTileWidget extends StatefulWidget {
  final QuickPortfolioAssetModel modelPortfolio;
  final double totalAmount;
  final Function(bool) onChecked;
  final int numberOfSelectedAssets;
  final bool showDefault;
  final bool isChecked;
  final Function(double) onChangedRatio;
  final Function(bool) isFocus;

  const QuickPortfolioTileWidget({
    super.key,
    required this.modelPortfolio,
    required this.totalAmount,
    required this.onChecked,
    required this.numberOfSelectedAssets,
    required this.showDefault,
    required this.isChecked,
    required this.onChangedRatio,
    required this.isFocus,
  });

  @override
  State<QuickPortfolioTileWidget> createState() => _QuickPortfolioTileWidgetState();
}

class _QuickPortfolioTileWidgetState extends State<QuickPortfolioTileWidget> {
  final TextEditingController _ratioController = TextEditingController();
  double _ratio = 0;
  bool _isChanged = false;

  @override
  void initState() {
    _ratioController.text = MoneyUtils().readableMoney(widget.modelPortfolio.ratio);
    _ratio = widget.modelPortfolio.ratio;
    super.initState();
  }

  @override
  void didUpdateWidget(QuickPortfolioTileWidget oldWidget) {
    _ratioController.text = MoneyUtils().readableMoney(widget.modelPortfolio.ratio);
    _ratio = widget.modelPortfolio.ratio;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Grid.m),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CheckboxListTile(
              // contentPadding: const EdgeInsets.only(left: Grid.s),
              tileColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SymbolIcon(
                    size: 20,
                    symbolName: widget.modelPortfolio.name,
                    symbolType: SymbolTypes.equity,
                  ),
                  const SizedBox(width: Grid.xs),
                  Text(
                    widget.modelPortfolio.name,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ],
              ),
              activeColor: Theme.of(context).focusColor,
              value: widget.isChecked,
              onChanged: (bool? value) {
                widget.onChecked(value == true);
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Text(
            '₺${_calculateAmount()}',
            style: context.pAppStyle.labelReg14textPrimary.copyWith(
              fontWeight: FontWeight.w600,
              color: context.pColorScheme.textPrimary,
            ),
          ),
          Container(
            color: context.pColorScheme.transparent,
            child: Focus(
              onFocusChange: (value) {
                widget.isFocus(value);
                if (!value) {
                  widget.onChangedRatio(_ratio);
                }
              },
              child: SizedBox(
                width: 64,
                height: 31,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  enabled: widget.isChecked,
                  textAlign: TextAlign.center,
                  style: context.pAppStyle.labelReg14primary.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixText: '%',
                    prefixStyle: context.pAppStyle.labelReg14primary.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent, width: 0),
                      gapPadding: 8,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          Grid.s + Grid.xs,
                        ),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          Grid.s + Grid.xs,
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          Grid.s + Grid.xs,
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    fillColor: context.pColorScheme.card,
                    filled: true,
                  ),
                  inputFormatters: [
                    MoneyInputFormatter(),
                  ],
                  controller: _ratioController,
                  onSubmitted: (value) => widget.onChangedRatio(_ratio),
                  onTapOutside: (event) => widget.onChangedRatio(_ratio),
                  onChanged: (value) {
                    setState(() {
                      _isChanged = true;
                      _ratio = MoneyUtils().fromReadableMoney(value);
                      _ratioController.text = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAmount() {
    if (!widget.isChecked) {
      return MoneyUtils().readableMoney(0);
    }
    if (widget.showDefault && !_isChanged) {
      _ratioController.text = MoneyUtils().readableMoney(widget.modelPortfolio.ratio);
      return MoneyUtils().readableMoney(widget.totalAmount * widget.modelPortfolio.ratio / 100);
    }
    return MoneyUtils().readableMoney(widget.totalAmount * _ratio / 100);
  }
}
