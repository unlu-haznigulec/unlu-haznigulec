import 'package:design_system/components/selection_control/checkbox.dart';
import 'package:design_system/components/text_field/money_input_formatter.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/keyboard_actions.dart';

//Hazır portfoyler seçim tileleri
class ModelPortfolioTile extends StatefulWidget {
  final QuickPortfolioAssetModel modelPortfolio;
  final double totalAmount;
  final Function(bool) onChecked;
  final int numberOfSelectedAssets;
  final bool showDefault;
  final bool isChecked;
  final Function(double) onChangedRatio;
  final Function(bool) isFocus;
  final bool? fromUs;

  const ModelPortfolioTile({
    super.key,
    required this.modelPortfolio,
    required this.totalAmount,
    required this.onChecked,
    required this.numberOfSelectedAssets,
    required this.showDefault,
    required this.isChecked,
    required this.onChangedRatio,
    required this.isFocus,
    this.fromUs = false,
  });

  @override
  State<ModelPortfolioTile> createState() => _ModelPortfolioTileState();
}

class _ModelPortfolioTileState extends State<ModelPortfolioTile> {
  final TextEditingController _ratioController = TextEditingController();
  double _ratio = 0;
  bool _isChanged = false;
  late KeyboardActionsConfig _keyboardActionsConfig;
  late FocusNode _focusNode;
  final ValueNotifier<String> _notifier = ValueNotifier<String>('');

  @override
  void initState() {
    _ratioController.text = MoneyUtils().readableMoney(widget.modelPortfolio.ratio);
    _ratio = widget.modelPortfolio.ratio;
    _focusNode = FocusNode();

    _keyboardActionsConfig = createKeyboardActionsConfig(
      focusNode: _focusNode,
      notifier: _notifier,
      showSeparator: true,
      textEditingController: _ratioController,
    );
    _ratioController.addListener(() {
      _notifier.value = _ratioController.text;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(ModelPortfolioTile oldWidget) {
    _ratioController.text = MoneyUtils().readableMoney(widget.modelPortfolio.ratio);
    _ratio = widget.modelPortfolio.ratio;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s + Grid.xs,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              children: [
                PCheckbox(
                  width: Grid.l,
                  height: Grid.l,
                  value: widget.isChecked,
                  backgroundColor: Theme.of(context).focusColor,
                  onChanged: (bool? value) {
                    widget.onChecked(value == true);
                  },
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                SymbolIcon(
                  size: 15,
                  symbolName: widget.modelPortfolio.founderCode != null && widget.modelPortfolio.founderCode!.isNotEmpty
                      ? widget.modelPortfolio.founderCode ?? ''
                      : widget.modelPortfolio.code,
                  symbolType: widget.fromUs!
                      ? SymbolTypes.foreign
                      : widget.modelPortfolio.founderCode != null && widget.modelPortfolio.founderCode!.isNotEmpty
                          ? SymbolTypes.fund
                          : SymbolTypes.equity,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Text(
                  widget.modelPortfolio.code,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${widget.fromUs! ? CurrencyEnum.dollar.symbol : CurrencyEnum.turkishLira.symbol}${_calculateAmount()}',
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
          Flexible(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: KeyboardActions(
                autoScroll: false,
                disableScroll: true,
                config: _keyboardActionsConfig,
                tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
                child: Focus(
                  onFocusChange: (value) {
                    widget.isFocus(value);
                    if (!value) {
                      if (_ratio == 0) {
                        widget.onChecked(false);
                      }
                      _ratio = MoneyUtils().fromReadableMoney(_notifier.value);
                      widget.onChangedRatio(_ratio);
                      _isChanged = true;
                      _ratioController.text = _notifier.value;
                    }
                  },
                  child: IntrinsicWidth(
                    child: TextField(
                      focusNode: _focusNode,
                      readOnly: true,
                      showCursor: true,
                      cursorWidth: 1,
                      cursorColor: context.pColorScheme.primary,
                      cursorHeight: Grid.m,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enabled: widget.isChecked,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.top,
                      style: context.pAppStyle.labelMed14primary.copyWith(
                        color: _ratio == 0 ? context.pColorScheme.textTeritary : context.pColorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        prefixText: '%',
                        prefixStyle: context.pAppStyle.labelMed14primary.copyWith(
                            color: _ratio == 0 ? context.pColorScheme.textTeritary : context.pColorScheme.primary,
                            letterSpacing: 0),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Grid.s,
                        ),
                        constraints: const BoxConstraints(
                          maxWidth: 72,
                          maxHeight: 31,
                          minWidth: 72,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              Grid.m,
                            ),
                          ),
                        ),
                        fillColor: context.pColorScheme.card,
                        filled: true,
                      ),
                      inputFormatters: [
                        MoneyInputFormatter(),
                      ],
                      controller: _ratioController,
                    ),
                  ),
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
