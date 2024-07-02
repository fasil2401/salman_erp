import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/view/Hr%20Screen/hr_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/inventory_screen.dart';
import 'package:axolon_erp/view/Logistic%20Screen/logistics_screen.dart';
import 'package:axolon_erp/view/SalesScreen/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  final homeController = Get.put(HomeController());

  getWidget(MenuOptions option) {
    Widget screen = InventoryScreen(isGoingback: false);
    switch (option) {
      case MenuOptions.Inventory:
        screen = InventoryScreen(isGoingback: false);
        break;
      case MenuOptions.HR:
        screen = HrScreen(isGoingback: false);
        break;
        case MenuOptions.Logistics:
        screen = LogisticsScreen(isGoingback: false);
        break;
      case
       MenuOptions.Sales:
        screen = SalesScreen(isGoingback: false);
        break;
      default:
    }
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => getWidget(homeController.favouriteMenu.value));
  }
}
