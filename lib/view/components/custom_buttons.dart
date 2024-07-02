import 'package:axolon_erp/controller/app%20controls/connection_setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final connectionSettingController = Get.put(ConnectionSettingController());

class Buttons {
  static ElevatedButton buildElevatedButtonCancel({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  static ElevatedButton buildElevatedButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Obx(() => connectionSettingController.isLoading.value
          ?const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(text, style: TextStyle(color: textColor))),
    );
  }
}
