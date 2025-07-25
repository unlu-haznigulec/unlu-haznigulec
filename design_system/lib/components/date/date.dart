import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PDate extends StatelessWidget {
  final String date;
  const PDate({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      textAlign: TextAlign.left,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.pAppStyle.labelMed14textSecondary,
    );
  }
}
