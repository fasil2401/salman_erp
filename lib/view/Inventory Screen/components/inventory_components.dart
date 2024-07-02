import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class InventoryComponents {
  static Widget tableHeadText(
      String text, TextAlign align, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primary),
        textScaleFactor: 0.8,
      ),
    );
  }

  static Widget tableText(String text, TextAlign align) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 5, bottom: 8),
      child: AutoSizeText(
        text,
        textAlign: align,
        maxLines: 1,
        maxFontSize: 13,
        minFontSize: 12,
        style: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        textScaleFactor: 0.8,
      ),
    );
  }

  static Row stockAvailRow(String title, String value, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title :',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primary),
        ),
        SizedBox(
          width: 7,
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  static Row detailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '$title :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
