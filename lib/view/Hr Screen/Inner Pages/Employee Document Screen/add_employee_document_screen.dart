import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/employee_document_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmployeeDocumentScreen extends StatelessWidget {
  AddEmployeeDocumentScreen({super.key});
  final employeeDocumentController = Get.put(EmployeeDocumentController());
  final homecontroller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Document Apply"),
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
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              controller: TextEditingController(
                                  text:
                                      '${employeeDocumentController.selectedDocType.value}'),
                              //   "${employeeDocumentController.selectedType.value.code ?? ''} - ${employeeDocumentController.selectedType.value.name ?? ''}"),
                              icon: Icons.arrow_drop_down_circle_outlined,
                              ontap: () async {
                                // await CommonWidget.commonDialog(
                                //   context: context,
                                //   title: "Doc ID",
                                //   content: docIdContent(context),
                                // );
                              },
                              label: "Doc Type"))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              controller: employeeDocumentController
                                  .docNumberController.value,
                              ontap: () {},
                              label: "Doc Number"))),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: false,
                              keyboardtype: TextInputType.text,
                              controller: employeeDocumentController
                                  .issuePlaceController.value,
                              icon: Icons.arrow_drop_down_circle_outlined,
                              label: "Issue Place",
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.datetime,
                              label: "Issue Date",
                              controller: TextEditingController(
                                  text:
                                      "${DateFormatter.dateFormat.format(employeeDocumentController.issueDate.value)}"),
                              icon: Icons.calendar_month_outlined,
                              ontap: () async {
                                DateTime date = await employeeDocumentController
                                    .selectDatesForCreating(
                                        context,
                                        employeeDocumentController
                                            .issueDate.value);
                                employeeDocumentController.issueDate.value =
                                    date;
                              }))
                    ],
                  ),
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
                                      "${DateFormatter.dateFormat.format(employeeDocumentController.expiryDate.value)}"),
                              label: "Expiry Date",
                              ontap: () async {
                                DateTime date = await employeeDocumentController
                                    .selectDatesForCreating(
                                        context,
                                        employeeDocumentController
                                            .expiryDate.value);
                                employeeDocumentController.expiryDate.value =
                                    date;
                              },
                              icon: Icons.calendar_month_outlined))),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Expanded(
                      //     child: Obx(() => CommonTextField.textfield(
                      //           suffixicon: false,
                      //           readonly: false,
                      //           keyboardtype: TextInputType.datetime,
                      //           controller: employeeDocumentController
                      //               .remarksController.value,
                      //           label: "Remarks",
                      //         ))),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CommonWidget.multilineTextfiled(
                      maxline: 2,
                      label: "Reason",
                      controller:
                          employeeDocumentController.remarksController.value),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // CommonWidget.multilineTextfiled(
                  //     maxline: 6,
                  //     label: "Note",
                  //     controller:
                  //         employeeDocumentController.noteController.value),
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
                    child:
                        //  Obx(() =>
                        CommonWidget.saveAndCancelButton(
                            onPressOfCancel: () {
                              // employeeDocumentController.clearData();
                              Navigator.pop(context);
                            },
                            onTapOfSave: () async {
                              // if (employeeDocumentController.isNewRecord.value ==
                              //     true) {
                              //   if (homecontroller.isScreenRightAvailable(
                              //       screenId: HrScreenId.employeeDocumentRequest,
                              //       type: ScreenRightOptions.Add)) {
                              //     await employeeDocumentController
                              //         .createLeaveRequest();
                              //   }
                              // } else {
                              //   if (homecontroller.isScreenRightAvailable(
                              //       screenId: HrScreenId.employeeDocumentRequest,
                              //       type: ScreenRightOptions.Edit)) {
                              //     await employeeDocumentController
                              //         .createLeaveRequest();
                              //   }
                              // }
                            },
                            isSaving: false,
                            isSaveActive: true
                            // employeeDocumentController
                            //         .isNewRecord.value
                            //     ? employeeDocumentController.isAddEnabled.value
                            //     : employeeDocumentController.isEditEnabled.value,
                            )),
              ))
        ],
      ),
    );
  }
}
