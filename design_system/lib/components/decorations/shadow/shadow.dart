import 'package:flutter/material.dart';

class PShadow {
  static const BoxShadow level_0 = BoxShadow();

  static const BoxShadow level_1 = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 4),
    blurRadius: 8,
  );

  static const BoxShadow level_2 = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.11),
    offset: Offset(0, 6),
    blurRadius: 12,
  );

  static const BoxShadow level_3 = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.21),
    offset: Offset(0, 12),
    blurRadius: 36,
  );
}
