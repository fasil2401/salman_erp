import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

@immutable
class ItemDetailsField extends StatelessWidget {
  const ItemDetailsField({
    Key? key,
    required this.callback,
    required this.label,
    required this.controller,
  }) : super(key: key);

  final Function() callback;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.text.isEmpty
          ? TextEditingController(text: ' ')
          : controller,
      // enabled: false,
      onTap: callback,
      readOnly: true,
      maxLines: 1,
      style: TextStyle(fontSize: 12, color: AppColors.primary),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.mutedColor, width: 0.1),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
