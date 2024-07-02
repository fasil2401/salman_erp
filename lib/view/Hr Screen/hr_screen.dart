import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/items.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';

class HrScreen extends StatelessWidget {
  HrScreen({this.isGoingback = true, super.key});
  final homeController = Get.put(HomeController());
  final bool isGoingback;
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
          title: Text('HR'),
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
                list: HrScreenItems.HrItems,
                title: 'HR Management',
                isFavorite: true,
                option: MenuOptions.HR,
              ),
              SizedBox(
                height: 10,
              ),
              MainScreenTemplate(
                list: HrScreenItems.HrReportItems,
                title: 'Reports',
                isFavorite: false,
                option: MenuOptions.HR,
              ),
            ],
          ),
        ),
        // bottomNavigationBar: AppBottomBar(),
      ),
    );
  }
}
