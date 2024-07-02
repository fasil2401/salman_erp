import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Approval%20Controller/approval_controller.dart';
import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/report_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/Approval%20Sreen/approval_screen.dart';
import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/items.dart';
import 'package:axolon_erp/view/SalesScreen/sales_screen.dart';
import 'package:axolon_erp/view/components/drawerScreens.dart';
import 'package:axolon_erp/view/components/fav_scree.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({this.screenIndex, super.key});
  int? screenIndex;
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final approvalController = Get.put(ApprovalController());
  final attendanceController = Get.put(AttendanceController());
  final reportController = Get.put(ReportController());
  int currentIndex = 0;
  @override
  void initState() {
    log('screenIndex ===== ${widget.screenIndex}');
    super.initState();
  }

  final screens = [
    DashboardScreen(),
    ApprovalScreen(),
    FavoriteScreen(),
    AttendanceScreen(
      isBottomNavigation: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // log('screenIndex ===== ${widget.screenIndex}');
      if (widget.screenIndex != null) {
        setState(() {
          currentIndex = 1;
        });
      }
    });

    return SafeArea(
      child: Scaffold(
        // body: screens.elementAt(currentIndex),

        body: Stack(
          children: [
            Offstage(
              offstage: currentIndex != 0,
              child: screens[0],
            ),
            Offstage(
              offstage: currentIndex != 1,
              child: screens[1],
            ),
            Offstage(
              offstage: currentIndex != 2,
              child: screens[2],
            ),
            Offstage(
              offstage: currentIndex != 3,
              child: screens[3],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.primary,
          currentIndex: currentIndex,
          onTap: (index) async {
            if (index == 3) {
              if (homeController
                  .isUserRightAvailable(HrScreenItems.attendanceId)) {
                if (homeController.isScreenRightAvailable(
                    screenId: HrScreenId.employeePunchInOut,
                    type: ScreenRightOptions.View)) {
                  setState(() => currentIndex = index);
                  await reportController.getEmployeeAttendanceHistory();
                  attendanceController.initPage();
                } else {
                  return;
                }
              } else {
                SnackbarServices.errorSnackbar(
                    'User dont have access to Profile');
              }
            } else if (index == 1) {
              setState(() => currentIndex = index);
              approvalController.getApprovalCategories();
            } else {
              setState(() => currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.white,
          items: [
            BottomNavigationBarItem(
              icon: _buildItem(AppIcons.dashboard),
              activeIcon: _buildItem(AppIcons.dashboard_filled),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  _buildItem(AppIcons.approval),
                ],
              ),
              activeIcon: Stack(
                children: [
                  _buildItem(AppIcons.approval_filed),
                ],
              ),
              label: 'Approval',
            ),
            BottomNavigationBarItem(
              icon: _buildItem(AppIcons.favorite),
              activeIcon: _buildItem(AppIcons.favorite_filled),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: _buildItem(AppIcons.profile),
              activeIcon: _buildItem(AppIcons.profile_filled),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String icon) {
    return Stack(
      children: [
        SizedBox(
          height: 22,
          width: 22,
          child: SvgPicture.asset(
            icon,
            color: AppColors.white,
          ),
        ),
        icon == AppIcons.approval_filed || icon == AppIcons.approval
            ? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(2),
                  child: Obx(
                    () => AutoSizeText(
                      '${approvalController.totalCount.value}',
                      maxFontSize: 8,
                      minFontSize: 2,
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
