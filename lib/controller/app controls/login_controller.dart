import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Local%20Db%20Controller/local_settings_controller.dart';
import 'package:axolon_erp/services/login_services.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/home_screen/navigation.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final localSettingsController = Get.put(LocalSettingsController());
  final loginController = Get.put(LoginTokenController());

  var isLoading = false.obs;
  var userName = ''.obs;
  var password = ''.obs;
  var res = 0.obs;
  var message = ''.obs;
  var token = ''.obs;
  var webUrl = ''.obs;
  var isRemember = false.obs;
  String url = '';
  String data = '';

  getUserName(String userName) {
    this.userName.value = userName;
  }

  getPassword(String password) {
    this.password.value = password;
  }

  rememberPassword() async {
    isRemember.value = !isRemember.value;
  }

  updateConnectionSetting() async {
    String connectionName =
        await UserSimplePreferences.getConnectionName() ?? '';
    await localSettingsController.updateLocalSettings(
        connectionName: connectionName,
        userName: userName.value,
        password: password.value);
  }

  saveCredentials() async {
    await updateConnectionSetting();
    await UserSimplePreferences.setUsername(userName.value);
    await UserSimplePreferences.setUserPassword(password.value);

    // getLogin();
    genearateApi();
  }

  genearateApi() async {
    final bool isRemembered =
        UserSimplePreferences.getRememberPassword() ?? false;
    final String serverIp = await UserSimplePreferences.getServerIp() ?? '';
    final String databaseName = await UserSimplePreferences.getDatabase() ?? '';
    final String erpPort = await UserSimplePreferences.getErpPort() ?? '';
    // final String httpPort = await UserSimplePreferences.getHttpPort() ?? '';
    final String username = await UserSimplePreferences.getUsername() ?? '';
    final String password = isRemembered
        ? await UserSimplePreferences.getUserPassword() ?? ''
        : this.password.value;
    final String webPort = await UserSimplePreferences.getWebPort() ?? '';
    final String port = webPort.split(':')[0];
    url = 'http://${serverIp}/V1/Api/Gettoken';
    data = jsonEncode({
      "instance": serverIp,
      "userId": username,
      "Password": password,
      "passwordhash": "",
      "dbName": databaseName,
      "port": webPort,
      "servername": ""
    });
    webUrl.value =
        'http://${serverIp}:${erpPort}/User/mobilelogin?userid=${username}&passwordhash=${password}&dbName=${databaseName}&port=${port}&iscall=1';
    UserSimplePreferences.setRememberPassword(isRemember.value);

    getLogin();
  }

  getLogin() async {
    try {
      print(webUrl.value);
      isLoading.value = true;
      var feedback = await RemoteServicesLogin().getLogin(webUrl.value, data);
      if (feedback != null) {
        res.value = feedback.res;
        message.value = feedback.msg;
        SnackbarServices.errorSnackbar(message.value);
      } else {
        // message.value = 'failure';
      }
    } finally {
      if (res.value == 1) {
        isLoading.value = false;
        // await UserSimplePreferences.setLogin('true');
        // getWebView();
      } else {
        // Get.back();
        isLoading.value = false;
      }
    }
  }

  getWebView() async {
    // Get.offAllNamed(RouteManager().routes[3].name);

    Get.offAll(() => NavigationScreen());
  }
}
