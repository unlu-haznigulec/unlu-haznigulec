import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/decimal_input_formatter.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class QuickCashTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Color? backgroundColor;
  final TextStyle? fieldStyle;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(bool)? onFocusChange;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnable;
  final double? cursorWidth;
  final double? cursorHeight;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final InputDecoration? inputDecoration;
  final bool showSeperator;
  final int maxDigitAfterSeperator;
  final Function()? onTapPrice;

  const QuickCashTextfieldWidget({
    super.key,
    required this.controller,
    this.backgroundColor,
    required this.fieldStyle,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.onFocusChange,
    this.focusNode,
    this.inputFormatters,
    this.isEnable = true,
    this.cursorWidth,
    this.cursorHeight,
    this.textInputAction,
    this.keyboardType,
    this.textAlign,
    this.textAlignVertical,
    this.inputDecoration,
    this.showSeperator = true,
    this.maxDigitAfterSeperator = 2,
    this.onTapPrice,
  });

  @override
  State<QuickCashTextfieldWidget> createState() => _QuickCashTextfieldWidgetState();
}

class _QuickCashTextfieldWidgetState extends State<QuickCashTextfieldWidget> {
  late FocusNode _focusNode;
  late ValueNotifier<String> _notifier;
  late int selectionStart;
  late int selectionEnd;
  bool isSelectionActive = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _notifier = ValueNotifier<String>('');
    _notifier.value = widget.controller.text;
    selectionStart = widget.controller.selection.start;
    selectionEnd = widget.controller.selection.end;
    widget.controller.addListener(() {
      ///Text Selection yapildi ise secilen texti siler ve yeni texti ekler
      if (isSelectionActive) {
        if (widget.controller.text.substring(selectionStart, selectionEnd) == widget.controller.text) return;
        String newValue =
            widget.controller.text.replaceRange(selectionStart, selectionEnd, widget.controller.text.characters.last);
        newValue = newValue.substring(0, newValue.length - 1);
        selectionStart = newValue.length;
        selectionEnd = newValue.length;
        isSelectionActive = false;
        _notifier.value = newValue;
      }
      if (selectionStart != selectionEnd &&
          widget.controller.selection.start == -1 &&
          widget.controller.selection.end == -1) {
        isSelectionActive = !isSelectionActive;
        return;
      }

      selectionStart = widget.controller.selection.start;
      selectionEnd = widget.controller.selection.end;

      _notifier.value = widget.controller.text;
    });
    _notifier.addListener(() {
      if (widget.showSeperator) {
        final newValue = TextEditingValue(
          text: _notifier.value,
          selection: TextSelection.collapsed(offset: _notifier.value.length),
        );
        final formatted = DecimalInputFormatter(decimalRange: widget.showSeperator ? widget.maxDigitAfterSeperator : 0)
            .formatEditUpdate(widget.controller.value, newValue);
        widget.controller.text = formatted.text;
        widget.onChanged?.call(formatted.text);
      } else {
        widget.controller.text = _notifier.value;
        widget.onChanged?.call(_notifier.value);
      }
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _notifier.value = widget.controller.text;
        widget.onTapPrice?.call();
      } else {
        widget.onSubmitted?.call(widget.controller.text);
      }

      widget.onFocusChange?.call(_focusNode.hasFocus);
      isCustomKeyboardOpen.value = _focusNode.hasFocus;
    });
    super.initState();
  }

  @override
  void dispose() {
    _notifier.removeListener(() {});
    widget.controller.removeListener(() {});
    _focusNode.removeListener(() {});
    super.dispose();
  }

  KeyboardActionsConfig _getKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      keyboardBarColor: context.pColorScheme.secondary,
      keyboardSeparatorColor: context.pColorScheme.secondary,
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
            showSeparator: widget.showSeperator,
          ),
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
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: IntrinsicWidth(
            child: TextField(
              focusNode: _focusNode,
              enabled: widget.isEnable,
              showCursor: true,
              readOnly: true,
              cursorColor: context.pColorScheme.primary,
              cursorHeight: 19,
              textAlign: TextAlign.end,
              style: widget.fieldStyle,
              maxLines: 1,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onTap: null,
              inputFormatters: widget.inputFormatters,
              onTapOutside: widget.onTapOutside,
              controller: widget.controller,
              decoration: widget.inputDecoration,
            ),
          ),
        ),
      ),
    );
  }
}
