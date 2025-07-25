import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/decimal_input_formatter.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CustomKeyboardTextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  final String label;
  final TextStyle labelStyle;
  final TextStyle? focusedLabelStyle;

  final bool hasTextControl;
  final bool isObscure;
  final bool isEnable;

  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final Function(bool)? onFocusChange;

  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final PValidator? validator;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final InputDecoration? inputDecoration;
  final bool showSeperator;
  final int maxDigitAfterSeperator;

  final Color? enabledColor;
  final Color? focusedColor;

  const CustomKeyboardTextfieldWidget({
    super.key,
    required this.controller,
    this.backgroundColor,
    required this.textStyle,
    required this.label,
    required this.labelStyle,
    this.focusedLabelStyle,
    this.hasTextControl = true,
    this.isObscure = false,
    this.isEnable = true,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.onFocusChange,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.inputDecoration,
    this.showSeperator = true,
    this.maxDigitAfterSeperator = 2,
    this.inputFormatters,
    this.validator,
    this.enabledColor,
    this.focusedColor,
  });

  @override
  State<CustomKeyboardTextfieldWidget> createState() => _CustomKeyboardTextfieldWidgetState();
}

class _CustomKeyboardTextfieldWidgetState extends State<CustomKeyboardTextfieldWidget> {
  late FocusNode _focusNode;
  late ValueNotifier<String> _notifier;

  late int selectionStart;
  late int selectionEnd;
  bool isSelectionActive = false;

  bool _hasText = false;
  late bool _isObscure;
  String? _errorText;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _notifier = ValueNotifier<String>('');

    _isObscure = widget.isObscure;
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

      if (widget.hasTextControl && widget.controller.text.isNotEmpty && !_hasText) {
        setState(() {
          _hasText = true;
        });
      } else if (widget.hasTextControl && widget.controller.text.isEmpty && _hasText) {
        setState(() {
          _hasText = false;
        });
      }
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
      } else if (widget.inputFormatters?.isNotEmpty == true) {
        {
          TextEditingValue currentValue = TextEditingValue(
            text: widget.controller.text,
            selection: TextSelection.collapsed(offset: widget.controller.text.length),
          );
          TextEditingValue newValue = TextEditingValue(
            text: _notifier.value,
            selection: TextSelection.collapsed(offset: _notifier.value.length),
          );
          for (var formatter in widget.inputFormatters!) {
            currentValue = formatter.formatEditUpdate(currentValue, newValue);
          }
          widget.controller.text = currentValue.text;
          widget.onChanged?.call(currentValue.text);
        }
      } else {
        widget.controller.text = _notifier.value;
        widget.onChanged?.call(_notifier.value);
      }

      if (widget.validator != null) {
        setState(() {
          _errorText = widget.validator?.validate.call(widget.controller.text);
        });
      }
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _notifier.value = widget.controller.text;
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
    widget.controller.removeListener(() {});
    _notifier.removeListener(() {});
    _focusNode.removeListener(() {});
    _notifier.dispose();
    _focusNode.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              readOnly: true,
              showCursor: true,
              enabled: widget.isEnable,
              focusNode: _focusNode,
              controller: widget.controller,
              style: widget.textStyle,
              obscureText: _isObscure,
              maxLines: 1,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: widget.inputFormatters,
              onTapOutside: widget.onTapOutside,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: widget.labelStyle,
                floatingLabelStyle: widget.focusedLabelStyle,
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText?.isNotEmpty == true
                        ? context.pColorScheme.critical
                        : !widget.hasTextControl
                            ? (widget.enabledColor ?? context.pColorScheme.textQuaternary)
                            : _hasText
                                ? (widget.enabledColor ?? context.pColorScheme.textQuaternary)
                                : (widget.focusedColor ?? context.pColorScheme.primary),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText?.isNotEmpty == true
                        ? context.pColorScheme.critical
                        : widget.focusedColor ?? context.pColorScheme.primary,
                    width: 1.0,
                  ),
                ),
                suffixIcon: widget.isObscure
                    ? InkWell(
                        child: Transform.scale(
                          scale: 0.4,
                          child: SvgPicture.asset(
                            _isObscure ? ImagesPath.eye_off : ImagesPath.eye_on,
                            width: 18,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(
                            () {
                              _isObscure = !_isObscure;
                            },
                          );
                        },
                      )
                    : null,
              ),
            ),
            if (_errorText?.isNotEmpty == true) ...{
              const SizedBox(height: Grid.xs),
              Text(
                _errorText!,
                style: context.pAppStyle.labelMed12primary.copyWith(
                  color: context.pColorScheme.critical,
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}
