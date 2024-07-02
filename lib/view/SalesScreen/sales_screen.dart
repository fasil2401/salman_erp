import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/components/sales_screen_items.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SalesScreen extends StatelessWidget {
  SalesScreen({this.isGoingback = true, super.key});
  final salesController = Get.put(SalesController());
  final homeController = Get.put(HomeController());
  final bool isGoingback;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isGoingback) {
          homeController.setDashboard(MenuOptions.Dashboard);
          return false;
        } else {
          return true;
        }
        // await homeController.removeFromBottomList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sales'),
          leadingWidth: isGoingback ? 40 : 0,
          leading: Visibility(
            visible: isGoingback,
            child: IconButton(
              onPressed: () {
                homeController.setDashboard(MenuOptions.Dashboard);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              MainScreenTemplate(
                list: SalesScreenItems.SalesItems,
                title: 'Sales',
                isFavorite: true,
                option: MenuOptions.Sales,
              ),
              SizedBox(
                height: 10,
              ),
              MainScreenTemplate(
                list: SalesScreenItems.SalesReportItems,
                title: 'Reports',
                isFavorite: false,
                option: MenuOptions.Sales,
              ),
            ],
          ),
        ),
        // bottomNavigationBar: AppBottomBar(),
      ),
    );
  }
}
