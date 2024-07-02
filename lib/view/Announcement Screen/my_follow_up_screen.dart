import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/follow_up_controller.dart';
import 'package:axolon_erp/services/enums.dart';

import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';

import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFollowUpScreen extends StatelessWidget {
  MyFollowUpScreen({super.key});
  final followupcontroller = Get.put(FollowUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: GetBuilder<FollowUpController>(
              builder: (_) => _.isLoading.value
                  ? popShimmer()
                  : _.followUpList.isEmpty
                      ? Center(child: Text("No Data"))
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                          itemCount: _.followUpList.length,
                          itemBuilder: (context, index) {
                            var item = _.followUpList[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shadowColor: Colors.black,
                              elevation: 10,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      color: isSameDay(item.nextfollowupDate!)
                                          ? item.followUpStatus == null
                                              ? Colors.white
                                              : item.followUpStatus ==
                                                      FollowUpStatus.Open.value
                                                  ? FollowUpStatus.Open.color
                                                  : item.followUpStatus ==
                                                          FollowUpStatus
                                                              .InProgress.value
                                                      ? FollowUpStatus
                                                          .InProgress.color
                                                      : item.followUpStatus ==
                                                              FollowUpStatus
                                                                  .Completed
                                                                  .value
                                                          ? FollowUpStatus
                                                              .Completed.color
                                                          : Colors.white
                                          : Colors.transparent),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: item.followUpStatus == null
                                          ? Colors.white
                                          : item.followUpStatus ==
                                                  FollowUpStatus.Open.value
                                              ? FollowUpStatus.Open.color
                                              : item.followUpStatus ==
                                                      FollowUpStatus
                                                          .InProgress.value
                                                  ? FollowUpStatus
                                                      .InProgress.color
                                                  : item.followUpStatus ==
                                                          FollowUpStatus
                                                              .Completed.value
                                                      ? FollowUpStatus
                                                          .Completed.color
                                                      : Colors.white,
                                      //  _getColorForLeadStatus(
                                      //     item.leadStatus),
                                      offset: const Offset(0, 3),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: IgnorePointer(
                                    ignoring: false,
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.zero,
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          Null;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      item.leadName ?? "",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .mutedColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      buildFilterDialog(context,
                                                          followupcontroller,
                                                          followUpId:
                                                              item.followupId ??
                                                                  '');
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 9,
                                                          vertical: 3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: item.followUpStatus ==
                                                                null
                                                            ? Colors.white
                                                            : item.followUpStatus ==
                                                                    FollowUpStatus
                                                                        .Open
                                                                        .value
                                                                ? FollowUpStatus
                                                                    .Open.color
                                                                : item.followUpStatus ==
                                                                        FollowUpStatus
                                                                            .InProgress
                                                                            .value
                                                                    ? FollowUpStatus
                                                                        .InProgress
                                                                        .color
                                                                    : item.followUpStatus ==
                                                                            FollowUpStatus
                                                                                .Completed.value
                                                                        ? FollowUpStatus
                                                                            .Completed
                                                                            .color
                                                                        : Colors
                                                                            .white,
                                                      ),
                                                      child: Text(
                                                        item.followUpStatus ==
                                                                null
                                                            ? ''
                                                            : item.followUpStatus ==
                                                                    FollowUpStatus
                                                                        .Open
                                                                        .value
                                                                ? FollowUpStatus
                                                                    .Open.name
                                                                : item.followUpStatus ==
                                                                        FollowUpStatus
                                                                            .InProgress
                                                                            .value
                                                                    ? FollowUpStatus
                                                                        .InProgress
                                                                        .name
                                                                    : item.followUpStatus ==
                                                                            FollowUpStatus
                                                                                .Completed.value
                                                                        ? FollowUpStatus
                                                                            .Completed
                                                                            .name
                                                                        : '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: item.followUpStatus ==
                                                                  FollowUpStatus
                                                                      .Completed
                                                                      .value
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "CurrentDate : ${item.currentfollowupDate == null ? '' : DateFormatter.dateFormat.format(item.currentfollowupDate!)}",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.mutedColor,
                                                      fontSize: 12.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    "NextDate : ${item.nextfollowupDate == null ? '' : DateFormatter.dateFormat.format(item.nextfollowupDate!)}",
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      childrenPadding: EdgeInsets.all(8),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                item.remark ?? "",
                                                style: TextStyle(
                                                  color: AppColors.mutedColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}

bool isSameDay(DateTime date) {
  return DateTime.now().year == date.year &&
      DateTime.now().month == date.month &&
      DateTime.now().day == date.day;
}

Future<dynamic> buildFilterDialog(
    BuildContext context, FollowUpController controller,
    {required String followUpId}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          title: popupTitle(
              onTap: () {
                controller.isSelectedStatus.value = false;
                controller.update();
                Navigator.pop(context);
              },
              title: 'Select Status'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: GetBuilder<FollowUpController>(
                    builder: (_) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: FollowUpStatus.values.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              _.selectStatus(index);
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 12,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.lightGrey,
                                                width: 0.4),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: FollowUpStatus
                                                .values[index].color),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          FollowUpStatus.values[index].name,
                                          minFontSize: 8,
                                          maxFontSize: 14,
                                          style: const TextStyle(
                                            color: AppColors.mutedColor,
                                          ),
                                        ),
                                      ),
                                      _.isSelectedStatus.value &&
                                              _.selectedSTatusIndex.value ==
                                                  index
                                          ? const Icon(
                                              Icons.check,
                                              size: 15,
                                              color: AppColors.primary,
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (controller.isSelectedStatus.value == false) {
                            SnackbarServices.errorSnackbar(
                                'Please select a status !');
                            return;
                          } else {
                            controller.isSelectedStatus.value = false;
                            Navigator.pop(context);
                            controller.changeStatus(
                                followUpId: followUpId,
                                status: FollowUpStatus
                                    .values[
                                        controller.selectedSTatusIndex.value]
                                    .value);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Text('Apply')))
              ],
            ),
          ),
        );
      });
}

Color _getColorForLeadStatus(String? leadStatus) {
  if (leadStatus != null) {
    switch (leadStatus.toUpperCase()) {
      case 'OPEN':
        return Color(0xFF00FF00);
      case 'INPROGRESS':
        return Color(0xFFFF8000);
      case 'COMPLETED':
        return AppColors.primary;
      default:
        return Colors.transparent;
    }
  }
  return Colors.transparent;
}
