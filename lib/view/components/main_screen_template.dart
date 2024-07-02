import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/SalesScreen/components/sales_screen_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainScreenTemplate extends StatelessWidget {
  MainScreenTemplate({
    Key? key,
    required this.list,
    required this.title,
    required this.isFavorite,
    required this.option,
  }) : super(key: key);
  final homeController = Get.put(HomeController());
  var list;
  final String title;
  final bool isFavorite;
  final MenuOptions option;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mutedColor, width: 0.5),
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      alignment: Alignment.bottomCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: isFavorite
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeadText(title),
                      InkWell(
                        onTap: () {
                          homeController.setFavorite(option);
                        },
                        child: Obx(() => CircleAvatar(
                            radius: 13,
                            backgroundColor:
                                option == homeController.favouriteMenu.value
                                    ? AppColors.primary
                                    : Colors.white,
                            child: Icon(
                              option == homeController.favouriteMenu.value
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              size: 15,
                              color:
                                  option == homeController.favouriteMenu.value
                                      ? AppColors.white
                                      : Colors.black87,
                            ))),
                      ),
                    ],
                  )
                : _buildHeadText(title),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 5,
                mainAxisExtent: 85,
              ),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Obx(() => GestureDetector(
                      onTap: () {
                        homeController.user.value.isAdmin == true &&
                                list[index].menuId !=
                                    SalesScreenItems.salesInvoiceId
                            ? Get.toNamed(list[index].route)
                            : homeController
                                    .isUserRightAvailable(list[index].menuId)
                                ? homeController.isScreenRightAvailable(
                                        screenId: list[index].screenId,
                                        type: ScreenRightOptions.View)
                                    ? Get.toNamed(list[index].route)
                                    : Get.toNamed(RouteManager.redirect)
                                : Get.toNamed(RouteManager.redirect);
                      },
                      child: Column(
                        children: [
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SvgPicture.asset(
                                list[index].icon,
                                color:
                                    homeController.user.value.isAdmin == true &&
                                            list[index].menuId !=
                                                SalesScreenItems.salesInvoiceId
                                        ? AppColors.primary
                                        : homeController.isUserRightAvailable(
                                                list[index].menuId)
                                            ? AppColors.primary
                                            : AppColors.mutedColor,
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: AutoSizeText(
                              list[index].title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              maxFontSize: 12,
                              minFontSize: 10,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Text _buildHeadText(String text) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
