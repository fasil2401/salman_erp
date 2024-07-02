import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SnackbarServices {
  static errorSnackbar(String message) {
    Get.snackbar('Warning', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        // borderColor: Colors.red,
        // borderWidth: 1,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.error, color: Colors.white));
  }

  static warningSnackbar(String message) {
    Get.snackbar('Warning', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        // borderColor: Colors.red,
        // borderWidth: 1,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.error, color: Colors.white));
  }

  static void successSnackbar(String message) {
    Get.snackbar('Success', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        // borderColor: Colors.green,
        // borderWidth: 1,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.check, color: Colors.white));
  }

  static void internetSnackbar() {
    Get.snackbar(
        'No Internet Connection', 'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        // borderColor: Colors.blue,
        // borderWidth: 1,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.network_check_rounded, color: Colors.white));
  }
}
