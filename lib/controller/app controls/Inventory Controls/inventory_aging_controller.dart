import 'dart:convert';
import 'dart:typed_data';

import 'package:axolon_erp/model/Inventory%20Model/all_product_catalog_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:developer' as developer;
import '../../../services/Api Services/api_services.dart';
import '../../../utils/Calculations/date_range_selector.dart';
import '../../../utils/constants/snackbar.dart';
import '../../../view/components/common_filter_controls.dart';
import '../../Api Controls/login_token_controller.dart';
import '../home_controller.dart';

class InventoryAgingController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
    var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;

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

// Products start
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
  
// Products end

  //for report start
var isLoadingReport = false.obs;
var isPrintingProgress = false.obs;
var reportList = [].obs;
  //for report end
//---------date start -------------//
  DateTime date = DateTime.now();
  var reportDate = DateTime.now().obs;
  selectDate(context) async {
    DateTime? newDate =
        await CommonFilterControls.getCalender(context, reportDate.value);
    if (newDate != null) {
      reportDate.value = newDate ;
    }
    update();
  }
// date end

//---------location start -------------//
var selectedLocationList = [].obs;
   var isRangeLocation = false.obs;
   var locationController = TextEditingController().obs;

  //---------location end -------------//

//---------reports start -------------//
var reportRadio = 'summary'.obs;
 updateReportRadio(String value) {
    reportRadio.value = value;
  }

  //---------reports end -------------//

  //---------products start -------------//
  var productAccordion = false.obs;

  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  //---------products end -------------//

getinventoryAgingReport(BuildContext context) async {
    isLoadingReport.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String reportDate = this.reportDate.value.toIso8601String();
    baseString.value = '';
    final data = jsonEncode(
      {
      "PrintResultData": {
    "FileName": "Inventory Aging Summary",
    "SysDocType": 0,
    "FileType": 1
  },
      "token": "$token",
      "AsOfDate": "$reportDate",
      "fromLocation": CommonFilterControls.getJsonFromToFilter(true, isRangeLocation.value, false, selectedLocationList),
      "toLocation": CommonFilterControls.getJsonFromToFilter(false, isRangeLocation.value, false, selectedLocationList),
      "fromItem": CommonFilterControls.getJsonFromToFilter(true, isRangeProducts.value, true, selectedProductList),
      "toItem": CommonFilterControls.getJsonFromToFilter(false, isRangeProducts.value, true, selectedProductList),
      "fromClass": CommonFilterControls.getJsonFromToFilter(true, isRangeProductClass.value, false, selectedProductClassList),
      "toClass": CommonFilterControls.getJsonFromToFilter(false, isRangeProductClass.value, false, selectedProductClassList),
      "fromCategory": CommonFilterControls.getJsonFromToFilter(true, isRangeProductCategory.value, false, selectedProductCategoryList),
      "toCategory": CommonFilterControls.getJsonFromToFilter(false, isRangeProductCategory.value, false, selectedProductCategoryList),
      "fromBrand": CommonFilterControls.getJsonFromToFilter(true, isRangeProductBrand.value, false, selectedProductBrandList),
      "toBrand": CommonFilterControls.getJsonFromToFilter(false, isRangeProductBrand.value, false, selectedProductBrandList),
      "fromManufacturer": CommonFilterControls.getJsonFromToFilter(true, isRangeProductManufacture.value, false, selectedProductManufactureList),
      "toManufacturer": CommonFilterControls.getJsonFromToFilter(false, isRangeProductManufacture.value, false, selectedProductManufactureList),
      "fromStyle": CommonFilterControls.getJsonFromToFilter(true, isRangeProductStyle.value, false, selectedProductStyleList),
      "toStyle": CommonFilterControls.getJsonFromToFilter(false, isRangeProductStyle.value, false, selectedProductStyleList),
      "fromOrigin": CommonFilterControls.getJsonFromToFilter(true, isRangeProductOrigin.value, false, selectedProductOriginList),
      "toOrigin": CommonFilterControls.getJsonFromToFilter(false, isRangeProductOrigin.value, false, selectedProductOriginList),
     
      "LocationIDs": 
      CommonFilterControls.getJsonListFilter(locationController.value, isRangeLocation.value, selectedLocationList, false),
      "ItemIDs": 
      CommonFilterControls.getJsonListFilter(productsControl, isRangeProducts.value, selectedProductList, true),
      "ItemClassIDs": 
      CommonFilterControls.getJsonListFilter(productClassControl, isRangeProductClass.value, selectedProductClassList, false),
      "ItemCategoryIDs": 
      CommonFilterControls.getJsonListFilter(productCategoryControl, isRangeProductCategory.value, selectedProductCategoryList, false),
      "BrandIDs": 
      CommonFilterControls.getJsonListFilter(productBrandControl, isRangeProductBrand.value, selectedProductBrandList, false),
      "ManufactureIDs": 
      CommonFilterControls.getJsonListFilter(productManufactureControl, isRangeProductManufacture.value, selectedProductManufactureList, false),
      "OriginIDs": 
      CommonFilterControls.getJsonListFilter(ProductOriginControl, isRangeProductOrigin.value, selectedProductOriginList, false),
      "StyleIDs": 
      CommonFilterControls.getJsonListFilter(ProductStyleControl, isRangeProductStyle.value, selectedProductStyleList, false),
      
        "ShowInActive": isinactiveProducts.value,
  "ShowZeroQuantity": iszeroQtyProducts.value,
    });
    try {
      print(data);
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api: 'GetInventoryAgingSummaryReport', data: data);
          print(feedback);
      if (feedback != null) {
        
        // if (feedback['result'] == 0) {
        //   isLoadingReport.value = false;
        // }
        

        // response.value = feedback['result'];

        // log("${feedback}");

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
