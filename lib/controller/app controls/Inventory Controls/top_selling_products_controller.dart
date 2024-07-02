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

class TopSellingProductsController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
  var topQty = 10.0.obs;

  //for report start
  var isLoadingReport = false.obs;
  var isPrintingProgress = false.obs;
  var reportList = [].obs;
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
  selectDate(context, bool isFrom) async {
    DateTime? newDate =
        await CommonFilterControls.getCalender(context, fromDate.value);
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

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

//---------date end -------------//

//---------location start -------------//
  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //---------location end -------------//

//---------report type start -------------//

  List<String> reportTypes = ['Sales Value', 'Sales Quantity', 'Sales Profit'];

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

  getTopProductsReport(BuildContext context) async {
    isLoadingReport.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String fromDate = this.fromDate.value.toIso8601String();
    String toDate = this.toDate.value.toIso8601String();
    baseString.value = '';
    var mode = reportType == reportTypes[0]
        ? 'Amount'
        : reportType == reportTypes[1]
            ? 'Quantity'
            : 'Profit';
    final data = jsonEncode(
      {
        "FileName": reportType.value == reportTypes[0]
            ? "Product Top List By Sales Value"
            : reportType.value == reportTypes[1]
                ? "Product Top List By Sales Qty"
                : "Product Top List By Profit",
        "SysDocType": 0,
        "FileType": 1
      },
    );
    try {
      print(data);
      var locationIDs = CommonFilterControls.getJsonListFilter(
          locationController.value,
          isRangeLocation.value,
          selectedLocationList,
          false);
      developer.log(
          'GetProductTopList?token=${token}&Top=${topQty.value.toInt()}&Mode=${mode}&DateFrom=${fromDate}&DateTo=${toDate}');
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api: 'GetProductTopList?token=${token}&Top=${topQty.value.toInt()}&Mode=${mode}&DateFrom=${fromDate}&DateTo=${toDate}' +
              (isRangeLocation.value
                  ? '&FromLocation=${CommonFilterControls.getJsonFromToFilter(true, isRangeLocation.value, false, selectedLocationList)}&ToLocation=${CommonFilterControls.getJsonFromToFilter(false, isRangeLocation.value, false, selectedLocationList)}'
                  : locationIDs != ''
                      ? '&LocationIDs=${locationIDs}'
                      : ''),
          data: data);
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
