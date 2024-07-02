import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class MyTaskCommonTextField {
  static Widget textfield({
    Function()? ontap,
    String? label,
    TextEditingController? controller,
    IconData? icon,
    bool suffixicon = true,
    bool readonly = false,
    TextInputType keyboardtype = TextInputType.text,
    bool isUpdate = false, // New parameter to control label color
    bool isDisabled =
        false, // New parameter to control text field disable state
  }) =>
      SizedBox(
        child: TextField(
          enabled: !isDisabled, // Set enabled based on the isDisabled parameter
          controller: controller,
          readOnly: readonly || isUpdate, // Set readOnly if isUpdate is true
          onTap: ontap,
          keyboardType: keyboardtype,
          style: TextStyle(
              fontSize: 12,
              color: isUpdate ? Colors.grey : AppColors.mutedColor),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            isCollapsed: true,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.mutedColor, width: 0.1),
            ),
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isUpdate ? Colors.grey : AppColors.primary,
            ),
            suffixIcon: suffixicon
                ? Icon(
                    icon != null ? icon : Icons.more_vert,
                    color: isUpdate ? AppColors.mutedColor : AppColors.primary,
                    size: 15,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            suffixIconConstraints:
                BoxConstraints.tightFor(height: 30, width: 30),
          ),
        ),
      );

  static Widget multilineTextfield({
    required int maxline,
    required String label,
    required TextEditingController controller,
    bool isUpdate = false,
    bool isDisable = false,
  }) {
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
          color: isUpdate ? Colors.grey : AppColors.primary,
        ),
      ),
      autofocus: false,
      onTap: () {},
      maxLines: maxline,
      controller: controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      enabled: !isDisable,
      readOnly: isUpdate || isDisable,
    );
  }
}
