import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';

class Api {
  static getBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    print('ip is +++++++========= http://$serverIp:$port');
    // final erpPort = UserSimplePreferences.getErpPort() ?? '';
    // final erpPort = '81';
    return 'http://${serverIp}:${port}/V1/Api/';
  }

  static getInventoryBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/Inventory/';
  }

  static getVansaleBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/VanSale/';
  }

  static getCRMBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/CRM/';
  }

  static getEmployeeBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/Employee/';
  }
  static getReportBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/Report/';
  }
  static getAccountBaseUrl() {
    final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
    final port = webPort.split(':')[1];
    return 'http://${serverIp}:${port}/V1/Accounts/';
  }
   static getProjectBaseUrl() {
     final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
     final port = webPort.split(':')[1];
   return 'http://${serverIp}:${port}/V1/Project/'; 
  }
  static getCustomerBaseUrl() {
     final serverIp = UserSimplePreferences.getServerIp() ?? '';
    final webPort = UserSimplePreferences.getWebPort() ?? '';
     final port = webPort.split(':')[1];
   return 'http://${serverIp}:${port}/V1/Customer/'; 
  }

  static getGoogleApiKey() {
    const String apiKey = 'AIzaSyBpm__Hnh7yUPiPHQVsLOqQt6u8Lk2u1-k';
    return apiKey;
  }
}
