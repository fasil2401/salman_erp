import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/view/Hr%20Screen/hr_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/inventory_screen.dart';
import 'package:axolon_erp/view/Logistic%20Screen/logistics_screen.dart';
import 'package:axolon_erp/view/SalesScreen/sales_screen.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final homeController = Get.put(HomeController());

  getWidget(MenuOptions option) {
    Widget screen = HomeScreen();
    switch (option) {
      case MenuOptions.Inventory:
        screen = InventoryScreen();
        break;
      case MenuOptions.HR:
        screen = HrScreen();
        break;
      case MenuOptions.Logistics:
        screen = LogisticsScreen();
        break;
      case MenuOptions.Sales:
        screen = SalesScreen();
        break;
      case MenuOptions.Dashboard:
        screen = HomeScreen();
        break;
      default:
    }
    return screen;
  }

  final screens = [
    HomeScreen(),
    InventoryScreen(),
    SalesScreen(),
    HrScreen(),
    LogisticsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (homeController.dashboardMenu.value == MenuOptions.Dashboard) {
            return true;
          } else {
            homeController.setDashboard(MenuOptions.Dashboard);
            return false;
          }
        },
        child: Obx(() => IndexedStack(
              index: homeController.dashboardIndex.value,
              children: screens,
            )));
  }
}
