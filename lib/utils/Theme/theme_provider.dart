import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ThemeProvider {
  final ThemeData _themeData = ThemeData(
      fontFamily: 'Rubik',
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ));
  get theme => _themeData;
}
