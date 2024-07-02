import 'package:flutter/material.dart';

class ColorHelper{
 static Color getContrastingTextColorFromHex(String hexColor) {
  Color color = Color(int.parse(hexColor.replaceAll("#", ""), radix: 16));
  double luminance = (0.299 * color.red +
      0.587 * color.green +
      0.114 * color.blue) /
      255;

  return luminance > 0.5 ? Colors.black : Colors.white;
}
}