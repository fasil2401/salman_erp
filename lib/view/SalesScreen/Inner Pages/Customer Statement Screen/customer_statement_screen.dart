import 'dart:core';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/customer_satement_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';

class CustomerStatementScreen extends StatefulWidget {
  CustomerStatementScreen({super.key});

  @override
  State<CustomerStatementScreen> createState() =>
      _CustomerStatementScreenState();
}

class _CustomerStatementScreenState extends State<CustomerStatementScreen> {
  final customerStatementController = Get.put(CustomerStatementController());
  final salesScreenController = Get.put(SalesController());
  final homecontroller = Get.put(HomeController());

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  final ScrollController _scrollController = ScrollController();

  var selectedSysdocValue;

  String? gender;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          context: context,
          builder: (context) => _buildFilter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Statement'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => handleClickOnAppBar(item),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(0),
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                padding: const EdgeInsets.all(0),
                height: 30,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.print_outlined,
                        size: 20,
                        color: AppColors.mutedColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Print to PDF'),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                padding: const EdgeInsets.all(0),
                height: 30,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.share,
                        size: 20,
                        color: AppColors.mutedColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Share'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(
        () => customerStatementController.reportList.isEmpty
            ? Center(
                child: Text('No Data Found'),
              )
            : Stack(
                children: [
                  SfDataGrid(
                    key: _key,
                    verticalScrollController: _scrollController,
                    // horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                    // verticalScrollPhysics: NeverScrollableScrollPhysics(),
                    isScrollbarAlwaysShown: false,
                    gridLinesVisibility: GridLinesVisibility.none,
                    headerGridLinesVisibility: GridLinesVisibility.none,
                    allowEditing: true,
                    columnWidthMode: MediaQuery.of(context).size.width > 450
                        ? ColumnWidthMode.fill
                        : ColumnWidthMode.none,
                    headerRowHeight: 30,
                    editingGestureType: EditingGestureType.doubleTap,
                    source: customerStatementController.reportSource,
                    columns: [
                      GridColumn(
                        columnName: 'Date',
                        label: _buildGridColumnLabel('Date'),
                        autoFitPadding: EdgeInsets.zero,
                      ),
                      GridColumn(
                        columnName: 'Number',
                        label: _buildGridColumnLabel('Number'),
                      ),
                      GridColumn(
                        columnName: 'Type',
                        label: _buildGridColumnLabel('Type'),
                      ),
                      GridColumn(
                        columnName: 'Description',
                        label: _buildGridColumnLabel('Description'),
                      ),
                      GridColumn(
                        columnName: 'Debit',
                        label: _buildGridColumnLabel('Debit'),
                      ),
                      GridColumn(
                        columnName: 'Credit',
                        label: _buildGridColumnLabel('Credit'),
                      ),
                      GridColumn(
                        columnName: 'Balance',
                        label: _buildGridColumnLabel('Balance'),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: AppColors.white,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mutedColor.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: _buildCusromerCard(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.mutedColor.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                'Transaction History',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(() => ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: customerStatementController
                                        .reportList.length,
                                    itemBuilder: (context, index) {
                                      var report = customerStatementController
                                          .reportList[index];
                                      return _buildListTile(report);
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 10,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              context: context,
              builder: (context) => _buildFilter(context));
        },
        child: SvgPicture.asset(AppIcons.filter,
            color: Colors.white, height: 20, width: 20),
      ),
    );
  }

  Card _buildListTile(report) {
    double? credit = customerStatementController.isAccountCurrency.value
        ? report.credit
        : report.creditFc;
    double? debit = customerStatementController.isAccountCurrency.value
        ? report.debit
        : report.debitFc;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: credit == 0.0
                ? AppColors.success.withOpacity(0.2)
                : AppColors.error.withOpacity(0.2),
            child: SvgPicture.asset(
              credit == 0.0 ? AppIcons.debit : AppIcons.credit,
              height: 20,
              width: 20,
              color: credit == 0.0 ? AppColors.darkGreen : AppColors.darkRed,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  report.docNo,
                  minFontSize: 12,
                  maxFontSize: 16,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                AutoSizeText(
                  DateFormatter.dateFormat.format(report.date).toString(),
                  minFontSize: 10,
                  maxFontSize: 14,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AutoSizeText(
                credit == 0.0
                    ? debit != null
                        ? InventoryCalculations.formatPrice(debit.toDouble())
                        : ''
                    : credit != null
                        ? InventoryCalculations.formatPrice(credit.toDouble())
                        : '',
                minFontSize: 12,
                maxFontSize: 16,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(
                report.balance != null
                    ? '${report.balance.toStringAsFixed(2)}'
                    : '',
                minFontSize: 10,
                maxFontSize: 14,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedColor,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Card _buildCusromerCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.5),
              AppColors.primary,
              // AppColors.primary,
              // AppColors.mutedBlueColor,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  // CircleAvatar(
                  //   radius: 30,
                  //   backgroundColor: Colors.white,
                  //   backgroundImage: AssetImage(
                  //     Images.axolon_logo,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => AutoSizeText(
                            customerStatementController
                                    .reportHeader.value.customerCode ??
                                '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 14,
                            maxFontSize: 18,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(() => AutoSizeText(
                              customerStatementController
                                      .reportHeader.value.customerName ??
                                  '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 12,
                              maxFontSize: 16,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(() => AutoSizeText(
                              'Phone : ${customerStatementController.reportHeader.value.phone1 ?? ''}',
                              minFontSize: 12,
                              maxFontSize: 16,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 45,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Opening Balance',
                            maxLines: 1,
                            minFontSize: 14,
                            maxFontSize: 18,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(() => AutoSizeText(
                                customerStatementController.reportHeader.value
                                            .openingBalance ==
                                        null
                                    ? ''
                                    : InventoryCalculations.formatPrice(
                                        customerStatementController
                                            .reportHeader.value.openingBalance
                                            .toDouble()),
                                minFontSize: 14,
                                maxFontSize: 18,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              )),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      color: AppColors.mutedColor,
                      indent: 5,
                      endIndent: 15,
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Ending Balance',
                            minFontSize: 14,
                            maxFontSize: 18,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(() => AutoSizeText(
                                customerStatementController
                                            .reportHeader.value.endingBalance ==
                                        null
                                    ? ''
                                    : InventoryCalculations.formatPrice(
                                        customerStatementController
                                            .reportHeader.value.endingBalance
                                            .toDouble()),
                                minFontSize: 12,
                                maxFontSize: 16,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              )),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 2,
                      color: AppColors.mutedColor,
                      indent: 5,
                      endIndent: 15,
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Currency',
                            minFontSize: 14,
                            maxFontSize: 18,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Obx(() => AutoSizeText(
                                customerStatementController
                                        .reportHeader.value.currencyId ??
                                    '',
                                minFontSize: 12,
                                maxFontSize: 16,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText _buildHeaderText(String text) {
    return AutoSizeText(text,
        minFontSize: 10,
        maxFontSize: 15,
        style: TextStyle(
            fontWeight: FontWeight.w400, color: AppColors.mutedColor));
  }

  void handleClickOnAppBar(int item) {
    switch (item) {
      case 0:
        exportDataGridToPdf("share");
        break;
      case 1:
        exportDataGridToPdf("save");
        break;
    }
  }

  Container _buildGridColumnLabel(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppColors.mutedColor,
            width: 1,
          ),
          top: BorderSide(
            color: AppColors.mutedColor,
            width: 1,
          ),
          right: BorderSide(
            color: AppColors.mutedColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        // overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Obx(() => DropdownButtonFormField2(
                      isDense: true,
                      value: DateRangeSelector.dateRange[
                          customerStatementController.dateIndex.value],
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Dates',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ),
                        // contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primary,
                      ),
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: DateRangeSelector.dateRange
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Rubik',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedSysdocValue = value;
                        customerStatementController.selectDateRange(
                            selectedSysdocValue.value,
                            DateRangeSelector.dateRange
                                .indexOf(selectedSysdocValue));
                      },
                      onSaved: (value) {},
                    )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Card(
                      child: Center(
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.mutedColor,
                    ),
                  )))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Flexible(
                child: Obx(
                  () => _buildTextFeild(
                    controller: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(customerStatementController.fromDate.value)
                          .toString(),
                    ),
                    label: 'From Date',
                    enabled: customerStatementController.isFromDate.value,
                    isDate: true,
                    onTap: () {
                      customerStatementController.selectDate(context, true);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Obx(
                  () => _buildTextFeild(
                    controller: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(customerStatementController.toDate.value)
                          .toString(),
                    ),
                    label: 'To Date',
                    enabled: customerStatementController.isToDate.value,
                    isDate: true,
                    onTap: () {
                      customerStatementController.selectDate(context, false);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: AutoSizeText(
                  'Is Account Currency',
                  minFontSize: 12,
                  maxLines: 1,
                  maxFontSize: 20,
                  style: TextStyle(
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Flexible(
                child: Obx(() => RadioListTile(
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text("Yes"),
                      value: "yes",
                      groupValue:
                          customerStatementController.locationRadio.value,
                      onChanged: (value) {
                        customerStatementController
                            .updateAccountCurrency(value.toString());
                      },
                    )),
              ),
              Flexible(
                child: Obx(() => RadioListTile(
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text("No"),
                      value: "no",
                      groupValue:
                          customerStatementController.locationRadio.value,
                      onChanged: (value) {
                        customerStatementController
                            .updateAccountCurrency(value.toString());
                      },
                    )),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => _buildTextFeild(
              controller: TextEditingController(
                text: customerStatementController.customer.value.name ?? ' ',
              ),
              label: 'Customer Id',
              enabled: true,
              isDate: false,
              onTap: () async {
                // customerStatementController.selectCustomer(context);
                var customer = await homecontroller.selectCustomer(
                  context: context,
                );
                if (customer.code != null) {
                  log(customer.code.toString());
                  customerStatementController.selectCustomer(customer);
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                customerStatementController.getCustomerStatement(context);
              },
              child: Obx(() => customerStatementController.isLoadingReport.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Display',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> exportDataGridToPdf(String shareorsave) async {
    if (_key.currentState != null) {
      customerStatementController.isPrintingProgress.value = true;
      final ByteData data =
          await rootBundle.load('assets/images/axolon_logo.png');
      final PdfDocument document = _key.currentState!.exportToPdfDocument(
          fitAllColumnsInOnePage: true,
          cellExport: (DataGridCellPdfExportDetails details) {
            if (details.cellType == DataGridExportCellType.columnHeader) {
              details.pdfCell.style = PdfGridCellStyle(
                  borders: PdfBorders(
                      top: PdfPen(PdfColor(0, 0, 0), width: 0.5),
                      right: PdfPen(PdfColor(0, 0, 0), width: 0.5),
                      left: PdfPen(PdfColor(0, 0, 0), width: 0.5),
                      bottom: PdfPen(PdfColor(0, 0, 0), width: 2)),
                  font: PdfStandardFont(PdfFontFamily.helvetica, 10,
                      style: PdfFontStyle.bold),
                  format: PdfStringFormat(
                    alignment: PdfTextAlignment.center,
                    lineAlignment: PdfVerticalAlignment.middle,
                  ));
            } else if (details.cellType == DataGridExportCellType.row &&
                details.columnName == 'Date') {
              details.pdfCell.style = PdfGridCellStyle(
                  borders: PdfBorders(
                      top: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      right: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      left: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      bottom: PdfPen(PdfColor(255, 255, 255), width: 0.5)),
                  format: PdfStringFormat(alignment: PdfTextAlignment.left));
            } else {
              details.pdfCell.style = PdfGridCellStyle(
                  borders: PdfBorders(
                      top: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      right: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      left: PdfPen(PdfColor(255, 255, 255), width: 0.5),
                      bottom: PdfPen(PdfColor(255, 255, 255), width: 0.5)),
                  format: PdfStringFormat(alignment: PdfTextAlignment.right));
            }
          },
          headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
            final double width = details.pdfPage.getClientSize().width;
            final PdfPageTemplateElement header =
                PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

            // header.graphics.drawImage(
            //     PdfBitmap(data.buffer
            //         .asUint8List(data.offsetInBytes, data.lengthInBytes)),
            //     Rect.fromLTWH(width - 148, 0, 148, 60));

            header.graphics.drawString(
              'Customer Statement',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.bold),
              format: PdfStringFormat(alignment: PdfTextAlignment.center),
              bounds: Rect.fromLTWH(width / 3, 0, width / 3, 0),
            );
            header.graphics.drawString(
              '\n From : ${DateFormatter.dateFormat.format(customerStatementController.fromDate.value).toString()} - To : ${DateFormatter.dateFormat.format(customerStatementController.toDate.value).toString()}',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.regular),
              bounds: Rect.fromLTRB(width / 3, 10, width / 3, 0),
            );

            details.pdfDocumentTemplate.top = header;
          });
      final List<int> bytes = document.saveSync();
      if (shareorsave == "share") {
        await helper.FileSaveHelper.saveAndLaunchFile(
            bytes, 'CustomerStatement.pdf');
      } else if (shareorsave == "save") {
        helper.FileSaveHelper.saveAndShareFile(bytes, 'CustomerStatement.pdf');
      }
      customerStatementController.isPrintingProgress.value = false;
      document.dispose();
    } else {
      SnackbarServices.errorSnackbar('Please Add Details !');
    }
  }

  TextField _buildTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.account_circle_outlined,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }
}
