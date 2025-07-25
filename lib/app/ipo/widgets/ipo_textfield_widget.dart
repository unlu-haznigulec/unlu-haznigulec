import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoTextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool enable;
  final String hintText;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onFieldChanged;
  final Function()? onTapAction;
  final List<TextInputFormatter>? textInputFormatter;
  final FocusNode? focusNode;
  const IpoTextFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.enable,
    required this.hintText,
    this.onFieldSubmitted,
    this.onFieldChanged,
    this.onTapAction,
    this.textInputFormatter,
    this.focusNode,
  });

  @override
  State<IpoTextFieldWidget> createState() => _IpoTextFieldWidgetState();
}

class _IpoTextFieldWidgetState extends State<IpoTextFieldWidget> {
  late ValueNotifier<String> _notifier;
  late FocusNode _focusNode;

  @override
  initState() {
    super.initState();
    _notifier = ValueNotifier<String>(widget.title);
    _notifier.value = widget.controller.text;
    widget.controller.addListener(() {
      _notifier.value = widget.controller.text;
    });
    _notifier.addListener(() {
      widget.controller.text = _notifier.value;
      widget.onFieldChanged?.call(_notifier.value);
    });
    _focusNode = widget.focusNode ?? FocusNode();
  }

  KeyboardActionsConfig _getKeyboardConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: context.pColorScheme.secondary,
      keyboardSeparatorColor: context.pColorScheme.secondary,
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
      child: Container(
        color: context.pColorScheme.transparent,
        padding: const EdgeInsets.all(
          Grid.s,
        ),
        height: inputComponentHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).unselectedWidgetColor,
                    fontSize: 14,
                  ),
            ),
            SizedBox(
              height: 38,
              child: TextField(
                showCursor: true,
                readOnly: true,
                onTap: () {
                  widget.onTapAction?.call();
                },
                onTapAlwaysCalled: true,
                enabled: widget.enable,
                focusNode: _focusNode,
                textAlign: TextAlign.right,
                controller: widget.controller,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: widget.enable
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).unselectedWidgetColor,
                      fontSize: 14,
                    ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: widget.textInputFormatter ?? [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  fillColor: context.pColorScheme.transparent,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 12,
                      ),
                ),
                onChanged: widget.onFieldChanged,
                onSubmitted: widget.onFieldSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
