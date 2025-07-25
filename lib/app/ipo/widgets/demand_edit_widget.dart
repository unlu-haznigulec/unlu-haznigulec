import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DemandEdit extends StatefulWidget {
  final String initialValue;
  final Function(String) onFieldChanged;
  final Function() onEditingComplete;
  final bool enabled;

  const DemandEdit({
    super.key,
    required this.initialValue,
    required this.onFieldChanged,
    required this.onEditingComplete,
    required this.enabled,
  });

  @override
  _DemandEditState createState() => _DemandEditState();
}

class _DemandEditState extends State<DemandEdit> {
  late TextEditingController _editingController;
  final ValueNotifier<String> _notifier = ValueNotifier<String>('');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _editingController = TextEditingController(text: widget.initialValue);
    _notifier.value = widget.initialValue;
    _editingController.addListener(() {
      _notifier.value = _editingController.text;
    });
    _notifier.addListener(() {
      _editingController.text = _notifier.value;
      widget.onFieldChanged(_notifier.value);
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  KeyboardActionsConfig _getKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: context.pColorScheme.secondary,
      nextFocus: false,
      defaultDoneWidget: Text(
        L10n.tr('tamam'),
        style: context.pAppStyle.labelMed18primary,
      ),
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _focusNode,
          footerBuilder: (_) => NumpadKeyboard(
            cNotifier: _notifier,
            showSeparator: true,
          ),
          onTapAction: () {
            _focusNode.unfocus();
            _editingController.text = MoneyUtils().readableMoney(
              MoneyUtils().fromReadableMoney(
                _editingController.text,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _getKeyboardConfig(),
      autoScroll: false,
      disableScroll: true,
      tapOutsideBehavior: TapOutsideBehavior.none,
      child: Padding(
        padding: const EdgeInsets.all(
          Grid.xxs,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 55,
            ),
            child: IntrinsicWidth(
              child: TextField(
                controller: _editingController,
                readOnly: true,
                showCursor: true,
                textAlign: TextAlign.end,
                focusNode: _focusNode,
                enabled: widget.enabled,
                onChanged: widget.onFieldChanged,
                onSubmitted: widget.onFieldChanged,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                ),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  widget.onEditingComplete();
                },
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color: widget.enabled ? context.pColorScheme.primary : context.pColorScheme.textTeritary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  suffixText: CurrencyEnum.turkishLira.symbol,
                  suffixStyle: context.pAppStyle.labelMed14primary.copyWith(
                    color: widget.enabled ? context.pColorScheme.primary : context.pColorScheme.textTeritary,
                    letterSpacing: 0,
                  ),
                  fillColor: context.pColorScheme.card,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Grid.s + Grid.s,
                    vertical: 7,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: context.pColorScheme.transparent,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide(
                      color: context.pColorScheme.transparent,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Grid.m,
                      ),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
