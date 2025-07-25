import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/keyboard_actions.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PasswordTypeWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String labelText;
  final bool autoFocus;
  final Function(String)? onPressedDone;

  const PasswordTypeWidget({
    super.key,
    required this.textEditingController,
    required this.labelText,
    required this.autoFocus,
    this.onPressedDone,
  });

  @override
  State<PasswordTypeWidget> createState() => _PasswordTypeWidgetState();
}

class _PasswordTypeWidgetState extends State<PasswordTypeWidget> {
  bool _visiblePassword1 = true;
  late KeyboardActionsConfig _keyboardActionsConfig;
  late FocusNode _focusNode;
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
      child: TextFormField(
        readOnly: true,
        focusNode: _focusNode,
        controller: widget.textEditingController,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
        keyboardType: TextInputType.number,
        obscureText: _visiblePassword1,
        cursorColor: context.pColorScheme.lightHigh,
        decoration: _inputDecoration(),
        autofocus: widget.autoFocus,
        onFieldSubmitted: widget.onPressedDone,
        style: TextStyle(
          color: context.pColorScheme.lightHigh,
          fontSize: 16,
          fontFamily: 'Inter-Medium',
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: context.pColorScheme.primary.shade400,
      labelText: widget.labelText,
      labelStyle: TextStyle(
        color: context.pColorScheme.lightMedium,
        fontFamily: 'Inter-Medium',
        fontSize: 14,
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _passwordObscureIcon(),
          const SizedBox(width: 10),
          _forgotPasswordWidget(),
          const SizedBox(width: 5),
        ],
      ),
      border: InputBorder.none,
    );
  }

  Widget _passwordObscureIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _visiblePassword1 = !_visiblePassword1;
        });
      },
      child: Icon(
        _visiblePassword1 ? Icons.visibility_off : Icons.visibility,
        color: context.pColorScheme.lightHigh,
        size: 16,
      ),
    );
  }

  Widget _forgotPasswordWidget() {
    return GestureDetector(
      onTap: () => _goForgotPasswordPage(),
      child: Text(
        L10n.tr('sifremi_unuttum'),
        style: TextStyle(
          color: context.pColorScheme.lightMedium,
          fontSize: 14,
          fontFamily: 'Inter-Medium',
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  _goForgotPasswordPage() {
    //TODO(taha): fix routing
    // router.push(
    //   const ForgotPasswordRoute(),
    // );
  }
}
