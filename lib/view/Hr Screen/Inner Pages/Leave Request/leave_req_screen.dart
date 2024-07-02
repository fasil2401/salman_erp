import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Local%20Db%20Controller/local_settings_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/leave_req_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Leave%20Request/add_leave_req_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/home_screen/components/homescreen_drawer.dart';
import 'package:axolon_erp/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LeaveReqScreen extends StatelessWidget {
  LeaveReqScreen({Key? key}) : super(key: key);

  var selectedValue;

  final leaveReqController = Get.put(LeaveReqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(1, 66, 150, 1),
        title: const Text('Leave Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Obx(
                () => CommonFilterControls.buildDateRageDropdown(context,
                    dropValue: DateRangeSelector
                        .dateRange[leaveReqController.dateIndex.value],
                    onChanged: (value) async {
                      selectedValue = value;
                      await leaveReqController.selectDateRange(
                          selectedValue.value,
                          DateRangeSelector.dateRange.indexOf(selectedValue));
                      leaveReqController.getLeaveRequestDetailList();
                    },
                    fromController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(leaveReqController.fromDate.value)
                          .toString(),
                    ),
                    toController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(leaveReqController.toDate.value)
                          .toString(),
                    ),
                    onTapFrom: () async {
                      await leaveReqController.selectDate(context, true);
                      leaveReqController.getLeaveRequestDetailList();
                    },
                    onTapTo: () async {
                      await leaveReqController.selectDate(context, false);
                      leaveReqController.getLeaveRequestDetailList();
                    },
                    isFromEnable: leaveReqController.isFromDate.value,
                    isToEnable: leaveReqController.isToDate.value,
                    isClosing: false),
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<LeaveReqController>(
                  builder: (controller) => controller.isLoading.value
                      ? popShimmer()
                      : controller.leaveList.isEmpty
                          ? const Text("No Data")
                          : ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 8,
                                  ),
                              key: Key("leave_req"),
                              itemCount: controller.leaveList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = controller.leaveList[index];

                                return InkWell(
                                  onTap: () {
                                    controller.getLeaveRequestDetailById(item);
                                    Get.to(() => AddLeaveRequestScreen());
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: AppColors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CommonWidget.commonRow(
                                                  isBlue: true,
                                                  firsthead:
                                                      "${item.sysDocId ?? ''}",
                                                  secondhead:
                                                      "${item.docNumber ?? ''}",
                                                  isValueAvailable: false),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Leave Type :",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .mutedColor)),
                                                        Flexible(
                                                          child: Text(
                                                              " ${item.leaveTypeName}",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .mutedColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize:
                                                                      13)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Approval Status :",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .mutedColor)),
                                                        Flexible(
                                                          child: Text(
                                                              " ${item.approvalStatus}",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      13)),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CommonWidget.commonRow(
                                                isBlue: false,
                                                firsthead: "Leave Days :",
                                                firstValue:
                                                    " ${item.leaveDays ?? ''}",
                                                secondhead: "Employee Id :",
                                                secondValue:
                                                    " ${item.employeeId ?? ''}",
                                                isValueAvailable: true,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CommonWidget.commonRow(
                                                isBlue: false,
                                                firsthead: "Start Date :",
                                                firstValue:
                                                    " ${DateFormatter.dateFormat.format(item.startDate ?? DateTime.now())}",
                                                secondhead: "End Date :",
                                                secondValue:
                                                    " ${DateFormatter.dateFormat.format(item.endDate ?? DateTime.now())}",
                                                isValueAvailable: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            leaveReqController.getDocId();
            leaveReqController.clearData();
            leaveReqController.isNewRecord.value = true;
            Get.to(() => AddLeaveRequestScreen())?.then(
                (value) => leaveReqController.getLeaveRequestDetailList());
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.primary),
    );
  }
}
