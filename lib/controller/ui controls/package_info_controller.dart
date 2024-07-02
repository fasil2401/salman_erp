import 'dart:io';

import 'package:axolon_erp/utils/package_info/package_info.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class PackageInfoController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  var _packageInfo = ''.obs;
  var _appName = ''.obs;
  get version => _packageInfo;
  get appName => _appName;

  Map<String, dynamic> packageInfo = {};

  Future init() async {
    final packageInfo = await PackageInfoApi.getInfo();

    print(packageInfo);

    final newPackageInfo = {
      ...packageInfo,
    };
    final idName = Platform.isAndroid ? 'packageName' : 'bundleID';
    this.packageInfo = newPackageInfo;
    _packageInfo.value = packageInfo['version'];
    _appName.value = packageInfo[idName];
    await UserSimplePreferences.setVersion(_packageInfo.value);
  }
}
