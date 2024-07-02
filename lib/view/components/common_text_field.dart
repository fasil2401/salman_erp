import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonTextField {
  static Widget textfield(
          {Function()? ontap,
          String? label,
          TextEditingController? controller,
          FocusNode? focus,
          IconData? icon,
          required bool suffixicon,
          TextAlign textAlign = TextAlign.left,
          required bool readonly,
          Function(dynamic)? onchanged,
          required TextInputType keyboardtype}) =>
      SizedBox(
        // height: 35.0,
        child: TextField(
          maxLines: 1,
          controller: controller,
          // enabled: false,
          readOnly: readonly,
          onTap: ontap,
          onChanged: onchanged,
          autofocus: false,
          keyboardType: keyboardtype,

          textAlign: textAlign,
          style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
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
              color: AppColors.primary,
            ),
            suffixIcon: suffixicon == true
                ? Icon(
                    icon != null ? icon : Icons.more_vert,
                    color: AppColors.primary,
                    size: 15,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            suffixIconConstraints:suffixicon==true
                ?BoxConstraints.tightFor(height: 30, width: 30)
                :BoxConstraints(),
          ),
        ),
      );
}
