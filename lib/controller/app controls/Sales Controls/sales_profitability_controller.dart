import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:axolon_erp/model/Inventory%20Model/all_product_catalog_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:developer' as developer;
import '../../../model/Sales Model/get_customer_satatement_model.dart';
import '../../../model/location_list_model.dart';
import '../../../services/Api Services/api_services.dart';
import '../../../utils/Calculations/date_range_selector.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/snackbar.dart';
import '../../../utils/date_formatter.dart';
import '../../../view/components/common_filter_controls.dart';
import '../../Api Controls/login_token_controller.dart';
import '../home_controller.dart';

class SalesProfitabilityController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var response = 0.obs;
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;

  // Customers start
 TextEditingController customersControl = TextEditingController();
  TextEditingController classControl = TextEditingController();
  TextEditingController groupControl = TextEditingController();
  TextEditingController areaControl = TextEditingController();
  TextEditingController countryControl = TextEditingController();

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
  
// Customers end

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

// Sales Person start
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
  
// Sales Person end

  //for report start
var isLoadingReport = false.obs;
var isPrintingProgress = false.obs;
var reportList = [].obs;
late ReportSource reportSource;
  //for report end
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

//---------report type start -------------//

List<String> reportTypes = ['Summary', 'Detail', 'Items'];

  late var reportType = reportTypes[0].obs;

  changeReportType(String type) {
    reportType.value = type.toString();
  }
  //---------report type end -------------//

  //---------products start -------------//
  var productAccordion = false.obs;

  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  //---------products end -------------//


  //---------Salesperson start -------------//

   var salePersonAccordion = false.obs;

  showsalePersonAccordian() {
    salePersonAccordion.value = !salePersonAccordion.value;
  }

  //---------Salesperson end -------------//

  //---------Customer accordian start -------------//

   var customerAccordion = false.obs;

  showCustomerAccordian() {
    customerAccordion.value = !customerAccordion.value;
  }

  //---------Customer accordian end -------------//

  getSalesProfitReport(BuildContext context) async {
    isLoadingReport.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String fromDate = this.fromDate.value.toIso8601String();
    String toDate = this.toDate.value.toIso8601String();
    baseString.value = '';
    final data = jsonEncode(
      {
      "PrintResultData": {
    "FileName": reportType.value == reportTypes[0] ? "SalesProfitabilitySummary"
              : reportType.value == reportTypes[1] ? "SalesProfitability" 
              : "SalesProfitabilityItemWise",
    "SysDocType": 0,
    "FileType": 1
  },
      "token": "$token",
      "IsSummary": reportType.value == reportTypes[0] ? true : false,
      "IsDetail": reportType.value == reportTypes[1] ? true : false,
      "IsItemWise": reportType.value == reportTypes[2] ? true : false,
      "FromDate": "$fromDate",
      "ToDate": "$toDate",
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
      "fromCustomer": CommonFilterControls.getJsonFromToFilter(true, isRangeCustomers.value, false, selectedCustomerList),
      "toCustomer": CommonFilterControls.getJsonFromToFilter(false, isRangeCustomers.value, false, selectedCustomerList),
      "fromCustomerClass": CommonFilterControls.getJsonFromToFilter(true, isRangeClass.value, false, selectedClassList),
      "toCustomerClass": CommonFilterControls.getJsonFromToFilter(false, isRangeClass.value, false, selectedClassList),
      "fromCustomerGroup": CommonFilterControls.getJsonFromToFilter(true, isRangeGroup.value, false, selectedGroupList),
      "toCustomerGroup": CommonFilterControls.getJsonFromToFilter(false, isRangeGroup.value, false, selectedGroupList),
      "fromCustomerArea": CommonFilterControls.getJsonFromToFilter(true, isRangeArea.value, false, selectedAreaList),
      "toCustomerArea": CommonFilterControls.getJsonFromToFilter(false, isRangeArea.value, false, selectedAreaList),
      "fromCustomerCountry": CommonFilterControls.getJsonFromToFilter(true, isRangeCountry.value, false, selectedCountryList),
      "toCustomerCountry": CommonFilterControls.getJsonFromToFilter(false, isRangeCountry.value, false, selectedCountryList),
      "fromSalesperson": CommonFilterControls.getJsonFromToFilter(true, isRangeSalesPerson.value, false, selectedSalesPersonList),
      "toSalesperson": CommonFilterControls.getJsonFromToFilter(false, isRangeSalesPerson.value, false, selectedSalesPersonList),
      "fromSalespersonDivision": CommonFilterControls.getJsonFromToFilter(true, isRangeSalesDivision.value, false, selectedSalesDivisionList),
      "toSalespersonDivision": CommonFilterControls.getJsonFromToFilter(false, isRangeSalesDivision.value, false, selectedSalesDivisionList),
      "fromSalespersonGroup": CommonFilterControls.getJsonFromToFilter(true, isRangeSalesGroup.value, false, selectedSalesGroupList),
      "toSalespersonGroup": CommonFilterControls.getJsonFromToFilter(false, isRangeSalesGroup.value, false, selectedSalesGroupList),
      "fromSalespersonArea": CommonFilterControls.getJsonFromToFilter(true, isRangeSalesArea.value, false, selectedSalesAreaList),
      "toSalespersonArea": CommonFilterControls.getJsonFromToFilter(false, isRangeSalesArea.value, false, selectedSalesAreaList),
      "fromSalespersonCountry": CommonFilterControls.getJsonFromToFilter(true, isRangeSalesCountry.value, false, selectedSalesCountryList),
      "toSalespersonCountry": CommonFilterControls.getJsonFromToFilter(false, isRangeSalesCountry.value, false, selectedSalesCountryList),
      
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
      "SalespersonIDs": 
      CommonFilterControls.getJsonListFilter(salesPersonControl, isRangeSalesPerson.value, selectedSalesPersonList, false),
      "DivisionIDs": 
      CommonFilterControls.getJsonListFilter(salesDivisionControl, isRangeSalesDivision.value, selectedSalesDivisionList, false),
      "SalespersonGroupIDs": 
      CommonFilterControls.getJsonListFilter(salesGroupControl, isRangeSalesGroup.value, selectedSalesGroupList, false),
      "AreaIDs": 
      CommonFilterControls.getJsonListFilter(salesAreaControl, isRangeSalesArea.value, selectedSalesAreaList, false),
      "CountryIDs": 
      CommonFilterControls.getJsonListFilter(salesCountryControl, isRangeSalesCountry.value, selectedSalesCountryList, false),
      "CustomerIDs": 
      CommonFilterControls.getJsonListFilter(customersControl, isRangeCustomers.value, selectedCustomerList, false),
      "CustomerClassIDs": 
      CommonFilterControls.getJsonListFilter(classControl, isRangeClass.value, selectedClassList, false),
      "CustomerGroupIDs": 
      CommonFilterControls.getJsonListFilter(groupControl, isRangeGroup.value, selectedGroupList, false),
      "CustomerAreaIDs": 
      CommonFilterControls.getJsonListFilter(areaControl, isRangeArea.value, selectedAreaList, false),
      "CustomerCountryIDs": 
      CommonFilterControls.getJsonListFilter(countryControl, isRangeCountry.value, selectedCountryList, false),

    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'GetSalesProfitabilityReport', data: data);
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

   
// String getJsonFilter(String bodyText, String fromBodyText, String toBodyText,

//  TextEditingController txtController ,bool isRange, var filterList, bool isProduct)
// {
//   String TT = (txtController.text == CommonFilterControls.allSelectedText
//           ? "''" : (!isRange
//               ? filterList.isEmpty
//                   ? "''"
//                   : "\"'${filterList.map((element) => isProduct? element.productId.toString() : element.code.toString()).join("','")}'\""
//               : "''") );//+",";
//   String T =  "${bodyText}:"+ txtController.text == CommonFilterControls.allSelectedText
//           ? ''
//           : !isRange
//               ? filterList.isEmpty
//                   ? ""
//                   : "'${filterList.map((element) => isProduct? element.productId.toString() : element.code.toString()).join("','")}'"
//               : "" +
//           "${fromBodyText}:"+
//           "${isRange ? isProduct? filterList[0].productId : filterList[0].code : ""}"
//       "${toBodyText}:"+
//           "${isRange? isProduct? filterList[filterList.length - 1].productId : filterList[filterList.length - 1].code : ""}";
//   print(T);
//   return TT;
// }

}



class ReportSource extends DataGridSource {
  ReportSource(List<ProductCatalogModel> analysis) {
    dataGridRows = analysis
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<dynamic>(
                  columnName: 'Product ID',
                  value: dataGridRow.productID),
              DataGridCell<dynamic>(
                  columnName: 'Name',
                  value: dataGridRow.description == null
                      ? ''
                      : dataGridRow.description!.replaceAll('\n', ' ')),
              DataGridCell<dynamic>(
                  columnName: 'Class Name',  value: dataGridRow.className == null
                      ? ''
                      : dataGridRow.className!.replaceAll('\n', ' ')),
                       DataGridCell<dynamic>(
                  columnName: 'Unit',  value: dataGridRow.unitID == null
                      ? ''
                      : dataGridRow.unitID!.replaceAll('\n', ' ')),
            ],
          ),
        )
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 20,
          width: 100,
          alignment: dataGridCell.columnName == 'Date'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child:
              Text(
            dataGridCell.value.toString(),
          ),
        );
      }).toList(),
    );
  }


}
