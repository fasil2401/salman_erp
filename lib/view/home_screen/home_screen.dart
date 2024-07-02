import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Local%20Db%20Controller/local_settings_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Announcement%20Screen/announcement_screen.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:axolon_erp/view/home_screen/components/homescreen_drawer.dart';
import 'package:axolon_erp/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// final packageInfoCOntroller = Get.put(PackageInfoController());

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isReloading = false;
  bool isError = false;
  int position = 1;
  WebViewController? _webViewController;
  final localSettingsController = Get.put(LocalSettingsController());
  final homeController = Get.put(HomeController());
  var settingsList = [];
  final _key = UniqueKey();
  String url = '';
  @override
  void initState() {
    super.initState();
    generateUrl();
    getLocalSettings();
    url =
        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1';
    print(url);
  }

  getLocalSettings() async {
    await localSettingsController.getLocalSettings();
    List<dynamic> settings = localSettingsController.connectionSettings;
    for (var setting in settings) {
      settingsList.add(setting);
    }
  }

  String serverIp = '';
  String databaseName = '';
  String erpPort = '';
  String username = '';
  String password = '';
  String webPort = '';
  String httpPort = '';

  String webUrl = '';
  generateUrl() async {
    setState(() {
      serverIp = UserSimplePreferences.getServerIp() ?? '';
      databaseName = UserSimplePreferences.getDatabase() ?? '';
      erpPort = UserSimplePreferences.getErpPort() ?? '';
      username = UserSimplePreferences.getUsername() ?? '';
      password = UserSimplePreferences.getUserPassword() ?? '';
      webPort = UserSimplePreferences.getWebPort() ?? '';
      httpPort = webPort.split(':')[0];
      // UserSimplePreferences.getHttpPort() ?? '';
    });
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    _webViewController!.goBack();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('webUrlissssss $webUrl');
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: SizedBox(
            height: 30,
            child: Image.asset(
              Images.logo,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(() => AnnouncementScreen());
                // Get.to(ConnectionScreen());
              },
            ),
          ],
        ),
        drawer: HomeScreenDrawer(
          width: width,
          username: username,
          settingsList: settingsList,
          webViewController: _webViewController,
          height: height,
        ),
        body: IndexedStack(
          index: position,
          children: [
            isError
                ? SizedBox(
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: width * 0.5,
                          width: width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(Images.error),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Something went wrong!\nPlease try again later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offAll(() => LoginScreen());
                            },
                            child: Text(
                              'Go to Login',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ))
                      ],
                    ),
                  )
                : WebView(
                    key: _key,
                    initialUrl:
                        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1',
                    // 'http://86.96.196.11/index.html',
                    // initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    zoomEnabled: true,
                    debuggingEnabled: true,
                    onProgress: (progress) => print(
                        "WebView is loading (progress : $progress%) ::: http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${httpPort}&iscall=1 "),
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                    },

                    onPageFinished: (finish) {
                      setState(
                        () {
                          print(url);
                          isLoading = false;
                          // isReloading = false;
                          position = 0;
                        },
                      );
                    },
                    onWebResourceError: (
                      error,
                    ) =>
                        setState(() {
                      isError = true;
                      position = 0;
                    }),
                    onPageStarted: (url) => setState(() {
                      isLoading = true;
                      position = 1;
                    }),
                  ),
            Container(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
            // isLoading
            //     ? Container(
            //         height: height,
            //         width: width,
            //         child: Center(
            //           child: CircularProgressIndicator(
            //             color: AppColors.primary,
            //           ),
            //         ),
            //       )
            //     : Stack(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   await _webViewController!
        //       .loadUrl('http://192.168.35.5/LeaveRequest/Create');
        // }),
        // bottomNavigationBar: AppBottomBar(),
      ),
    );
  }
}
