import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/Approval%20Controller/approval_controller.dart';
import 'package:axolon_erp/model/Approvals%20Model/showApprovalDetailsModel.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'dart:math' as math;
import 'package:timeline_tile/timeline_tile.dart';

Widget timelineApprovaalHistory(
    {required BuildContext context, required List<TaskDetailsModel> list}) {
  Size size = MediaQuery.of(context).size;
  final approvalController = Get.put(ApprovalController());
  return Obx(() => approvalController.isTaskDetailsLoading.value
          ? popShimmer()
          : list.isEmpty
              ? Center(child: Text("No Data"))
              : ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: approvalController.activeTaskDetails.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return
                        //  TimelineTile(
                        //     alignment: TimelineAlign.manual,
                        //     isLast: index == approvalController.taskDetails.length - 1,
                        //     isFirst: index == 0,
                        //     beforeLineStyle: LineStyle(color: Colors.grey, thickness: 1.5),
                        //     afterLineStyle: LineStyle(color: Colors.grey, thickness: 1.5),
                        //     lineXY: 0.3,
                        //     //  alignment: TimelineAlign.start,
                        //     endChild: Column(
                        //       children: [Text("xxx")],
                        //     ));

                        TimelineTile(
                            alignment: TimelineAlign.start,
                            lineXY: 0,
                            isFirst: index == 0,
                            isLast: index == list.length - 1,
                            beforeLineStyle:
                                LineStyle(color: Colors.grey, thickness: 1.5),
                            afterLineStyle:
                                LineStyle(color: Colors.grey, thickness: 1.5),
                            // indicatorStyle: IndicatorStyle(
                            // color: AppColors.primary,
                            // height: 10,
                            // width: 10,
                            // iconStyle: IconStyle(
                            //   fontSize: 5,
                            //   color: AppColors.mutedBlueColor,
                            //   iconData: Icons.circle,
                            // ),
                            // ),
                            indicatorStyle: IndicatorStyle(
                              indicatorXY: 0,
                              drawGap: true,
                              // color: item.isExpired == true ||
                              //         item.isExpired == null ||
                              //         item.isExpired == ''
                              //     ? AppColors.darkRed
                              //     : AppColors.darkGreen,
                              height: 25,
                              width: 25,
                              indicator: SvgPicture.asset(
                                ApprovalTypeStatus.values
                                    .firstWhere((element) =>
                                        element.value == item.status)
                                    .icon,
                                height: 25,
                                width: 25,
                                color: ApprovalTypeStatus.values
                                    .firstWhere((element) =>
                                        element.value == item.status)
                                    .color,
                              ),
                              //  CircleAvatar(
                              //   backgroundColor: AppColors.darkGreen,
                              //   child: Center(
                              //     child: Icon(
                              //       Icons.check,
                              //       size: 15,
                              //     ),
                              //   ),
                              // )
                              // iconStyle: IconStyle(
                              //   fontSize: 12,
                              //   color: AppColors.mutedBlueColor,
                              //   iconData: Icons.circle,
                              // ),
                            ),
                            endChild: approvalHistoryCard(context, item, size));
                  })
      //     ListTile(
      //   title: Column(
      //     children: [
      //       SizedBox(
      //           width: double.infinity,
      //           child: Row(
      //             children: [
      //               Transform.translate(
      //                 offset: Offset(-5, 0),
      //                 child: Container(
      //                   width: 12,
      //                   alignment: Alignment.center,
      //                   child: Container(
      //                     width: 12,
      //                     height: 12,
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(40),
      //                         border: Border.all(
      //                             width: 3,
      //                             color: AppColors.primary,
      //                             style: BorderStyle.solid)),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      // item.dateApproved == null || item.dateApproved == ''
      //     ? ""
      //     : DateFormatter.dateFormatter.format(
      //         DateTime.parse(item.dateApproved.toString())),
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.w400,
      //                     fontSize: 14.0,
      //                     color: AppColors.mutedColor),
      //               ),
      //             ],
      //           )),
      //       IntrinsicHeight(
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             Container(
      //               width: 3,
      //               alignment: Alignment.center,
      //               child: IntrinsicHeight(
      //                 child: Row(
      //                   crossAxisAlignment: CrossAxisAlignment.stretch,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                         color: Colors.grey,
      //                         width: 3,
      //                         height: 120 // if I remove the size it desappear
      //                         ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               width: 10,
      //             ), // Row(children: [
      //             Expanded(
      //               child: Row(
      //                 children: [
      //                   Expanded(
      //                     child: Card(
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.only(
      //                             topLeft: Radius.circular(10),
      //                             bottomLeft: Radius.circular(10)),
      //                       ),
      //                       elevation: 3,
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(15),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               item.userName == null || item.userName == ""
      //                                   ? item.assigneeId ?? ""
      //                                   : item.userName ?? '',
      //                               style:
      //                                   TextStyle(fontWeight: FontWeight.w600),
      //                             ),
      //                             const SizedBox(
      //                               height: 5,
      //                             ),
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   'Remarks : ',
      //                                   style: TextStyle(
      //                                       color: AppColors.mutedColor,
      //                                       fontWeight: FontWeight.w400),
      //                                 ),
      //                                 // Obx(() =>
      //                                 Expanded(
      //                                     child: Column(
      //                                   children: [
      //                                     Text(
      //                                       // textAlign: TextAlign.justify,
      //                                       item.remarks ??
      //                                           'typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
      //                                       maxLines: item.readMore! ? 1000 : 3,
      //                                     ),
      //                                     TextButton(
      //                                       onPressed: () {
      // approvalController
      //     .readMoreText(index);
      //                                       },
      //                                       child: Text(
      //                                         item.readMore!
      //                                             ? "Read less"
      //                                             : "Read more",
      //                                         style: TextStyle(
      //                                             color: AppColors.primary),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 )),
      //                               ],
      //                             ),
      //                             const SizedBox(
      //                               height: 5,
      //                             ),
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   'ApprovalStatus : ',
      //                                   style: TextStyle(
      //                                       color: AppColors.mutedColor,
      //                                       fontWeight: FontWeight.w400),
      //                                 ),
      //                                 Expanded(
      //                                   child: Text(
      //                                     item.status ==
      //                                             ApprovalTypeStatus
      //                                                 .Approved.value
      //                                         ? ApprovalTypeStatus.Approved.name
      //                                         : item.status ==
      //                                                 ApprovalTypeStatus
      //                                                     .Pending.value
      //                                             ? ApprovalTypeStatus
      //                                                 .Pending.name
      //                                             : item.status ==
      //                                                     ApprovalTypeStatus
      //                                                         .Rejected.value
      //                                                 ? ApprovalTypeStatus
      //                                                     .Rejected.name
      //                                                 : ApprovalTypeStatus
      //                                                     .WaitingPreRequisit
      //                                                     .name,
      //                                     style: TextStyle(
      //                                         color: AppColors.primary,
      //                                         fontWeight: FontWeight.w400),
      //                                   ),
      //                                 )
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Transform.translate(
      //               offset: Offset(-6, 0),
      //               child: SizedBox(
      //                 width: size.width / 7,
      //                 child: Card(
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.only(
      //                         topRight: Radius.circular(10),
      //                         bottomRight: Radius.circular(10)),
      //                   ),
      //                   elevation: 3,
      //                   color: item.isExpired == true
      //                       ? AppColors.darkRed
      //                       : AppColors.darkGreen,
      //                   child: Center(
      //                     child: Transform.rotate(
      //                         angle: math.pi / -2,
      //                         child: item.isExpired == true
      //                             ? Text(
      //                                 "Expired",
      //                                 style: TextStyle(
      //                                     color: AppColors.white,
      //                                     fontSize: 13,
      //                                     fontWeight: FontWeight.w500),
      //                               )
      //                             : Text(
      //                                 "Active",
      //                                 style: TextStyle(
      //                                     color: AppColors.white,
      //                                     fontSize: 13,
      //                                     fontWeight: FontWeight.w500),
      //                               )),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // ])
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      //   // ),
      // );
      // },
      );
}

Widget approvalHistoryCard(
    BuildContext context, TaskDetailsModel item, Size size) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.dateApproved == null || item.dateApproved == ''
                  ? ""
                  : DateFormatter.dayFormat
                      .format(DateTime.parse(item.dateApproved.toString())),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: AppColors.mutedColor,
              ),
            ),
            Text(
              item.dateApproved == null || item.dateApproved == ''
                  ? ""
                  : DateFormatter.dateFormatTime
                      .format(DateTime.parse(item.dateApproved.toString())),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: AppColors.mutedColor,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.lightGrey),
                color: AppColors.lightGrey.withOpacity(0.4)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Approval Status : ',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                        child: Text(
                          ApprovalTypeStatus.values
                              .firstWhere(
                                  (element) => element.value == item.status)
                              .name,
                          style: TextStyle(
                              fontSize: 14,
                              color: ApprovalTypeStatus.values
                                  .firstWhere(
                                      (element) => element.value == item.status)
                                  .color,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Visibility(
                        visible:
                            item.status == ApprovalTypeStatus.Waiting.value ||
                                item.status == ApprovalTypeStatus.Pending.value,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: popupTitle(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: 'User List'),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        item.userList ?? '',
                                        style: const TextStyle(
                                            color: AppColors.mutedColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Icon(
                            Icons.group,
                            size: 15,
                            color: AppColors.mutedColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigned To : ',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            item.assignedTo ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedColor,
                                fontWeight: FontWeight.w400),
                          )),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Performed By : ',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            item.approverId ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedColor,
                                fontWeight: FontWeight.w400),
                          )),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Remarks : ',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                            item.remarks ?? '',
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mutedColor,
                                fontWeight: FontWeight.w400),
                          )),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width / 9,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            elevation: 3,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}
