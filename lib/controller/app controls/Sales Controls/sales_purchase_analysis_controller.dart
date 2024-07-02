import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/snackbar.dart';

class SalesPurchaseAnalysisController extends GetxController {
  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
  TextEditingController productControl = TextEditingController();
  TextEditingController classControl = TextEditingController();
  TextEditingController categoryControl = TextEditingController();
  TextEditingController brandControl = TextEditingController();
  TextEditingController manufacturerControl = TextEditingController();
  TextEditingController originControl = TextEditingController();
  TextEditingController styleControl = TextEditingController();
  var isLoading = false.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var isRangeProduct = false.obs;
  var isRangeClass = false.obs;
  var isRangeCategory = false.obs;
  var isRangeBrand = false.obs;
  var isRangeManufacturer = false.obs;
  var isRangeOrigin = false.obs;
  var isRangeStyle = false.obs;
  DateTime date = DateTime.now();
  var isAverage = false.obs;
  var selectedProductList = [].obs;
  var selectedclassList = [].obs;
  var selectedCategoryList = [].obs;
  var selectedBrandList = [].obs;
  var selectedManufacturerList = [].obs;
  var selectedOriginList = [].obs;
  var selectedStyleList = [].obs;

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

  var productAccordion = false.obs;
  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  //-----------------------location--------------------------//
  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //----------------------------------------------------------------//
  changeIsAverage(bool value) {
    isAverage.value = !isAverage.value;
  }

//---------------------------api------------------------------------//
  getSalesPurchaseAnalysisReport(BuildContext context) async {
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
    "FileName":  isAverage.value ? "Sales Purchase AvgAnalysis": "Sales Purchase Analysis",
    "SysDocType": 0,
    "FileType": 1
  },
      "token": "$token",
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
      "fromLocation": CommonFilterControls.getJsonFromToFilter(
          true, isRangeLocation.value, false, selectedLocationList),
      "toLocation": CommonFilterControls.getJsonFromToFilter(
          false, isRangeLocation.value, false, selectedLocationList),
      "fromItem": CommonFilterControls.getJsonFromToFilter(
          true, isRangeProduct.value, true, selectedProductList),
      "toItem": CommonFilterControls.getJsonFromToFilter(
          false, isRangeProduct.value, true, selectedProductList),
      "fromClass": CommonFilterControls.getJsonFromToFilter(
          true, isRangeClass.value, false, selectedclassList),
      "toClass": CommonFilterControls.getJsonFromToFilter(
          false, isRangeClass.value, false, selectedclassList),
      "fromCategory": CommonFilterControls.getJsonFromToFilter(
          true, isRangeCategory.value, false, selectedCategoryList),
      "toCategory": CommonFilterControls.getJsonFromToFilter(
          false, isRangeCategory.value, false, selectedCategoryList),
      "fromBrand": CommonFilterControls.getJsonFromToFilter(
          true, isRangeBrand.value, false, selectedBrandList),
      "toBrand": CommonFilterControls.getJsonFromToFilter(
          false, isRangeBrand.value, false, selectedBrandList),
      "fromManufacturer": CommonFilterControls.getJsonFromToFilter(
          true, isRangeManufacturer.value, false, selectedManufacturerList),
      "toManufacturer": CommonFilterControls.getJsonFromToFilter(
          false, isRangeManufacturer.value, false, selectedManufacturerList),
      "fromStyle": CommonFilterControls.getJsonFromToFilter(
          true, isRangeStyle.value, false, selectedStyleList),
      "toStyle": CommonFilterControls.getJsonFromToFilter(
          false, isRangeStyle.value, false, selectedStyleList),
      "fromOrigin": CommonFilterControls.getJsonFromToFilter(
          true, isRangeOrigin.value, false, selectedOriginList),
      "toOrigin": CommonFilterControls.getJsonFromToFilter(
          false, isRangeOrigin.value, false, selectedOriginList),
      "LocationIDs": CommonFilterControls.getJsonListFilter(
          locationController.value,
          isRangeLocation.value,
          selectedLocationList,
          false),
      "ItemIDs": CommonFilterControls.getJsonListFilter(
          productControl, isRangeProduct.value, selectedProductList, true),
      "ItemClassIDs": CommonFilterControls.getJsonListFilter(
          classControl, isRangeClass.value, selectedclassList, false),
      "ItemCategoryIDs": CommonFilterControls.getJsonListFilter(
          categoryControl, isRangeCategory.value, selectedCategoryList, false),
      "BrandIDs": CommonFilterControls.getJsonListFilter(
          brandControl, isRangeBrand.value, selectedBrandList, false),
      "ManufactureIDs": CommonFilterControls.getJsonListFilter(
          manufacturerControl,
          isRangeManufacturer.value,
          selectedManufacturerList,
          false),
      "OriginIDs": CommonFilterControls.getJsonListFilter(
          originControl, isRangeOrigin.value, selectedOriginList, false),
      "StyleIDs": CommonFilterControls.getJsonListFilter(
          styleControl, isRangeStyle.value, selectedStyleList, false),
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetSalesPurchaseAnalysisReport', data: data);
      if (feedback != null) {
        baseString.value = '';
        // developer.log("${feedback}");
        isLoading.value = false;
        if (feedback['Modelobject'] != null) {
          baseString.value = feedback['Modelobject'];
          bytes.value = base64.decode(feedback['Modelobject']);
          update();
          print(baseString.value);
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
