import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/Logistic%20Screen/components/items.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/main_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class LogisticsScreen extends StatelessWidget {
  LogisticsScreen({super.key, this.isGoingback = true});
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
          title: Text('Logistics'),
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
                list: LogisticsScreenItems.LogisticsItems,
                title: 'Logistics',
                isFavorite: true,
                option: MenuOptions.Logistics,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showTimelineAlertDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                'Status Log',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.mutedColor,
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 15,
                ),
              ),
            )
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: timeline(context),
        ),
      );
    },
  );
}
