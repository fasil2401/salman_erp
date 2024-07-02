import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/my_task_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Theme/color_helper.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/MyTask%20Screen/add_my_task_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';

import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyTaskScreen extends StatelessWidget {
  MyTaskScreen({Key? key}) : super(key: key);
  final mytaskController = Get.put(MyTaskController());
  final homeController = Get.put(HomeController());
  var selectedValue;
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(1, 66, 150, 1),
        title: const Text('My Task'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(children: [
            // Obx(() => CommonFilterControls.buildDateRageDropdown(
            //       context,
            //       isClosing: false,
            //       dropValue: DateRangeSelector
            //           .dateRange[mytaskController.dateIndex.value],
            //       onChanged: (value) async {
            //         selectedValue = value;
            //         await mytaskController.selectDateRange(selectedValue.value,
            //             DateRangeSelector.dateRange.indexOf(selectedValue));
            //         // mytaskController.getMyTaskList();
            //       },
            //       fromController: TextEditingController(
            //         text: DateFormatter.dateFormat
            //             .format(mytaskController.fromDate.value)
            //             .toString(),
            //       ),
            //       toController: TextEditingController(
            //         text: DateFormatter.dateFormat
            //             .format(mytaskController.toDate.value)
            //             .toString(),
            //       ),
            //       onTapFrom: () {
            //         mytaskController.selectDate(context, true);
            //       },
            //       onTapTo: () {
            //         mytaskController.selectDate(context, false);
            //       },
            //       isFromEnable: mytaskController.isFromDate.value,
            //       isToEnable: mytaskController.isToDate.value,
            //     )),
            // const SizedBox(
            //   height: 15,
            // ),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => buildExpansionTextFields(
                        controller: mytaskController.searchController.value,
                        onTap: () {},
                        isReadOnly: false,
                        onChanged: (value) {},
                        focus: _focusNode,
                        disableSuffix: true,
                        hint: 'Search',
                        isSearch: true),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).unfocus();
                    mytaskController.searchMytaskLIst(
                        mytaskController.searchController.value.text.trim());
                  },
                  child: Card(
                      color: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.search,
                          color: AppColors.mutedColor,
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    mytaskController.clearSearch();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        context: context,
                        builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                left: 18,
                                right: 18,
                                top: 15,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Scrollbar(
                                thumbVisibility: true,
                                interactive: true,
                                child: SingleChildScrollView(
                                    child: _buildFilterBottomsheet(context)))));
                  },
                  child: Card(
                      color: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          AppIcons.filter,
                          width: 22,
                          height: 22,
                          color: AppColors.mutedColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                        '${mytaskController.filterSearchMyTaskList.length} Results',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.mutedColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            GetBuilder<MyTaskController>(
                builder: (controller) => controller.isMyTaskListLoading.value
                    ? popShimmer()
                    : controller.filterSearchMyTaskList.isEmpty
                        ? const Text("No Data")
                        : ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 8,
                                ),
                            shrinkWrap: true,
                            key: Key("my_task"),
                            itemCount: controller.filterSearchMyTaskList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var item = mytaskController
                                  .filterSearchMyTaskList[index];
                              var color =
                                  mytaskController.getColor(item.status ?? '');
                              return InkWell(
                                  onDoubleTap: () {
                                    mytaskController
                                        .getMyTaskbyid(item.taskCode ?? "");

                                    Get.to(() => AddMyTaskScreen(
                                          isUpdate: true,
                                        ));
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
                                            boxShadow: [
                                              BoxShadow(
                                                color: color == null ||
                                                        color == ''
                                                    ? Colors.white
                                                    : Color(int.parse(
                                                            '${color!.split('#')[1]}',
                                                            radix: 16) +
                                                        0xFF000000),
                                                // Color of the bottom border
                                                offset: const Offset(0,
                                                    3), // Position of the shadow
                                                blurRadius:
                                                    0, // Spread of the shadow
                                              ),
                                            ],
                                          ),
                                          child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: IgnorePointer(
                                                  ignoring: false,
                                                  child: ExpansionTile(
                                                      // initiallyExpanded: isExpanded,

                                                      tilePadding:
                                                          EdgeInsets.zero,
                                                      // trailing: const SizedBox(
                                                      //   width: 0,
                                                      // ),
                                                      textColor: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      title: InkWell(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            Null;
                                                          },
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      16,
                                                                      8,
                                                                      0,
                                                                      0),
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text(
                                                                                '${item.taskCode ?? ''} ',
                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {},
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                    color: color == null || color == '' ? Colors.white : Color(int.parse('${color!.split('#')[1]}', radix: 16) + 0xFF000000),
                                                                                  ),
                                                                                  child: Text(
                                                                                    '${item.status}',
                                                                                    style: TextStyle(fontSize: 12, color: color == null || color == '' ? Colors.black : ColorHelper.getContrastingTextColorFromHex(color!), fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                          Text(
                                                                            //   "13 FDB 2024",
                                                                            item.actStartDate == null || item.actStartDate == ''
                                                                                ? ""
                                                                                : "${DateFormatter.dateFormat.format(item.actStartDate ?? DateTime.now())}",
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                const TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          ),
                                                                        ]),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    _buildTileText(
                                                                        text: item.createdBy ??
                                                                            "",
                                                                        title:
                                                                            'Created By'),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    _buildTileText(
                                                                        text: item.jobCode ??
                                                                            "",
                                                                        //"${item.jobCode ?? ""} - ${item.job ?? ''}",
                                                                        title:
                                                                            'Job'),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    _buildTileText(
                                                                        text: item.description ??
                                                                            '',
                                                                        title:
                                                                            'Description'),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ]))),
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                ),
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            12,
                                                                            0,
                                                                            12,
                                                                            8),
                                                                    child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Divider(
                                                                            thickness:
                                                                                1.5,
                                                                            color:
                                                                                AppColors.lightGrey,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          buildTileTwoHeaderText(
                                                                            firstTitle:
                                                                                'Priority',
                                                                            firstText:
                                                                                item.priorityId ?? "",
                                                                            // "${item.priorityId ?? ""} - ${item.priority ?? ''}",
                                                                            secondTitle:
                                                                                "Complete",
                                                                            secondText:
                                                                                "${item.completed ?? ''}%",
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          buildTileTwoHeaderText(
                                                                              firstTitle: 'Assigned',
                                                                              firstText: "${item.assignedTo ?? ''}",
                                                                              secondTitle: "Requested",
                                                                              secondText: "${item.requestedBy ?? ''}"),
                                                                          SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          _buildTileText(
                                                                              text: item.taskGroup ?? "",
                                                                              title: "Task Group"),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          _buildExpansionTextFields(
                                                                              controller: TextEditingController(
                                                                                text: "Start Date : ${item.startDate == null || item.startDate == '' ? "" : DateFormatter.dateFormat.format(item.startDate ?? DateTime.now())}",
                                                                              ),
                                                                              onTap: () {}),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          _buildExpansionTextFields(
                                                                              controller: TextEditingController(
                                                                                text: "End Date : ${item.endDate == null || item.endDate == '' ? "" : DateFormatter.dateFormat.format(item.endDate ?? DateTime.now())}",
                                                                              ),
                                                                              onTap: () {}),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          _buildExpansionTextFields(
                                                                              controller: TextEditingController(
                                                                                text: "Actual Start Date : ${item.actStartDate == null || item.actStartDate == '' ? "" : DateFormatter.dateFormat.format(item.actStartDate ?? DateTime.now())}",
                                                                              ),
                                                                              onTap: () {}),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          _buildExpansionTextFields(
                                                                              controller: TextEditingController(
                                                                                text: "Actual End Date : ${item.actEndDate == null || item.actEndDate == '' ? "" : DateFormatter.dateFormat.format(item.actEndDate ?? DateTime.now())}",
                                                                              ),
                                                                              onTap: () {}),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                        ]))))
                                                      ]))))));
                            }))
          ]),
        ),
      ),
      floatingActionButton: Visibility(
        visible: mytaskController.isViewEnabled.value,
        child: FloatingActionButton(
            onPressed: () {
              mytaskController.clearData();
              Get.to(() => AddMyTaskScreen(
                    isUpdate: false,
                  ));
            },
            child: Icon(Icons.add),
            backgroundColor: AppColors.primary),
      ),
    );
  }

  Row _buildTileText({required String title, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title: ",
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        Expanded(
          child: Text(text,
              textAlign: TextAlign.start,
              // maxLines: 2,
              style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        ),
      ],
    );
  }

  Row buildTileTwoHeaderText(
      {required String firstTitle,
      required String firstText,
      required String secondTitle,
      required String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTileText(title: firstTitle, text: firstText)),
        SizedBox(
          width: 5,
        ),
        Expanded(child: _buildTileText(title: secondTitle, text: secondText))
      ],
    );
  }

  _buildOpenListPopContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: GetBuilder<MyTaskController>(
                builder: (controller) => controller.isLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : controller.myTaskfiltermodeList.isEmpty
                        ? Text("No Data")
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = controller.myTaskfiltermodeList[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  controller.selectedPublicFilter.value = item;
                                  mytaskController.getMyTaskFollowUpList();
                                  mytaskController.myTaskIdFilterController
                                      .text = item.name;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item.name}",
                                        style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: controller.myTaskfiltermodeList.length)),
          )
        ],
      ),
    );
  }

  Column _buildFilterBottomsheet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Filter'),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Public'),
                  buildExpansionTextFields(
                    controller: mytaskController.myTaskIdFilterController,
                    onTap: () {
                      CommonWidget.commonDialog(
                          context: context,
                          title: "Select Mode",
                          content: _buildOpenListPopContent(context));
                      // _buildOpenListPopContent(
                      //   context,
                      // );
                    },
                    isDropdown: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       // width: MediaQuery.of(context).size.width,
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(6),
        //           ),
        //           backgroundColor: AppColors.mutedBlueColor,
        //         ),
        //         onPressed: () {
        //           mytaskController.myTaskIdFilterController.clear();
        //           //mytaskController.clearFilter();
        //         },
        //         child: const Text(
        //           'Clear',
        //           style: TextStyle(
        //             color: AppColors.primary,
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 10,
        //     ),
        //     Expanded(
        //       // width: MediaQuery.of(context).size.width,
        //       child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(6),
        //             ),
        //             backgroundColor: AppColors.primary,
        //           ),
        //           onPressed: () {
        //             //  mytaskController.getMyTaskList(
        //             //                   filterMode: MyTask.CreatedBy.value);
        //             // mytaskController.getMyTaskList();
        //             Navigator.pop(context);
        //           },
        //           child: const Text('Apply')),
        //     ),
        //   ],
        // )
      ],
    );
  }

  ClipRRect _buildExpansionTextFields(
      {required TextEditingController controller, required Function() onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: AppColors.mutedColor),
        maxLines: 1,
        onTap: onTap,
        readOnly: true,
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          filled: true,
          // enabled: false,
          fillColor: AppColors.lightGrey.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffix: SvgPicture.asset(
            AppIcons.calendar1,
            color: AppColors.mutedColor,
            height: 15,
            width: 15,
          ),
        ),
      ),
    );
  }

  static int getValueFromName(String name) {
    for (var task in MyTask.values) {
      if (task.name == name) {
        return task.value;
      }
    }
    // Return null or throw an exception if the name doesn't exist
    throw Exception('No enum value found for name: $name');
  }
}
