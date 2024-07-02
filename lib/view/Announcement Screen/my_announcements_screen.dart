import 'package:axolon_erp/controller/app%20controls/announcement_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAnnouncementScreen extends StatelessWidget {
  MyAnnouncementScreen({super.key});
  final announcementController = Get.put(AnnouncementController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: GetBuilder<AnnouncementController>(
              builder: (_) => _.isAnnouncementLoading.value
                  ? popShimmer()
                  : _.announcemnetList.isEmpty
                      ? Center(child: Text("No Data"))
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                                height: 8,
                              ),
                          itemCount: _.announcemnetList.length,
                          itemBuilder: (context, index) {
                            var item = _.announcemnetList[index];
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
                                      color: AppColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: item.priority == null
                                              ? Colors.white
                                              : item.priority ==
                                                      Priority.High.value
                                                  ? Priority.High.color
                                                  : item.priority ==
                                                          Priority.Medium.value
                                                      ? Priority.Medium.color
                                                      : item.priority ==
                                                              Priority.Low.value
                                                          ? Priority.Low.color
                                                          : Colors
                                                              .white, // Color of the bottom border
                                          offset: const Offset(
                                              0, 3), // Position of the shadow
                                          blurRadius: 0, // Spread of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: IgnorePointer(
                                            ignoring: false,
                                            child: ExpansionTile(
                                              tilePadding: EdgeInsets.zero,
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: InkWell(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Null;
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                Text(
                                                                  'Subject : ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: AppColors
                                                                          .mutedColor),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    "${item.subject ?? ''}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: AppColors
                                                                            .primary),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: item.priority ==
                                                                      null
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          1)
                                                                  : item.priority ==
                                                                          Priority
                                                                              .High.value
                                                                      ? Priority
                                                                          .High
                                                                          .color
                                                                      : item.priority ==
                                                                              Priority
                                                                                  .Medium.value
                                                                          ? Priority
                                                                              .Medium
                                                                              .color
                                                                          : item.priority == Priority.Low.value
                                                                              ? Priority.Low.color
                                                                              : Colors.white,
                                                            ),
                                                            child: Text(
                                                              item.priority ==
                                                                      null
                                                                  ? ''
                                                                  : item.priority ==
                                                                          Priority
                                                                              .High
                                                                              .value
                                                                      ? Priority
                                                                          .High
                                                                          .name
                                                                      : item.priority ==
                                                                              Priority
                                                                                  .Medium.value
                                                                          ? Priority
                                                                              .Medium
                                                                              .name
                                                                          : item.priority == Priority.Low.value
                                                                              ? Priority.Low.name
                                                                              : '',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        DateFormatter
                                                            .dateFormatter
                                                            .format(DateTime.parse(
                                                                item.announcementDate ??
                                                                    '')),
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .mutedColor,
                                                            fontSize: 13),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              childrenPadding:
                                                  EdgeInsets.all(10),
                                              children: [
                                                if (item.notification != null &&
                                                    item.notification!
                                                        .isNotEmpty)
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                        item.notification ?? '',
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .mutedColor,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            )))));
                          }),
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

Widget commonText(
        {required String firstHead,
        required String firstData,
        required String secondHead,
        required String secondData,
        required bool isthirdTextavailable,
        String? thirdHead,
        String? thirdData}) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstHead,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400),
              ),
              Flexible(
                  child: Text(
                firstData,
                style: TextStyle(
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              )),
            ],
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                secondHead,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400),
              ),
              Flexible(
                  child: Text(
                secondData,
                style: TextStyle(
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              )),
            ],
          ),
        ),
        SizedBox(
          width: 5,
        ),
        if (isthirdTextavailable)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thirdHead ?? '',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w400),
                ),
                Flexible(
                    child: Text(
                  thirdData ?? '',
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                )),
              ],
            ),
          ),
      ],
    );
