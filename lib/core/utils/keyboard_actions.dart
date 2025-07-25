import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

KeyboardActionsConfig createKeyboardActionsConfig({
  required FocusNode focusNode,
  required ValueNotifier<String> notifier,
  required TextEditingController textEditingController,
  required bool showSeparator,
  void Function(bool)? onFocusChange,
  void Function(String)? onChanged,
}) {
  focusNode.addListener(() {
    if (focusNode.hasFocus) {
      notifier.value = textEditingController.text;
    }
    onFocusChange?.call(focusNode.hasFocus);
  });

  notifier.addListener(() {
    textEditingController.text = notifier.value;
    onChanged?.call(notifier.value);
  });

  return KeyboardActionsConfig(
    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
    nextFocus: false,
    keyboardBarColor: PageNavigator.globalContext?.pColorScheme.secondary,
    defaultDoneWidget: Text(
      L10n.tr('tamam'),
      style: TextStyle(
        color: PageNavigator.globalContext?.pColorScheme.primary,
        fontSize: Grid.m,
      ),
    ),
    actions: [
      KeyboardActionsItem(
        displayArrows: false,
        focusNode: focusNode,
        footerBuilder: (_) => NumpadKeyboard(
          cNotifier: notifier,
          showSeparator: showSeparator,
        ),
      ),
    ],
  );
}
