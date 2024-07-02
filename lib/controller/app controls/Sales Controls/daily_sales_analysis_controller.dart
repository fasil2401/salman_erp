import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/daily_sales_analysis_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/sales_analysis_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;

class DailySalesAnalysisController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var isLoading = false.obs;
  var isLoadingLocations = false.obs;
  var isLoadingReport = false.obs;
  var response = 0.obs;
  DateTime date = DateTime.now();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var locationRadio = 'all'.obs;
  var isSingleLocation = false.obs;
  var isMultipleLocation = false.obs;
  var fromLocation = LocationSingleModel().obs;
  var toLocation = LocationSingleModel().obs;
  var singleLocation = LocationSingleModel().obs;
  var reportList = [].obs;
  late DailyAnalysisSource dailyAnalysisSource;
  var isButtonOpen = false.obs;
  var isPrintingProgress = false.obs;
  var dateIndex = 0.obs;
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;
  //-----------------------location--------------------------//
  var selectedLocationList = [].obs;
  var isRangeLocation = false.obs;
  var locationController = TextEditingController().obs;

  //----------------------------------------------------------------//
  updateLocationRadio(String value) {
    locationRadio.value = value;
    if (value == 'single') {
      isSingleLocation.value = true;
      isMultipleLocation.value = false;
      fromLocation.value = LocationSingleModel();
      toLocation.value = LocationSingleModel();
    } else if (value == 'range') {
      isSingleLocation.value = false;
      isMultipleLocation.value = true;
      singleLocation.value = LocationSingleModel();
    } else {
      isSingleLocation.value = false;
      isMultipleLocation.value = false;
      fromLocation.value = LocationSingleModel();
      toLocation.value = LocationSingleModel();
      singleLocation.value = LocationSingleModel();
    }
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

  selectLocation(String value, BuildContext context) async {
    if (value == 'from') {
      fromLocation.value = await homeController.selectLocatio(context: context);
    } else if (value == 'to') {
      toLocation.value = await homeController.selectLocatio(context: context);
    } else {
      singleLocation.value =
          await homeController.selectLocatio(context: context);
    }
  }

  getDailyAnalysis(BuildContext context) async {
    if (isLoadingReport.value == false) {
      isLoadingReport.value = true;
      await loginController.getToken();
      String fromDate = this.fromDate.value.toIso8601String();
      String toDate = this.toDate.value.toIso8601String();
      final String token = loginController.token.value;
      String toLocation = '';
      String fromLocation = '';
      if (isRangeLocation.value == true && selectedLocationList.isNotEmpty) {
        toLocation =
            '${selectedLocationList[selectedLocationList.length - 1].code}';
        fromLocation = '${selectedLocationList[0].code}';
      }

      // if (isSingleLocation.value) {
      //   toLocation = singleLocation.value.code ?? '';
      //   fromLocation = singleLocation.value.code ?? '';
      // } else if (isMultipleLocation.value) {
      //   toLocation = this.toLocation.value.code ?? '';
      //   fromLocation = this.fromLocation.value.code ?? '';
      // }
      baseString.value = '';
      var data = jsonEncode(
          {"FileName": "Daily Sales Analysis", "SysDocType": 0, "FileType": 1});
      var result;
      try {
        var feedback = await ApiServices.fetchDataRawBody(
            api: isRangeLocation.value == true
                ? 'GetDailySalesAnalysis?token=${token}&fromDate=${fromDate}&toDate=${toDate}&locationFrom=${fromLocation}&locationTo=${toLocation}'
                : locationController.value.text ==
                        CommonFilterControls.allSelectedText || selectedLocationList.isEmpty
                    ? 'GetDailySalesAnalysis?token=${token}&fromDate=${fromDate}&toDate=${toDate}'
                    : "GetDailySalesAnalysis?token=${token}&fromDate=${fromDate}&toDate=${toDate}&LocationIDs='${selectedLocationList.map((element) => element.code.toString()).join("','")}'",
            data: data);
        if (feedback != null) {
          baseString.value = '';
          // developer.log("${feedback}");
          isLoadingReport.value = false;
          if (feedback['Modelobject'] != null) {
            baseString.value = feedback['Modelobject'];
            bytes.value = base64.decode(feedback['Modelobject']);
            update();
          }
          // List<int> bytes = base64.decode(feedback['Modelobject']);
          // await helper.FileSaveHelper.saveAndLaunchFile(
          //     bytes, 'Daily Sales Analysis.pdf');
          // result = DailySalesAnalysisModel.fromJson(feedback);
          // response.value = result.result;
          // reportList.value = result.modelobject;
          // isLoadingReport.value = false;
          // if (reportList.isNotEmpty) {
          //   dailyAnalysisSource = DailyAnalysisSource(result.modelobject);
          // }
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
}

class DailyAnalysisSource extends DataGridSource {
  DailyAnalysisSource(List<AnalysisModel> analysis) {
    dataGridRows = analysis
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<dynamic>(
                  columnName: 'Date',
                  value: DateFormatter.dateFormat
                      .format(dataGridRow.date)
                      .toString()),
              DataGridCell<dynamic>(
                columnName: 'GrossSale',
                value: SalesAnalysisCalculations.getGrossSale(
                        cashSale: dataGridRow.cashSale,
                        creditSale: dataGridRow.creditSale,
                        cashSaleTax: dataGridRow.cashSaleTax,
                        creditSaleTax: dataGridRow.creditSaleTax)
                    .toStringAsFixed(2),
              ),
              DataGridCell<dynamic>(
                columnName: 'Return',
                value: SalesAnalysisCalculations.getReturn(
                        salesReturn: dataGridRow.salesReturn,
                        taxReturn: dataGridRow.taxReturn,
                        discountReturn: dataGridRow.discountReturn,
                        roundOffReturn: dataGridRow.roundOffReturn)
                    .toStringAsFixed(2),
              ),
              DataGridCell<dynamic>(
                  columnName: 'Discount', value: dataGridRow.discount),
              DataGridCell<dynamic>(columnName: 'Tax', value: dataGridRow.tax),
              DataGridCell<dynamic>(
                  columnName: 'RoundOff', value: dataGridRow.roundOff),
              DataGridCell<dynamic>(
                columnName: 'NetSale',
                value: SalesAnalysisCalculations.getNetSale(
                        grossSale: SalesAnalysisCalculations.getGrossSale(
                            cashSale: dataGridRow.cashSale,
                            creditSale: dataGridRow.creditSale,
                            cashSaleTax: dataGridRow.cashSaleTax,
                            creditSaleTax: dataGridRow.creditSaleTax),
                        returnAmount: SalesAnalysisCalculations.getReturn(
                            salesReturn: dataGridRow.salesReturn,
                            taxReturn: dataGridRow.taxReturn,
                            discountReturn: dataGridRow.discountReturn,
                            roundOffReturn: dataGridRow.roundOffReturn),
                        tax: dataGridRow.tax)
                    .toStringAsFixed(2),
              ),
              DataGridCell<dynamic>(
                  columnName: 'Cost',
                  value: dataGridRow.cost == null
                      ? 0.00.toStringAsFixed(2)
                      : dataGridRow.cost.toStringAsFixed(2)),
              DataGridCell<dynamic>(
                columnName: 'Profit',
                value: SalesAnalysisCalculations.getNetProfit(
                        netSale: SalesAnalysisCalculations.getNetSale(
                            grossSale: SalesAnalysisCalculations.getGrossSale(
                                cashSale: dataGridRow.cashSale,
                                creditSale: dataGridRow.creditSale,
                                cashSaleTax: dataGridRow.cashSaleTax,
                                creditSaleTax: dataGridRow.creditSaleTax),
                            returnAmount: SalesAnalysisCalculations.getReturn(
                                salesReturn: dataGridRow.salesReturn,
                                taxReturn: dataGridRow.taxReturn,
                                discountReturn: dataGridRow.discountReturn,
                                roundOffReturn: dataGridRow.roundOffReturn),
                            tax: dataGridRow.tax),
                        cost: dataGridRow.cost)
                    .toStringAsFixed(2),
              ),
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
          alignment: dataGridCell.columnName == 'Date'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: dataGridCell.columnName == 'Profit'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RotatedBox(
                      quarterTurns:
                          double.parse(dataGridCell.value) >= 0 ? 4 : 2,
                      child: SvgPicture.asset(
                        AppIcons.up_arrow,
                        height: 15,
                        width: 10,
                        color: double.parse(dataGridCell.value) >= 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    AutoSizeText(
                      dataGridCell.value.toString(),
                      minFontSize: 8,
                      maxFontSize: 12,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : AutoSizeText(
                  dataGridCell.value.toString(),
                  minFontSize: 8,
                  maxFontSize: 12,
                  // overflow: TextOverflow.ellipsis,
                ),
        );
      }).toList(),
    );
  }
}
