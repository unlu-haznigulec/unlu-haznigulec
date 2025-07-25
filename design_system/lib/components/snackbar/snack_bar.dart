import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:p_core/route/page_navigator.dart';

FlashController<dynamic>? _activeSnackBar;

void showPSnackBar(
  String message, {
  String? buttonText,
  VoidCallback? buttonPressed,
  int duration = 3,
  bool longButton = false,
  double bottomMargin = 0,
  bool darkBackground = false,
  BuildContext? context,
  int maxLines = 10,
}) {
  _activeSnackBar?.dismiss();
  _activeSnackBar = null;

  final Widget _text = Padding(
    padding: EdgeInsetsDirectional.fromSTEB(Grid.m, Grid.m, longButton ? Grid.m : 0, longButton ? 0 : Grid.m),
    child: Text(
      message,
      style: (context ?? PageNavigator.globalContext!).pAppStyle.interRegularBase.copyWith(
            fontSize: Grid.s + Grid.xs + Grid.xxs,
            color: darkBackground
                ? (context ?? PageNavigator.globalContext!).pColorScheme.darkHigh
                : (context ?? PageNavigator.globalContext!).pColorScheme.lightHigh,
          ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    ),
  );
  final Widget _button = buttonText != null
      ? PTextButton(
          text: buttonText,
          variant: !darkBackground ? PButtonVariant.ghost : PButtonVariant.brand,
          onPressed: () {
            _activeSnackBar?.dismiss();
            if (buttonPressed != null) {
              buttonPressed();
            }
          },
        )
      : const SizedBox(height: Grid.m, width: Grid.m);

  if ((context ?? PageNavigator.globalContext) != null)
    showFlash(
      context: context ?? PageNavigator.globalContext!,
      duration: Duration(seconds: duration),
      builder: (_, FlashController<dynamic> controller) {
        _activeSnackBar = controller;
        return Flash<dynamic>(
          controller: controller,
          position: FlashPosition.bottom,
          child: longButton
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _text,
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: _button,
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    Expanded(child: _text),
                    _button,
                  ],
                ),
        );
      },
    ).then((_) {
      _activeSnackBar = null;
    });
}
