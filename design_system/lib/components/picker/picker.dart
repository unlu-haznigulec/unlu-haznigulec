import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/dialog/dialog.dart';
import 'package:design_system/components/lozenge/lozenge.dart';
import 'package:design_system/components/selection_control/radio_button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/platform_utils.dart';

void showPPicker<T>({
  String? title,
  required List<PickerItem<T>> values,
  T? initialValue,
  required ValueSetter<T?> onSelected,
  required BuildContext? context,
  bool useRootNavigator = true,
}) {
  KeyboardUtils.dismissKeyboard();
  if (PlatformUtils.isIos) {
    _showCupertinoPicker<T>(title, values, initialValue, onSelected, context, useRootNavigator);
  } else {
    _showMaterialPicker<T>(title, values, initialValue, onSelected, context, useRootNavigator);
  }
}

void _showMaterialPicker<T>(
  String? title,
  List<PickerItem<T>> values,
  T? initialValue,
  ValueSetter<T?> onSelected,
  BuildContext? context,
  bool useRootNavigator,
) {
  T? selectedValue = initialValue;
  PDialog.showAlertDialog(
    context: context ?? PageNavigator.globalContext,
    title: title ?? '',
    disableContentPadding: true,
    content: _PPickerContent<T>(
      values: values,
      initialValue: initialValue,
      onSelected: (T? value) {
        selectedValue = value;
      },
    ),
    positiveAction: PDialogAction(
      text: 'ok',
      action: () {
        onSelected(selectedValue);
      },
    ),
    negativeAction: PDialogAction.cancel(),
    useRootNavigator: useRootNavigator,
  );
}

Future<void> _showCupertinoPicker<T>(
  String? title,
  List<PickerItem<T>> values,
  T? initialValue,
  ValueSetter<T?> onSelected,
  BuildContext? context,
  bool useRootNavigator,
) async {
  T? selectedValue = initialValue;
  int initialIndex = 0;

  if (selectedValue != null) {
    initialIndex = values.indexWhere((PickerItem<T> item) => item.value == selectedValue);

    if (initialIndex < 0) {
      initialIndex = 0;
    }
  } else if (values.isNotEmpty == true) {
    selectedValue = values[0].value;
  }

  showCupertinoModalPopup(
    context: context ?? PageNavigator.globalContext!,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext innerContext) {
      return _buildBottomPicker(
        innerContext,
        picker: CupertinoPicker(
          backgroundColor: innerContext.pColorScheme.lightHigh,
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: initialIndex,
          ),
          onSelectedItemChanged: (int index) {
            selectedValue = values[index].value;
          },
          children: values.map((PickerItem<T> item) {
            return Text(
              item.text == 'null' ? 'none' : item.text,
              overflow: TextOverflow.ellipsis,
            );
          }).toList(),
        ),
        onDone: () {
          onSelected(selectedValue);
          Navigator.of(innerContext).pop();
        },
        onCancel: () {
          Navigator.of(innerContext).pop();
        },
      );
    },
  );
}

Widget _buildBottomPicker(
  BuildContext context, {
  required Widget picker,
  VoidCallback? onCancel,
  required VoidCallback onDone,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 6.0),
    color: context.pColorScheme.backgroundColor,
    child: DefaultTextStyle(
      style: TextStyle(
        color: context.pColorScheme.textPrimary.shade900,
        fontSize: 22.0,
      ),
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PTextButton(
                    text: 'cancel',
                    variant: PButtonVariant.error,
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel();
                      }
                    },
                  ),
                  PTextButton(
                    key: const Key(ButtonKeys.pickerDoneButton),
                    text: 'done',
                    onPressed: () {
                      onDone();
                    },
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 150,
                child: picker,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PPickerContent<T> extends StatefulWidget {
  final List<PickerItem<T>> values;
  final ValueSetter<T?> onSelected;
  final T? initialValue;

  const _PPickerContent({
    Key? key,
    required this.values,
    required this.onSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _PPickerContentState<T> createState() => _PPickerContentState<T>();
}

class _PPickerContentState<T> extends State<_PPickerContent<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: Grid.l),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          decoration: PlatformUtils.isIos
              ? null
              : BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.pColorScheme.textPrimary.shade300),
                    bottom: BorderSide(color: context.pColorScheme.textPrimary.shade300),
                  ),
                ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.values.map((PickerItem<T> item) {
                return PRadioButtonRow<T>(
                  text: item.text == 'null' ? 'none' : item.text,
                  value: item.value,
                  groupValue: selectedValue,
                  onChanged: (T? value) {
                    setState(() {
                      selectedValue = value;
                      widget.onSelected(selectedValue);
                    });
                  },
                  child: item.customWidget,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class PickerItem<T> {
  final T value;
  final String text;
  final Widget? customWidget;

  PickerItem({
    required this.value,
    required this.text,
    this.customWidget,
  });
}

void showStatusBadgePPicker<T>({
  String? title,
  required List<StatusBadgePickerItem<T>> values,
  T? initialValue,
  required ValueSetter<T?> onSelected,
}) {
  KeyboardUtils.dismissKeyboard();
  if (PlatformUtils.isIos) {
    _showStatusBadgeCupertinoPicker(title, values, initialValue, onSelected);
  } else {
    _showStatusBadgeMaterialPicker(title, values, initialValue, onSelected);
  }
}

void _showStatusBadgeMaterialPicker<T>(
  String? title,
  List<StatusBadgePickerItem<T>> values,
  T? initialValue,
  ValueSetter<T?> onSelected,
) {
  T? selectedValue = initialValue;
  PDialog.showAlertDialog(
    context: PageNavigator.globalContext,
    title: title ?? '',
    disableContentPadding: true,
    content: _PStatusBadgePickerContent<T>(
      values: values,
      initialValue: initialValue,
      onSelected: (T? value) {
        selectedValue = value;
      },
    ),
    positiveAction: PDialogAction(
      text: 'ok',
      action: () {
        onSelected(selectedValue);
      },
    ),
    negativeAction: PDialogAction.cancel(),
  );
}

Future<void> _showStatusBadgeCupertinoPicker<T>(
  String? title,
  List<StatusBadgePickerItem<T>> values,
  T? initialValue,
  ValueSetter<T?> onSelected,
) async {
  T? selectedValue = initialValue;
  int initialIndex = 0;

  if (selectedValue != null) {
    initialIndex = values.indexWhere((StatusBadgePickerItem<T> item) => item.value == selectedValue);

    if (initialIndex < 0) {
      initialIndex = 0;
    }
  } else if (values.isNotEmpty == true) {
    selectedValue = values[0].value;
  }

  showCupertinoModalPopup(
    context: PageNavigator.globalContext!,
    builder: (BuildContext builder) {
      return _buildStatusBadgeBottomPicker(
        builder,
        picker: CupertinoPicker(
          backgroundColor: builder.pColorScheme.lightHigh,
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: initialIndex,
          ),
          onSelectedItemChanged: (int index) {
            selectedValue = values[index].value;
          },
          children: values.map((StatusBadgePickerItem<T> item) {
            return PLozenge.withColor(
              text: item.text,
              backgroundColor: item.color ?? builder.pColorScheme.transparent,
            );
          }).toList(),
        ),
        onDone: () {
          onSelected(selectedValue);
        },
      );
    },
  );
}

Widget _buildStatusBadgeBottomPicker(
  BuildContext context, {
  required Widget picker,
  VoidCallback? onCancel,
  required VoidCallback onDone,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 6.0),
    color: context.pColorScheme.lightHigh,
    child: DefaultTextStyle(
      style: TextStyle(
        color: context.pColorScheme.textPrimary.shade900,
        fontSize: 22.0,
      ),
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PTextButton(
                    text: 'cancel',
                    variant: PButtonVariant.error,
                    onPressed: () {
                      PageNavigator.pop();
                      if (onCancel != null) {
                        onCancel();
                      }
                    },
                  ),
                  PTextButton(
                    key: const Key(ButtonKeys.pickerDoneButton),
                    text: 'done',
                    onPressed: () {
                      PageNavigator.pop();
                      onDone();
                    },
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 150,
                child: picker,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _PStatusBadgePickerContent<T> extends StatefulWidget {
  final List<StatusBadgePickerItem<T>> values;
  final ValueSetter<T?> onSelected;
  final T? initialValue;

  const _PStatusBadgePickerContent({Key? key, required this.values, required this.onSelected, this.initialValue})
      : super(key: key);

  @override
  _PStatusBadgePickerContentState<T> createState() => _PStatusBadgePickerContentState<T>();
}

class _PStatusBadgePickerContentState<T> extends State<_PStatusBadgePickerContent<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: Grid.l),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          decoration: PlatformUtils.isIos
              ? null
              : BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.pColorScheme.textPrimary.shade300),
                    bottom: BorderSide(color: context.pColorScheme.textPrimary.shade300),
                  ),
                ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.values.map((StatusBadgePickerItem<T> item) {
                return PStatusBadgeRadioButtonRow<T>(
                  text: item.text,
                  value: item.value,
                  color: item.color,
                  groupValue: selectedValue,
                  onChanged: (T? value) {
                    setState(() {
                      selectedValue = value;
                      widget.onSelected(selectedValue);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBadgePickerItem<T> {
  final T value;
  final String text;
  final Color? color;

  StatusBadgePickerItem({required this.value, required this.text, this.color});
}
