import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/leave_req_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeaveRequestScreen extends StatelessWidget {
  AddLeaveRequestScreen({super.key});
  final leaveRequestController = Get.put(LeaveReqController());
  final homecontroller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Request Apply"),
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
                                      "${leaveRequestController.selectedDocId.value.code ?? ''} - ${leaveRequestController.selectedDocId.value.name ?? ''}"),
                              icon: Icons.arrow_drop_down_circle_outlined,
                              ontap: () async {
                                await CommonWidget.commonDialog(
                                  context: context,
                                  title: "Doc ID",
                                  content: docIdContent(context),
                                );
                              },
                              label: "Doc ID"))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              controller: leaveRequestController
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
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              controller: TextEditingController(
                                  text:
                                      "${leaveRequestController.selectedLeaveType.value.typeCode ?? ''} - ${leaveRequestController.selectedLeaveType.value.typeName ?? ''}"),
                              icon: Icons.arrow_drop_down_circle_outlined,
                              label: "Leave Type",
                              ontap: () async {
                                if (leaveRequestController
                                    .leaveTypeList.isEmpty) {
                                  leaveRequestController.getLeaveType();
                                }
                                await CommonWidget.commonDialog(
                                  context: context,
                                  title: "Leave Type",
                                  content: leaveTypeContent(context),
                                );
                              },
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: CommonTextField.textfield(
                        suffixicon: false,
                        readonly: true,
                        keyboardtype: TextInputType.datetime,
                        label: "App.Date",
                        controller: TextEditingController(
                            text:
                                "${DateFormatter.dateFormat.format(leaveRequestController.appDate.value)}"),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Available Leave : ",
                        style: TextStyle(
                            color: AppColors.mutedColor, fontSize: 13),
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                            color: AppColors.mutedColor, fontSize: 12),
                      )
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
                                      "${DateFormatter.dateFormat.format(leaveRequestController.startDate.value)}"),
                              label: "Start Date",
                              ontap: () async {
                                DateTime date = await leaveRequestController
                                    .selectDateStartDate(context,
                                        leaveRequestController.startDate.value);
                                leaveRequestController.startDate.value = date;
                                leaveRequestController
                                    .getAvailableDateAndDays();
                              },
                              icon: Icons.calendar_month_outlined))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.datetime,
                              controller: TextEditingController(
                                  text:
                                      "${DateFormatter.dateFormat.format(leaveRequestController.endDate.value)}"),
                              label: "End Date",
                              ontap: () async {
                                DateTime date = await leaveRequestController
                                    .selectDateStartDate(context,
                                        leaveRequestController.endDate.value);
                                leaveRequestController.endDate.value = date;
                                leaveRequestController
                                    .getAvailableDateAndDays();
                              },
                              icon: Icons.calendar_month_outlined))),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            "Days : ${leaveRequestController.days.value}",
                            style: TextStyle(color: AppColors.mutedColor),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.19,
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.datetime,
                              controller: TextEditingController(
                                  text:
                                      "${DateFormatter.dateFormat.format(leaveRequestController.travellingDate.value)}"),
                              label: "Travelling Date",
                              ontap: () async {
                                DateTime date = await leaveRequestController
                                    .selectDateStartDate(
                                        context,
                                        leaveRequestController
                                            .travellingDate.value);
                                leaveRequestController.travellingDate.value =
                                    date;
                              },
                              icon: Icons.calendar_month_outlined))),
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
                        controller: leaveRequestController.refController.value,
                        label: "Ref",
                        ontap: () {},
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.number,
                            label: "Leave Days",
                            controller: TextEditingController(
                                text:
                                    "${leaveRequestController.selectedLeaveType.value.typeCode == null ? '' : leaveRequestController.leaveDays.value}"))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CommonWidget.multilineTextfiled(
                      maxline: 2,
                      label: "Reason",
                      controller:
                          leaveRequestController.reasonController.value),
                  SizedBox(
                    height: 15,
                  ),
                  CommonWidget.multilineTextfiled(
                      maxline: 6,
                      label: "Note",
                      controller: leaveRequestController.noteController.value),
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
                            leaveRequestController.clearData();
                            Navigator.pop(context);
                          },
                          onTapOfSave: () async {
                            if (leaveRequestController.isNewRecord.value ==
                                true) {
                              if (homecontroller.isScreenRightAvailable(
                                  screenId: HrScreenId.employeeLeaveRequest,
                                  type: ScreenRightOptions.Add)) {
                                await leaveRequestController
                                    .createLeaveRequest();
                              }
                            } else {
                              if (homecontroller.isScreenRightAvailable(
                                  screenId: HrScreenId.employeeLeaveRequest,
                                  type: ScreenRightOptions.Edit)) {
                                await leaveRequestController
                                    .createLeaveRequest();
                              }
                            }
                          },
                          isSaving: leaveRequestController.isSaving.value,
                          isSaveActive: leaveRequestController.isNewRecord.value
                              ? leaveRequestController.isAddEnabled.value
                              : leaveRequestController.isEditEnabled.value,
                        ))),
              ))
        ],
      ),
    );
  }

  docIdContent(BuildContext context) {
    return GetBuilder<LeaveReqController>(
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

  leaveTypeContent(BuildContext context) {
    return GetBuilder<LeaveReqController>(
        builder: (controller) => controller.isLoading.value
            ? SalesShimmer.locationPopShimmer()
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = controller.leaveTypeList[index];
                  return InkWell(
                    onTap: () {
                      controller.selectedLeaveType.value = item;
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${item.typeCode} - ${item.typeName}",
                            style: TextStyle(
                                color: AppColors.mutedColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: controller.leaveTypeList.length));
  }
}
