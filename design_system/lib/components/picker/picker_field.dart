import 'package:design_system/components/picker/picker.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/icon/streamline_icons.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/keyboard_utils.dart';

class PPickerField<T> extends StatefulWidget {
  final String label;
  final List<PickerItem<T>>? values;
  final ValueSetter<T?>? onChanged;
  final String? helperText;
  final String? errorText;
  final bool optional;
  final TextEditingController? controller;
  final T? initialValue;
  final bool hideSelected;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final bool useRootNavigator;
  final PValidator? validator;
  final int? errorMaxLines;
  final ValueSetter<Function(T)?>? onTap;
  final String Function(T)? displayText;

  const PPickerField({
    Key? key,
    required this.label,
    this.values,
    this.onChanged,
    this.helperText,
    this.errorText,
    this.optional = false,
    this.controller,
    this.initialValue,
    this.hideSelected = false,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.always,
    this.useRootNavigator = false,
    this.errorMaxLines,
    this.validator,
    this.onTap,
    this.displayText,
  })  : assert(values != null || onTap != null),
        assert(values != null || displayText != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PPickerFieldState<T>();
}

class _PPickerFieldState<T> extends State<PPickerField<T>> {
  TextEditingController? _controller;
  bool disposeController = false;
  T? selected;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      disposeController = true;
    } else {
      _controller = widget.controller;
      disposeController = false;
    }

    selected = widget.initialValue;

    if (selected != null) {
      _controller?.text = _getText(selected);
    }
  }

  @override
  void dispose() {
    if (disposeController) {
      _controller?.dispose();
    }
    super.dispose();
  }

  void onSelectValue(T? value) {
    selected = value;
    _controller?.text = _getText(value);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          if (widget.onTap != null) {
            KeyboardUtils.dismissKeyboard();
            widget.onTap?.call(onSelectValue);
          } else {
            showPPicker(
              title: widget.label,
              values: widget.values!,
              context: context,
              initialValue: widget.hideSelected ? null : selected,
              useRootNavigator: widget.useRootNavigator,
              onSelected: onSelectValue,
            );
          }
        }
      },
      child: AbsorbPointer(
        child: PTextField(
          label: widget.label,
          controller: _controller,
          helperText: widget.helperText,
          errorText: widget.errorText,
          enabled: widget.onChanged != null,
          errorMaxLines: widget.errorMaxLines,
          suffixWidget: Icon(
            StreamlineIcons.arrow_down_1,
            size: 14,
            color: context.pColorScheme.darkMedium,
          ),
          focusNode: widget.focusNode,
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
        ),
      ),
    );
  }

  String _getText(T? value) {
    try {
      return widget.values?.firstWhere((PickerItem<T> element) => element.value == value).text ??
          widget.displayText?.call(value as T) ??
          '-';
    } on StateError {
      return '';
    }
  }
}
