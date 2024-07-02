import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DiscountSheet extends StatelessWidget {
  DiscountSheet({
    required this.onTapPercent,
    required this.onTapAmount,
    required this.onChangePercent,
    required this.onChangeAmount,
    required this.amountFocus,
    required this.percentFocus,
    required this.amountController,
    required this.percentController,
    Key? key,
  }) : super(key: key);

  Function() onTapPercent;
  Function() onTapAmount;
  Function(String value) onChangePercent;
  Function(String value) onChangeAmount;
  TextEditingController percentController;
  TextEditingController amountController;
  FocusNode percentFocus;
  FocusNode amountFocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 10,
          left: 15,
          right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Card(
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.mutedColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: _buildDiscountFields(
                  context: context,
                  label: 'Percentage',
                  controller: percentController,
                  focusNode: percentFocus,
                  onChanged: onChangePercent,
                  onTap: onTapPercent,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '%',
                style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: _buildDiscountFields(
                  context: context,
                  label: 'Amount',
                  controller: amountController,
                  focusNode: amountFocus,
                  onChanged: onChangeAmount,
                  onTap: onTapAmount,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  TextField _buildDiscountFields({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    required Function() onTap,
    required FocusNode focusNode,
  }) {
    // _discountAmountController.text =
    //     salesController.discount.value.toStringAsFixed(2);
    // _discountPercentageController.text =
    //     salesController.discountPercentage.value.toStringAsFixed(2);

    return TextField(
      maxLines: 1,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      },
      controller: controller,
      // textInputAction: TextInputAction.continueAction,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 12, color: AppColors.primary),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
