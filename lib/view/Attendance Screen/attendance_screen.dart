import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/dummy_list.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/Attendance%20Screen/components/report_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:axolon_erp/view/components/custom_text.dart';
import 'package:axolon_erp/view/components/responsive_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:getwidget/getwidget.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({this.isBottomNavigation, super.key});

  bool? isBottomNavigation;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final attendanceController = Get.put(AttendanceController());
  final homeController = Get.put(HomeController());

  var selectedValue;

  @override
  void initState() {
    super.initState();
    // attendanceController.getEmployeePunchingDetails();
    // attendanceController.initPage();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isBottomNavigation == null) {
        attendanceController.initPage();
      }
    });
    return DefaultTabController(
      length: 2,
      initialIndex: widget.isBottomNavigation != null ? 1 : 0,
      child: WillPopScope(
        onWillPop: () async {
          if (widget.isBottomNavigation != null) {
            await homeController.removeFromBottomList();
          }

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Attendance'),
            bottom: TabBar(tabs: [
              Tab(
                text: 'Attendance',
              ),
              Tab(
                text: 'Report',
              ),
              // Tab(
              //   text: 'Leave',
              // ),
            ]),
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: () => attendanceController.refreshLog(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: _buildTime()),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Obx(() => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    child: Text(
                                      'Job:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        attendanceController.getJobList();
                                        CommonWidget.commonDialog(
                                          context: context,
                                          title: "Select Job",
                                          content: selectJob(context),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(selectedValue?.name ??
                                              "Select Job"),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.mutedColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Expanded(
                                  //   child: Obx(
                                  //     () => DropdownButtonHideUnderline(
                                  //       child: DropdownButton2(
                                  //         isExpanded: false,
                                  //         isDense: true,
                                  //         hint: Text(
                                  //           'Select Job',
                                  //           style: TextStyle(
                                  //             fontSize: 14,
                                  //             color:
                                  //                 Theme.of(context).hintColor,
                                  //           ),
                                  //           overflow: TextOverflow.ellipsis,
                                  //         ),
                                  //         items: attendanceController.jobList
                                  //             .map((item) => DropdownMenuItem(
                                  //                   value: item,
                                  //                   child: Text(
                                  //                     item.name,
                                  //                     style: const TextStyle(
                                  //                       fontSize: 14,
                                  //                       color: Colors.black54,
                                  //                     ),
                                  //                   ),
                                  //                 ))
                                  //             .toList(),
                                  //         value: selectedValue,
                                  //         onChanged: (value) {
                                  //           setState(() {
                                  //             selectedValue = value;
                                  //           });
                                  //           attendanceController
                                  //               .setJobId(selectedValue);
                                  //         },
                                  //         dropdownDecoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(14),
                                  //           color: Colors.white,
                                  //         ),
                                  //         buttonHeight: 20,
                                  //         buttonWidth: 140,
                                  //         itemHeight: 40,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  if (attendanceController
                                          .allowGeoFencingOnPunching.value ==
                                      true)
                                    InkWell(
                                      onTap: () {
                                        attendanceController
                                            .googleMapView(context);
                                      },
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.primary,
                                      ),
                                    )
                                ],
                              ))),
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                                text: 'Check In',
                                icon: Icons.login_rounded,
                                color: AppColors.primary,
                                logFlag: 1),
                          ),
                          Expanded(
                            child: _buildButton(
                                text: 'Check Out',
                                icon: Icons.logout_rounded,
                                color: AppColors.primary,
                                logFlag: 2),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                                text: 'Start Break',
                                icon: Icons.coffee,
                                color: AppColors.primary,
                                logFlag: 3),
                          ),
                          Expanded(
                            child: _buildButton(
                                text: 'End Break',
                                icon: Icons.coffee_outlined,
                                color: AppColors.primary,
                                logFlag: 4),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _buildTimeLineHead(context),
                      Obx(
                        () => attendanceController.isLoading.value
                            ? _buildShimmer()
                            : Container(
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      attendanceController.attendanceLog.length,
                                  itemBuilder: (context, index) {
                                    return TimelineTile(
                                      alignment: TimelineAlign.manual,
                                      lineXY: 0.2,
                                      isFirst: index == 0,
                                      isLast: index ==
                                          attendanceController
                                                  .attendanceLog.length -
                                              1,
                                      afterLineStyle: LineStyle(
                                        color: AppColors.primary,
                                        thickness: 3,
                                      ),
                                      beforeLineStyle: LineStyle(
                                        color: AppColors.primary,
                                        thickness: 3,
                                      ),
                                      indicatorStyle: IndicatorStyle(
                                        width: 25,
                                        height: 25,
                                        indicator: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: attendanceController
                                                        .attendanceLog[index]
                                                        .logFlag ==
                                                    'CheckIn'
                                                ? AppColors.darkGreen
                                                : attendanceController
                                                            .attendanceLog[
                                                                index]
                                                            .logFlag ==
                                                        'CheckOut'
                                                    ? AppColors.darkRed
                                                    : AppColors.mutedColor,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              attendanceController
                                                          .attendanceLog[index]
                                                          .logFlag ==
                                                      'CheckIn'
                                                  ? Icons.login_rounded
                                                  : attendanceController
                                                              .attendanceLog[
                                                                  index]
                                                              .logFlag ==
                                                          'CheckOut'
                                                      ? Icons.logout_rounded
                                                      : Icons.coffee_outlined,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      endChild: Container(
                                        height: 45,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              attendanceController
                                                  .attendanceLog[index].logFlag,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              'Time: ${attendanceController.attendanceLog[index].logDate.trim().substring(8)}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              'Location: ${attendanceController.attendanceLog[index].locationId}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              ReportScreen(),
              // Center(
              //   child: Text('Leave'),
              // ),
            ],
          ),
          // bottomNavigationBar: AppBottomBar(),
        ),
      ),
    );
  }

  Container _buildShimmer() {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: AppColors.lightGrey,
        highlightColor: AppColors.primary,
        enabled: true,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: timeLineList.length,
          itemBuilder: (context, index) {
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.2,
              isFirst: index == 0,
              isLast: index == timeLineList.length - 1,
              afterLineStyle: LineStyle(
                color: AppColors.primary,
                thickness: 3,
              ),
              beforeLineStyle: LineStyle(
                color: AppColors.primary,
                thickness: 3,
              ),
              indicatorStyle: IndicatorStyle(
                width: 25,
                height: 25,
                indicator: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? AppColors.darkGreen
                        : index == timeLineList.length - 1
                            ? AppColors.darkRed
                            : AppColors.mutedColor,
                  ),
                  child: Center(
                    child: Icon(
                      index == 0
                          ? Icons.login_rounded
                          : index == timeLineList.length - 1
                              ? Icons.logout_rounded
                              : Icons.coffee_outlined,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ),
              endChild: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeLineList[index].title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Time: ${timeLineList[index].time}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row _buildTimeLineHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.buildTitleText('Time Line'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                attendanceController.selectedDate.value,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                attendanceController.selectDate(context);
              },
              icon: Icon(Icons.date_range_outlined, color: AppColors.primary),
              tooltip: 'Select Date',
            ),
          ],
        )
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required IconData icon,
    required int logFlag,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Obx(() => ResponsiveButton(
            onTap: attendanceController.isLogActive.value
                ? () async {
                    if (attendanceController.allowGeoFencingOnPunching.value ==
                        true) {
                      final userInside =
                          await attendanceController.userInsideOrOut();
                      if (userInside == true) {
                        attendanceController.createAttendanceLog(
                            logFlag, context);
                      } else {
                        SnackbarServices.errorSnackbar("you are outside");
                      }
                    } else {
                      attendanceController.createAttendanceLog(
                          logFlag, context);
                    }
                  }
                : () {},
            child: Stack(
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: FittedBox(
                    child: Image.asset(
                      Images.finger_print,
                      filterQuality: FilterQuality.high,
                      width: 30,
                      height: 30,
                      // color: color.withOpacity(0.8),
                      color: attendanceController.isLogActive.value
                          ? color.withOpacity(0.8)
                          : AppColors.mutedColor.withOpacity(0.2),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Obx(() => Container(
                        padding: EdgeInsets.only(left: 1, top: 1),
                        decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5)),
                        child: attendanceController.isLoadingAttendance.value &&
                                attendanceController.logFlag.value == logFlag
                            ? GFLoader(
                                type: GFLoaderType.circle,
                                size: 5,
                                loaderColorOne: color,
                                loaderColorTwo: color,
                                loaderColorThree: color,
                              )
                            : Icon(
                                icon,
                                color: attendanceController.isLogActive.value
                                    ? color
                                    : color.withOpacity(0.2),
                                // size: 30,
                              ),
                      )),
                )
              ],
            ),
            height: 80,
            width: 80,
            borderRadius: 50,
          )),
    );
    // return Obx(() => Card(
    //       color: attendanceController.isLogActive.value
    //           ? Colors.white
    //           : AppColors.mutedColor.withOpacity(0.2),
    //       elevation: 3,
    //       child: InkWell(
    //         splashColor: attendanceController.isLogActive.value
    //             ? color.withOpacity(0.2)
    //             : AppColors.mutedColor.withOpacity(0.2),
    //         splashFactory: InkRipple.splashFactory,
    //         onTap: attendanceController.isLogActive.value
    //             ? () {
    //                 attendanceController.createAttendanceLog(logFlag, context);
    //               }
    //             : () {},
    //         child: Container(
    //           height: 15.h,
    //           color: Colors.transparent,
    //           child: Center(
    //             child: Obx(
    //               () => Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   attendanceController.isLoadingAttendance.value &&
    //                           attendanceController.logFlag.value == logFlag
    //                       ? GFLoader(
    //                           type: GFLoaderType.circle,
    //                           size: 15,
    //                           loaderColorOne: color,
    //                           loaderColorTwo: color,
    //                           loaderColorThree: color,
    //                         )
    //                       : Icon(
    //                           icon,
    //                           color: attendanceController.isLogActive.value
    //                               ? color
    //                               : color.withOpacity(0.2),
    //                           // size: 30,
    //                         ),
    //                   SizedBox(
    //                     height: 8,
    //                   ),
    //                   Text(
    //                     text,
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       color: AppColors.mutedColor,
    //                       fontSize: 14,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ));
  }

  Widget _buildTime() {
    return FittedBox(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(attendanceController.h.value < 10) ? '0${attendanceController.h.value}' : attendanceController.h.value}:${(attendanceController.m.value < 10) ? '0${attendanceController.m.value}' : attendanceController.m.value} :',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 28,
              child: Text(
                '${(attendanceController.s.value < 10) ? '0${attendanceController.s.value}' : attendanceController.s.value}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              (attendanceController.H.value >= 12) ? '\tpm' : '\am',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectJob(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildExpansionTextFields(
              controller: TextEditingController(),
              onTap: () {},
              hint: 'Search',
              isReadOnly: false,
              onChanged: (value) {
                attendanceController.filterJobLists(value);
              },
              isSearch: true),
          Flexible(
            child: GetBuilder<AttendanceController>(
                builder: (controller) => controller.isJobListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : controller.filterJobList.isEmpty
                        ? Text("No Data")
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = controller.filterJobList[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedValue = item;
                                  });
                                  attendanceController.setJobId(selectedValue);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item.name}",
                                        style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: controller.filterJobList.length)),
          )
        ],
      ),
    );
  }
}
