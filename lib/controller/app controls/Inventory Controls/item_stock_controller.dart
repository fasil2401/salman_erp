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

class ItemStockController extends GetxController {
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
  var isRangeProduct = false.obs;
  var isRangeClass = false.obs;
  var isRangeCategory = false.obs;
  var isRangeBrand = false.obs;
  var isRangeManufacturer = false.obs;
  var isRangeOrigin = false.obs;
  var isRangeStyle = false.obs;
  var selectedProductList = [].obs;
  var selectedclassList = [].obs;
  var selectedCategoryList = [].obs;
  var selectedBrandList = [].obs;
  var selectedManufacturerList = [].obs;
  var selectedOriginList = [].obs;
  var selectedStyleList = [].obs;

  var productAccordion = false.obs;
  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  showDummy() {
    productAccordion.value = productAccordion.value;
  }

  //-----------------------location--------------------------//
  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //----------------------------------------------------------------//

  //---------date start -------------//
  DateTime date = DateTime.now();
  var reportDate = DateTime.now().obs;
  selectDate(context) async {
    DateTime? newDate =
        await CommonFilterControls.getCalender(context, reportDate.value);
    if (newDate != null) {
      reportDate.value = newDate;
    }
    update();
  }
// date end

//---------inactive toggles start -------------//
  var isinactiveProducts = false.obs;
  var iszeroQtyProducts = false.obs;

  toggleInactiveProducts() {
    isinactiveProducts.value = !isinactiveProducts.value;
  }

  toggleZeroQtyProducts() {
    iszeroQtyProducts.value = !iszeroQtyProducts.value;
  }

  //---------inactive toggles end -------------//

//---------------------------api------------------------------------//
  getProductStockListReport(BuildContext context) async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String asOfDate = this.reportDate.value.toIso8601String();
    baseString.value = '';
    final data = jsonEncode({
      "PrintResultData": {
        "FileName": "Item Stock List Location Wise",
        "SysDocType": 0,
        "FileType": 1
      },
      "token": "$token",
      "AsOfDate": "$asOfDate",
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
      "fromLocation": CommonFilterControls.getJsonFromToFilter(
          true, isRangeLocation.value, false, selectedLocationList),
      "toLocation": CommonFilterControls.getJsonFromToFilter(
          false, isRangeLocation.value, false, selectedLocationList),
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
      "LocationIDs": CommonFilterControls.getJsonListFilter(
          locationController.value,
          isRangeLocation.value,
          selectedLocationList,
          false),
      "ShowInActive": isinactiveProducts.value,
      "ShowZeroQuantity": iszeroQtyProducts.value
    });
    try {
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api: 'GetProductStockListReport', data: data);
      log("${feedback}");
      if (feedback != null) {
        baseString.value = '';

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
