import 'package:axolon_erp/controller/app%20controls/connection_setting_controller.dart';
import 'package:axolon_erp/model/Local%20Db%20Model/connection_setting_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/default_settings.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/home_screen/navigation.dart';
import 'package:get/get.dart';

final connectionSettingController = Get.put(ConnectionSettingController());

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    enterApp();
  }

  var settingsList = [
    ConnectionModel(
        connectionName: 'Select Settings',
        serverIp: '',
        webPort: '',
        httpPort: '',
        erpPort: '',
        databaseName: '')
  ];
  enterApp() async {
    // await checkForDefault();
    String isConnected = await UserSimplePreferences.getConnection() ?? 'false';
    String isLoggedIn = await UserSimplePreferences.getLogin() ?? 'false';
    await Future.delayed(Duration(seconds: 4), () {
      if (isConnected == 'true') {
        if (isLoggedIn == 'true') {
          // Get.offNamed(RouteManager().routes[3].name);
          Get.off(() => NavigationScreen());
        } else {
          Get.offNamed(RouteManager().routes[1].name);
        }
      } else {
        Get.offNamed(RouteManager().routes[2].name);
      }
    });
  }

  checkForDefault() async {
    String isConnectionAVailable =
        await UserSimplePreferences.getIsConnectionAvailable() ?? 'false';
    if (isConnectionAVailable == 'false') {
      await UserSimplePreferences.setIsConnectionAvailable('true');
      await UserSimplePreferences.setConnectionName(
          DefaultSettings.connectionName);
      await UserSimplePreferences.setServerIp(DefaultSettings.serverIP);
      await UserSimplePreferences.setWebPort(DefaultSettings.webPort);
      await UserSimplePreferences.setHttpPort(DefaultSettings.httpPort);
      await UserSimplePreferences.setErpPort(DefaultSettings.erpPort);
      await UserSimplePreferences.setDatabase(DefaultSettings.databaseName);
      await setData();
      // connectionSettingController.saveSettings(settingsList);
      // await UserSimplePreferences.setConnection('true');
      await Future.delayed(Duration(seconds: 4), () {
        connectionSettingController.saveSettings(settingsList);
        UserSimplePreferences.setConnection('true');
      });
    }
  }

  setData() async {
    await connectionSettingController
        .getConnectionName(DefaultSettings.connectionName);
    await connectionSettingController.getServerIp(DefaultSettings.serverIP);
    await connectionSettingController.getWebPort(DefaultSettings.webPort);
    await connectionSettingController
        .getDatabaseName(DefaultSettings.databaseName);
    await connectionSettingController.getErpPort(DefaultSettings.erpPort);
    await connectionSettingController.getHttpPort(DefaultSettings.httpPort);
  }
}
