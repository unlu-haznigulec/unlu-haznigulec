import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final Function(String text) onChanged;
  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    required this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: context.pAppStyle.labelReg18textSecondary,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.pColorScheme.primary, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.pColorScheme.primary, width: 1.5),
        ),
        errorText: widget.errorText,
        errorStyle: context.pAppStyle.interRegularBase
            .copyWith(fontSize: Grid.s + Grid.xxs, color: context.pColorScheme.critical),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: Grid.s),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => setState(() {
              _isObscure = !_isObscure;
            }),
            child: SvgPicture.asset(
              _isObscure ? ImagesPath.eye_off : ImagesPath.eye_on,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 28,
          maxWidth: 19,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      obscureText: _isObscure,
      cursorWidth: 2,
      cursorHeight: 19,
      cursorColor: context.pColorScheme.primary,
      onChanged: widget.onChanged,
    );
  }
}
