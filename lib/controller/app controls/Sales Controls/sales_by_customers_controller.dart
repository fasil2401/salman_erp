import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SalesByCustomerController extends GetxController {
  final salesController = Get.put(SalesController());
  final homeControl = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  TextEditingController customersControl = TextEditingController();
  TextEditingController classControl = TextEditingController();
  TextEditingController groupControl = TextEditingController();
  TextEditingController areaControl = TextEditingController();
  TextEditingController countryControl = TextEditingController();
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
  var summaryorDetail = 'summary'.obs;
  var filterList = [].obs;
  var isLoading = false.obs;
  var values = false.obs;
  var response = 0.obs;
  var isRange = false.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var isRangeCustomers = false.obs;
  var isRangeClass = false.obs;
  var isRangeGroup = false.obs;
  var isRangeArea = false.obs;
  var isRangeCountry = false.obs;
  var selectedCustomerList = [].obs;
  var selectedClassList = [].obs;
  var selectedGroupList = [].obs;
  var selectedAreaList = [].obs;
  var selectedCountryList = [].obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var dateIndex = 0.obs;

  var showaccordian = false.obs;

  getSalesByCustomerSummaryReport(BuildContext context) async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String fromDate = this.fromDate.value.toIso8601String();
    String toDate = this.toDate.value.toIso8601String();
    baseString.value = '';
    final data = jsonEncode({
      "PrintResultData": {
        "FileName": reportType.value == "Summary"? "Sales By Customer Summary" : "Sales By Customer Detail",
        "SysDocType": 0,
        "FileType": 1
      },
      "token": "$token",
      "IsSummary": reportType.value == "Summary" ? true : false,
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
      "fromCustomer": CommonFilterControls.getJsonFromToFilter(
          true, isRangeCustomers.value, false, selectedCustomerList),
      "toCustomer": CommonFilterControls.getJsonFromToFilter(
          false, isRangeCustomers.value, false, selectedCustomerList),
      "fromClass": CommonFilterControls.getJsonFromToFilter(
          true, isRangeClass.value, false, selectedClassList),
      "toClass": CommonFilterControls.getJsonFromToFilter(
          false, isRangeClass.value, false, selectedClassList),
      "fromGroup": CommonFilterControls.getJsonFromToFilter(
          true, isRangeGroup.value, false, selectedGroupList),
      "toGroup": CommonFilterControls.getJsonFromToFilter(
          false, isRangeGroup.value, false, selectedGroupList),
      "fromArea": CommonFilterControls.getJsonFromToFilter(
          true, isRangeArea.value, false, selectedAreaList),
      "toArea": CommonFilterControls.getJsonFromToFilter(
          false, isRangeArea.value, false, selectedAreaList),
      "fromCountry": CommonFilterControls.getJsonFromToFilter(
          true, isRangeCountry.value, false, selectedCountryList),
      "toCountry": CommonFilterControls.getJsonFromToFilter(
          false, isRangeCountry.value, false, selectedCountryList),
      "customerIDs": CommonFilterControls.getJsonListFilter(customersControl,
          isRangeCustomers.value, selectedCustomerList, false),
      "classIDs": CommonFilterControls.getJsonListFilter(
          classControl, isRangeClass.value, selectedClassList, false),
      "groupIDs": CommonFilterControls.getJsonListFilter(
          groupControl, isRangeGroup.value, selectedGroupList, false),
      "areaIDs": CommonFilterControls.getJsonListFilter(
          areaControl, isRangeArea.value, selectedAreaList, false),
      "countryIDs": CommonFilterControls.getJsonListFilter(
          countryControl, isRangeCountry.value, selectedCountryList, false),
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetSalesByCustomerSummaryReport', data: data);
      log("${feedback}");
      if (feedback != null) {
        baseString.value = '';
        // developer.log("${feedback}");
        isLoading.value = false;
        if (feedback['Modelobject'] != null) {
          baseString.value = feedback['Modelobject'];
          bytes.value = base64.decode(feedback['Modelobject']);
          update();
        }
      }
    } finally {
      isLoading.value = false;
      if (baseString.value.isNotEmpty) {
        Navigator.pop(context);
        // developer.log(dailyAnalysisSource[0].toString(), name: 'Report Name');
      } else {
        SnackbarServices.errorSnackbar('No Data Found !!');
      }
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

  changetoSummaryorDetail(String value) {
    summaryorDetail.value = value;
    update();
  }

  showAccordian() {
    showaccordian.value = !showaccordian.value;
  }
  //---------ReportTypes Start -------------//

  List<String> reportTypes = ['Summary', 'Detail'];

  var reportType = 'Summary'.obs;

  changeReportType(String type) {
    reportType.value = type.toString();
  }

  //---------ReportTypes end -------------//
}
