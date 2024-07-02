import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/letter_reqst_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_letter_request_screen.dart';

class LetterRequestScreen extends StatelessWidget {
  LetterRequestScreen({super.key});
  final letterRqstController = Get.put(LetterReqController());
  var selectedValue;
  GlobalKey<FormState>? listKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Request'),
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
                        .dateRange[letterRqstController.dateIndex.value],
                    onChanged: (value) async {
                      selectedValue = value;
                      await letterRqstController.selectDateRange(
                          selectedValue.value,
                          DateRangeSelector.dateRange.indexOf(selectedValue));
                      letterRqstController.getLetterRequestDetailList();
                    },
                    fromController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(letterRqstController.fromDate.value)
                          .toString(),
                    ),
                    toController: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(letterRqstController.toDate.value)
                          .toString(),
                    ),
                    onTapFrom: () async {
                      await letterRqstController.selectDate(context, true);

                      letterRqstController.getLetterRequestDetailList();
                    },
                    onTapTo: () async {
                      await letterRqstController.selectDate(context, false);
                      letterRqstController.getLetterRequestDetailList();
                    },
                    isFromEnable: letterRqstController.isFromDate.value,
                    isToEnable: letterRqstController.isToDate.value,
                    isClosing: false),
              ),
              const SizedBox(
                height: 15,
              ),
              GetBuilder<LetterReqController>(
                builder: (_) => _.isLoading.value
                    ? popShimmer()
                    : _.letterList.isEmpty
                        ? const Text("No Data")
                        : ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 8,
                                ),
                            key: listKey,
                            itemCount: _.letterList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var item = _.letterList[index];

                              return InkWell(
                                onTap: () {
                                  _.getLetterRequestDetailById(item);

                                  Get.to(() => AddLetterRqstScreen());
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("${item.docId ?? ""}",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primary)),
                                                  ],
                                                ),
                                                Text(
                                                  "${item.docNumber ?? ""}",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.mutedColor),
                                                )
                                              ],
                                            ),
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
                                                  child: Text(
                                                      "Date:${item.letterIssueDate == null ? '' : DateFormatter.dateFormat.format(item.letterIssueDate!)}",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .mutedColor)),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "Request Date:${item.requestedDate == null ? '' : DateFormatter.dateFormat.format(item.requestedDate!)}",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .mutedColor)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text("Attachment",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .mutedColor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 13)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            letterRqstController.getDocId();
            letterRqstController.clearData();
            letterRqstController.isNewRecord.value = true;
            Get.to(() => AddLetterRqstScreen())?.then(
                (value) => letterRqstController.getLetterRequestDetailList());
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.primary),
    );
  }
}
