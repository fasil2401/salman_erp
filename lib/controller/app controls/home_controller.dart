import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Approval%20Controller/approval_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/common_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_erp/main.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_filter_item_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_follow_up_status_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_leads_status_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/lead_list_model.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_group_detail_list_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/attachment_list_model.dart';
import 'package:axolon_erp/model/company_preference_model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/model/get_company_info_model.dart';
import 'package:axolon_erp/model/get_customer_class_list_model.dart';
import 'package:axolon_erp/model/get_job_list_model.dart';
import 'package:axolon_erp/model/get_user_detail_model.dart';
import 'package:axolon_erp/model/get_user_employee_model.dart';
import 'package:axolon_erp/model/get_user_security_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/model/sales_person_filter_model.dart';
import 'package:axolon_erp/model/user_by_id_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Approval%20Sreen/approval_screen.dart';
import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/hr_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/inventory_screen.dart';
import 'package:axolon_erp/view/Logistic%20Screen/logistics_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_order_screen.dart';
import 'package:axolon_erp/view/SalesScreen/components/sales_screen_items.dart';
import 'package:axolon_erp/view/SalesScreen/sales_screen.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:axolon_erp/view/home_screen/navigation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer' as developer;

import '../../model/Inventory Model/get_all_products_model.dart';
import '../../model/Inventory Model/producct_filter_by_location.dart';
import '../../model/Sales Model/Leads Model/get_area_list_model.dart';
import '../../model/Sales Model/Leads Model/get_country_list_model.dart';
import '../../model/Sales Model/Leads Model/get_source_list_model.dart';
import '../../model/Sales Model/Leads Model/get_stage_list_model.dart';
import '../../model/Sales Model/Salesman Activity models/activity_reason_list_model..dart';
import '../../model/Sales Model/Salesman Activity models/activity_type_model.dart';
import '../../model/Sales Model/Salesman Activity models/contacts_list_model.dart';
import '../../model/Sales Model/Salesman Activity models/get_users_list_model.dart';
import '../../model/account_model.dart';
import '../../model/bank_model.dart';
import '../../model/employee_department_model.dart';
import '../../model/employee_grade_model.dart';
import '../../model/employee_group_model.dart';
import '../../model/employee_location.dart';
import '../../model/employee_position_model.dart';
import '../../model/employee_sponsor_model.dart';
import '../../model/employee_type_model.dart';
import '../../model/employees_list_model.dart';
import '../../utils/constants/colors.dart';
import '../../view/SalesScreen/Inner Pages/Components/Sales Shimmer/pop_up_shimmer.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getFavMenu();
    getUserDetails();
  }

  final loginController = Get.put(LoginTokenController());
  final salesController = Get.put(SalesController());
  final commonController = Get.put(CommonController());
  final approvalController = Get.put(ApprovalController());
  final packageInfoCOntroller = Get.put(PackageInfoController());

  var isLoading = false.obs;
  var isjoblistLoading = false.obs;
  var response = 0.obs;
  var model = [].obs;
  var userEmployee = UserEmployeeModel().obs;
  var menuSecurityList = [].obs;
  var screenSecurityList = [].obs;
  var defaultsList = [].obs;
  var taxGroupList = [].obs;
  var employeeId = ''.obs;
  var salesPersonId = ''.obs;
  var userImage = ''.obs;
  var user = UserModel().obs;
  var favouriteMenu = MenuOptions.Inventory.obs;
  var dashboardMenu = MenuOptions.Dashboard.obs;
  var dashboardIndex = 0.obs;
  var bottomMenuList = <BottomMenu>[BottomMenu.Dashboard].obs;
  var productList = [].obs;
  var productFilterList = [].obs;
  var product = Products().obs;
  //-------------------------------lead and salesman activity---------------------//
  var followUpStatusList = [].obs;
  var followUplist = [].obs;
  var nextFollowUpList = [].obs;
  var filterList = [].obs;
  var statusList = [].obs;
  var reasonList = [].obs;
  var stageList = [].obs;
  var areaList = [].obs;
  var areaCountryList = [].obs;
  var countryList = [].obs;
  var sourceList = [].obs;
  var activitytypelist = [].obs;
  var regardinglist = [].obs;
  var contactlist = [].obs;
  var activitybylist = [].obs;
  var leadList = [].obs;
  var chatenabled = false.obs;
  var countryCode = "".obs;
  var isJobListLoading = false.obs;
  //--------------------------------------------------------------------------------//

  //-------------------------------customer combo---------------------//

  TextEditingController combofromControl = TextEditingController();
  TextEditingController combotoControl = TextEditingController();
  TextEditingController nextcardnumbercontrol = TextEditingController();
  var selectedComboItems = [].obs;
  var isRange = false.obs;
  var isAllItems = false.obs;
  var selectedCombofilterList = [].obs;
  var selectedComboList = [].obs;
  var customerClassList = [].obs;
  var customerGroupList = [].obs;
  //-------------------------------customer combo end---------------------//

  var customerList = [].obs;
  var customerFilterList = [].obs;
  var customer = CustomerModel().obs;
  // var isLoadingCustomer = false.obs;
  //-------------------------------location Start---------------------//
  var locationList = [].obs;
  var locationFilterList = [].obs;
  var location = LocationSingleModel().obs;
  var isLoadingLocations = false.obs;
  //-------------------------------location End---------------------//

  //-------------------------------ProductFLiter Start---------------------//
  var productClassList = [].obs;
  var productCategoryList = [].obs;
  var productBrandList = [].obs;
  var productManufacturerList = [].obs;
  var productStyleList = [].obs;
  var productLocationList = [].obs;

  //-------------------------------ProductFLiter End---------------------//

  //-------------------------------Salesperson Start---------------------//
  var salesPersonList = [].obs;
  var salesPersonGroupList = [].obs;
  var salesPersonDivisionList = [].obs;
  //-------------------------------Salesperson End---------------------//

  //-------------------------------Employees Start---------------------//
  var employeesList = [].obs;
  var employeeDepartmentList = [].obs;
  var employeeLocationList = [].obs;
  var employeeTypeList = [].obs;
  var employeeDivisionList = [].obs;
  var employeeSponsorList = [].obs;
  var employeeGroupList = [].obs;
  var employeeGradeList = [].obs;
  var employeePositionList = [].obs;
  var bankList = [].obs;
  var accountList = [].obs;

  var employeesFilterList = [].obs;
  var employeeDepartmentFilterList = [].obs;
  var employeeLocationFilterList = [].obs;
  var employeeTypeFilterList = [].obs;
  var employeeSponsorFilterList = [].obs;
  var employeeGroupFilterList = [].obs;
  var employeeGradeFilterList = [].obs;
  var employeePositionFilterList = [].obs;
  var bankFilterList = [].obs;
  var accountFilterList = [].obs;

  var isLoadingEmployees = false.obs;
  var isLoadingEmployeeDepartment = false.obs;
  var isLoadingEmployeeLocation = false.obs;
  var isLoadingEmployeeType = false.obs;
  var isLoadingEmployeeSponsor = false.obs;
  var isLoadingEmployeeGroup = false.obs;
  var isLoadingEmployeeGrade = false.obs;
  var isLoadingEmployeePosition = false.obs;
  var isLoadingBank = false.obs;
  var isLoadingAccount = false.obs;

  //-------------------------------Employees End---------------------//

  //-------------------------------Attachment Start---------------------//
  var isAttachmentListLoading = false.obs;
  var attachmentList = <AttachmentListModel>[].obs;
  //-------------------------------Attachment End---------------------//

  var actionStatusComboList = <ActionStatusComboModel>[].obs;
  var filterActionChangingStatusList = <ActionStatusSecuirityModel>[].obs;
  var actionStatusChangingList = <ActionStatusSecuirityModel>[].obs;
  var filterActionStatusList = <ActionStatusComboModel>[].obs;
  var selectedStatusValue = ActionStatusComboModel().obs;
  var jobList = <JobModel>[].obs;
  var filterJobList = <JobModel>[].obs;

  var companyOptionsList = <CompanyOptionModel>[].obs;
  var companyInfo = 1.obs;
  var companyInfoInstance = CompanyInfoModel().obs;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This Channel is used for importance notifucations',
    importance: Importance.high,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initLocalNotifications() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(
      settings,
      // onSe
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future<void> initNotification() async {
    await initPlatformState();
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // _firebaseMessaging.getInitialMessage().then(handleMessage)
    final fCMToken = await _firebaseMessaging.getToken();
    developer.log(fCMToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgoundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  channelDescription: androidChannel.description,
                  icon: '@drawable/ic_launcher',
                  channelAction: AndroidNotificationChannelAction.update,
                  autoCancel: false,
                  actions: [
                AndroidNotificationAction(
                  'accept_action',
                  'Approve',
                  showsUserInterface: true,
                ),
                AndroidNotificationAction(
                  'decline_action',
                  'Reject',
                  showsUserInterface: true,
                ),
              ])),
          payload: jsonEncode(message.toMap()));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      navigatorKey.currentState?.pushNamed('/approvals');
      // if (notification != null && notification.body != null) {
      //   final title = notification.title;
      //   switch (title) {
      //     case "test data":
      //       navigatorKey.currentState?.pushNamed('/announcement');
      //       break;
      //     case "MyTask":
      //       navigatorKey.currentState?.pushNamed('/myTask');
      //       break;
      //     case "Merchandise Test":
      //       navigatorKey.currentState?.pushNamed('/merchandise');
      //       break;
      //     case "Salesinvoice":
      //       navigatorKey.currentState?.pushNamed('/salesInvoice');
      //       break;
      //     case "Salesorder":
      //       navigatorKey.currentState?.pushNamed('/salesOrder');
      //       break;
      //     default:

      //       break;
      //   }
      // }
    });

    await sendFCMToken(fCMToken.toString());
    // await sendFCMToken(fCMToken.toString());
  }

  initPlatformState() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      await UserSimplePreferences.setDeviceId(androidInfo.model!);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      await UserSimplePreferences.setDeviceId(iosInfo.utsname.machine!);
    }
  }

  sendFCMToken(String fCMToken) async {
    final String token = loginController.token.value;
    final String user = await UserSimplePreferences.getUsername() ?? '';
    final String appId = packageInfoCOntroller.appName.value;
    final String deviceId = await UserSimplePreferences.getDeviceId() ?? '';
    final String fcmToken = fCMToken;
    final data = jsonEncode({
      "token": token,
      "FCMID": 0,
      "UserID": user,
      "Email": "",
      "AppID": appId,
      "Mobile": "",
      "DeviceID": deviceId,
      "FCMTokenID": fcmToken
    });
    developer.log(data);
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'CreateFCMToken', data: data);
      if (feedback != null) {
        if (feedback['res'] == 1) {
          developer.log('Fcm Token saving success');
        }
      }
    } catch (e) {
      developer.log(e.toString(), name: 'Token Saving responce');
    } finally {}
  }

  getFavMenu() async {
    String favMenuName =
        await UserSimplePreferences.getFavMenu() ?? MenuOptions.Inventory.name;
    favouriteMenu.value =
        MenuOptions.values.firstWhere((element) => element.name == favMenuName);
  }

  addToBottomList(BottomMenu menu) {
    bottomMenuList.add(menu);
  }

  removeFromBottomList() {
    bottomMenuList.removeLast();
  }

  setFavorite(MenuOptions option) {
    favouriteMenu.value = option;
    UserSimplePreferences.setFavMenu(option.name.toString());
  }

  setDashboard(MenuOptions option) {
    dashboardMenu.value = option;
    switch (option) {
      case MenuOptions.Inventory:
        dashboardIndex.value = 1;
        break;
      case MenuOptions.HR:
        dashboardIndex.value = 3;
        break;
      case MenuOptions.Logistics:
        dashboardIndex.value = 4;
        break;
      case MenuOptions.Sales:
        dashboardIndex.value = 2;
        break;
      case MenuOptions.Dashboard:
        dashboardIndex.value = 0;
        break;
      default:
    }
  }

  goToFavorite() {
    // selectBottomMenu(BottomMenu.Favorite);
    addToBottomList(BottomMenu.Favorite);
    switch (favouriteMenu.value) {
      case MenuOptions.Inventory:
        Get.to(() => InventoryScreen());
        break;
      case MenuOptions.HR:
        Get.to(() => HrScreen());
        break;
      case MenuOptions.Sales:
        Get.to(() => SalesScreen());
        break;
      case MenuOptions.Logistics:
        Get.to(() => LogisticsScreen());
        break;
      default:
    }
  }

  Widget getFavoriteScreen() {
    Widget screen = InventoryScreen();
    switch (favouriteMenu.value) {
      case MenuOptions.Inventory:
        screen = InventoryScreen();
        break;
      case MenuOptions.HR:
        screen = HrScreen();
        break;
      case MenuOptions.Sales:
        screen = SalesScreen();
        break;
      case MenuOptions.Logistics:
        screen = LogisticsScreen();
        break;
      default:
    }
    return screen;
  }

  goToApproval() {
    // selectBottomMenu(BottomMenu.Approval);
    addToBottomList(BottomMenu.Approval);
    Get.to(() => ApprovalScreen());
  }

  gotToDashboard() {
    // selectBottomMenu(BottomMenu.Dashboard);
    bottomMenuList.value = [BottomMenu.Dashboard];
    Get.offAll(() => HomeScreen());
  }

  goToProfile() {
    // selectBottomMenu(BottomMenu.Profile);
    addToBottomList(BottomMenu.Profile);
    Get.to(() => AttendanceScreen(
          isBottomNavigation: true,
        ));
  }

  getUserDetails() async {
    bool isConnected = await ApiServices.isConnected();
    if (isConnected) {
      await approvalController.getApprovalCategories();
      await loginController.getToken();
      await initNotification();
      await initLocalNotifications();
      final String userName = await UserSimplePreferences.getUsername() ?? '';
      if (loginController.token.value.isEmpty) {
        await loginController.getToken();
      }
      final String token = loginController.token.value;
      dynamic result;
      try {
        var feedback = await ApiServices.fetchData(
            api: 'GetUserDetails?token=${token}&userid=${userName}');
        if (feedback != null) {
          result = GetUserDetailModel.fromJson(feedback);
          response.value = result.res;
          model.value = result.model;
        }
        if (response.value == 1) {
          employeeId.value = model[0].employeeId ?? '';
          salesPersonId.value = model[0].defaultSalesPersonId ?? '';
          getUserUserSecurityList();
          update();
        }
      } finally {}
    }
  }

  getUserEmployeeDetails() async {
    // await loginController.getToken();
    final String employeeId = this.employeeId.value.toString();
    final String token = loginController.token.value;
    await UserSimplePreferences.setEmployeeId(employeeId);
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserEmployee?token=${token}&employeeID=${employeeId}');
      if (feedback != null) {
        result = GetUserEmployeeModel.fromJson(feedback);
        response.value = result.res;
        model.value = result.model;
        userEmployee.value = result.model[0];
      }

      if (response.value == 1) {
        if (model.isNotEmpty) {
          userImage.value = model[0].photo ?? '';
        }
      }
    } finally {}
  }

  getUserById() async {
    isLoading.value = true;
    // await loginController.getToken();
    final String token = loginController.token.value;
    final String userId = loginController.userId.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserByID?token=${token}&userid=${userId}');
      if (feedback != null) {
        result = UserByIdModel.fromJson(feedback);
        response.value = result.res;
        user.value = result.model[0];
        isLoading.value = false;
      }
      salesController.getSystemDocList();
      isLoading.value = false;
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getCompanyPreference() async {
    final String token = loginController.token.value;
    List<int> preferences =
        CompanyOptions.values.map((option) => option.value).toList();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetCompanyPreference?token=$token',
          data: preferences.toString());
      if (feedback != null) {
        result = CompanyPreferencerModel.fromJson(feedback);
        companyOptionsList.value = result.model;
        update();
      }
    } finally {}
  }

  bool isCompanyOptionAvailable(int option) {
    CompanyOptionModel preference = companyOptionsList.firstWhere(
        (element) => element.optionId == option.toString(),
        orElse: () => CompanyOptionModel());

    return preference.optionValue.toString().toLowerCase() == 'true'
        ? true
        : false;
  }

  String getCompanyOption(int option) {
    CompanyOptionModel preference = companyOptionsList.firstWhere((element) {
      return element.optionId == option.toString();
    }, orElse: () => CompanyOptionModel());

    return preference.optionValue.toString();
  }

  getUserUserSecurityList() async {
    await getCompanyPreference();
    await getCompanyInfo();
    await getUserById();
    // await loginController.getToken();
    final String userName = await UserSimplePreferences.getUsername() ?? '';
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserSecurity?token=${token}&userID=${userName}');
      if (feedback != null) {
        result = GetUserSecurityModel.fromJson(feedback);
        response.value = result.result;
        menuSecurityList.value = result.menuSecurityObj;
        screenSecurityList.value = result.screenSecurityObj;
        if (feedback['result'] == 1) {
          getUserEmployeeDetails();
        }
      }
    } finally {}
  }

  getCompanyInfo() async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataVansale(
          api: 'GetCompanyInfo?token=${token}');
      if (feedback != null) {
        result = GetCompanyInfoModel.fromJson(feedback);
        if (result.modelobject[0]?.minPriceSaleAction == 1 ||
            result.modelobject[0]?.minPriceSaleAction == 2 ||
            result.modelobject[0]?.minPriceSaleAction == 3) {
          companyInfo.value = result.modelobject[0]?.minPriceSaleAction ?? 1;
          companyInfoInstance.value = result.modelobject[0];
        }
      }
      developer.log("${feedback} feeedback preference");
    } finally {}
  }

  getTaxGroupDetailList() async {
    developer.log('getting tax detail from server');
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetTaxGroupDetailList?token=${token}');
      if (feedback != null) {
        result = TaxGroupDetailListModel.fromJson(feedback);
        response.value = result.res;
        taxGroupList.value = result.model;
      }
    } finally {
      if (response.value == 1) {}
    }
  }

  bool isUserRightAvailable(String value) {
    var data = menuSecurityList
        .where((row) => (row.menuId == value && row.enable == true));
    String option = getCompanyOption(CompanyOptions.LocalSalesFlow.value);
    int optionValue = int.parse(option);
    if (value == SalesScreenItems.salesInvoiceId && optionValue != 0) {
      return false;
    }

    if (data.length >= 1) {
      developer.log('The Data found !!! Successs', name: 'The Data');
      return true;
    } else {
      developer.log('The Data not found', name: 'The Data');
      return false;
    }
  }

  bool isScreenRightAvailable(
      {required String screenId, required ScreenRightOptions type}) {
    var data;
    String message = '';
    switch (type) {
      case ScreenRightOptions.View:
        data = screenSecurityList.firstWhere(
            (row) => (row.screenId == screenId && row.viewRight == true),
            orElse: () => null);
        message = 'User dont have permission to view this page !!';
        break;
      case ScreenRightOptions.Edit:
        data = screenSecurityList.firstWhere(
            (row) => (row.screenId == screenId && row.editRight == true),
            orElse: () => null);
        message = 'User dont have permission to Edit this page !!';
        break;
      case ScreenRightOptions.Add:
        data = screenSecurityList.firstWhere(
            (row) => (row.screenId == screenId && row.newRight == true),
            orElse: () => null);
        message = 'User dont have permission to Add this!!';
        break;
      case ScreenRightOptions.Delete:
        data = screenSecurityList.firstWhere(
            (row) => (row.screenId == screenId && row.deleteRight == true),
            orElse: () => null);
        message = 'User dont have permission to Delete this!!';
        break;
      default:
    }
    if (data != null || user.value.isAdmin == true) {
      // developer.log(data.viewRight.toString(), name: 'Screen right');
      return true;
    } else {
      if (type == ScreenRightOptions.View) {
        SnackbarServices.errorSnackbar(message);
      }

      return false;
    }
  }

  getAllProducts() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetAllProductList?token=${token}');
      if (feedback != null) {
        result = GetAllProductsModel.fromJson(feedback);
        response.value = result.res;
        productList.value = result.products;
        productFilterList.value = result.products;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
        developer.log(productList.length.toString(), name: 'All Products');
      }
    }
  }

  searchProducts(String value) {
    productFilterList.value = productList.value
        .where((element) =>
            element.productId.toLowerCase().contains(value.toLowerCase()) ||
            element.description.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //--------------------salesman activity controller---------------------------//
  selectCRMList(
      {required BuildContext context,
      required String text,
      Function()? oneditingcomplete,
      required TextEditingController controller,
      var list}) async {
    final double width = MediaQuery.of(context).size.width;
    filterList.value = list;
    switch (text) {
      case "Activity Type":
        {
          if (list != null) {
            isLoading.value = false;
            this.activitytypelist = list;
          }
          if (this.activitytypelist.isEmpty) {
            getActivityTypeList();
          }
        }
        break;

      case "Regarding":
        {
          if (list != null) {
            isLoading.value = false;
            this.regardinglist = list;
          }
          if (this.regardinglist.isEmpty) {
            getRegardingList();
          }
        }
        break;
      case "Reasons":
        {
          if (list != null) {
            isLoading.value = false;
            this.regardinglist = list;
          }
          if (this.regardinglist.isEmpty) {
            getRegardingList();
          }
        }
        break;

      case "Leads":
        {
          // if (list != null) {
          //   isLoading.value = false;
          //   this.leadList = list;
          // }
          // if (this.leadList.isEmpty) {
          getLeadList();
          //   }
        }
        break;

      case "Customers":
        {
          if (list != null) {
            isLoading.value = false;
            customerList = list;
          }
          if (customerList.isEmpty) {
            isLoading.value = true;
            getCustomerList();
            isLoading.value = false;
          }
        }
        break;

      case "Activity By":
        {
          if (list != null) {
            isLoading.value = false;
            this.activitybylist = list;
          }
          if (this.activitybylist.isEmpty) {
            getActivitybyList();
          }
        }
        break;
      case "Follow Up By":
        {
          if (list != null) {
            isLoading.value = false;
            this.activitybylist = list;
          }
          if (this.activitybylist.isEmpty) {
            getActivitybyList();
          }
        }
        break;
      case "Next Follow Up By":
        {
          if (list != null) {
            isLoading.value = false;
            this.activitybylist = list;
          }
          if (this.activitybylist.isEmpty) {
            getActivitybyList();
          }
        }
        break;
      case "Status":
        {
          if (list != null) {
            isLoading.value = false;
            this.statusList = list;
          }
          if (this.statusList.isEmpty) {
            getStatusList();
          }
        }
        break;
      case "Follow Up Status":
        {
          if (list != null) {
            isLoading.value = false;
            this.followUpStatusList = list;
          }
          if (this.followUpStatusList.isEmpty) {
            getFollowUpStatusList();
          }
        }
        break;
      case "Stage":
        {
          if (list != null) {
            isLoading.value = false;
            this.stageList = list;
          }
          if (this.stageList.isEmpty) {
            getStageList();
          }
        }
        break;

      case "Area":
        {
          if (list != null) {
            isLoading.value = false;
            this.areaCountryList = list;
          }
          if (this.areaCountryList.isEmpty) {
            getAreaCountryList(countryCode.value);
          }
        }
        break;
      case "Country":
        {
          if (list != null) {
            isLoading.value = false;
            this.countryList = list;
          }
          if (this.countryList.isEmpty) {
            getCountryList();
          }
        }
        break;
      case "Source":
        {
          if (list != null) {
            isLoading.value = false;
            this.sourceList = list;
          }
          if (this.sourceList.isEmpty) {
            getSourceList();
          }
        }
        break;
      default:
        {
          if (list != null) {
            isLoading.value = false;
            this.contactlist = list;
          }
          if (this.contactlist.isEmpty) {
            getContactsList();
          }
        }
        break;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  decoration: InputDecoration(
                      isCollapsed: true,
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(8)),
                  onChanged: (value) {
                    if (controller.text.isEmpty) {
                      filterList.value = list;
                    }
                    search(value, list);
                  },
                  onEditingComplete: oneditingcomplete),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => isLoading.value
                        ? SalesShimmer.locationPopShimmer()
                        : CupertinoScrollbar(
                            thumbVisibility: true,
                            child: Obx(() {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: filterList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.text =
                                          "${filterList[index].code} - ${filterList[index].name}";
                                      isLoading.value = false;
                                      if (text == "Leads" ||
                                          text == "Customers") {
                                        chatenabled.value = true;
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              '${filterList[index].code} - ',
                                              minFontSize: 12,
                                              maxFontSize: 12,
                                              style: TextStyle(
                                                color: AppColors.mutedColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 3.5,
                                              child: AutoSizeText(
                                                '${filterList[index].name}',
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.mutedColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })),
                  ),
                ),
              )
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  getActivityTypeList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api: 'GetActivityTypes?token=${token}');

      if (feedback != null) {
        result = ActivityTypeListModel.fromJson(feedback);
        response.value = result.result;
        activitytypelist.value = result.modelobject;
        isLoading.value = false;
        //  log("${response.toString()}");
      }
    } finally {
      if (response.value == 1) {
        //   log(response.string);
      }
    }
  }

  getRegardingList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    if (regardinglist.isEmpty) {
      try {
        var feedback = await ApiServices.fetchDataCRM(
            api: 'GetActivityReasonList?token=${token}');
        developer.log("${feedback}");
        if (feedback != null) {
          result = ActivityReasonListModel.fromJson(feedback);
          print(result);
          response.value = result.result;
          regardinglist.value = result.modelobject;
          isLoading.value = false;
          developer.log("${response.toString()}");
        }
      } finally {
        if (response.value == 1) {
          developer.log(response.string);
        }
      }
    } else {
      isLoading.value = false;
    }
  }

  getLeadList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    if (leadList.isEmpty) {
      try {
        var feedback =
            await ApiServices.fetchDataCRM(api: 'GetLeadList?token=${token}');
        if (feedback != null) {
          result = LeadListModel.fromJson(feedback);
          response.value = result.result;
          leadList.value = result.modelobject;
          isLoading.value = false;
        }
      } finally {
        if (response.value == 1) {
          isLoading.value = false;
        }
      }
    } else {
      isLoading.value = false;
    }
  }

  getActivitybyList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    if (activitybylist.isEmpty) {
      try {
        var feedback =
            await ApiServices.fetchData(api: 'GetUserList?token=${token}');
        if (feedback != null) {
          result = GetUsersLIstModel.fromJson(feedback);
          response.value = result.result;
          activitybylist.value = result.modelobject;
          isLoading.value = false;
        }
      } finally {
        if (response.value == 1) {
          isLoading.value = false;
        }
      }
    } else {
      isLoading.value = false;
    }
  }

  getContactsList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    if (contactlist.isEmpty) {
      try {
        var feedback = await ApiServices.fetchDataCRM(
            api: 'GetContactsList?token=${token}');
        if (feedback != null) {
          result = ContactListModel.fromJson(feedback);
          response.value = result.result;
          contactlist.value = result.modelobject;
          isLoading.value = false;
        }
      } finally {
        if (response.value == 1) {
          isLoading.value = false;
        }
      }
    } else {
      isLoading.value = false;
    }
  }

  search(String value, var list) {
    filterList.value = list.value
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()) as bool)
        .toList();
  }

//----------------------lead controller---------------------------------//
  getStatusList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api: 'GetLeadStatusList?token=${token}');
      if (feedback != null) {
        result = GetLeadStatusListModel.fromJson(feedback);
        response.value = result.result;
        statusList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getFollowUpStatusList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api: 'GetLeadFollowUpStatusList?token=${token}');
      if (feedback != null) {
        result = GetLeadFollowUpStatusList.fromJson(feedback);
        response.value = result.result;
        followUpStatusList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getSourceList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetSourceList?token=${token}');
      if (feedback != null) {
        result = GetSourceListModel.fromJson(feedback);

        response.value = result.result;

        sourceList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getCountryList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetCountryList?token=${token}');
      if (feedback != null) {
        result = GetCountryListModel.fromJson(feedback);
        response.value = result.result;
        countryList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getAreaCountryList(String country) async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api: 'GetAreaCountryList?token=${token}&country=${country}');
      if (feedback != null) {
        result = GetAreaListModel.fromJson(feedback);
        response.value = result.result;
        areaCountryList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getAreaList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetAreaList?token=${token}');
      if (feedback != null) {
        result = GetAreaListModel.fromJson(feedback);
        response.value = result.result;
        areaList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getStageList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetStageList?token=${token}');
      if (feedback != null) {
        result = GetStageListModel.fromJson(feedback);
        response.value = result.result;
        stageList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

//---------------------------------------------------------------------//
//-----------------------Product Filter Start-----------------------------------------------//
  getProductClassList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetProductClassList?token=${token}');
      if (feedback != null) {
        result = ProductFilterItemModel.fromJson(feedback);
        response.value = result.res;
        productClassList.value = result.model;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getProductCategoryList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetProductCategoryList?token=${token}');
      if (feedback != null) {
        result = ProductFilterItemModel.fromJson(feedback);
        response.value = result.res;
        productCategoryList.value = result.model;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getProductBrandList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetProductBrandList?token=${token}');
      if (feedback != null) {
        result = ProductFilterItemModel.fromJson(feedback);
        response.value = result.res;
        productBrandList.value = result.model;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getProductManufacturerList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetProductManufacturerList?token=${token}');
      if (feedback != null) {
        result = ProductFilterItemModel.fromJson(feedback);
        response.value = result.res;
        productManufacturerList.value = result.model;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getProductStyleList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetProductStyleList?token=${token}');
      if (feedback != null) {
        result = ProductFilterItemModel.fromJson(feedback);
        response.value = result.res;
        productStyleList.value = result.model;
        isLoading.value = false;
        print("result Amritha222 ${result.model}");
        print("result Amritha ${result}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  getProductLocationList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String userid = loginController.userId.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserLocation?token=${token}&userid=${userid}');
      if (feedback != null) {
        result = LocationFilter.fromJson(feedback);
        response.value = result.res;
        productLocationList.value = result.model;

        /// for display location list

        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  //-----------------------Product Filter End-----------------------------------------------//

  //-----------------------Salesperson Filter Start-----------------------------------------------//
  getSalesPersonList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetSalespersonList?token=${token}');
      if (feedback != null) {
        result = SalesPersonFilterItemModel.fromJson(feedback);
        response.value = result.result;
        salesPersonList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getSalesPersonGroupList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetSalespersonGroupList?token=${token}');
      if (feedback != null) {
        result = SalesPersonFilterItemModel.fromJson(feedback);
        response.value = result.result;
        salesPersonGroupList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getSalesPersonDivisionList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetDivisionList?token=${token}');
      if (feedback != null) {
        result = SalesPersonFilterItemModel.fromJson(feedback);
        response.value = result.result;
        salesPersonDivisionList.value = result.modelobject;
        isLoading.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  //-----------------------Salesperson Filter End-----------------------------------------------//

  selectProduct({required BuildContext context, var productList}) async {
    if (productList != null) {
      this.productList = productList;
      productFilterList.value = this.productList;
    }
    if (this.productList.isEmpty) {
      getAllProducts();
    }
    // customerFilterList = this.customerList;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              'Products',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  searchProducts(value);
                },
                onEditingComplete: () async {
                  await changeFocus(context);
                },
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => isLoading.value
                        ? SalesShimmer.locationPopShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: productFilterList.length,
                            itemBuilder: (context, index) {
                              var product = productFilterList[index];
                              return InkWell(
                                onTap: <Products>() {
                                  this.product.value = product;
                                  Get.back();
                                  productFilterList.value = this.productList;
                                  return this.product.value;
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      "${product.productId} - ${product.description}",
                                      minFontSize: 12,
                                      maxFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors.mutedColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      this.product.value = Products();
                      Get.back();
                    },
                    child: Text('Close',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return product.value;
  }

  var tempList = [].obs;
  var tempRange = false.obs;
  selectCombination(
      {required BuildContext context,
      required TextEditingController controller,
      required FilterComboOptions option,
      var selectedList}) async {
    final double width = MediaQuery.of(context).size.width;
    if (selectedList != null) {
      if (selectedList.length != 0) {
        selectedComboItems.value = List.from(selectedList);
        tempList.value = List.from(selectedList);
      } else {
        selectedComboItems.clear();
        tempList.clear();
      }
    } else {
      selectedComboItems.clear();
      tempList.clear();
    }
    if (controller.text.toString() == CommonFilterControls.allSelectedText) {
      isAllItems.value = true;
    } else {
      isAllItems.value = false;
    }

    combofromControl.clear();
    combotoControl.clear();
    isRange.value = false;
    tempRange.value = false;
    String heading = '';

    switch (option) {
      case FilterComboOptions.Customer:
        selectedCombofilterList.value = customerList;
        selectedComboList.value = customerList;
        heading = "Customer";
        if (customerList.isEmpty) {
          getCustomerList();
        }

        break;
      case FilterComboOptions.Class:
        selectedCombofilterList.value = customerClassList;
        selectedComboList.value = customerClassList;
        heading = "Class";
        if (customerClassList.isEmpty) {
          getCustomerClassList();
        }
        break;
      case FilterComboOptions.Group:
        selectedCombofilterList.value = customerGroupList;
        selectedComboList.value = customerGroupList;
        heading = "Group";
        if (customerGroupList.isEmpty) {
          getCustomerGroupList();
        }
        break;
      case FilterComboOptions.Area:
        selectedCombofilterList.value = areaList;
        selectedComboList.value = areaList;
        heading = "Area";
        if (areaList.isEmpty) {
          getAreaList();
        }
        break;
      case FilterComboOptions.Country:
        selectedCombofilterList.value = countryList;
        selectedComboList.value = countryList;
        heading = "Country";
        if (countryList.isEmpty) {
          getCountryList();
        }
        break;
      case FilterComboOptions.Item:
        selectedCombofilterList.value = productList;
        selectedComboList.value = productFilterList;
        heading = "Item";
        if (productList.isEmpty) {
          getAllProducts();
        }

        break;
      case FilterComboOptions.ItemClass:
        selectedCombofilterList.value = productClassList;
        selectedComboList.value = productClassList;
        heading = "Item Class";
        if (productClassList.isEmpty) {
          getProductClassList();
        }

        break;
      case FilterComboOptions.ItemCategory:
        selectedCombofilterList.value = productCategoryList;
        selectedComboList.value = productCategoryList;
        heading = "Item Category";
        if (productCategoryList.isEmpty) {
          getProductCategoryList();
        }

        break;
      case FilterComboOptions.ItemBrand:
        selectedCombofilterList.value = productBrandList;
        selectedComboList.value = productBrandList;
        heading = "Item Brand";
        if (productBrandList.isEmpty) {
          getProductBrandList();
        }

        break;
      // case FilterComboOptions.Location:
      //   selectedCombofilterList.value = productLocationList;
      //   selectedComboList.value = productLocationList;
      //   heading = "Item Location";
      //   if (productLocationList.isEmpty) {
      //     getProductLocationList();
      //   }
      //
      //   break;

      case FilterComboOptions.ItemManufacture:
        selectedCombofilterList.value = productManufacturerList;
        selectedComboList.value = productManufacturerList;
        heading = "Item Manufacturer";
        if (productManufacturerList.isEmpty) {
          getProductManufacturerList();
        }

        break;
      case FilterComboOptions.ItemOrigin:
        selectedCombofilterList.value = countryList;
        selectedComboList.value = countryList;
        heading = "Item Origin";
        if (countryList.isEmpty) {
          getCountryList();
        }

        break;
      case FilterComboOptions.ItemStyle:
        selectedCombofilterList.value = productStyleList;
        selectedComboList.value = productStyleList;
        heading = "Item Style";
        if (productStyleList.isEmpty) {
          getProductStyleList();
        }

        break;
      case FilterComboOptions.SalesPerson:
        selectedCombofilterList.value = salesPersonList;
        selectedComboList.value = salesPersonList;
        heading = "Salesperson";
        if (salesPersonList.isEmpty) {
          getSalesPersonList();
        }

        break;
      case FilterComboOptions.SalesPersonDivision:
        selectedCombofilterList.value = salesPersonDivisionList;
        selectedComboList.value = salesPersonDivisionList;
        heading = "Salesperson Division";
        if (salesPersonDivisionList.isEmpty) {
          getSalesPersonDivisionList();
        }

        break;
      case FilterComboOptions.SalesPersonGroup:
        selectedCombofilterList.value = salesPersonGroupList;
        selectedComboList.value = salesPersonGroupList;
        heading = "Salesperson Group";
        if (salesPersonGroupList.isEmpty) {
          getSalesPersonGroupList();
        }

        break;
      case FilterComboOptions.SalesPersonArea:
        selectedCombofilterList.value = areaList;
        selectedComboList.value = areaList;
        heading = "Salesperson Area";
        if (areaList.isEmpty) {
          getAreaList();
        }

        break;
      case FilterComboOptions.SalesPersonCountry:
        selectedCombofilterList.value = countryList;
        selectedComboList.value = countryList;
        heading = "Salesperson Country";
        if (countryList.isEmpty) {
          getCountryList();
        }
        break;
      case FilterComboOptions.Location:
        selectedCombofilterList.value = locationList;
        selectedComboList.value = locationList;
        heading = "Location";
        if (locationList.isEmpty) {
          getLocationList();
        }
        break;
      case FilterComboOptions.Employees:
        selectedCombofilterList.value = employeesList;
        selectedComboList.value = employeesList;
        heading = "Employees";
        if (employeesList.isEmpty) {
          getEmployeesList();
        }
        break;
      case FilterComboOptions.EmployeeDepartment:
        selectedCombofilterList.value = employeeDepartmentList;
        selectedComboList.value = employeeDepartmentList;
        heading = "Employee Department";
        if (employeeDepartmentList.isEmpty) {
          getEmployeeDepartmentList();
        }
        break;
      case FilterComboOptions.EmployeeType:
        selectedCombofilterList.value = employeeTypeList;
        selectedComboList.value = employeeTypeList;
        heading = "Employee Type";
        if (employeeTypeList.isEmpty) {
          getEmployeeTypeList();
        }
        break;
      case FilterComboOptions.EmployeeLocation:
        selectedCombofilterList.value = employeeLocationList;
        selectedComboList.value = employeeLocationList;
        heading = "Employee Location";
        if (employeeLocationList.isEmpty) {
          getEmployeeLocationList();
        }
        break;
      case FilterComboOptions.EmployeeSponsor:
        selectedCombofilterList.value = employeeSponsorList;
        selectedComboList.value = employeeSponsorList;
        heading = "Employee Sponsor";
        if (employeeSponsorList.isEmpty) {
          getEmployeeSponsorList();
        }
        break;
      case FilterComboOptions.EmployeeGrade:
        selectedCombofilterList.value = employeeGradeList;
        selectedComboList.value = employeeGradeList;
        heading = "Employee Grade";
        if (employeeGradeList.isEmpty) {
          getEmployeeGradeList();
        }
        break;
      case FilterComboOptions.EmployeeGroup:
        selectedCombofilterList.value = employeeGroupList;
        selectedComboList.value = employeeGroupList;
        heading = "Employee Group";
        if (employeeGroupList.isEmpty) {
          getEmployeeGroupList();
        }
        break;
      case FilterComboOptions.EmployeePosition:
        selectedCombofilterList.value = employeePositionList;
        selectedComboList.value = employeePositionList;
        heading = "Employee Position";
        if (employeePositionList.isEmpty) {
          getEmployeePositionList();
        }
        break;
      case FilterComboOptions.Bank:
        selectedCombofilterList.value = bankList;
        selectedComboList.value = bankList;
        heading = "Bank";
        if (bankList.isEmpty) {
          getBankList();
        }
        break;
      case FilterComboOptions.Account:
        selectedCombofilterList.value = accountList;
        selectedComboList.value = accountList;
        heading = "Account";
        if (accountList.isEmpty) {
          getAccountList();
        }
        break;
      default:
        {
          debugPrint('nothing');
          return;
        }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 9.w,
                child: CommonTextField.textfield(
                  suffixicon: false,
                  readonly: false,
                  keyboardtype: TextInputType.text,
                  label: "Search",
                  onchanged: (value) {
                    if (value.isEmpty) {
                      selectedCombofilterList.value = selectedComboList;
                    }
                    searchCombo(value, selectedComboList, option);
                  },
                  ontap: () {},
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 9.w,
                      child: CommonTextField.textfield(
                          suffixicon: false,
                          readonly: true,
                          keyboardtype: TextInputType.text,
                          label: "From",
                          ontap: () async {
                            // commonFilterList = selectedComboList;
                            // commonItemList = selectedComboList;
                            isAllItems.value = false;
                            final from = await commonController.selectOption(
                                context: context,
                                list: selectedComboList,
                                heading: "From",
                                options: option);
                            if (from != null) {
                              // selectedComboItems.clear();
                              combotoControl.text = '';
                              tempList.clear();
                              // selectedComboItems.add(from);
                              tempList.add(from);
                              if ((option == FilterComboOptions.Item
                                      ? from.productId
                                      : from.code) !=
                                  null) {
                                combofromControl.text =
                                    "${option == FilterComboOptions.Item ? from.productId : from.code} - ${option == FilterComboOptions.Item ? from.description : from.name}";
                                update();
                              }
                            }
                          },
                          controller: combofromControl),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 9.w,
                      child: CommonTextField.textfield(
                          suffixicon: false,
                          readonly: true,
                          keyboardtype: TextInputType.text,
                          label: "To",
                          ontap: () async {
                            isAllItems.value = false;
                            if (combofromControl.text == "") {
                              SnackbarServices.errorSnackbar(
                                  "Please select from");
                            } else {
                              final to = await commonController.selectOption(
                                  context: context,
                                  heading: "To",
                                  list: selectedComboList,
                                  options: option);
                              if (to != null) {
                                tempList.removeRange(1, tempList.length);
                                if ((option == FilterComboOptions.Item
                                        ? to.productId
                                        : to.code) !=
                                    null) {
                                  // selectedComboItems.add(to);

                                  tempList.add(to);
                                  combotoControl.text =
                                      "${option == FilterComboOptions.Item ? to.productId : to.code} - ${option == FilterComboOptions.Item ? to.description : to.name}";
                                  // selectBetween(
                                  //     selectedCombofilterList
                                  //         .indexOf(selectedComboItems.first),
                                  //     selectedCombofilterList
                                  //         .indexOf(selectedComboItems.last));
                                  selectBetween(
                                      selectedCombofilterList
                                          .indexOf(tempList.first),
                                      selectedCombofilterList
                                          .indexOf(tempList.last));
                                  // isRange.value = true;
                                  tempRange.value = true;
                                  // log("${selectedcustomerComboItems[1].code}");
                                  update();
                                }
                              }
                            }
                          },
                          controller: combotoControl),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() => SizedBox(
                      width: 130,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: AppColors.mutedColor),
                        child: CheckboxListTile(
                          title: Text(
                            'Select All',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.mutedColor),
                          ),
                          dense: true,
                          activeColor: AppColors.primary,
                          checkColor: AppColors.white,
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.platform,
                          value: isAllItems.value,
                          onChanged: (value) {
                            isAllItems.value = !isAllItems.value;
                            update();
                            if (isAllItems.value) {
                              // selectedComboItems.clear();
                              tempList.clear();
                              for (var item in selectedComboList) {
                                tempList.add(item);
                              }
                              combotoControl.text = '';
                              combofromControl.text = '';
                              tempRange.value = false;
                              // isRange.value = false;
                              update();
                            } else {
                              tempList.clear();
                              update();
                            }
                          },
                        ),
                      ),
                    )),
              ),
              Flexible(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Obx(
                        () => isLoading.value == true
                            ? SalesShimmer.locationPopShimmer()
                            : CupertinoScrollbar(
                                thumbVisibility: true,
                                child: Obx(() => ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: selectedCombofilterList.length,
                                      itemBuilder: (context, index) {
                                        return GetBuilder<HomeController>(
                                            builder: (_) => CheckboxListTile(
                                                  dense: true,
                                                  title: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AutoSizeText(
                                                        '${option == FilterComboOptions.Item ? selectedCombofilterList[index].productId : selectedCombofilterList[index].code} - ',
                                                        minFontSize: 12,
                                                        maxFontSize: 12,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .mutedColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width / 3.5,
                                                        child: AutoSizeText(
                                                          '${option == FilterComboOptions.Item ? selectedCombofilterList[index].description : selectedCombofilterList[index].name}',
                                                          minFontSize: 10,
                                                          maxFontSize: 12,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .mutedColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  autofocus: false,
                                                  activeColor:
                                                      AppColors.primary,
                                                  checkColor: Colors.white,
                                                  value:
                                                      // selectedComboItems
                                                      //         .contains(
                                                      //             selectedCombofilterList[
                                                      //                 index])
                                                      isAllItems.value
                                                          ? true
                                                          : tempList.contains(
                                                                  selectedCombofilterList[
                                                                      index])
                                                              ? true
                                                              : false,
                                                  onChanged: (newValue) {
                                                    isAllItems.value = false;
                                                    // if (selectedComboItems.contains(
                                                    //     selectedCombofilterList[
                                                    //         index])) {
                                                    //   selectedComboItems.remove(
                                                    //       selectedCombofilterList[
                                                    //           index]);
                                                    if (tempList.contains(
                                                        selectedCombofilterList[
                                                            index])) {
                                                      tempList.remove(
                                                          selectedCombofilterList[
                                                              index]);
                                                      update();
                                                    } else {
                                                      // selectedComboItems.add(
                                                      //     selectedCombofilterList[
                                                      //         index]);
                                                      tempList.add(
                                                          selectedCombofilterList[
                                                              index]);
                                                    }
                                                    // isRange.value = false;
                                                    tempRange.value = false;
                                                    update();
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                ));
                                      },
                                    )),
                              ),
                      )))
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: InkWell(
                //     onTap: () {
                //       // selectedComboItems.clear();
                //       combofromControl.clear();
                //       combotoControl.clear();
                //       isRange.value = false;
                //       update();
                //       Navigator.pop(context);
                //     },
                //     child: Text('Cancel',
                //         style: TextStyle(color: AppColors.primary)),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    combofromControl.clear();
                    combotoControl.clear();
                    update();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mutedBlueColor),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedComboItems.value = tempList;
                    isRange.value = tempRange.value;
                    combofromControl.clear();
                    combotoControl.clear();

                    update();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child: Text(
                    'Select',
                    style: TextStyle(
                        color: AppColors.white, fontWeight: FontWeight.w400),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: InkWell(
                //     onTap: () {
                //       combofromControl.clear();
                //       combotoControl.clear();

                //       update();
                //       Navigator.pop(context);
                //       // if (selectedItem.length != 0) {
                //       //   selectedItem.clear();
                //       //   update();
                //       // } else {
                //       //   for (int i = 0; i < filterList.length; i++) {
                //       //     if (selectedItem.contains(filterList[i])) {
                //       //       log("it contains");
                //       //     } else {
                //       //       selectedItem.add(filterList[i]);
                //       //     }
                //       //   }
                //       //   update();
                //       //   //  selectedItem.addAll(filterList);
                //       //   //  selectedItem.clear();
                //       // }
                //     },
                //     child: Text('Select',
                //         style: TextStyle(color: AppColors.primary)),
                //   ),
                // ),
              ],
            )
          ],
        );
      },
    );
    return {
      "list": selectedComboItems,
      "isRange": isRange.value,
      "isAll": isAllItems.value,
    };
  }

  searchCombo(String value, var list, FilterComboOptions option) {
    selectedCombofilterList.value = list.value
        .where((element) =>
            (option == FilterComboOptions.Item
                    ? element.productId
                    : element.code)
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            (option == FilterComboOptions.Item
                    ? element.description
                    : element.name)
                .toLowerCase()
                .contains(value.toLowerCase()) as bool)
        .toList();
  }

  void selectBetween(int start, int end) {
    for (int i = start + 1; i < end; i++) {
      // selectedComboItems.insert(1, selectedCombofilterList[i]);
      tempList.insert(1, selectedCombofilterList[i]);
    }
  }

  searchCustomers(String value) {
    customerFilterList.value = customerList.value
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  getCustomerClassList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetCustomerClassList?token=${token}');
      if (feedback != null) {
        result = GetCustomerClassListModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        customerClassList.value = result.modelobject;

        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(customerClassList.value[0].name.toString(),
            name: 'Customer Class');
      }
    }
  }

  getCustomerGroupList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetCustomerGroupList?token=${token}');
      if (feedback != null) {
        result = GetCustomerClassListModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        customerGroupList.value = result.modelobject;

        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(customerGroupList.value[0].name.toString(),
            name: 'Customer group');
      }
    }
  }

  selectCustomer({required BuildContext context, var customerList}) async {
    if (customerList != null) {
      this.customerList = customerList;
      customerFilterList.value = this.customerList;
    }
    if (this.customerList.isEmpty) {
      getCustomerList();
    }
    // customerFilterList = this.customerList;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              'Customers',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  searchCustomers(value);
                },
                onEditingComplete: () async {
                  await changeFocus(context);
                },
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => isLoading.value
                        ? SalesShimmer.locationPopShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: customerFilterList.length,
                            itemBuilder: (context, index) {
                              var customer = customerFilterList[index];
                              return InkWell(
                                onTap: <CustomerModel>() {
                                  this.customer.value = customer;
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                  customerFilterList.value = this.customerList;
                                  return this.customer.value;
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      "${customer.code} - ${customer.name}",
                                      minFontSize: 12,
                                      maxFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors.mutedColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      this.customer.value = CustomerModel();
                      // Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return customer.value;
  }

  getCustomerList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetCustomerList?token=${token}');
      if (feedback != null) {
        result = AllCustomerModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        customerList.value = result.modelobject;
        customerFilterList.value = customerList;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(customerList.value[0].name.toString(),
            name: 'Customer Name');
      }
    }
  }
  //-------------------------------location Start---------------------//

  selectLocatio({required BuildContext context, var locationList}) async {
    if (locationList != null) {
      this.locationList = locationList;
      locationFilterList.value = this.locationList;
    }
    if (this.locationList.isEmpty) {
      getLocationList();
    }
    // customerFilterList = this.customerList;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              'Locations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  searchLocations(value);
                },
                onEditingComplete: () async {
                  await changeFocus(context);
                },
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => isLoadingLocations.value
                        ? SalesShimmer.locationPopShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: locationFilterList.length,
                            itemBuilder: (context, index) {
                              var location = locationFilterList[index];
                              return InkWell(
                                onTap: <CustomerModel>() {
                                  this.location.value = location;
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                  locationFilterList.value = this.locationList;
                                  return this.location.value;
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      "${location.code} - ${location.name}",
                                      minFontSize: 12,
                                      maxFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors.mutedColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      this.location.value = LocationSingleModel();
                      // Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return location.value;
  }

  searchLocations(String value) {
    locationFilterList.value = locationList.value
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  getLocationList() async {
    isLoadingLocations.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetLocation?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = LocationModel.fromJson(feedback);
        response.value = result.res;
        locationList.value = result.model;
        locationFilterList.value = locationList;
        isLoadingLocations.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  //-------------------------------location End---------------------//

  //-------------------------------employee Start---------------------//

  getEmployeesList() async {
    isLoadingEmployees.value = true;
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetEmployeeList?token=${token}');
      if (feedback != null) {
        //  developer.log('$feedback');
        result = EmployeesModel.fromJson(feedback);
        response.value = result.res;
        employeesList.value = result.model;
        employeesFilterList.value = employeesList;
        isLoadingEmployees.value = false;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
        update();
      }
    }
  }

  getEmployeeDepartmentList() async {
    isLoadingEmployeeDepartment.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetDepartmentList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeDepartmentModel.fromJson(feedback);
        response.value = result.res;
        employeeDepartmentList.value = result.model;
        employeeDepartmentFilterList.value = employeeDepartmentList;
        isLoadingEmployeeDepartment.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeeTypeList() async {
    isLoadingEmployeeType.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetEmplayeeTypeList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeTypeModel.fromJson(feedback);
        response.value = result.res;
        employeeTypeList.value = result.model;
        employeeTypeFilterList.value = employeesList;
        isLoadingEmployeeType.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeeLocationList() async {
    isLoadingEmployeeLocation.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetWorkLocationList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeLocationModel.fromJson(feedback);
        response.value = result.res;
        employeeLocationList.value = result.model;
        employeeLocationFilterList.value = employeeLocationList;
        isLoadingEmployeeLocation.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeeSponsorList() async {
    isLoadingEmployeeSponsor.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetSponsorList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeSponsorModel.fromJson(feedback);
        response.value = result.res;
        employeeSponsorList.value = result.model;
        employeeSponsorFilterList.value = employeeSponsorList;
        isLoadingEmployeeSponsor.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeeGradeList() async {
    isLoadingEmployeeGrade.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetGradeList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeGradeModel.fromJson(feedback);
        response.value = result.res;
        employeeGradeList.value = result.model;
        employeeGradeFilterList.value = employeeGradeList;
        isLoadingEmployeeGrade.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeeGroupList() async {
    isLoadingEmployeeGroup.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetEmployeeGroupList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeeGroupModel.fromJson(feedback);
        response.value = result.res;
        employeeGroupList.value = result.model;
        employeeGroupFilterList.value = employeeGroupList;
        isLoadingEmployeeGroup.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getEmployeePositionList() async {
    isLoadingEmployeePosition.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetPositionList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = EmployeePositionModel.fromJson(feedback);
        response.value = result.res;
        employeePositionList.value = result.model;
        employeePositionFilterList.value = employeePositionList;
        isLoadingEmployeePosition.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getBankList() async {
    isLoadingBank.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataAccount(api: 'GetBankList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = BankModel.fromJson(feedback);
        response.value = result.res;
        bankList.value = result.model;
        bankFilterList.value = bankList;
        isLoadingBank.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getAccountList() async {
    isLoadingAccount.value = true;
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataAccount(
          api: 'GetAllAccountList?token=${token}');
      if (feedback != null) {
        developer.log('$feedback');
        result = AccountModel.fromJson(feedback);
        response.value = result.res;
        accountList.value = result.model;
        accountFilterList.value = accountList;
        isLoadingAccount.value = false;
        isLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  //-------------------------------employee End---------------------//

  //-------------------------------Attachment Start---------------------//
  var isLoadingSave = false.obs;
  var result = FilePickerResult([]).obs;
  getAttachmentList({required String sysDoc, required String voucher}) async {
    isAttachmentListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetAttachment?token=${token}&entityType=${EntityType.Transactions.value}&EntitySysDocID=${sysDoc}&EntityID=${voucher}');
      if (feedback != null) {
        developer.log('$feedback');
        result = GetAttachmentListModel.fromJson(feedback);
        // response.value = result.res;
        attachmentList.value = result.modelobject;
        isAttachmentListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        // isLoading.value = false;
      }
      isAttachmentListLoading.value = false;
    }
  }

  selectFile() async {
    result.value = (await FilePicker.platform.pickFiles(allowMultiple: true))!;
    update();
  }

  takePicture() async {
    final XFile? cameraImages = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (cameraImages != null) {
      result.value.files.add(PlatformFile(
          path: cameraImages.path, name: cameraImages.name, size: 0));
      result.refresh();
    }
    update();
  }

  dynamic filetypeIcon(int index) {
    if (result.value.files[index].extension == "jpg") {
      return image(AppIcons.jpg);
    } else if (result.value.files[index].extension == "png") {
      return image(AppIcons.png);
    } else if (result.value.files[index].extension == "jpeg") {
      image(AppIcons.jpeg);
    } else if (result.value.files[index].extension == "mp4" ||
        result.value.files[index].extension == "mkv") {
      return image(AppIcons.mp4);
    } else if (result.value.files[index].extension == "opus" ||
        result.value.files[index].extension == "mp3") {
      return image(AppIcons.mp3);
    } else if (result.value.files[index].extension == "pdf") {
      return image(
        AppIcons.pdf,
      );
    }
    return Icon(Icons.folder_open_outlined);
  }

  Image image(String image) => Image.asset(
        image, scale: 15,
        // scale: 20,
      );

  addAttachment(
      String sysDocId, String voucherNumber, EntityType entityType) async {
    isLoadingSave.value = true;
    await loginController.getToken();
    for (int index = 0; index < result.value.files.length; index++) {
      List<int> imageBytes =
          File(result.value.files[index].path!).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      final String token = loginController.token.value;
      String data = jsonEncode({
        "token": "$token",
        "EntityID": "${voucherNumber}",
        "EntityType": entityType.value,
        "EntitySysDocID": "${sysDocId}",
        "EntityDocName": "${result.value.files[index].name}",
        "EntityDocDesc": "",
        "EntityDocKeyword":
            "${UserSimplePreferences.getUsername()}${DateTime.now()}",
        "EntityDocPath": "",
        "RowIndex": index,
        "FileData": "${base64Image}"
      });
      try {
        var feedback = await ApiServices.fetchDataRawBody(
            api: 'AddAttachment', data: data);
        developer.log("$feedback");
        if (feedback != null) {
          if (feedback["res"] == 0) {
            isLoadingSave.value = false;
            SnackbarServices.errorSnackbar("${feedback['err']}");
            response.value = feedback["res"];
          } else {
            response.value = feedback["res"];
            result.value = FilePickerResult([]);
          }
        }
      } finally {
        if (response.value == 1) {}
      }
    }
  }
  //-------------------------------Attachment End---------------------//

  getNextCardNumber() async {
    isLoading.value = true;

    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    const String tablename = "Job_Task";
    const String id = "TaskID";
    try {
      var feedback = await ApiServices.fetchData(
        api: 'GetNextCardNumber?token=$token&tableName=$tablename&id=$id',
      );
      if (feedback != null) {
        if (feedback['result'] == 1) {
          response.value = feedback['result'];
          nextcardnumbercontrol.text = feedback['code'];
          isLoading.value = false;
        }
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getActionStatusComboList() async {
    if (actionStatusComboList.isNotEmpty) {
      await getActionStatusSecurityList();
      return;
    }
    isLoading.value = true;
    actionStatusComboList.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetActionStatusComboList?token=$token');
      if (feedback != null) {
        result = GetActionStatusComboListModel.fromJson(feedback);
        actionStatusComboList.value = result.modelobject;
        await getActionStatusSecurityList();
      }
      isLoading.value = false;
      update();
    } finally {}
  }

  getJobList() async {
    jobList.clear();
    filterJobList.clear();

    isLoading.value = true;
    update();
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetJobList?token=${token}');
      if (feedback != null) {
        result = GetJobListModel.fromJson(feedback);
        // developer.log(feedback.toString(), name: 'GetJobList');
        response.value = result.res;
        jobList.value = result.model;
        filterJobList.value = jobList;
        update();
      }
      isLoading.value = false;
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  getActionStatusSecurityList() async {
    isLoading.value = true;
    // actionStatusChangingList.value.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetActionStatusSecurity?token=$token');
      if (feedback != null) {
        result = GetActionStatusSecurityModel.fromJson(feedback);
        var list = result.modelobject;
        actionStatusChangingList.value = list
            .where(
                (element) => element.statusType == 1 && element.isView == true)
            .toList();
        filterActionChangingStatusList.value = actionStatusChangingList;
        if (filterActionChangingStatusList.isNotEmpty) {
          filterActionStatusList.value = actionStatusComboList
              .where((element) => containsMatchingObject(element))
              .toList();
        } else {
          filterActionStatusList.value = actionStatusComboList
              .where((element) => element.statusType == 1)
              .toList();
        }
      }
      isLoading.value = false;
      update();
    } finally {}
  }

  bool containsMatchingObject(var element) {
    return filterActionChangingStatusList.any((obj2) {
      return obj2.statusId == element.code;
    });
  }

  searchStatusLIst(String value) {
    filterActionStatusList.value = actionStatusComboList
        .where((element) =>
                // element.code!.toLowerCase().contains(value.toLowerCase()) &&
                //     containsMatchingObject(element) ||
                element.name!.toLowerCase().contains(value.toLowerCase())
            // &&
            //     containsMatchingObject(element)
            )
        .toList();
    update();
  }
}
