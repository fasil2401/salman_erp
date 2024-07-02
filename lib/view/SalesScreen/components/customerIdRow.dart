import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomerIdRow extends StatelessWidget {
  CustomerIdRow({Key? key, required this.onTap, required this.controller,required this.isLoading})
      : super(key: key);

  Function() onTap;
  TextEditingController controller;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Text(
            'Customer Id:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              isCollapsed: true,
              isDense: true,
              border: InputBorder.none,
              suffix: Transform.translate(
                offset: Offset(0, 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.mutedColor,
                        )
                      : Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            onTap: onTap
          ),
        ),
      ],
    );
  }
}
