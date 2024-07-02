import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyConnectionAvailable = 'connection_available';
  static const _keyConnectionName = 'connectionName';
  static const _keyServerIp = 'server_ip';
  static const _keyWebPort = 'webPort';
  static const _keyHttpPort = 'httpPort';
  static const _keyErpPort = 'erpPort';
  static const _keyServerDatabase = 'database';
  static const _keyUserName = 'username';
  static const _keyUserPassword = 'password';
  static const _keyIslogedIn = 'islogedin';
  static const _keyConnection = 'isConnected';
  static const _keyEmployeeId = 'employee_id';
  static const _keyLatitude = 'latitude';
  static const _keyLongitude = 'longitude';
  static const _keyAttendanceLogTime = 'attendanceLogTime';
  static const _keyRememberPassword = 'rememberPassword';
  static const _keyVersion = 'version';
  static const _keyDeviceId = 'deviceId';
  static const _keyFavoriteMenu = 'favMenu';
  // container Tracking Filter controls start
  static const _keyVendorFilter = 'vendorFilter';
  static const _keyStatusFilter = 'statusFilter';
  static const _keyPortFilter = 'portFilter';
  static const _keyContainerFilter = 'containerFilter';
  static const _keyContainerDateFilter = 'containerDateFilter';
  static const _keyLeadDateFilter = 'leadDateFilter';
  static const _keyLeadIdFilter = 'leadFilter';
  static const _keyLeadStatusFilter = 'leadStatusFilter';
  static const _keySalesPersonFilter = 'salesPersonFilter';
   static const _keyDisableCamera = 'disableCamera';
  // container Tracking Filter controls end

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setIsConnectionAvailable(String availability) async =>
      await _preferences!.setString(_keyConnectionAvailable, availability);

  static String? getIsConnectionAvailable() =>
      _preferences!.getString(_keyConnectionAvailable);

  static Future setConnectionName(String connectionName) async =>
      await _preferences!.setString(_keyConnectionName, connectionName);

  static String? getConnectionName() =>
      _preferences!.getString(_keyConnectionName);

  static Future setUsername(String userName) async =>
      await _preferences!.setString(_keyUserName, userName);

  static String? getUsername() => _preferences!.getString(_keyUserName);

  static Future setUserPassword(String password) async =>
      await _preferences!.setString(_keyUserPassword, password);

  static String? getUserPassword() => _preferences!.getString(_keyUserPassword);

  static Future setServerIp(String serverIp) async =>
      await _preferences!.setString(_keyServerIp, serverIp);

  static String? getServerIp() => _preferences!.getString(_keyServerIp);

  static Future setWebPort(String port) async =>
      await _preferences!.setString(_keyWebPort, port);

  static String? getWebPort() => _preferences!.getString(_keyWebPort);

  static Future setHttpPort(String port) async =>
      await _preferences!.setString(_keyHttpPort, port);

  static String? getHttpPort() => _preferences!.getString(_keyHttpPort);

  static Future setErpPort(String port) async =>
      await _preferences!.setString(_keyErpPort, port);

  static String? getErpPort() => _preferences!.getString(_keyErpPort);

  static Future setDatabase(String database) async =>
      await _preferences!.setString(_keyServerDatabase, database);

  static String? getDatabase() => _preferences!.getString(_keyServerDatabase);

  static Future setLogin(String isLogin) async =>
      await _preferences!.setString(_keyIslogedIn, isLogin);

  static String? getLogin() => _preferences!.getString(_keyIslogedIn);

  static Future setConnection(String isConnected) async =>
      await _preferences!.setString(_keyConnection, isConnected);

  static String? getConnection() => _preferences!.getString(_keyConnection);

  static Future setEmployeeId(String employeeId) async =>
      await _preferences!.setString(_keyEmployeeId, employeeId);

  static String? getEmployeeId() => _preferences!.getString(_keyEmployeeId);

  static Future setLatitude(String latitude) async =>
      await _preferences!.setString(_keyLatitude, latitude);

  static String? getLatitude() => _preferences!.getString(_keyLatitude);

  static Future setLongitude(String longitude) async =>
      await _preferences!.setString(_keyLongitude, longitude);

  static String? getLongitude() => _preferences!.getString(_keyLongitude);

  static Future setAttendanceLogTime(String attendanceLogTime) async =>
      await _preferences!.setString(_keyAttendanceLogTime, attendanceLogTime);

  static String? getAttendanceLogTime() =>
      _preferences!.getString(_keyAttendanceLogTime);

  static Future setRememberPassword(bool isRemember) async =>
      await _preferences!.setBool(_keyRememberPassword, isRemember);

  static bool? getRememberPassword() =>
      _preferences!.getBool(_keyRememberPassword);

  static Future setVersion(String version) async =>
      await _preferences!.setString(_keyVersion, version);

  static String? getVersion() => _preferences!.getString(_keyVersion);

  static Future setDeviceId(String device) async =>
      await _preferences!.setString(_keyDeviceId, device);

  static String? getDeviceId() => _preferences!.getString(_keyDeviceId);

  static Future setFavMenu(String menu) async =>
      await _preferences!.setString(_keyFavoriteMenu, menu);

  static String? getFavMenu() => _preferences!.getString(_keyFavoriteMenu);

  // container Tracking Filter controls start

  static Future setVendorFilter(String vendor) async =>
      await _preferences!.setString(_keyVendorFilter, vendor);

  static String? getVendorFilter() => _preferences!.getString(_keyVendorFilter);

  static Future setStatusFilter(String status) async =>
      await _preferences!.setString(_keyStatusFilter, status);

  static String? getStatusFilter() => _preferences!.getString(_keyStatusFilter);

  static Future setPortFilter(String port) async =>
      await _preferences!.setString(_keyPortFilter, port);

  static String? getPortFilter() => _preferences!.getString(_keyPortFilter);

  static Future setContainerFilter(String container) async =>
      await _preferences!.setString(_keyContainerFilter, container);

  static String? getContainerFilter() =>
      _preferences!.getString(_keyContainerFilter);

  static Future setContainerDateFilter(int index) async =>
      await _preferences!.setInt(_keyContainerDateFilter, index);

  static int? getContainerDateFilter() =>
      _preferences!.getInt(_keyContainerDateFilter);
  static Future setLeadDateFilter(int index) async =>
      await _preferences!.setInt(_keyLeadDateFilter, index);
  static int? getLeadDateFilter() => _preferences!.getInt(_keyLeadDateFilter);
  static Future setSalesPersonFilter(String salesPerson) async =>
      await _preferences!.setString(_keySalesPersonFilter, salesPerson);

  static String? getSalesPersonFilter() =>
      _preferences!.getString(_keySalesPersonFilter);

  static Future setLeadStatusFilter(String leadstatus) async =>
      await _preferences!.setString(_keyLeadStatusFilter, leadstatus);

  static String? getLeadStatusFilter() =>
      _preferences!.getString(_keyLeadStatusFilter);

  static Future setLeadIdFilter(String leadId) async =>
      await _preferences!.setString(_keyLeadIdFilter, leadId);

  static String? getLeadIdFilter() => _preferences!.getString(_keyLeadIdFilter);
    static Future setIsCameraDisabled(int isDisable) async =>
      await _preferences!.setInt(_keyDisableCamera, isDisable);

  // container Tracking Filter controls end
}
