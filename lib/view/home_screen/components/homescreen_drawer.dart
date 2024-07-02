import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_erp/model/Local%20Db%20Model/connection_setting_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Approval%20Sreen/approval_screen.dart';
import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/hr_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/inventory_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_order_screen.dart';
import 'package:axolon_erp/view/SalesScreen/sales_screen.dart';
import 'package:axolon_erp/view/connection_settings/connection_screen.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreenDrawer extends StatelessWidget {
  HomeScreenDrawer({
    Key? key,
    required this.width,
    required this.username,
    required this.settingsList,
    required WebViewController? webViewController,
    required this.height,
  })  : _webViewController = webViewController,
        super(key: key);

  final homeController = Get.put(HomeController());
  final packageInfoCOntroller = Get.put(PackageInfoController());

  final double width;
  final String username;
  final List settingsList;
  final WebViewController? _webViewController;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      Obx(
                        () {
                          Uint8List bytes = Base64Codec()
                              .decode(homeController.userImage.value);
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: homeController.userImage.value == ''
                                ? CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    radius: 35,
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        Images.user,
                                        fit: BoxFit.cover,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    radius: 35,
                                    backgroundImage: MemoryImage(bytes),
                                  ),
                          );
                        },
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${UserSimplePreferences.getConnectionName()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.mutedBlueColor,
                                  radius: 15,
                                  child: Icon(
                                    Icons.logout,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                await UserSimplePreferences.setLogin('false');
                                Get.offAllNamed(RouteManager().routes[1].name);
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    // Navigator.pop(context);
                    // Get.to(() => SalesSreen());
                    // Get.to(() => HrScreen());
                    homeController.setDashboard(MenuOptions.Dashboard);
                    String serverIp = UserSimplePreferences.getServerIp() ?? '';
                    String databaseName =
                        UserSimplePreferences.getDatabase() ?? '';
                    String erpPort = UserSimplePreferences.getErpPort() ?? '';
                    String username = UserSimplePreferences.getUsername() ?? '';
                    String password =
                        UserSimplePreferences.getUserPassword() ?? '';
                    String webPort = UserSimplePreferences.getWebPort() ?? '';
                    // String httpPort = UserSimplePreferences.getHttpPort() ?? '';
                    final String port = webPort.split(':')[0];
                    homeController.addToBottomList(BottomMenu.Dashboard);
                    // Get.offAll(() => HomeScreen());
                    Navigator.pop(context);
                    await _webViewController!.loadUrl(
                      'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${port}&iscall=1',
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        RotatedBox(
                            quarterTurns: 0,
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset(
                                    AppIcons.dashboard_filled,
                                    color: AppColors.primary))),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);
                //     Get.to(() => ApprovalScreen());
                //     homeController.addToBottomList(BottomMenu.Approval);
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 22),
                //     child: Row(
                //       children: [
                //         RotatedBox(
                //             quarterTurns: 0,
                //             child: SizedBox(
                //                 height: 25,
                //                 width: 25,
                //                 child: SvgPicture.asset(AppIcons.quality,
                //                     color: AppColors.primary))),
                //         SizedBox(
                //           width: 35,
                //         ),
                //         Text(
                //           'Approvals',
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: AppColors.primary,
                //             fontWeight: FontWeight.w400,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Get.to(() => AttendanceScreen());
                    homeController.setDashboard(MenuOptions.Inventory);
                    // Get.to(() => InventoryScreen());
                    homeController.addToBottomList(BottomMenu.Common);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timeline_outlined,
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Inventory',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    homeController.setDashboard(MenuOptions.Sales);
                    // Get.to(() => SalesScreen());
                    homeController.addToBottomList(BottomMenu.Common);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.sell_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Sales',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Get.to(() => SalesSreen());
                    homeController.setDashboard(MenuOptions.HR);
                    // Get.to(() => HrScreen());
                    homeController.addToBottomList(BottomMenu.Common);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        RotatedBox(
                            quarterTurns: 0,
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset('assets/icons/hr.svg',
                                    color: AppColors.primary))),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'HR',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // Get.to(() => SalesSreen());
                    homeController.setDashboard(MenuOptions.Logistics);
                    // Get.to(() => HrScreen());
                    homeController.addToBottomList(BottomMenu.Common);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        RotatedBox(
                            quarterTurns: 0,
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset('assets/icons/hr.svg',
                                    color: AppColors.primary))),
                        SizedBox(
                          width: 35,
                        ),
                        Text(
                          'Logistics',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: Colors.transparent,
                      // collapsedBackgroundColor: AppColors.mutedBlueColor,
                      leading: Icon(
                        Icons.workspaces_outlined,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Switch Companies',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      children: [
                        Column(
                          children: [
                            settingsList.isNotEmpty
                                ? ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: settingsList.length,
                                    itemBuilder: (context, index) {
                                      var connection = UserSimplePreferences
                                              .getConnectionName() ??
                                          '';
                                      return GestureDetector(
                                        onTap: () async {
                                          var connectonName =
                                              settingsList[index]
                                                  .connectionName;
                                          var serverIp =
                                              settingsList[index].serverIp;
                                          var databaseName =
                                              settingsList[index].databaseName;
                                          var erpPort =
                                              settingsList[index].erpPort;
                                          var username =
                                              settingsList[index].userName;
                                          var password =
                                              settingsList[index].password;
                                          var webPort =
                                              settingsList[index].webPort;
                                          var httpPort =
                                              settingsList[index].httpPort;

                                          await UserSimplePreferences
                                              .setConnectionName(connectonName);
                                          await UserSimplePreferences
                                              .setServerIp(serverIp);
                                          await UserSimplePreferences
                                              .setDatabase(databaseName);
                                          await UserSimplePreferences
                                              .setErpPort(erpPort);
                                          await UserSimplePreferences
                                              .setUsername(username);
                                          await UserSimplePreferences
                                              .setUserPassword(password);
                                          await UserSimplePreferences
                                              .setWebPort(webPort);
                                          await UserSimplePreferences
                                              .setHttpPort(httpPort);
                                          final String port =
                                              webPort.split(':')[0];
                                          Navigator.pop(context);
                                          homeController.getFavMenu();
                                          homeController.getUserDetails();
                                          homeController.setDashboard(
                                              MenuOptions.Dashboard);
                                          _webViewController!.loadUrl(
                                            'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${port}&iscall=1',
                                          );
                                          homeController.getFavMenu();
                                          homeController.getUserDetails();
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: connection ==
                                                      settingsList[index]
                                                          .connectionName
                                                  ? AppColors.lightGrey
                                                  : Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: ListTile(
                                                  dense: true,
                                                  title: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        settingsList[index]
                                                            .connectionName!,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10, top: 18),
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.circle,
                                                size: 12,
                                                color: connection ==
                                                        settingsList[index]
                                                            .connectionName
                                                    ? AppColors.success
                                                    : Colors.transparent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 2,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: ListTile(
                                      dense: true,
                                      title: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Please wait...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => ConnectionScreen(
                                    connectionModel: ConnectionModel(
                                        connectionName: 'New Connection',
                                        webPort: '',
                                        databaseName: '',
                                        httpPort: '',
                                        erpPort: '',
                                        serverIp: '')));
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: height * 0.025,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: height * 0.025,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AutoSizeText(
            'version : ${UserSimplePreferences.getVersion() ?? ''}',
            minFontSize: 12,
            maxFontSize: 16,
            style: TextStyle(
              color: AppColors.mutedColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          AutoSizeText(
            'License : Evaluation',
            minFontSize: 12,
            maxFontSize: 16,
            style: TextStyle(
              color: AppColors.mutedColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
