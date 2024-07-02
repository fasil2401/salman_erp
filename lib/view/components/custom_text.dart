import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomText {
  static buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        color: AppColors.mutedColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
