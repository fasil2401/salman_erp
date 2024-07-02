import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class OrderAccordion extends StatelessWidget {
  OrderAccordion({
    required this.onToggleCollapsed,
    required this.onTapTransactionDate,
    required this.onTapDueDate,
    required this.onTapRemarks,
    required this.transactionDateController,
    required this.dueDateController,
    required this.remarksController,
    required this.onChangeRemarks,
    required this.remarkFocus,
    Key? key,
  }) : super(key: key);

  Function(bool value) onToggleCollapsed;
  Function() onTapTransactionDate;
  Function() onTapDueDate;
  Function() onTapRemarks;
  TextEditingController transactionDateController;
  TextEditingController dueDateController;
  TextEditingController remarksController;
  Function(String value) onChangeRemarks;
  FocusNode remarkFocus;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      title: 'Order Details',
      titleBorderRadius: BorderRadius.circular(5),
      expandedTitleBackgroundColor: AppColors.primary,
      collapsedTitleBackgroundColor: Colors.black38,
      collapsedIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      expandedIcon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
      textStyle: TextStyle(
        color: Colors.white,
      ),
      onToggleCollapsed: onToggleCollapsed,
      titlePadding: EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 5),
      contentChild: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                  child:  _buildDateTextFeild(
                  controller: transactionDateController,
                  label: 'Transaction Date',
                  enabled: true,
                  isDate: true,
                  onTap: onTapTransactionDate,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: _buildDateTextFeild(
                    controller: dueDateController,
                    label: 'Due Date',
                    enabled: true,
                    isDate: true,
                    onTap: onTapDueDate,
                  ),
                
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
           TextField(
              controller: remarksController,
              onEditingComplete: () async {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: onChangeRemarks,
              focusNode: remarkFocus,
              onTap:onTapRemarks,
              decoration: InputDecoration(
                labelText: 'Remarks',
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                ),
                isCollapsed: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            
          )
        ],
      ),
    );
  }

  TextField _buildDateTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }
}
