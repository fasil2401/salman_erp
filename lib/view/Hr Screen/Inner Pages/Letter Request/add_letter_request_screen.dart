import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/letter_reqst_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLetterRqstScreen extends StatelessWidget {
  AddLetterRqstScreen({super.key});
  final letterRqstController = Get.put(LetterReqController());
  final homecontroller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Letter Request Apply"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Obx(
                        () => CommonTextField.textfield(
                            suffixicon: true,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                                text:
                                    "${letterRqstController.selectedDocId.value.code ?? ''} - ${letterRqstController.selectedDocId.value.name ?? ''}"),
                            icon: Icons.arrow_drop_down_circle_outlined,
                            ontap: () async {
                              await commonDialog(
                                context: context,
                                title: "Letter Type",
                                content: docIdContent(context),
                              );
                            },
                            label: "Letter Type"),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              controller: letterRqstController
                                  .docnumberController.value,
                              ontap: () {},
                              label: "Number"))),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Obx(() => CommonTextField.textfield(
                      suffixicon: false,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(letterRqstController.date.value)),
                      ontap: () {},
                      label: "Date")),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                            suffixicon: true,
                            readonly: true,
                            keyboardtype: TextInputType.datetime,
                            controller: TextEditingController(
                                text:
                                    "${DateFormatter.dateFormat.format(letterRqstController.rqstDate.value)}"),
                            label: "Requested On",
                            ontap: () async {
                              DateTime date = await letterRqstController
                                  .selectDateStartDate(context,
                                      letterRqstController.rqstDate.value);
                              letterRqstController.rqstDate.value = date;
                            },
                            icon: Icons.calendar_month_outlined)),
                      ),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      // Expanded(
                      //     child: Obx(() => CommonTextField.textfield(
                      //         suffixicon: true,
                      //         readonly: true,
                      //         keyboardtype: TextInputType.datetime,
                      //         controller: TextEditingController(
                      //             text:
                      //                 "${DateFormatter.dateFormat.format(letterRqstController.validDate.value)}"),
                      //         label: "Valid To",
                      //         ontap: () async {
                      //           DateTime date = await letterRqstController
                      //               .selectDateStartDate(context,
                      //                   letterRqstController.validDate.value);
                      //           letterRqstController.validDate.value = date;
                      //           // leaveRequestController.getAvailableDateAndDays();
                      //         },
                      //         icon: Icons.calendar_month_outlined))),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  multilineTextfiled(
                      maxline: 6,
                      label: "RequestDetails:",
                      controller:
                          letterRqstController.rqstdetailsController.value),
                  SizedBox(
                    height: 15,
                  ),
                  multilineTextfiled(
                      maxline: 6,
                      label: "Remarks:",
                      controller: letterRqstController.remarkController.value),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => CommonWidget.saveAndCancelButton(
                        onPressOfCancel: () {
                          letterRqstController.clearData();
                          Navigator.pop(context);
                        },
                        onTapOfSave: () async {
                          if (letterRqstController.isNewRecord.value == true) {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: HrScreenId.employeeLetterIssueRequest,
                                type: ScreenRightOptions.Add)) {
                              await letterRqstController.createLetterRequest();
                            }
                          } else {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: HrScreenId.employeeLetterIssueRequest,
                                type: ScreenRightOptions.Edit)) {
                              await letterRqstController.createLetterRequest();
                            }
                          }
                        },
                        isSaving: letterRqstController.isSaving.value,
                        isSaveActive: letterRqstController.isNewRecord.value
                            ? letterRqstController.isAddEnabled.value
                            : letterRqstController.isEditEnabled.value,
                      ))),
            ),
          ),
        ],
      ),
    );
  }

  commonDialog({
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

  docIdContent(BuildContext context) {
    return GetBuilder<LetterReqController>(
        builder: (controller) => controller.isLoading.value
            ? SalesShimmer.locationPopShimmer()
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = controller.docIdList[index];
                  return InkWell(
                    onTap: () {
                      controller.selectedDocId.value = item;
                      controller.getVoucherNumber(
                          controller.selectedDocId.value.code ?? '');
                      Navigator.pop(
                        context,
                      ); // Return selected item
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${item.code} - ${item.name}",
                            style: TextStyle(
                                color: AppColors.mutedColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: controller.docIdList.length));
  }

  multilineTextfiled(
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
}
