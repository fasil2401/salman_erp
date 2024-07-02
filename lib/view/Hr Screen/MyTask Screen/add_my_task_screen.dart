import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/my_task_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';
import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Theme/color_helper.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/MyTask%20Screen/Components/add_comments.dart';
import 'package:axolon_erp/view/Hr%20Screen/MyTask%20Screen/Components/common_text_feild.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/chatscreen.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddMyTaskScreen extends StatelessWidget {
  final bool isUpdate;
  AddMyTaskScreen({Key? key, required this.isUpdate}) : super(key: key);
  final mytaskController = Get.put(MyTaskController());
  final homeController = Get.put(HomeController());
  var selectedValue;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.3;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(1, 66, 150, 1),
        title: Text(
          isUpdate == true ? "Update My Task" : "Add My Task",
        ),
        actions: [
          Visibility(
            visible: isUpdate == false,
            child: IconButton(
              onPressed: () {
                if (mytaskController.isLoadingOpenlist.value) {
                  return;
                }
                mytaskController.getProjectTaskList();
                CommonWidget.commonDialog(
                  context: context,
                  title: "",
                  content: _buildOpenListPopContent(context),
                );
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       insetPadding: EdgeInsets.all(10),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(20))),
                //       title: _buildOpenListHeader(context),
                //       content: _buildOpenListPopContent(context),
                //       actions: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.all(5.0),
                //               child: InkWell(
                //                 onTap: () {
                //                   Navigator.pop(context);
                //                 },
                //                 child: Text('Close',
                //                     style: TextStyle(color: AppColors.primary)),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
              icon: SvgPicture.asset(
                AppIcons.openList,
                color: Colors.white,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MyTaskCommonTextField.textfield(
                    suffixicon: false,
                    readonly: true,
                    keyboardtype: TextInputType.text,
                    controller: homeController.nextcardnumbercontrol,
                    label: "Task Code",
                    isUpdate: isUpdate,
                    isDisabled: isUpdate,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      controller: mytaskController.statuscontrol.value,
                      keyboardtype: TextInputType.text,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (homeController.actionStatusComboList.isEmpty) {
                          homeController.getActionStatusComboList();
                        }
                        // await CommonWidget.commonDialog(
                        //   context: context,
                        //   title: "Status",
                        //   content: commonContent(
                        //       context: context,
                        //       search: true,
                        //       list: homeController.actionStatusComboList,
                        //       textController: mytaskController.statuscontrol.value),
                        // );
                        await showStatusList(
                          context: context,
                          list: homeController.actionStatusChangingList.value,
                          controller: homeController,
                          textController: mytaskController.statuscontrol.value,
                        );
                      },
                      label: "Status",
                    ))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            MyTaskCommonTextField.textfield(
              suffixicon: false,
              readonly: false,
              keyboardtype: TextInputType.text,
              controller: mytaskController.descriptionController.value,
              label: "Description",
              isUpdate: isUpdate,
              isDisabled: isUpdate,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                      child: MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        controller: mytaskController.taskgroupcontrol.value,
                        icon: Icons.arrow_drop_down_circle_outlined,
                        ontap: () async {
                          if (mytaskController.taskGroupList.isEmpty) {
                            mytaskController.getTaskGroup();
                          }
                          await CommonWidget.commonDialog(
                            context: context,
                            title: "Task Group",
                            content: commonContent(
                                context: context,
                                search: false,
                                list: mytaskController.taskGroupList,
                                textController:
                                    mytaskController.taskgroupcontrol.value),
                          );
                        },
                        label: "Task Group",
                        isUpdate: isUpdate,
                        isDisabled: isUpdate,
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      controller: mytaskController.projectcontrol.value,
                      keyboardtype: TextInputType.text,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (homeController.jobList.isEmpty) {
                          await homeController.getJobList();
                        }
                        print(
                            "${homeController.filterJobList.length}lengthhhhh");
                        await CommonWidget.commonDialog(
                            context: context,
                            title: "Project",
                            content: commonContent(
                              context: context,
                              search: true,
                              list: homeController.filterJobList,
                              textController:
                                  mytaskController.projectcontrol.value,
                              expansionTextField: buildExpansionTextFields(
                                controller: TextEditingController(),
                                onTap: () {},
                                isSearch: true,
                                hint: 'Search',
                                isReadOnly: false,
                                onChanged: (value) async {
                                  await mytaskController.filterJobLists(value);
                                },
                                onEditingComplete: () async {},
                              ),
                            ));
                      },
                      label: "Project",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: mytaskController.costCategorycontrol.value,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (mytaskController.costCategoryList.isEmpty) {
                          mytaskController.getCostCategory();
                        }

                        await CommonWidget.commonDialog(
                          context: context,
                          title: "Cost Category",
                          content: commonContent(
                              search: false,
                              context: context,
                              list: mytaskController.costCategoryList,
                              textController:
                                  mytaskController.costCategorycontrol.value),
                        );
                      },
                      label: "Cost Category",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
                SizedBox(
                  width: 10,
                ),
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      controller: mytaskController.prioritycontrol.value,
                      keyboardtype: TextInputType.text,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (mytaskController.priorityList.isEmpty) {
                          mytaskController.getPriority();
                        }
                        await CommonWidget.commonDialog(
                          context: context,
                          title: "Priority",
                          content: commonContent(
                              context: context,
                              search: false,
                              list: mytaskController.priorityList,
                              textController:
                                  mytaskController.prioritycontrol.value),
                        );
                      },
                      label: "Priority",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: Obx(() => MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.datetime,
                        controller: TextEditingController(
                            text:
                                "${DateFormatter.dateFormat.format(mytaskController.scheduleStartDate.value)}"),
                        label: "Schedule Start Date",
                        isUpdate: isUpdate,
                        isDisabled: isUpdate,
                        ontap: () async {
                          DateTime date = await mytaskController.selectDate(
                              context,
                              mytaskController.scheduleStartDate.value);
                          mytaskController.scheduleStartDate.value = date;
                        },
                        icon: Icons.calendar_month_outlined))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Obx(() => MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.datetime,
                        controller: TextEditingController(
                            text:
                                "${DateFormatter.dateFormat.format(mytaskController.scheduleendDate.value)}"),
                        label: "Schedule End Date",
                        isUpdate: isUpdate,
                        isDisabled: isUpdate,
                        ontap: () async {
                          DateTime date = await mytaskController.selectDate(
                              context, mytaskController.scheduleendDate.value);
                          mytaskController.scheduleendDate.value = date;
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
                    child: Obx(() => MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.datetime,
                        controller: TextEditingController(
                            text:
                                "${DateFormatter.dateFormat.format(mytaskController.actualStartDate.value)}"),
                        label: "Actual Date",
                        isUpdate: isUpdate,
                        isDisabled: isUpdate,
                        ontap: () async {
                          DateTime date = await mytaskController.selectDate(
                              context, mytaskController.actualStartDate.value);
                          mytaskController.actualStartDate.value = date;
                        },
                        icon: Icons.calendar_month_outlined))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Obx(() => MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.datetime,
                        controller: TextEditingController(
                            text:
                                "${DateFormatter.dateFormat.format(mytaskController.actualEndDate.value)}"),
                        label: "Actual End Date",
                        isUpdate: isUpdate,
                        isDisabled: isUpdate,
                        ontap: () async {
                          DateTime date = await mytaskController.selectDate(
                              context, mytaskController.actualEndDate.value);
                          mytaskController.actualEndDate.value = date;
                        },
                        icon: Icons.calendar_month_outlined))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MyTaskCommonTextField.textfield(
                    suffixicon: false,
                    readonly: false,
                    keyboardtype: TextInputType.number,
                    controller: mytaskController.totalhourscontrol.value,
                    label: "Total Hours",
                    // isUpdate: isUpdate,
                    // isDisabled: isUpdate,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: MyTaskCommonTextField.textfield(
                        suffixicon: true,
                        readonly: false,
                        keyboardtype: TextInputType.number,
                        controller: mytaskController.percCompletedcontrol.value,
                        icon: Icons.percent,
                        ontap: () async {
                          // await CommonWidget.commonDialog(
                          //   context: context,
                          //   title: "Percentage Completed",
                          //   content: Column(),
                          // );
                        },
                        label: "Perc.Completed")),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: mytaskController.requesteedtocontrol.value,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (homeController.employeesList.isEmpty) {
                          await homeController.getEmployeesList();
                        }
                        await CommonWidget.commonDialog(
                            context: context,
                            title: "Requested By",
                            content: commonContent(
                              context: context,
                              search: true,
                              list: homeController.employeesFilterList,
                              textController:
                                  mytaskController.requesteedtocontrol.value,
                              expansionTextField: buildExpansionTextFields(
                                controller: TextEditingController(),
                                onTap: () {},
                                isSearch: true,
                                hint: 'Search',
                                isReadOnly: false,
                                onChanged: (value) {
                                  mytaskController.filterEmployeeLists(value);
                                },
                                onEditingComplete: () async {},
                              ),
                            ));
                      },
                      label: "Requested By",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
                SizedBox(
                  width: 10,
                ),
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: mytaskController.assignedtocontrol.value,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (homeController.employeesList.isEmpty) {
                          await homeController.getEmployeesList();
                        }
                        await CommonWidget.commonDialog(
                            context: context,
                            title: "Assigned To",
                            content: commonContent(
                              search: true,
                              context: context,
                              list: homeController.employeesFilterList,
                              textController:
                                  mytaskController.assignedtocontrol.value,
                              expansionTextField: buildExpansionTextFields(
                                controller: TextEditingController(),
                                onTap: () {},
                                isSearch: true,
                                hint: 'Search',
                                isReadOnly: false,
                                onChanged: (value) {
                                  mytaskController.filterEmployeeLists(value);
                                },
                                onEditingComplete: () async {},
                              ),
                            ));
                      },
                      label: "Assigned To",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: mytaskController.teamidController.value,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (mytaskController.teamIdList.isEmpty) {
                          mytaskController.getTeamId();
                        }
                        await CommonWidget.commonDialog(
                          context: context,
                          title: "Team",
                          content: commonContent(
                              search: false,
                              context: context,
                              list: mytaskController.teamIdList,
                              textController:
                                  mytaskController.teamidController.value),
                        );
                      },
                      label: "Team",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
                SizedBox(
                  width: 10,
                ),
                Obx(() => Expanded(
                        child: MyTaskCommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: mytaskController.delayReasoncontrol.value,
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        if (mytaskController.delayReasonList.isEmpty) {
                          mytaskController.getDelayReason();
                        }
                        await CommonWidget.commonDialog(
                          context: context,
                          title: "Delay Reason",
                          content: commonContent(
                              search: false,
                              context: context,
                              list: mytaskController.delayReasonList,
                              textController:
                                  mytaskController.delayReasoncontrol.value),
                        );
                      },
                      label: "Delay Reason",
                      isUpdate: isUpdate,
                      isDisabled: isUpdate,
                    ))),
              ],
            ),

            // Obx(() => MyTaskCommonTextField.textfield(
            //       suffixicon: true,
            //       readonly: true,
            //       keyboardtype: TextInputType.text,
            //       controller: mytaskController.teamidController.value,
            //       icon: Icons.arrow_drop_down_circle_outlined,
            //       ontap: () async {
            //         if (mytaskController.teamIdList.isEmpty) {
            //           mytaskController.getTeamId();
            //         }
            //         await CommonWidget.commonDialog(
            //           context: context,
            //           title: "Team",
            //           content: commonContent(
            //               search: false,
            //               context: context,
            //               list: mytaskController.teamIdList,
            //               textController:
            //                   mytaskController.teamidController.value),
            //         );
            //       },
            //       label: "Team",
            //       isUpdate: isUpdate,
            //       isDisabled: isUpdate,
            //     )),
            // SizedBox(
            //   height: 15,
            // ),
            // Obx(() => MyTaskCommonTextField.textfield(
            //       suffixicon: true,
            //       readonly: true,
            //       keyboardtype: TextInputType.text,
            //       controller: mytaskController.delayReasoncontrol.value,
            //       icon: Icons.arrow_drop_down_circle_outlined,
            //       ontap: () async {
            //         if (mytaskController.delayReasonList.isEmpty) {
            //           mytaskController.getDelayReason();
            //         }
            //         await CommonWidget.commonDialog(
            //           context: context,
            //           title: "Delay Reason",
            //           content: commonContent(
            //               search: false,
            //               context: context,
            //               list: mytaskController.delayReasonList,
            //               textController:
            //                   mytaskController.delayReasoncontrol.value),
            //         );
            //       },
            //       label: "Delay Reason",
            //       isUpdate: isUpdate,
            //       isDisabled: isUpdate,
            //     )),
            SizedBox(
              height: 15,
            ),
            MyTaskCommonTextField.multilineTextfield(
              maxline: 2,
              label: 'Note',
              controller: mytaskController.noteController.value,
              isUpdate: isUpdate,
            )
          ]),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.rotate(
              angle: -90 * (pi / 180),
              child: IconButton(
                icon: Icon(
                  Icons.attachment,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () {
                  CommonWidget.commonDialog(
                      context: context,
                      title: "Add Attachment",
                      content: selectAttachment(context));
                },
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.chat_outlined,
                size: 25,
                color: AppColors.mutedColor,
              ),
              onPressed: () {
                Get.to(CommentPage());
              },
            ),
            SizedBox(width: screenWidth * 0.4),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () async {
                  if (mytaskController.validation()) {
                    await mytaskController.createMyTask();
                    mytaskController.clearData();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(() => mytaskController.isSaveloading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ))
                        : Text(
                            isUpdate == true ? "Update" : "Create",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ))),
              ),
            ),
            //           Container(
            //             width: buttonWidth,
            //             child: Obx(
            // () => mytaskController.isSaveloading.value
            //     ? SizedBox(
            //         width: 20,
            //         height: 20,
            //         child: CircularProgressIndicator(
            //                     strokeWidth: 2,
            //                     color: Colors.white,
            //                   ),
            //       )
            //     : Buttons.buildElevatedButton(
            //         text: isUpdate == true ? "Update" : "Create",
            //         onPressed: () async {
            //           if (mytaskController.validation()) {
            //             await mytaskController.createMyTask();
            //             mytaskController.clearData();
            //             Navigator.pop(context);
            //           }
            //         },
            //         color: AppColors.primary,
            //         textColor: AppColors.white,
            //       ),
// )

//             ),
          ],
        ),
      ),
    );
  }

  commonContent(
      {required BuildContext context,
      var list,
      required bool search,
      required TextEditingController textController,
      Widget? expansionTextField}) {
    // accept Widget as optional parameter
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: search == true,
            child: expansionTextField ?? SizedBox(),
          ),
          SizedBox(
            height: 5,
          ),
          GetBuilder<MyTaskController>(
              builder: (controller) => controller.isLoading.value
                  ? SalesShimmer.locationPopShimmer()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = list[index];
                        return InkWell(
                          onTap: () {
                            // controller.getTaskGroup();
                            textController.text = "${item.code} - ${item.name}";
                            mytaskController.clearSearch();

                            Navigator.pop(
                              context,
                            ); // Return selected item
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${item.code} - ${item.name}",
                                    style: TextStyle(
                                        color: AppColors.mutedColor,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: list.length)),
        ],
      ),
    );
  }

  showStatusList({
    required BuildContext context,
    required List<ActionStatusSecuirityModel> list,
    required var controller,
    required TextEditingController textController,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          insetPadding: EdgeInsets.all(10),
          title: popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Status',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildExpansionTextFields(
                controller: TextEditingController(),
                onTap: () {},
                isSearch: true,
                hint: 'Search',
                isReadOnly: false,
                onChanged: (value) {
                  homeController.searchStatusLIst(value);
                },
                onEditingComplete: () async {},
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => homeController.isLoading.value
                        ? SalesShimmer.locationPopShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.filterActionStatusList.length,
                            itemBuilder: (context, index) {
                              var status =
                                  controller.filterActionStatusList[index];
                              return InkWell(
                                onTap: () {
                                  controller.selectedStatusValue.value = status;

                                  textController.text =
                                      "${status.code} - ${status.name}";
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(
                                      thickness: 0.4,
                                      color: AppColors.mutedColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.lightGrey,
                                                width: 0.4,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: status.hexColorCode ==
                                                          null ||
                                                      status.hexColorCode == ''
                                                  ? Colors.white
                                                  : Color(int.parse(
                                                          '${status.hexColorCode!.split('#')[1]}',
                                                          radix: 16) +
                                                      0xFF000000),
                                            ),
                                          ),
                                          AutoSizeText(
                                            "${status.code}",
                                            minFontSize: 8,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: AppColors.mutedColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  selectAttachment(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => GestureDetector(
              onTap: () async {
                homeController.selectFile();
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: AppColors.mutedColor,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                          color: AppColors.mutedColor.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10)),
                      child: homeController.result.value == FilePickerResult([])
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  color: AppColors.mutedColor,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Attach File',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                ),
                              ],
                            )
                          : Center(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 4),
                                  itemCount:
                                      homeController.result.value.files.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          homeController.filetypeIcon(index),
                                          Center(
                                            child: Text(
                                              "${homeController.result.value.files[index].name}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: AppColors.mutedColor,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: () {},
          //           child: Text(
          //             "Clear",
          //             style: TextStyle(color: AppColors.primary),
          //           ),
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: AppColors.mutedBlueColor,
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(5))),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Expanded(
          //       child: SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: () {},
          //           child: Text(
          //             "Add",
          //             style: TextStyle(color: AppColors.primary),
          //           ),
          //           style: ElevatedButton.styleFrom(
          //               backgroundColor: AppColors.mutedBlueColor,
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(5))),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  Column _buildOpenListHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Obx(
                () => DropdownButtonFormField2(
                  isDense: true,
                  value: DateRangeSelector
                      .dateRange[mytaskController.dateIndex.value],
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Dates',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Rubik',
                        ),
                      ),
                    ),
                    // contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                  ),
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  items: DateRangeSelector.dateRange
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedValue = value;
                    mytaskController.selectDateRange(selectedValue.value,
                        DateRangeSelector.dateRange.indexOf(selectedValue));
                  },
                  onSaved: (value) {},
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
                child: Obx(
              () => _buildDateTextFeild(
                controller: TextEditingController(
                  text: DateFormatter.dateFormat
                      .format(mytaskController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: mytaskController.isFromDate.value,
                isDate: true,
                onTap: () {
                  mytaskController.selectDate(context, true);
                },
              ),
            )),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Obx(
                () => _buildDateTextFeild(
                  controller: TextEditingController(
                    text: DateFormatter.dateFormat
                        .format(mytaskController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: mytaskController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    mytaskController.selectDate(context, false);
                  },
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              mytaskController.getProjectTaskList();
              // Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rubik',
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField _buildDateTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }

  SizedBox _buildOpenListPopContent(BuildContext context) {
    return SizedBox(
      //width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOpenListHeader(context),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => mytaskController.isLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : mytaskController.projectTaskFollowUpList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                mytaskController.projectTaskFollowUpList.length,
                            itemBuilder: (context, index) {
                              var item = mytaskController
                                  .projectTaskFollowUpList[index];
                              var color =
                                  mytaskController.getColor(item.status ?? '');
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: InkWell(
                                  onDoubleTap: () {
                                    mytaskController
                                        .getMyTaskbyid(item.taskCode);

                                    Navigator.pop(context);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         AddMyTaskScreen(isUpdate: true),
                                    //   ),
                                    // );

                                    // Get.to(() => AddMyTaskScreen(
                                    //       isUpdate: true,
                                    //     ));
                                  },
                                  splashColor:
                                      AppColors.mutedColor.withOpacity(0.2),
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item.taskCode ?? ''} ',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.primary),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: color == null ||
                                                            color == ''
                                                        ? Colors.white
                                                        : Color(int.parse(
                                                                '${color!.split('#')[1]}',
                                                                radix: 16) +
                                                            0xFF000000),
                                                  ),
                                                  child: Text(
                                                    '${item.status}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: color == null ||
                                                                color == ''
                                                            ? Colors.black
                                                            : ColorHelper
                                                                .getContrastingTextColorFromHex(
                                                                    color!),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ]),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          //width: width * 0.6,
                                          child: AutoSizeText(
                                            '${item.createdBy}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Job : ${item.job}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Description :${item.description}',
                                          //'Date : ${DateFormatter.dateFormat.format(item.orderDate)}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
