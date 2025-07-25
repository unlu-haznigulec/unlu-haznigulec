import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:p_core/utils/platform_utils.dart';

class PDialog {
  static Future<T?> showAlertDialog<T>({
    BuildContext? context,
    String? title,
    Widget? customTitleWidget,
    String? message,
    Widget? content,
    bool autoPop = true,
    bool disableContentPadding = false,
    PDialogAction? positiveAction,
    PDialogAction? negativeAction,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
  }) {
    final Widget? titleWidget = customTitleWidget ?? (title != null ? Text(title) : null);
    final Widget? body = content ?? (message != null ? Text(message) : null);

    if (PlatformUtils.isIos) {
      return _showCupertinoDialog(
        context,
        titleWidget,
        body,
        positiveAction,
        negativeAction,
        autoPop,
        barrierDismissible,
        useRootNavigator,
      );
    } else {
      return _showMaterialDialog(
        context,
        titleWidget,
        body,
        negativeAction,
        positiveAction,
        autoPop,
        disableContentPadding,
        barrierDismissible,
        useRootNavigator,
      );
    }
  }

  static void showLoadingDialog({String? text, BuildContext? context, bool? useRootNavigator}) {
    showDialog(
      context: context ?? PageNavigator.globalContext!,
      barrierDismissible: false,
      useRootNavigator: useRootNavigator ?? true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Grid.m),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    ...text != null
                        ? <Widget>[
                            const SizedBox(width: Grid.m),
                            Expanded(
                              child: Text(text),
                            ),
                          ]
                        : <Widget>[],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showTextFieldDialog({
    BuildContext? context,
    String? title,
    TextEditingController? controller,
    String? hint,
    int? maxLines,
    PDialogAction? positiveAction,
    PDialogAction? negativeAction,
    bool numberField = false,
    bool useRootNavigator = true,
  }) {
    PDialog.showAlertDialog(
      context: context,
      title: title,
      content: _getDialogContent(
        numberField,
        controller,
        hint,
        maxLines,
      ),
      positiveAction: positiveAction,
      negativeAction: negativeAction,
      useRootNavigator: useRootNavigator,
    );
  }

  static Widget _getDialogContent(
    bool numberField,
    TextEditingController? controller,
    String? hint,
    int? maxLines,
  ) {
    if (PlatformUtils.isIos) {
      if (numberField) {
        return _getCupertinoTextFieldNumber(controller: controller, hint: hint);
      }
      return _getCupertinoTextField(
        controller: controller,
        hint: hint,
        maxLines: maxLines,
      );
    } else {
      if (numberField) {
        return _getMaterialTextFieldNumber(controller: controller, hint: hint);
      }
      return _getMaterialTextField(
        controller: controller,
        hint: hint,
        maxLines: maxLines,
      );
    }
  }

  static void showDoubleNumberTextFieldDialog({
    BuildContext? context,
    String? title,
    TextEditingController? controllerOne,
    TextEditingController? controllerTwo,
    FocusNode? focusNodeOne,
    FocusNode? focusNodeTwo,
    String? hintOne,
    String? hintTwo,
    PDialogAction? positiveAction,
    PDialogAction? negativeAction,
    bool autoPop = true,
    bool useRootNavigator = true,
  }) {
    PDialog.showAlertDialog(
      context: context,
      title: title,
      autoPop: autoPop,
      content: PlatformUtils.isIos
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _getCupertinoTextFieldNumber(
                  controller: controllerOne,
                  hint: hintOne,
                  focusNode: focusNodeOne,
                  firstField: true,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                _getCupertinoTextFieldNumber(
                  controller: controllerTwo,
                  hint: hintTwo,
                  focusNode: focusNodeTwo,
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _getMaterialTextFieldNumber(
                  controller: controllerOne,
                  hint: hintOne,
                  focusNode: focusNodeOne,
                  firstField: true,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                _getMaterialTextFieldNumber(
                  controller: controllerTwo,
                  hint: hintTwo,
                  focusNode: focusNodeTwo,
                ),
              ],
            ),
      positiveAction: positiveAction,
      negativeAction: negativeAction,
      useRootNavigator: useRootNavigator,
    );
  }
}

Widget _getMaterialTextField({
  TextEditingController? controller,
  String? hint,
  int? maxLines,
}) {
  return TextField(
    controller: controller,
    autofocus: true,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
    ),
  );
}

Widget _getCupertinoTextField({
  TextEditingController? controller,
  String? hint,
  int? maxLines,
}) {
  return CupertinoTextField(
    padding: const EdgeInsets.only(top: Grid.s),
    controller: controller,
    autofocus: true,
    placeholder: hint,
    maxLines: maxLines,
  );
}

Widget _getMaterialTextFieldNumber({
  TextEditingController? controller,
  FocusNode? focusNode,
  String? hint,
  bool firstField = false,
}) {
  return TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      _getDecimalInputFormatter(),
    ],
    focusNode: focusNode,
    textInputAction: firstField ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      hintText: hint,
    ),
  );
}

Widget _getCupertinoTextFieldNumber({
  TextEditingController? controller,
  FocusNode? focusNode,
  String? hint,
  bool firstField = false,
}) {
  return CupertinoTextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      _getDecimalInputFormatter(),
    ],
    focusNode: focusNode,
    textInputAction: firstField ? TextInputAction.next : TextInputAction.done,
    placeholder: hint,
  );
}

TextInputFormatter _getDecimalInputFormatter() {
  return TextInputFormatter.withFunction(
    (TextEditingValue oldValue, TextEditingValue newValue) {
      final TextEditingValue value =
          newValue.text.isEmpty || RegExp(r'^[0-9]+((\.|\,)[0-9]*)?$').hasMatch(newValue.text) ? newValue : oldValue;
      return value.copyWith(text: value.text.replaceAll(',', '.'));
    },
  );
}

Future<T?> _showMaterialDialog<T>(
  BuildContext? context,
  Widget? titleWidget,
  Widget? body,
  PDialogAction? negativeAction,
  PDialogAction? positiveAction,
  bool autoPop,
  bool disableContentPadding,
  bool barrierDismissible,
  bool useRootNavigator,
) {
  return showDialog(
    context: context ?? PageNavigator.globalContext!,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) => didPop ? Navigator.of(context).pop(result) : null,
        child: AlertDialog(
          title: titleWidget,
          content: body,
          contentPadding: disableContentPadding ? EdgeInsets.zero : const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          actions: <Widget>[
            if (negativeAction != null)
              PTextButton(
                text: negativeAction.text,
                variant: negativeAction.danger ? PButtonVariant.error : PButtonVariant.brand,
                onPressed: negativeAction.active
                    ? () {
                        if (autoPop) {
                          //PageNavigator.pop();  /// Not Working in Web
                          Navigator.of(context).pop();
                        }
                        negativeAction.action?.call();
                      }
                    : null,
              ),
            if (positiveAction != null)
              PTextButton(
                text: positiveAction.text,
                variant: positiveAction.danger ? PButtonVariant.error : PButtonVariant.brand,
                onPressed: positiveAction.active
                    ? () {
                        if (autoPop) {
                          //PageNavigator.pop(); /// Not Working in Web
                          Navigator.of(context).pop();
                        }
                        positiveAction.action?.call();
                      }
                    : null,
              ),
          ],
        ),
      );
    },
  );
}

Future<T?> _showCupertinoDialog<T>(
  BuildContext? context,
  Widget? titleWidget,
  Widget? body,
  PDialogAction? positiveAction,
  PDialogAction? negativeAction,
  bool autoPop,
  bool barrierDismissible,
  bool useRootNavigator,
) {
  return showCupertinoDialog(
    context: context ?? PageNavigator.currentContext!,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: titleWidget,
        content: body,
        actions: <Widget>[
          if (negativeAction != null)
            CupertinoDialogAction(
              textStyle: negativeAction.danger != true ? TextStyle(color: context.pColorScheme.primary) : null,
              isDestructiveAction: negativeAction.danger,
              onPressed: negativeAction.active
                  ? () {
                      if (autoPop) {
                        PageNavigator.pop();
                      }
                      negativeAction.action?.call();
                    }
                  : null,
              child: Text(negativeAction.text),
            ),
          if (positiveAction != null)
            CupertinoDialogAction(
              textStyle: positiveAction.danger != true ? TextStyle(color: context.pColorScheme.primary) : null,
              isDestructiveAction: positiveAction.danger,
              onPressed: positiveAction.active
                  ? () {
                      if (autoPop) {
                        PageNavigator.pop();
                      }
                      positiveAction.action?.call();
                    }
                  : null,
              child: Text(positiveAction.text),
            ),
        ],
      );
    },
  );
}

class PDialogAction {
  final String text;
  final VoidCallback? action;
  final bool danger;
  final bool active;

  PDialogAction({
    required this.text,
    this.action,
    this.danger = false,
    this.active = true,
  });

  PDialogAction.cancel({this.action})
      : text = 'cancel',
        danger = false,
        active = true;
}
