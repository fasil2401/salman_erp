import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Leave%20Request%20Model/get_leave_request_details_by_id_model.dart';
import 'package:axolon_erp/model/Leave%20Request%20Model/get_leave_request_list_model.dart';
import 'package:axolon_erp/model/Leave%20Request%20Model/get_leave_type_model.dart';
import 'package:axolon_erp/model/system_doc_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class LeaveReqController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadInitials();
  }

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  var isSaving = false.obs;
  var isLoading = false.obs;
  var leaveList = <LeaveRequestModel>[].obs;
  var refController = TextEditingController().obs;
  var selectedDocId = SysDocModel().obs;
  var docNumberController = TextEditingController().obs;
  var reasonController = TextEditingController().obs;
  var noteController = TextEditingController().obs;
  var startDate = DateTime.now().obs;
  var travellingDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var appDate = DateTime.now().obs;
  var days = 1.obs;
  var leaveDays = 1.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var docIdList = [].obs;
  var leaveTypeList = <LeaveTypeModel>[].obs;
  var selectedLeaveType = LeaveTypeModel().obs;
  var selectedLeave = LeaveRequestByIdMdel().obs;
  var isNewRecord = false.obs;
  var isApproved = false.obs;
  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  loadInitials() async {
    int index = 8;
    await selectDateRange(
        index,
        DateRangeSelector.dateRange.indexOf(DateRangeSelector.dateRange
            .firstWhere((element) => element.value == index)));

    getLeaveRequestDetailList();
    isEnanbled();
  }

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeLeaveRequest,
        type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeLeaveRequest,
        type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
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

  getAvailableDateAndDays() {
    getActualLeaveDays();
    days.value = DateTime(endDate.value.year, endDate.value.month,
            endDate.value.day, 24, 59, 59)
        .difference(DateTime(startDate.value.year, startDate.value.month,
            startDate.value.day, 00, 00))
        .inDays;
    leaveDays.value = days.value;
    update();
  }

  Future<DateTime> selectDateStartDate(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  DateTime date = DateTime.now();
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
  }

  getDocId() {
    docIdList.clear();
    if (salesScreenController.sysDocList.isEmpty) {
      salesScreenController.getSystemDocList();
    }
    docIdList.value = salesScreenController.sysDocList
        .where((element) => element.sysDocType == SysdocType.LeaveRequest.value)
        .toList();
    selectedDocId.value = docIdList.first;
    getVoucherNumber(selectedDocId.value.code ?? '');
    update();
  }

  getActualLeaveDays() async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';

    try {
      var feedback = ApiServices.fetchDataEmployee(
          api:
              'GetActualLeaveDays?token=$token&employeeID=$employeeId&startDate=${startDate.value.toIso8601String()}&endDate=${endDate.value.toIso8601String()}&leaveTypeID=${selectedLeaveType.value.typeCode}');
    } finally {}
  }

  getLeaveType() async {
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataEmployee(api: 'GetLeaveType?token=$token');
      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetLeaveTypeModel.fromJson(feedback);
          leaveTypeList.value = result.model;
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  createLeaveRequest() async {
    isSaving.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    var data = jsonEncode({
      "token": token,
      "IsApproved": isApproved.value,
      "TransactionDate": appDate.value.toIso8601String(),
      "Reason": reasonController.value.text,
      "Reference": refController.value.text,
      "Note": noteController.value.text,
      "Isnewrecord": isNewRecord.value,
      "EmployeeID": employeeId,
      "EmployeeLeaveRequestModel": {
        "SysDocID": selectedDocId.value.code,
        "VoucherID": docNumberController.value.text,
        "Isapproved": false,
        "StartDate": startDate.value.toIso8601String(),
        "EndtDate": endDate.value.toIso8601String(),
        "TravellingDate": travellingDate.value.toIso8601String(),
        "LeaveTypeID": selectedLeaveType.value.typeCode,
        "ActualLeaveDays": 0,
        "RequestStartDate": startDate.value.toIso8601String(),
        "RequestEndDate": endDate.value.toIso8601String()
      }
    });
    try {
      developer.log("${data}");
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'CreateEmployeeLeaveRequest', data: data);
      developer.log("${feedback}");
      if (feedback != null) {
        if (feedback['res'] == 1) {
          clearData();
          SnackbarServices.successSnackbar(
              "Created Employee Leave Request Successfully");
          getVoucherNumber(selectedDocId.value.code ?? '');
        }
      }
    } finally {
      isSaving.value = false;
    }
  }

  getLeaveRequestDetailById(LeaveRequestModel item) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api:
              'GetLeaveRequestDetailsByID?token=$token&sysDocID=${item.sysDocId}&voucherID=${item.docNumber}&employeeActivityTypes=${EmployeeActivityTypes.Leave.value}');
      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetLeaveRequestDetailsByIdModel.fromJson(feedback);
          selectedLeave.value = result.model[0];
          selectedDocId.value = docIdList.firstWhere(
            (element) => item.sysDocId == element.code,
            orElse: () {
              SysDocModel();
            },
          );
          docNumberController.value.text = item.docNumber ?? '';
          if (leaveTypeList.value.isEmpty) {
            await getLeaveType();
          }
          selectedLeaveType.value = leaveTypeList.firstWhere(
              (element) => element.typeCode == item.leaveTypeId,
              orElse: () => LeaveTypeModel());
          startDate.value = item.startDate ?? DateTime.now();
          endDate.value = item.endDate ?? DateTime.now();
          refController.value.text = selectedLeave.value.reference ?? '';
          reasonController.value.text = selectedLeave.value.reason ?? '';
          noteController.value.text = selectedLeave.value.note ?? '';
          days.value = item.leaveDays ?? 0;
          leaveDays.value = item.leaveDays ?? 0;
          appDate.value = selectedLeave.value.transactionDate ?? DateTime.now();
          isNewRecord.value = false;
          // isApproved.value=item.approvalStatus??
        }
      }
    } finally {}
  }

  getLeaveRequestDetailList() async {
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    if (selectedDocId.value.code == null) {
      await getDocId();
    }
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api:
              'GetLeaveRequestDetailList?token=$token&from=${fromDate.value.toIso8601String()}&to=${toDate.value.toIso8601String()}&showVoid=false&sysDocID=${selectedDocId.value.code}');

      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetLeaveRequestDetailListModel.fromJson(feedback);
          String employeeId = homeController.employeeId.value;
          List<LeaveRequestModel> list = result.model
              .where((element) => element.employeeId == employeeId)
              .toList();
          filterRecentDates(list);
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  filterRecentDates(List<LeaveRequestModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.endDate!;
        DateTime dateB = b.endDate!;
        return dateB.compareTo(dateA); // Descending order
      });
      leaveList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }

  getVoucherNumber(
    String sysDocId,
  ) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String date = DateTime.now().toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetNextDocumentNo?token=${token}&sysDocID=${sysDocId}&dateTime=${date}');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        docNumberController.value.text = result.model;
      }
    } finally {}
  }

  clearData() {
    selectedLeaveType.value = LeaveTypeModel();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
    days.value = 1;
    travellingDate.value = DateTime.now();
    refController.value.clear();
    leaveDays.value = 1;
    reasonController.value.clear();
    noteController.value.clear();
    isNewRecord.value = false;
    update();
  }
}
