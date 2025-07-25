import 'package:flutter/material.dart';

class Shadows {
  static BoxShadow cardShadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor.withOpacity(.05),
        spreadRadius: .1,
        blurRadius: 2,
        offset: const Offset(0, 1),
      );
}
