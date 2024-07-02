import 'dart:convert';
import 'package:axolon_erp/model/login_token_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class LoginTokenController extends GetxController {
  var response = 0.obs;
  var message = ''.obs;
  var token = ''.obs;
  var userId = ''.obs;

  getToken() async {
    final String database = UserSimplePreferences.getDatabase() ?? '';
    final String webPort = UserSimplePreferences.getWebPort() ?? '';
    final String serverIp = UserSimplePreferences.getServerIp() ?? '';
    final String erpPort = UserSimplePreferences.getErpPort() ?? '';
    final String userId = UserSimplePreferences.getUsername() ?? '';
    final String password = UserSimplePreferences.getUserPassword() ?? '';
    final String port = webPort.split(':')[0];
    print('port is $port');
    final data = jsonEncode({
      "Instance": '${serverIp}:${erpPort}',
      "UserId": userId,
      "Password": password,
      "PasswordHash": "",
      "DbName": database,
      "Port": port,
      "servername": ""
    });
    print(data);
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'Gettoken', data: data);
      if (feedback != null) {
        result = LoginModel.fromJson(feedback);
        if (result != null) {
          response.value = result.res ?? 0;
          message.value = result.msg ?? '';
          token.value = result.loginToken ?? '';
          this.userId.value = result.userId ?? '';
        } else {
          response.value = 0;
          message.value = 'Something went wrong';
          // await getToken();
        }
      }
    } finally {
      if (response.value == 1) {}
    }
  }
}
