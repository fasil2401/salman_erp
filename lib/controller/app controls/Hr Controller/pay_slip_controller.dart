import 'dart:convert';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:month_year_picker/month_year_picker.dart';

class PaySlipController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var startDate = DateTime.now().obs;

  var endDate = DateTime.now().obs;
  var isSaving = false.obs;
  var isLoading = false.obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var baseString = ''.obs;
  var isLoadingReport = false.obs;
  var bytes = Uint8List(10000000).obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;

  Future<DateTime> selectDateStartDate(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  Future<DateTime> selectDateEndDate(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  final Rx<DateTime> selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;

  Future<void> selectMonthYear(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null &&
        (picked.year != selectedDate.value.year ||
            picked.month != selectedDate.value.month)) {
      picked = DateTime(
        picked.year,
        picked.month,
      );
      selectedDate.value = picked;
     // getPaySlipList(context, picked.month, picked.year);
      update();
    }
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

  getPaySlipList(
      BuildContext context, int selectedMonth, int selectedYear) async {
    int month = selectedDate.value.month;
    int year = selectedDate.value.year;
    isLoadingReport.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    final data = jsonEncode({
      "PrintResultData": {
        "FileName": "Employee Salary Slip",
        "SysDocType": 0,
        "FileType": 1,
      },
      "token": "$token",
      "employeeID": "$employeeId",
      "month": month,
      "year": year,
    });
    try {
      print("filterrrrrrrrr${data}");
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api: 'GetPaySlipReport', data: data);
      print("filterrrrrrrrr${data}");
      if (feedback != null) {
        // baseString.value = '';
        // developer.log("${feedback}");
        isLoadingReport.value = false;
        if (feedback['Modelobject'] != null) {
          baseString.value = feedback['Modelobject'];
          bytes.value = base64.decode(feedback['Modelobject']);
          update();
          print(baseString.value);
        }
      }
    } finally {
      isLoadingReport.value = false;
      if (baseString.value.isNotEmpty) {
        Navigator.pop(context);
        // developer.log(dailyAnalysisSource[0].toString(), name: 'Report Name');
      } else {
        SnackbarServices.errorSnackbar('No Data Found !!');
      }
    }
  }
}
