import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWidget {
  static commonDialog({
    required BuildContext context,
    required String title,
    required Widget content,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: AppColors.mutedColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.mutedColor,
                        child: Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: AppColors.lightGrey,
                ),
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: content))
            ]));
      },
    );
  }

  static Widget saveAndCancelButton({
    required Function() onPressOfCancel,
    required Function() onTapOfSave,
    required bool isSaving,
    required bool isSaveActive,
  }) {
    return Row(
      children: [
        Expanded(
          child: Buttons.buildElevatedButtonCancel(
            text: "Cancel",
            onPressed: onPressOfCancel,
            color: AppColors.mutedBlueColor,
            textColor: AppColors.primary,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaveActive ? onTapOfSave : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSaveActive ? AppColors.primary : AppColors.mutedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            child: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.mutedBlueColor,
                    ))
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.mutedBlueColor,
                      fontSize: 14,
                    ),
                  ),
          ),
        )
      ],
    );
  }

  static multilineTextfiled(
      {required int maxline,
      required String label,
      required TextEditingController controller}) {
    return TextField(
      style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
      onChanged: (value) {},
      decoration: InputDecoration(
        isCollapsed: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.mutedColor,
            width: 0.1,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
      ),
      autofocus: false,
      onTap: () {},
      maxLines: maxline,
      controller: controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }

  static commonRow(
      {required isBlue,
      required String firsthead,
      String? firstValue,
      required String secondhead,
      String? secondValue,
      required bool isValueAvailable}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(firsthead,
                  style: TextStyle(
                      color:
                          isBlue ? AppColors.primary : AppColors.mutedColor)),
              if (isValueAvailable)
                Flexible(
                  child: Text(firstValue ?? '',
                      style: TextStyle(
                          color: AppColors.mutedColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)),
                )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(secondhead, style: TextStyle(color: AppColors.mutedColor)),
              if (isValueAvailable)
                Flexible(
                  child: Text(secondValue ?? '',
                      style: TextStyle(
                          color: AppColors.mutedColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)),
                )
            ],
          ),
        ),
      ],
    );
  }
}
