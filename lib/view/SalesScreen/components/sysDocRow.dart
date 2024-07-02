import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SysDocRow extends StatelessWidget {
  SysDocRow({
    required this.onTap,
    required this.sysDocIdController,
    required this.sysDocSuffixLoading,
    required this.voucherIdController,
    required this.voucherSuffixLoading,
    Key? key,
  }) : super(key: key);

  Function() onTap;
  TextEditingController sysDocIdController;
  bool sysDocSuffixLoading;
  TextEditingController voucherIdController;
  bool voucherSuffixLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Text(
            'SysDoc Id:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        Flexible(
          child: TextField(
            controller: sysDocIdController,
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
                  child: sysDocSuffixLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.mutedColor,
                              )
                            : Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            onTap: onTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Text(
            'Voucher :',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
        Flexible(
          child: TextField(
            controller: voucherIdController,
            readOnly: true,
            decoration: InputDecoration(
              isCollapsed: true,
              isDense: true,
              border: InputBorder.none,
              suffix: Transform.translate(
                offset: Offset(0, 8),
                child: SizedBox(
                  width: 20,
                  height: 24,
                  child:  voucherSuffixLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.mutedColor,
                              )
                            : Container(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
