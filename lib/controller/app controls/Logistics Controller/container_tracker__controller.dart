import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/get_Packing_List_Details_Model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_action_status_log_list_model.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/model/get_shipper_list_mode.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContainerTrackerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  loadInitial() async {
    int index = UserSimplePreferences.getContainerDateFilter() ?? 8;
    await selectDateRange(
        index + 1,
        DateRangeSelector.dateRange.indexOf(DateRangeSelector.dateRange
            .firstWhere((element) => element.value == index + 1)));
    getPackingListDetails();
  }

  final loginController = Get.put(LoginTokenController());
  var shipperName = TextEditingController().obs;
  var statusCode = TextEditingController().obs;
  var statusName = TextEditingController().obs;
  var sysDocId = TextEditingController().obs;
  var voucherId = TextEditingController().obs;
  var remarks = TextEditingController().obs;
  var selectedShipperValue = ShipperModel().obs;
  var selectedStatusValue = ActionStatusComboModel().obs;
  var packingList = <PackingDetailModel>[].obs;
  var actionStatusLog = <ActionStatusLogModel>[].obs;
  var actionStatusComboList = <ActionStatusComboModel>[].obs;
  var actionStatusChangingList = <ActionStatusSecuirityModel>[].obs;
  var filterPackingList = <PackingDetailModel>[].obs;
  var filterSearchPackingList = <PackingDetailModel>[].obs;
  var filterShipperList = <ShipperModel>[].obs;
  var filterActionStatusList = <ActionStatusComboModel>[].obs;
  var filterActionChangingStatusList = <ActionStatusSecuirityModel>[].obs;
  var selectedActionStatus = ActionStatusComboModel().obs;
  var shipperList = <ShipperModel>[].obs;
  var result = FilePickerResult([]).obs;
  var isAttachmentListLoading = false.obs;
  var isPackingListLoading = false.obs;
  var isActionListLoading = false.obs;
  var isLoading = false.obs;
  var isActionStatusComboListLoading = false.obs;
  var changedDate = DateTime.now().obs;
  var refDate = DateTime.now().obs;
  var actualDate = DateTime.now().obs;
  var actualtime = TimeOfDay.now().obs;
  var vendorFilter = [].obs;
  var statusFilter = [].obs;
  var vendorFilterController =
      TextEditingController(text: UserSimplePreferences.getVendorFilter() ?? '')
          .obs;
  var statusFilterController =
      TextEditingController(text: UserSimplePreferences.getStatusFilter() ?? '')
          .obs;
  var containerNoFilterController = TextEditingController(
          text: UserSimplePreferences.getContainerFilter() ?? '')
      .obs;
  var portFilterController =
      TextEditingController(text: UserSimplePreferences.getPortFilter() ?? '')
          .obs;
  String statusFilterId = 'Status';
  String vendorFilterId = 'Vendor';
  var filterSearchList = [].obs;
  var searchController = TextEditingController().obs;

  var statusRef1Name = 'Ref 1'.obs;
  var statusRef1Controller = TextEditingController().obs;
  var statusRef2Name = 'Ref 2'.obs;
  var statusRef2Controller = TextEditingController().obs;

  var isLinkLoading = false.obs;
  var showClosedToggle = false.obs;
  var statusFilterList = <String>[].obs;

  //--------------------------Date---------------------------------//

  DateTime date = DateTime.now();
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var dateIndex = 0.obs;
  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
    UserSimplePreferences.setContainerDateFilter(index);
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await CommonFilterControls.getCalender(
        context, isFrom ? fromDate.value : toDate.value);
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  Future<TimeOfDay> selectTime(context, TimeOfDay times) async {
    TimeOfDay? newDate =
        await CommonFilterControls.getTimePicker(context, times);
    if (newDate != null) {
      times = newDate;
    }
    update();
    return times;
  }

  //-----------------------------------------------------------------------//

  toggleClosed() {
    showClosedToggle.value = !showClosedToggle.value;
    update();
  }

  getPackingListDetails() async {
    if (isPackingListLoading.value) {
      return;
    }
    isPackingListLoading.value = true;
    packingList.clear();
    filterPackingList.clear();
    filterSearchPackingList.clear();
    vendorFilter.clear();
    statusFilter.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    log("$token ${fromDate.value.toIso8601String()}   ${toDate.value.toIso8601String()}");
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetPackingListDetails?token=$token&fromDate=${fromDate.value.toIso8601String()}&toDate=${toDate.value.toIso8601String()}&ShowCompleted=${showClosedToggle.value}');
      if (feedback != null) {
        result = GetPackingListDetailsModel.fromJson(feedback);
        packingList.value = result.modelobject;
        filterSearchPackingList.value = result.modelobject;
        filterPackingList.value = packingList;
        var vendors = result.modelobject
            .map((item) => item.vendorName.toString())
            .toList()
            .toSet()
            .toList();
        vendorFilter.value = vendors;
        // vendorFilterSearchList.value = vendors;
        var status = result.modelobject
            .map((item) => item.actionstatuslog.toString())
            .toList()
            .toSet()
            .toList();
        statusFilter.value = status;
        await filterPackingSearchList();
      }
      await getActionStatusComboList();
      isPackingListLoading.value = false;
      update();
    } finally {
      isPackingListLoading.value = false;
      update();
    }
  }

  getActionStatusLogList(int index) async {
    isActionListLoading.value = true;
    actionStatusLog.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetActionStatusLogList?token=$token&VoucherID=${filterSearchPackingList[index].voucherId}&SysDocID=${packingList[index].docId}');
      if (feedback != null) {
        result = GetActionStatusLogListModel.fromJson(feedback);
        actionStatusLog.value = result.modelobject.reversed.toList();
      }
      isActionListLoading.value = false;
      update();
    } finally {
      isActionListLoading.value = false;
      update();
    }
  }

  filterPackingSearchList() {
    log(statusFilterList.toString(), name: 'Port');
    filterPackingList.value = packingList
        .where((element) =>
            (
                // element.vendorName != null &&
                //   vendorFilterController.value.text.isNotEmpty &&
                element.vendorName.toString().toLowerCase().contains(
                    vendorFilterController.value.text.toLowerCase())) &&
            (statusFilterList.isNotEmpty
                ? (
                        // element.actionstatuslog != null &&
                        //   statusFilterController.value.text.isNotEmpty &&
                        statusFilterList.any((item) =>
                            item.toLowerCase() ==
                            element.actionstatuslog.toString().toLowerCase())
                    // element.actionstatuslog.toString().toLowerCase().contains(
                    //     statusFilterController.value.text.toLowerCase())
                    )
                : true) &&
            (
                // element.port != null &&
                //   portFilterController.value.text.isNotEmpty &&
                element.port
                    .toString()
                    .toLowerCase()
                    .contains(portFilterController.value.text.toLowerCase())) &&
            (
                // element.containerNumber != null &&
                //   containerNoFilterController.value.text.isNotEmpty &&
                element.containerNumber.toString().toLowerCase().contains(
                    containerNoFilterController.value.text.toLowerCase())))
        .toList();
    update();
    filterSearchPackingList.value = filterPackingList;
    filterSearchPackingList.sort((a, b) {
      // Check for null dates and move them to the end
      if (a.eta == null) return 1;
      if (b.eta == null) return -1;

      // First, compare by the primary date in descending order
      final primaryComparison = b.eta!.compareTo(a.eta!);

      // If primary dates are equal, compare by the secondary date in descending order
      if (primaryComparison == 0) {
        if (a.transactionDate == null) return 1;
        if (b.transactionDate == null) return -1;
        return b.transactionDate!.compareTo(a.transactionDate!);
      }

      return primaryComparison;
    });
    UserSimplePreferences.setVendorFilter(vendorFilterController.value.text);
    UserSimplePreferences.setStatusFilter(statusFilterController.value.text);
    UserSimplePreferences.setPortFilter(portFilterController.value.text);
    UserSimplePreferences.setContainerFilter(
        containerNoFilterController.value.text);
    update();
  }

  clearFilter() {
    vendorFilterController.value.clear();
    statusFilterController.value.clear();
    portFilterController.value.clear();
    containerNoFilterController.value.clear();
    statusFilterList.clear();
    // filterPackingList.value = packingList;
    filterPackingSearchList();
    update();
  }

  searchPackingLIst(String value) {
    filterSearchPackingList.value = filterPackingList
        .where((element) =>
            (element.docId != null && element.docId!.toLowerCase().contains(value.toLowerCase())) ||
            (element.voucherId != null &&
                element.voucherId!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.actionstatuslog != null &&
                element.actionstatuslog!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.atd != null &&
                element.atd!.toLowerCase().contains(value.toLowerCase())) ||
            (element.bolNumber != null &&
                element.bolNumber!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.comments != null &&
                element.comments!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.containerNumber != null &&
                element.containerNumber!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.eta != null &&
                element.eta!.toLowerCase().contains(value.toLowerCase())) ||
            (element.itemCategory != null &&
                element.itemCategory!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.loadingPort != null &&
                element.loadingPort!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.nonPo != null &&
                element.nonPo!.toLowerCase().contains(value.toLowerCase())) ||
            (element.port != null &&
                element.port!.toLowerCase().contains(value.toLowerCase())) ||
            (element.reference1 != null &&
                element.reference1!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.reference2 != null &&
                element.reference2!.toLowerCase().contains(value.toLowerCase())) ||
            (element.shipper != null && element.shipper!.toLowerCase().contains(value.toLowerCase())) ||
            (element.shipperName != null && element.shipperName!.toLowerCase().contains(value.toLowerCase())) ||
            (element.vendorName != null && element.vendorName!.toLowerCase().contains(value.toLowerCase())))
        .toList();
    update();
  }

  selectPackageDate(
    context,
    DateTime date,
  ) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      changedDate.value = newDate;
    }

    update();
  }

  selectPackageTime(BuildContext context, TimeOfDay time) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
          ),
        );
      },
    );
  }

  updateDate(String sysDocId, String voucherId, String date) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    log("${changedDate.value.toIso8601String()}");
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'Update${date == "ERADate" ? "ETADate" : date}?token=$token&SysDocID=$sysDocId&VoucherID=$voucherId&$date=${changedDate.value.toIso8601String()}');
      log("${feedback}");
      if (feedback != null) {
        if (feedback["res"] == 0) {
          SnackbarServices.errorSnackbar(feedback["msg"]);
        }
      }
      update();
    } finally {
      getPackingListDetails();
    }
  }

  getShipperList() async {
    isLoading.value = true;
    shipperList.value.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetShipperList?token=$token');
      if (feedback != null) {
        result = GetShipperListModel.fromJson(feedback);
        shipperList.value = result.modelobject;
        filterShipperList.value = shipperList;
      }
      isLoading.value = false;
      update();
    } finally {}
  }

  searchFilter({required String filterId, required String value}) {
    if (filterId == statusFilterId) {
      filterSearchList.value = statusFilter
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
      update();
    } else if (filterId == vendorFilterId) {
      filterSearchList.value = vendorFilter
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
      update();
    }
  }

  selectFilterValue({required String filterId, required String value}) {
    if (filterId == statusFilterId) {
      if (statusFilterList.contains(value)) {
        statusFilterList.remove(value);
      } else {
        statusFilterList.add(value);
      }
      statusFilterController.value.text = statusFilterList.join(' , ');

      update();
    } else if (filterId == vendorFilterId) {
      vendorFilterController.value.text = value;
      update();
    }
  }

  clearSearch() {
    if (searchController.value.text.isNotEmpty) {
      searchController.value.clear();
      searchPackingLIst('');
    }

    update();
  }

  searchShipperLIst(String value) {
    filterShipperList.value = shipperList
        .where((element) =>
            element.code!.toLowerCase().contains(value.toLowerCase()) ||
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  searchStatusLIst(String value) {
    filterActionStatusList.value = actionStatusComboList
        .where((element) =>
            element.code!.toLowerCase().contains(value.toLowerCase()) &&
                containsMatchingObject(element) ||
            element.name!.toLowerCase().contains(value.toLowerCase()) &&
                containsMatchingObject(element))
        .toList();
    update();
  }

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  updateShipper(String sysDocId, String voucherId, String shipperName) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    log("${changedDate.value.toIso8601String()}");
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'UpdateShipperData?token=$token&SysDocID=$sysDocId&VoucherID=$voucherId&Shipper=$shipperName');
      log("${feedback}");
      if (feedback != null) {}
      update();
    } finally {
      getPackingListDetails();
    }
  }

  selectFile() async {
    result.value = (await FilePicker.platform.pickFiles(allowMultiple: true))!;
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
        image,
        scale: 14,
      );
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
        filterActionStatusList.value = actionStatusComboList;
        await getActionStatusSecurityList();
      }
      isLoading.value = false;
      update();
    } finally {}
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

  ActionStatusComboModel? getActionStatus(String statusId) {
    return actionStatusComboList
        .firstWhere((element) => element.code == statusId, orElse: null);
  }

  ActionStatusComboModel getActionStatusCombo(String code) {
    ActionStatusComboModel combo = actionStatusComboList.firstWhere(
      (element) => element.code == code,
      orElse: () => ActionStatusComboModel(name: ''),
    );
    return combo;
  }

  createActionLogStatus(int index, PackingDetailModel item) async {
    final username = UserSimplePreferences.getUsername() ?? '';

    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    var data = jsonEncode({
      "token": token,
      "SysDocID": sysDocId.value.text,
      "VoucherID": voucherId.value.text,
      "Isnewrecord": true,
      "IsCard": false,
      "DocType": SysdocType.PackingList.value,
      "LogStatus": statusCode.value.text,
      "Remarks": remarks.value.text,
      "Reference1": statusRef1Controller.value.text,
      "Reference2": statusRef2Controller.value.text,
      "ReferenceDate": refDate.value.toIso8601String(),
      "StatusType": ActionStatusType.Packing.value,
      "UpdatedBy": username,
      "DateUpdated": DateTime.now().toIso8601String(),
      "ActualDateTime": DateTime(
              actualDate.value.year,
              actualDate.value.month,
              actualDate.value.day,
              actualtime.value.hour,
              actualtime.value.minute)
          .toIso8601String()
    });

    try {
      log("${data}");
      var feedback = await ApiServices.fetchDataRawBodyInventory(
          api: 'CreateActionLogStatus', data: data);
      if (feedback != null) {
        getPackingListDetails();
      }
      update();
    } finally {}
  }

  Future<String> getPortTrackLink(PackingDetailModel item) async {
    isLinkLoading.value = true;
    // actionStatusChangingList.value.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String result = '';
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetPortTrackLink?token=$token&sysDocID=${item.docId}&voucherID=${item.voucherId}');
      if (feedback != null) {
        result = feedback['Modelobject'];
      }
      return result;
    } finally {
      isLinkLoading.value = false;
    }
  }

  Future<void> launchInBrowser(PackingDetailModel item) async {
    String x = item.containerNumber ?? '';
    List<String> c = x.split(""); // ['a', 'a', 'a', 'b', 'c', 'd']
    if (c.isEmpty) {
      return;
    }
    c.removeLast(); // ['a', 'a', 'a', 'b', 'c']
    item.containerNumber = c.join().toString();
    String url = await getPortTrackLink(item);
    String website = '';
    if (url.isNotEmpty) {
      website = url.replaceFirst('{ContainerNumber}', item.containerNumber!);
      log("${website}");
      if (!await launchUrl(
        Uri.parse(website),
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch ${item.containerNumber}');
      }
    } else {
      SnackbarServices.errorSnackbar('Could not Launch Url !');
    }
  }
}
