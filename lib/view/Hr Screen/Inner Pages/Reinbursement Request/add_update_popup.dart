import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/reimbursment_controller.dart';
import 'package:axolon_erp/model/Reimbursement%20Request%20Model/get_addition_code_list.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AddUpdatePopUp extends StatelessWidget {
  AddUpdatePopUp(
      {super.key, required this.item, required this.isUpdate, this.index = 0});
  final reimbursementController = Get.put(ReimbursementController());
  AdditionalCodeModel item;
  bool isUpdate;
  int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
                child: CommonTextField.textfield(
                    suffixicon: false,
                    readonly: false,
                    keyboardtype: TextInputType.number,
                    controller: reimbursementController.amountController.value,
                    label: "Amount")),
            SizedBox(
              width: 10,
            ),
            Flexible(
                child: Obx(() => CommonTextField.textfield(
                    suffixicon: true,
                    readonly: true,
                    keyboardtype: TextInputType.datetime,
                    controller: TextEditingController(
                        text:
                            "${DateFormatter.dateFormat.format(reimbursementController.refDate.value)}"),
                    label: "Ref Date",
                    ontap: () async {
                      DateTime date =
                          await reimbursementController.selectDatesForApplying(
                              context, reimbursementController.refDate.value);
                      reimbursementController.refDate.value = date;
                    },
                    icon: Icons.calendar_month_outlined))),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: false,
            readonly: false,
            keyboardtype: TextInputType.text,
            controller: reimbursementController.descontroller.value,
            label: "Description"),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Buttons.buildElevatedButtonCancel(
                  text: isUpdate ? "Update" : "Add",
                  onPressed: () {
                    if (reimbursementController
                        .amountController.value.text.isEmpty) {
                      SnackbarServices.errorSnackbar("Please enter amount");
                      return;
                    }
                    if (isUpdate) {
                      reimbursementController.updateItem(index);
                    } else {
                      reimbursementController.addItem(item);
                    }
                    reimbursementController.clearPopupData();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  color: AppColors.primary,
                  textColor: AppColors.mutedBlueColor),
            ),
          ],
        )
      ],
    );
  }
}
