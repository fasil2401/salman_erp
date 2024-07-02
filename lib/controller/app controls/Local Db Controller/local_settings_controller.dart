import 'package:axolon_erp/model/Local%20Db%20Model/connection_setting_model.dart';
import 'package:axolon_erp/services/db_helper/db_helper.dart';
import 'package:get/get.dart';

class LocalSettingsController extends GetxController {
  final connectionSettings = [].obs;

  Future<void> getLocalSettings() async {
    final List<Map<String, dynamic>> elements =
        await DbHelper().queryAllSettings();
    connectionSettings.assignAll(
        elements.map((data) => ConnectionModel.fromMap(data)).toList());
  }

  addLocalSettings({required ConnectionModel element}) async {
    print('adding');
    await DbHelper().insertSettings(element);
    connectionSettings.add(element);
    // getTransferOut();
  }

  updateLocalSettings(
      {required String connectionName,
      required String userName,
      required String password}) async {
    print('updating');
    await DbHelper()
        .updateConnectionSettings(connectionName, userName, password);
    getLocalSettings();
  }

  updateFields(
      {required String connectionName,
      required String serverIp,
      required String webPort,
      required String httpPort,
      required String erpPort,
      required String databaseName}) async {
    print('updating');
    await DbHelper().updateFields(
        connectionName: connectionName,
        serverIp: serverIp,
        webPort: webPort,
        httpPort: httpPort,
        erpPort: erpPort,
        databaseName: databaseName);
    getLocalSettings();
  }

   deleteConnectionSettings(String connectionName)async{
    await DbHelper().deleteConnectionSettings(connectionName);
    getLocalSettings();
  }

  deleteTable() async {
    await DbHelper().deleteSettingsTable();
  }
}
