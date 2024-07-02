import 'dart:ui';

import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Inventory%20Screen/components/items.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({this.isGoingback = true, super.key});
  final bool isGoingback;
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isGoingback) {
          homeController.setDashboard(MenuOptions.Dashboard);
          return false;
        }else{
          return true;
        }
        // await homeController.removeFromBottomList();
        
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inventory'),
          leadingWidth: isGoingback ? 40 : 0,
          leading: Visibility(
              visible: isGoingback,
              child: IconButton(
                  onPressed: () {
                    homeController.setDashboard(MenuOptions.Dashboard);
                  },
                  icon: Icon(Icons.arrow_back))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              MainScreenTemplate(
                list: InventoryScreenItems.inventoryItems,
                title: 'Inventory',
                isFavorite: true,
                option: MenuOptions.Inventory,
              ),
              SizedBox(
                height: 10,
              ),
              MainScreenTemplate(
                list: InventoryScreenItems.reportItems,
                title: 'Reports',
                isFavorite: false,
                option: MenuOptions.Inventory,
              ),
            ],
          ),
        ),
        // bottomNavigationBar: AppBottomBar(),
      ),
    );
  }
}
