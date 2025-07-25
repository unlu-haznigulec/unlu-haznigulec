import 'package:flutter/material.dart';

class ColorUtils {
  static const Color generalCardShadowColor = Color(0x28644b37);
  Color assetColor(String colorCounter) {
    Color itemColor;
    switch (colorCounter) {
      case '0':
        itemColor = const Color.fromRGBO(171, 135, 255, 1);
        break;
      case '1':
        itemColor = const Color.fromRGBO(245, 255, 198, 1);
        break;
      case '2':
        itemColor = const Color.fromRGBO(0, 40, 70, 1);
        break;
      case '3':
        itemColor = const Color.fromRGBO(230, 100, 25, 1);
        break;
      case '4':
        itemColor = const Color.fromRGBO(37, 112, 186, 1);
        break;
      case '5':
        itemColor = const Color.fromRGBO(215, 215, 215, 1);
        break;
      case '6':
        itemColor = const Color.fromRGBO(215, 213, 78, 1);
        break;
      case '7':
        itemColor = const Color.fromRGBO(377, 10, 186, 1);
        break;
      case '8':
        itemColor = const Color.fromRGBO(7, 88, 215, 1);
        break;
      case '9':
        itemColor = const Color.fromRGBO(99, 213, 75, 1);
        break;
      case '10':
        itemColor = const Color.fromRGBO(55, 60, 75, 1);
        break;
      case '11':
        itemColor = const Color.fromRGBO(45, 60, 200, 1);
        break;
      case '12':
        itemColor = const Color.fromRGBO(3, 200, 75, 1);
        break;
      case '13':
        itemColor = const Color.fromRGBO(150, 10, 200, 1);
        break;
      case '14':
        itemColor = const Color.fromRGBO(3, 200, 200, 1);
        break;
      case '15':
        itemColor = const Color.fromRGBO(150, 100, 200, 1);
        break;
      default:
        itemColor = Colors.black;
    }
    return itemColor;
  }
}
