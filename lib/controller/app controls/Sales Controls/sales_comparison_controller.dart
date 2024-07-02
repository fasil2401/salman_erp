import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/snackbar.dart';
import '../../../view/components/common_filter_controls.dart';
import '../home_controller.dart';

class SalesComparisonController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
  @override
  void onInit() {
    addList();
    super.onInit();
  }

//----------------------sales persons variables-------------------------//
  TextEditingController salesPersonController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  var isRangeSalesPerson = false.obs;
  var isRangeSalesDivision = false.obs;
  var isRangeSalesGroup = false.obs;
  var isRangeSalesArea = false.obs;
  var isRangeSalesCountry = false.obs;
  var selectedSalesPersonList = [].obs;
  var selectedSalesDivisionList = [].obs;
  var selectedSalesGroupList = [].obs;
  var selectedSalesAreaList = [].obs;
  var selectedSalesCountryList = [].obs;
//-----------------------------------------------------------------------//

  var summaryorDetail = 'summary'.obs;
  var isLoadingReport = false.obs;

  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var salesComparison = [].obs;
  var selectedItem = "All Salesperson".obs;
  addList() {
    salesComparison.addAll([
      "All Salesperson",
      "Single",
      "Range",
      "Division",
      "Group",
      "Area",
      "Country"
    ]);
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

  var salePersonAccordion = false.obs;

  showsalePersonAccordian() {
    salePersonAccordion.value = !salePersonAccordion.value;
  }
  //---------ReportTypes Start -------------//

  List<String> reportTypes = ['Summary', 'Detail'];

  var reportType = 'Summary'.obs;

  changeReportType(String type) {
    reportType.value = type.toString();
  }

  //---------ReportTypes end -------------//

  getSalesComparisonReport(BuildContext context) async {
    isLoadingReport.value = true;
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
        "FileName": reportType.value == reportTypes[0]
            ? "Sales comparison Pivot Summary"
            : "Sales comparison Pivot",
        "SysDocType": 0,
        "FileType": 1
      },
      "token": "$token",
      "IsSummary": reportType.value == reportTypes[0] ? true : false,
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
      "fromSalesperson": CommonFilterControls.getJsonFromToFilter(
          true, isRangeSalesPerson.value, false, selectedSalesPersonList),
      "toSalesperson": CommonFilterControls.getJsonFromToFilter(
          false, isRangeSalesPerson.value, false, selectedSalesPersonList),
      "fromSalespersonDivision": CommonFilterControls.getJsonFromToFilter(
          true, isRangeSalesDivision.value, false, selectedSalesDivisionList),
      "toSalespersonDivision": CommonFilterControls.getJsonFromToFilter(
          false, isRangeSalesDivision.value, false, selectedSalesDivisionList),
      "fromSalespersonGroup": CommonFilterControls.getJsonFromToFilter(
          true, isRangeSalesGroup.value, false, selectedSalesGroupList),
      "toSalespersonGroup": CommonFilterControls.getJsonFromToFilter(
          false, isRangeSalesGroup.value, false, selectedSalesGroupList),
      "fromSalespersonArea": CommonFilterControls.getJsonFromToFilter(
          true, isRangeSalesArea.value, false, selectedSalesAreaList),
      "toSalespersonArea": CommonFilterControls.getJsonFromToFilter(
          false, isRangeSalesArea.value, false, selectedSalesAreaList),
      "fromSalespersonCountry": CommonFilterControls.getJsonFromToFilter(
          true, isRangeSalesCountry.value, false, selectedSalesCountryList),
      "toSalespersonCountry": CommonFilterControls.getJsonFromToFilter(
          false, isRangeSalesCountry.value, false, selectedSalesCountryList),
      "SalespersonIDs": CommonFilterControls.getJsonListFilter(
          salesPersonController,
          isRangeSalesPerson.value,
          selectedSalesPersonList,
          false),
      "DivisionIDs": CommonFilterControls.getJsonListFilter(divisionController,
          isRangeSalesDivision.value, selectedSalesDivisionList, false),
      "SalespersonGroupIDs": CommonFilterControls.getJsonListFilter(
          groupController,
          isRangeSalesGroup.value,
          selectedSalesGroupList,
          false),
      "AreaIDs": CommonFilterControls.getJsonListFilter(
          areaController, isRangeSalesArea.value, selectedSalesAreaList, false),
      "CountryIDs": CommonFilterControls.getJsonListFilter(countryController,
          isRangeSalesCountry.value, selectedSalesCountryList, false),
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetSalesComparisonReport', data: data);
      if (feedback != null) {
        baseString.value = '';
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
