import 'package:design_system/components/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/keyboard_actions.dart';

class ChangePasswordTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final FormFieldValidator<String> validation;
  const ChangePasswordTextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.labelText,
    required this.validation,
  });

  @override
  State<ChangePasswordTextFieldWidget> createState() => _ChangePasswordTextFieldWidgetState();
}

class _ChangePasswordTextFieldWidgetState extends State<ChangePasswordTextFieldWidget> {
  late KeyboardActionsConfig _keyboardActionsConfig;
  late FocusNode _focusNode;
  bool _obscure = true;
  final ValueNotifier<String> _notifier = ValueNotifier<String>('');
  @override
  initState() {
    _focusNode = FocusNode(debugLabel: widget.labelText);

    _keyboardActionsConfig = createKeyboardActionsConfig(
      focusNode: _focusNode,
      notifier: _notifier,
      showSeparator: false,
      textEditingController: widget.textEditingController,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _keyboardActionsConfig,
      autoScroll: false,
      disableScroll: true,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      child: PTextField.password(
        readOnly: true,
        focusNode: _focusNode,
        controller: widget.textEditingController,
        label: widget.labelText,
        labelColor: context.pColorScheme.textSecondary,
        imagePath: _obscure ? ImagesPath.eye_off : ImagesPath.eye_on,
        onObscure: (obscure) {
          setState(() {
            _obscure = obscure;
          });
        },
        validator: PValidator(
          focusNode: _focusNode,
          validate: widget.validation,
        ),
      ),
    );
  }
}
