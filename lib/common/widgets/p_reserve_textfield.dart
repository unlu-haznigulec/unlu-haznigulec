import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PReserveTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final Function(int newUnit) onUnitChanged;
  final Function()? onTapReserve;
  const PReserveTextfield({
    super.key,
    this.controller,
    required this.onUnitChanged,
    this.onTapReserve,
  });

  @override
  State<PReserveTextfield> createState() => _PReserveTextfieldState();
}

class _PReserveTextfieldState extends State<PReserveTextfield> {
  late TextEditingController _unitController;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _unitController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PValueTextfieldWidget(
      controller: _unitController,
      title: L10n.tr('gorunenadet'),
      focusNode: _focusNode,
      showSeperator: false,
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          int unit = _unitController.text.isEmpty ? 0 : int.parse(_unitController.text);
          _unitController.text = unit.toString();
          widget.onUnitChanged(unit);
          setState(() {});
        } else {
          _unitController.text = int.parse(_unitController.text) == 0 ? '' : _unitController.text;
          widget.onTapReserve?.call();
        }
      },
    );
  }
}
