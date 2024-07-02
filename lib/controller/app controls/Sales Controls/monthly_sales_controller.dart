import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MonthlySalesController extends GetxController {
  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  var isLoadingReport = false.obs;
  var response = 0.obs;
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
//---------date start -------------//
  DateTime date = DateTime.now();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
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

//---------date end -------------//

//---------location start -------------//
  // var locationRadio = 'all'.obs;
  // var isSingleLocation = false.obs;
  // var isMultipleLocation = false.obs;
  // var fromLocation = LocationSingleModel().obs;
  // var toLocation = LocationSingleModel().obs;
  // var singleLocation = LocationSingleModel().obs;

  // updateLocationRadio(String value) {
  //   locationRadio.value = value;
  //   if (value == 'single') {
  //     isSingleLocation.value = true;
  //     isMultipleLocation.value = false;
  //     fromLocation.value = LocationSingleModel();
  //     toLocation.value = LocationSingleModel();
  //   } else if (value == 'range') {
  //     isSingleLocation.value = false;
  //     isMultipleLocation.value = true;
  //     singleLocation.value = LocationSingleModel();
  //   } else {
  //     isSingleLocation.value = false;
  //     isMultipleLocation.value = false;
  //     fromLocation.value = LocationSingleModel();
  //     toLocation.value = LocationSingleModel();
  //     singleLocation.value = LocationSingleModel();
  //   }
  // }

  // selectLocation(String value, BuildContext context) async {
  //   if (value == 'from') {
  //     fromLocation.value = await homeController.selectLocatio(context: context);
  //   } else if (value == 'to') {
  //     toLocation.value = await homeController.selectLocatio(context: context);
  //   } else {
  //     singleLocation.value =
  //         await homeController.selectLocatio(context: context);
  //   }
  // }

  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //---------location end -------------//

  //---------products start -------------//
  var productAccordion = false.obs;

  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  TextEditingController productsControl = TextEditingController();
  TextEditingController productClassControl = TextEditingController();
  TextEditingController productCategoryControl = TextEditingController();
  TextEditingController productBrandControl = TextEditingController();
  TextEditingController productManufactureControl = TextEditingController();
  TextEditingController ProductOriginControl = TextEditingController();
  TextEditingController ProductStyleControl = TextEditingController();

  var isRangeProducts = false.obs;
  var isRangeProductClass = false.obs;
  var isRangeProductCategory = false.obs;
  var isRangeProductBrand = false.obs;
  var isRangeProductManufacture = false.obs;
  var isRangeProductOrigin = false.obs;
  var isRangeProductStyle = false.obs;

  var selectedProductList = [].obs;
  var selectedProductClassList = [].obs;
  var selectedProductCategoryList = [].obs;
  var selectedProductBrandList = [].obs;
  var selectedProductManufactureList = [].obs;
  var selectedProductOriginList = [].obs;
  var selectedProductStyleList = [].obs;

  //---------products end -------------//

  //---------Salesperson start -------------//

  var salePersonAccordion = false.obs;

  showsalePersonAccordian() {
    salePersonAccordion.value = !salePersonAccordion.value;
  }

  TextEditingController salesPersonControl = TextEditingController();
  TextEditingController salesDivisionControl = TextEditingController();
  TextEditingController salesGroupControl = TextEditingController();
  TextEditingController salesAreaControl = TextEditingController();
  TextEditingController salesCountryControl = TextEditingController();

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

  //---------Salesperson end -------------//

  //---------ReportTypes Start -------------//

  List<String> reportTypes = ['By Item', 'By Category', 'More'];

  var reportType = 'By Item'.obs;

  changeReportType(String type) {
    reportType.value = type.toString();
  }

  //---------ReportTypes end -------------//

  // var pdfBytes = Uint8List(1).obs;

  // getSalesByCustomerSummaryReport() async {
  //   isLoading.value = true;
  //   await loginController.getToken();
  //   if (loginController.token.value.isEmpty) {
  //     await loginController.getToken();
  //   }
  //   final String token = loginController.token.value;
  //   String fromDate = this.fromDate.value.toIso8601String();
  //   String toDate = this.toDate.value.toIso8601String();
  //   dynamic result;
  //   final data = jsonEncode({
  //     "token": "string",
  //     "IsByItem": true,
  //     "IsByCategory": true,
  //     "IsByMore": true,
  //     "FromDate": "2023-03-02T12:20:02.381Z",
  //     "ToDate": "2023-03-02T12:20:02.381Z",
  //     "fromItem": "string",
  //     "toItem": "string",
  //     "fromClass": "string",
  //     "toClass": "string",
  //     "fromCategory": "string",
  //     "toCategory": "string",
  //     "fromLocation": "string",
  //     "toLocation": "string",
  //     "IsAsOfDate": true,
  //     "asOfDate": "2023-03-02T12:20:02.381Z",
  //     "showZero": true,
  //     "isInactive": true,
  //     "fromManufacturer": "string",
  //     "toManufacturer": "string",
  //     "fromStyle": "string",
  //     "toStyle": "string",
  //     "fromOrigin": "string",
  //     "toOrigin": "string",
  //     "fromSalesperson": "string",
  //     "toSalesperson": "string",
  //     "fromSalespersonDivision": "string",
  //     "toSalespersonDivision": "string",
  //     "fromSalespersonGroup": "string",
  //     "toSalespersonGroup": "string",
  //     "fromSalespersonArea": "string",
  //     "toSalespersonArea": "string",
  //     "fromSalespersonCountry": "string",
  //     "toSalespersonCountry": "string",
  //     "ItemIDs": "string",
  //     "ItemClassIDs": "string",
  //     "ItemCategoryIDs": "string",
  //     "BrandIDs": "string",
  //     "ManufactureIDs": "string",
  //     "OriginIDs": "string",
  //     "StyleIDs": "string",
  //     "SalespersonIDs": "string",
  //     "DivisionIDs": "string",
  //     "SalespersonGroupIDs": "string",
  //     "AreaIDs": "string",
  //     "CountryIDs": "string"
  //   });
  //   try {
  //     var feedback = await ApiServices.fetchDataRawBody(
  //         api: 'GetSalesByCustomerSummaryReport', data: data);
  //     if (feedback != null) {
  //       print(result);
  //       if (feedback['result'] == 0) {
  //         isLoadingReport.value = false;
  //       }
  //       response.value = feedback['result'];

  //       log("${feedback}");
  //     }
  //   } finally {
  //     if (response.value == 1) {
  //       isLoadingReport.value = false;
  //     }
  //   }
  // }
  getMonthlySalesReport(BuildContext context) async {
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
        "FileName": reportType.value == 'By Item'
            ? "Monthly Sales Pivot"
            : reportType.value == 'By Category'
                ? 'Monthly Sales Pivot By Category'
                : 'Monthly Sales Pivot More',
        "SysDocType": 0,
        "FileType": 1
      },
      "token": "$token",
      "IsByItem": reportType.value == 'By Item' ? true : false,
      "IsByCategory": reportType.value == 'By Category' ? true : false,
      "IsByMore": reportType.value == 'More' ? true : false,
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
      "fromItem": CommonFilterControls.getJsonFromToFilter(
          true, isRangeProducts.value, true, selectedProductList),
      "toItem": CommonFilterControls.getJsonFromToFilter(
          false, isRangeProducts.value, true, selectedProductList),
      "fromClass": CommonFilterControls.getJsonFromToFilter(
          true, isRangeProductClass.value, false, selectedProductClassList),
      "toClass": CommonFilterControls.getJsonFromToFilter(
          false, isRangeProductClass.value, false, selectedProductClassList),
      "fromCategory": CommonFilterControls.getJsonFromToFilter(true,
          isRangeProductCategory.value, false, selectedProductCategoryList),
      "toCategory": CommonFilterControls.getJsonFromToFilter(false,
          isRangeProductCategory.value, false, selectedProductCategoryList),
      "fromLocation": CommonFilterControls.getJsonFromToFilter(
          true, isRangeLocation.value, false, selectedLocationList),
      "toLocation": CommonFilterControls.getJsonFromToFilter(
          false, isRangeLocation.value, false, selectedLocationList),
      "IsAsOfDate": false,
      "asOfDate": "$toDate",
      "showZero": false,
      "isInactive": false,
      "fromManufacturer": CommonFilterControls.getJsonFromToFilter(
          true,
          isRangeProductManufacture.value,
          false,
          selectedProductManufactureList),
      "toManufacturer": CommonFilterControls.getJsonFromToFilter(
          false,
          isRangeProductManufacture.value,
          false,
          selectedProductManufactureList),
      "fromStyle": CommonFilterControls.getJsonFromToFilter(
          true, isRangeProductStyle.value, false, selectedProductStyleList),
      "toStyle": CommonFilterControls.getJsonFromToFilter(
          false, isRangeProductStyle.value, false, selectedProductStyleList),
      "fromOrigin": CommonFilterControls.getJsonFromToFilter(
          true, isRangeProductOrigin.value, false, selectedProductOriginList),
      "toOrigin": CommonFilterControls.getJsonFromToFilter(
          false, isRangeProductOrigin.value, false, selectedProductOriginList),
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
      "ItemIDs": CommonFilterControls.getJsonListFilter(
          productsControl, isRangeProducts.value, selectedProductList, true),
      "ItemClassIDs": CommonFilterControls.getJsonListFilter(
          productCategoryControl,
          isRangeProductClass.value,
          selectedProductClassList,
          false),
      "ItemCategoryIDs": CommonFilterControls.getJsonListFilter(
          productCategoryControl,
          isRangeProductCategory.value,
          selectedProductCategoryList,
          false),
      "BrandIDs": CommonFilterControls.getJsonListFilter(productBrandControl,
          isRangeProductBrand.value, selectedProductBrandList, false),
      "ManufactureIDs": CommonFilterControls.getJsonListFilter(
          productManufactureControl,
          isRangeProductManufacture.value,
          selectedProductManufactureList,
          false),
      "OriginIDs": CommonFilterControls.getJsonListFilter(ProductOriginControl,
          isRangeProductOrigin.value, selectedProductOriginList, false),
      "StyleIDs": CommonFilterControls.getJsonListFilter(ProductStyleControl,
          isRangeProductStyle.value, selectedProductStyleList, false),
      "SalespersonIDs": CommonFilterControls.getJsonListFilter(
          salesPersonControl,
          isRangeSalesPerson.value,
          selectedSalesPersonList,
          false),
      "DivisionIDs": CommonFilterControls.getJsonListFilter(
          salesDivisionControl,
          isRangeSalesDivision.value,
          selectedSalesDivisionList,
          false),
      "SalespersonGroupIDs": CommonFilterControls.getJsonListFilter(
          salesGroupControl,
          isRangeSalesGroup.value,
          selectedSalesGroupList,
          false),
      "AreaIDs": CommonFilterControls.getJsonListFilter(salesAreaControl,
          isRangeSalesArea.value, selectedSalesAreaList, false),
      "CountryIDs": CommonFilterControls.getJsonListFilter(salesCountryControl,
          isRangeSalesCountry.value, selectedSalesCountryList, false),
      "LocationIDs": CommonFilterControls.getJsonListFilter(
          locationController.value,
          isRangeLocation.value,
          selectedLocationList,
          false),
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetMonthlySalesReport', data: data);
      log("${feedback}");
      if (feedback != null) {
        baseString.value = '';
        // developer.log("${feedback}");
        isLoadingReport.value = false;
        if (feedback['Modelobject'] != null) {
          baseString.value = feedback['Modelobject'];
          bytes.value = base64.decode(feedback['Modelobject']);
          update();
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
