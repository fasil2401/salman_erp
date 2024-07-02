import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesPersonCommissionController extends GetxController {
  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  TextEditingController commissionController = TextEditingController();
  var salePersonAccordion = false.obs;
  var isLoading = false.obs;
  var response = 0.obs;
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;

  showsalePersonAccordian() {
    salePersonAccordion.value = !salePersonAccordion.value;
  }

  //-----------------------location--------------------------//
  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //----------------------------------------------------------------//
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

  //-----------------------------------------------------------------------//
  //---------------------------summary or detail---------------------------//
  var summaryorDetail = 'summary'.obs;
  changetoSummaryorDetail(String value) {
    summaryorDetail.value = value;
    update();
  }

  //----------------------------item Brand----------------------------------//
  var selectedItemBrandList = [].obs;
  var isRangeItemBrand = false.obs;
  var itemBrandController = TextEditingController().obs;
//---------------------------------------------------------------------------//
  //----------------------------item Category----------------------------------//
  var selectedItemCategoryList = [].obs;
  var isRangeItemCategory = false.obs;
  var itemCategoryController = TextEditingController().obs;
//---------------------------------------------------------------------------//
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
  //---------ReportTypes Start -------------//

  List<String> reportTypes = ['Summary', 'Detail', 'More'];

  var reportType = 'Summary'.obs;

  changeReportType(String type) {
    reportType.value = type.toString();
  }

  //---------ReportTypes end -------------//
  //-----------api-------------------------//
  getSalesPersonCommisionReport(BuildContext context) async {
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
        "FileName": reportType.value == 'Summary'
            ? "Salesperson Commission Summary"
            : reportType.value == 'Detail'
                ? "Salesperson Commission Details"
                : "Salesperson Commission More",
        "SysDocType": 0,
        "FileType": 1
      },
      "token": "$token",
      "IsSummary": reportType.value == 'Summary' ? true : false,
      "IsDetail": reportType.value == 'Detail' ? true : false,
      "IsMore": reportType.value == 'More' ? true : false,
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
      "fromLocation": CommonFilterControls.getJsonFromToFilter(
          true, isRangeLocation.value, false, selectedLocationList),
      "toLocation": CommonFilterControls.getJsonFromToFilter(
          false, isRangeLocation.value, false, selectedLocationList),
      "fromCategory": CommonFilterControls.getJsonFromToFilter(
          true, isRangeItemCategory.value, false, selectedItemCategoryList),
      "toCategory": CommonFilterControls.getJsonFromToFilter(
          false, isRangeItemCategory.value, false, selectedItemCategoryList),
      "fromBrand": CommonFilterControls.getJsonFromToFilter(
          true, isRangeItemBrand.value, false, selectedItemBrandList),
      "toBrand": CommonFilterControls.getJsonFromToFilter(
          false, isRangeItemBrand.value, false, selectedItemBrandList),
      "CommissionPerc": commissionController.text.isEmpty
          ? 0.0
          : double.parse(commissionController.text),
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
      "LocationIDs": CommonFilterControls.getJsonListFilter(
          locationController.value,
          isRangeLocation.value,
          selectedLocationList,
          false),
      "CategoryIDs": CommonFilterControls.getJsonListFilter(
          itemCategoryController.value,
          isRangeItemCategory.value,
          selectedItemCategoryList,
          false),
      "BrandIDs": CommonFilterControls.getJsonListFilter(
          itemBrandController.value,
          isRangeItemBrand.value,
          selectedItemBrandList,
          false),
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
          api: 'GetSalesPersonCommissionReport', data: data);
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
}
