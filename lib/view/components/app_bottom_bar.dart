import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppBottomBar extends StatelessWidget {
  AppBottomBar({
    Key? key,
  }) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primary,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bildItem(
              text: 'Dashboard',
              menu: BottomMenu.Dashboard,
              icon: AppIcons.dashboard,
              selectedIcon: AppIcons.dashboard_filled,
              onTap: () {
                homeController.gotToDashboard();
              }),
          _bildItem(
              text: 'Approval',
              menu: BottomMenu.Approval,
              icon: AppIcons.approval,
              selectedIcon: AppIcons.approval_filed,
              onTap: () {
                homeController.goToApproval();
              }),
          _bildItem(
              text: 'Favorite',
              menu: BottomMenu.Favorite,
              icon: AppIcons.favorite,
              selectedIcon: AppIcons.favorite_filled,
              onTap: () {
                homeController.goToFavorite();
              }),
          _bildItem(
              text: 'Profile',
              menu: BottomMenu.Profile,
              icon: AppIcons.profile,
              selectedIcon: AppIcons.profile_filled,
              onTap: () {
                homeController.goToProfile();
              }),
        ],
      ),
    );
  }

  Widget _bildItem({
    required String text,
    required String icon,
    required String selectedIcon,
    required Function() onTap,
    required BottomMenu menu,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => SizedBox(
                height: 22,
                width: 22,
                child: SvgPicture.asset(
                  menu == homeController.bottomMenuList.value.last
                      ? selectedIcon
                      : icon,
                  color: AppColors.white,
                ),
              )),
          SizedBox(
            height: 4,
          ),
          AutoSizeText(
            text,
            minFontSize: 8,
            maxFontSize: 16,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
