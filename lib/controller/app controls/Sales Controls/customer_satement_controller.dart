import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/daily_sales_analysis_model.dart';
import 'package:axolon_erp/model/Sales%20Model/get_customer_satatement_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/sales_analysis_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomerStatementController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //enterDatas();
  }

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var isLoadingCustomer = false.obs;
  var isLoadingReport = false.obs;
  var response = 0.obs;
  DateTime date = DateTime.now();
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var locationRadio = 'yes'.obs;
  var isSingleLocation = false.obs;
  var isMultipleLocation = false.obs;
  var isAccountCurrency = true.obs;
  var customers = [].obs;
  var customer = CustomerModel().obs;
  var reportList = [].obs;
  var reportHeader = CustomerStatementHeaderModel().obs;
  late ReportSource reportSource;
  var isButtonOpen = false.obs;
  var isPrintingProgress = false.obs;
  var dateIndex = 0.obs;

  updateAccountCurrency(String value) {
    locationRadio.value = value;
    if (value == 'yes') {
      isAccountCurrency.value = true;
    } else {
      isAccountCurrency.value = false;
    }
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
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

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    // customerId.value = this.customer.value.code ?? '';
  }

  // enterDatas() async {
  //   if (homeController.customerList.isEmpty) {
  //     await homeController.getCustomerList();
  //   }
  //   customer.value = homeController.customerList[0];
  // }

  // selectCustomer(BuildContext context) {
  //   if (customers.isEmpty) {
  //     getLocationList();
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20))),
  //         title: Center(
  //           child: Text(
  //             'Customers',
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               color: AppColors.primary,
  //             ),
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width * 0.8,
  //                 child: Obx(
  //                   () => isLoadingCustomer.value
  //                       ? SalesShimmer.locationPopShimmer()
  //                       : CupertinoScrollbar(
  //                           thumbVisibility: true,
  //                           child: ListView.builder(
  //                             shrinkWrap: true,
  //                             itemCount: customers.length,
  //                             itemBuilder: (context, index) {
  //                               return InkWell(
  //                                 onTap: () {
  //                                   customer.value = customers[index];
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Card(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(8.0),
  //                                     child: AutoSizeText(
  //                                       "${customers[index].code} - ${customers[index].name}",
  //                                       minFontSize: 12,
  //                                       maxFontSize: 16,
  //                                       style: TextStyle(
  //                                         color: AppColors.mutedColor,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(5.0),
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Close',
  //                       style: TextStyle(color: AppColors.primary)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  getLocationList() async {
    isLoadingCustomer.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetCustomerList?token=${token}');
      if (feedback != null) {
        result = AllCustomerModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        customers.value = result.modelobject;
        isLoadingCustomer.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(customers.value[0].name.toString(),
            name: 'Customer Name');
      }
    }
  }

  getCustomerStatement(BuildContext context) async {
    if (isLoadingReport.value == false) {
      isLoadingReport.value = true;
      await loginController.getToken();
      String fromDate = this.fromDate.value.toIso8601String();
      String toDate = this.toDate.value.toIso8601String();
      String customer = this.customer.value.code ?? '';
      bool isAccountCurrency = this.isAccountCurrency.value;
      final String token = loginController.token.value;

      dynamic result;
      try {
        var feedback = await ApiServices.fetchData(
            api:
                'GetCustomerStatement?token=${token}&fromDate=${fromDate}&toDate=${toDate}&customerID=${customer}&isAccountCurrency=${isAccountCurrency}');
        if (feedback != null) {
          result = GetCustomerStatementModel.fromJson(feedback);
          print(result);
          response.value = result.result;
          reportList.value = result.detailModelobject;
          isLoadingReport.value = false;
          reportHeader.value = result.headerModelobject[0];
          reportSource = ReportSource(result.detailModelobject);
        }
      } finally {
        if (response.value == 1 && reportList.value.isNotEmpty) {
          Navigator.pop(context);
          // developer.log(dailyAnalysisSource[0].toString(), name: 'Report Name');
        } else {
          SnackbarServices.errorSnackbar('No Data Found !!');
        }
      }
    }
  }
}

class ReportSource extends DataGridSource {
  ReportSource(List<CustomerStatementDetailModel> analysis) {
    dataGridRows = analysis
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<dynamic>(
                  columnName: 'Date',
                  value: DateFormatter.dateFormat
                      .format(dataGridRow.date ?? DateTime.now())
                      .toString()),
              DataGridCell<dynamic>(
                  columnName: 'Number', value: dataGridRow.docNo),
              DataGridCell<dynamic>(
                  columnName: 'Type', value: dataGridRow.docType),
              DataGridCell<dynamic>(
                  columnName: 'Description',
                  value: dataGridRow.description == null
                      ? ''
                      : dataGridRow.description!.replaceAll('\n', ' ')),
              DataGridCell<dynamic>(
                  columnName: 'Debit', value: dataGridRow.debit),
              DataGridCell<dynamic>(
                  columnName: 'Credit', value: dataGridRow.credit),
              DataGridCell<dynamic>(
                  columnName: 'Balance', value: dataGridRow.balance),
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
              //  dataGridCell.columnName == 'Profit'
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           RotatedBox(
              //             quarterTurns:
              //                 double.parse(dataGridCell.value) >= 0 ? 4 : 2,
              //             child: SvgPicture.asset(
              //               AppIcons.up_arrow,
              //               height: 15,
              //               width: 10,
              //               color: double.parse(dataGridCell.value) >= 0
              //                   ? AppColors.success
              //                   : AppColors.error,
              //             ),
              //           ),
              //           Text(
              //             dataGridCell.value.toString(),
              //             // overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       )
              //     :
              Text(
            dataGridCell.value.toString(),
            // overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
