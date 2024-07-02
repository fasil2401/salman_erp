import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/receipts_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/SalesScreen/components/sysDocRow.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final receiptsController = Get.put(ReceiptsController());
  final salesScreenController = Get.put(SalesController());
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Receipts"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Obx(
                () => SysDocRow(
                  onTap: () async {},
                  sysDocIdController: TextEditingController(
                    text: receiptsController.sysDocName.value,
                  ),
                  sysDocSuffixLoading: salesScreenController.isLoading.value,
                  voucherIdController: TextEditingController(
                    text: receiptsController.voucherNumber.value,
                  ),
                  voucherSuffixLoading:
                      receiptsController.isVoucherLoading.value,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {
                          receiptsController.selectDate(context);
                        },
                        label: "Date",
                        controller: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(receiptsController.date.value)
                              .toString(),
                        ),
                        icon: Icons.calendar_month),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: registerField(
                        receiptsController.registerController, () {}),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {},
                        label: "Cost Center",
                        controller: receiptsController.costCenterController,
                        icon: Icons.arrow_drop_down),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {},
                        label: "Currency",
                        controller: receiptsController.currencyController,
                        icon: Icons.arrow_drop_down),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {},
                        label: "Recieved From",
                        controller: receiptsController.recievedFromController,
                        icon: Icons.arrow_drop_down),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {},
                        label: "",
                        // controller: receiptsController.currencyController,
                        icon: Icons.arrow_drop_down),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextField.textfield(
                      suffixicon: false,
                      readonly: false,
                      keyboardtype: TextInputType.text,
                      ontap: () {},
                      label: "Amount",
                      controller: receiptsController.amountController,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        ontap: () {},
                        label: "Payment Method",
                        controller: receiptsController.paymentMethodController,
                        icon: Icons.arrow_drop_down),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CommonTextField.textfield(
                suffixicon: false,
                readonly: false,
                keyboardtype: TextInputType.text,
                ontap: () {},
                label: "Balance",
                controller: receiptsController.balanceController,
              ),
              SizedBox(
                height: 15,
              ),
              CommonTextField.textfield(
                suffixicon: false,
                readonly: false,
                keyboardtype: TextInputType.text,
                ontap: () {},
                label: "Reference",
                controller: receiptsController.referenceController,
              ),
              SizedBox(
                height: 15,
              ),
              CommonTextField.textfield(
                suffixicon: false,
                readonly: false,
                keyboardtype: TextInputType.text,
                ontap: () {},
                label: "Recieved For",
                controller: receiptsController.recievedForController,
              ),
              SizedBox(
                height: 15,
              ),
              CommonTextField.textfield(
                suffixicon: false,
                readonly: false,
                keyboardtype: TextInputType.text,
                ontap: () {},
                label: "Note",
                controller: receiptsController.noteController,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Clear",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mutedBlueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Obx(() => Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: receiptsController.isLoadingSave.value == true
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text("Save"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget registerField(TextEditingController controller, Function() onTap) {
    return CommonTextField.textfield(
      suffixicon: true,
      readonly: true,
      keyboardtype: TextInputType.text,
      ontap: onTap,
      controller: controller,
      icon: Icons.arrow_drop_down,
      label: "Register",
    );
  }
}
