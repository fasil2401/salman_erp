import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Reinbursement%20Request/add_reimbursment_request_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/app controls/Hr Controller/reimbursment_controller.dart';

class ReimbursementRequestScreen extends StatelessWidget {
  ReimbursementRequestScreen({super.key});
  final reimbursementController = Get.put(ReimbursementController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reimbursment Request"),
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
                        .dateRange[reimbursementController.dateIndex.value],
                    onChanged: (value) async {
                      selectedValue = value;
                      await reimbursementController.selectDateRange(
                          selectedValue.value,
                          DateRangeSelector.dateRange.indexOf(selectedValue));
                      reimbursementController.getReimbursementRequestList();
                    },
                    fromController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(reimbursementController.fromDate.value)
                          .toString(),
                    ),
                    toController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(reimbursementController.toDate.value)
                          .toString(),
                    ),
                    onTapFrom: () async {
                      await reimbursementController.selectDate(context, true);
                      reimbursementController.getReimbursementRequestList();
                    },
                    onTapTo: () async {
                      await reimbursementController.selectDate(context, false);
                      reimbursementController.getReimbursementRequestList();
                    },
                    isFromEnable: reimbursementController.isFromDate.value,
                    isToEnable: reimbursementController.isToDate.value,
                    isClosing: false),
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<ReimbursementController>(
                  builder: (controller) => controller.isLoading.value
                      ? popShimmer()
                      : controller.reimbursmentList.isEmpty
                          ? const Text("No Data")
                          : ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 8,
                                  ),
                              key: Key("reimbursment_list"),
                              itemCount: controller.reimbursmentList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = controller.reimbursmentList[index];

                                return InkWell(
                                  onTap: () {
                                    reimbursementController
                                        .getEmployeeReimbursementRequestByID(
                                            item.sysDocId ?? '',
                                            item.voucherId ?? '');
                                    Get.to(
                                        () => ReimbursmentRequestApplyScreen());
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
                                                      "${item.voucherId ?? ''}",
                                                  isValueAvailable: false),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CommonWidget.commonRow(
                                                  isBlue: false,
                                                  firstValue:
                                                      " ${DateFormatter.dateFormat.format(item.transactionDate ?? DateTime.now())}",
                                                  secondValue:
                                                      " ${item.total ?? 0}",
                                                  firsthead: "Date :",
                                                  secondhead: "Total :",
                                                  isValueAvailable: true),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CommonWidget.commonRow(
                                                  isBlue: false,
                                                  firsthead: "Created By :",
                                                  firstValue:
                                                      " ${item.createdBy ?? ''}",
                                                  secondhead: "Date Created :",
                                                  secondValue:
                                                      " ${DateFormatter.dateFormat.format(item.dateCreated ?? DateTime.now())}",
                                                  isValueAvailable: true),
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
            reimbursementController.getDocId();
            reimbursementController.clearData();
            reimbursementController.isNewRecord.value = true;
            Get.to(() => ReimbursmentRequestApplyScreen())?.then((value) =>
                reimbursementController.getReimbursementRequestList());
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.primary),
    );
  }
}
