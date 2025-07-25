import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  final String lang;
  final int fixedPrecision;

  MoneyInputFormatter({
    this.lang = 'tr',
    this.fixedPrecision = 2,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    String precisionSeparator = '.';
    String decimalSeparator = ',';
    if (lang == 'tr') {
      precisionSeparator = ',';
      decimalSeparator = '.';
    }
    if (newText.isEmpty) {
      return newValue;
    }

    newText = newText.replaceAll(decimalSeparator, '');

    if (newText.contains(precisionSeparator)) {
      final String beforeDecimal = newText.split(precisionSeparator)[0];
      String afterDecimal = newText.split(precisionSeparator)[1];
      if (afterDecimal.length > fixedPrecision) {
        afterDecimal = afterDecimal.substring(0, fixedPrecision);
      }
      newText = _formatNumber(beforeDecimal, decimalSeparator) + precisionSeparator + afterDecimal;
    } else {
      newText = _formatNumber(newText, decimalSeparator);
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatNumber(String s, String decimalSeparator) {
    return s.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$decimalSeparator');
  }
}
