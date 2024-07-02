import 'dart:convert';
import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/daily_sales_analysis_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';

class DailySalesAnalysisScreen extends StatefulWidget {
  DailySalesAnalysisScreen({super.key});

  @override
  State<DailySalesAnalysisScreen> createState() =>
      _DailySalesAnalysisScreenState();
}

class _DailySalesAnalysisScreenState extends State<DailySalesAnalysisScreen> {
  final dailyAnalysisController = Get.put(DailySalesAnalysisController());
  final homeController = Get.put(HomeController());
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  final ScrollController _scrollController = ScrollController();

  var selectedValue;

  String? gender;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, _buildFilter(context));
      ;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: dailyAnalysisController.baseString.value,
              name: "Daily Sales Analysis"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() => dailyAnalysisController.baseString.value.isEmpty
                ? CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<DailySalesAnalysisController>(
                    builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
          // Obx(
          //   () => dailyAnalysisController.reportList.isEmpty
          //       ? Container()
          //       : Container(
          //           child: Center(
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 10),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   AutoSizeText('Daily Sales Analysis',
          //                       minFontSize: 20,
          //                       maxFontSize: 24,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w500,
          //                           color: Colors.black)),
          //                   SizedBox(
          //                     height: 5,
          //                   ),
          //                   AutoSizeText(
          //                       'From: ${dailyAnalysisController.fromLocation.value.code ?? dailyAnalysisController.singleLocation.value.code}  To: ${dailyAnalysisController.toLocation.value.code ?? dailyAnalysisController.singleLocation.value.code}',
          //                       minFontSize: 10,
          //                       maxFontSize: 15,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w400,
          //                           color: AppColors.mutedColor)),
          //                   SizedBox(
          //                     height: 5,
          //                   ),
          //                   AutoSizeText(
          //                       'From Date: ${DateFormatter.dateFormat.format(dailyAnalysisController.fromDate.value).toString()} To Date: ${DateFormatter.dateFormat.format(dailyAnalysisController.toDate.value).toString()}',
          //                       minFontSize: 10,
          //                       maxFontSize: 15,
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.w400,
          //                           color: AppColors.mutedColor)),
          //                   SizedBox(
          //                     height: 5,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          // ),
          // Expanded(
          //   child: Obx(() {
          //     return dailyAnalysisController.reportList.isEmpty
          //         ? Container(
          //             child: Center(
          //               child: Text('No Data Found'),
          //             ),
          //           )
          //         : CupertinoScrollbar(
          //             controller: _scrollController,
          //             thicknessWhileDragging: 40,
          //             thumbVisibility: true,
          //             child: SfDataGrid(
          //               key: _key,
          //               verticalScrollController: _scrollController,
          //               // horizontalScrollPhysics: NeverScrollableScrollPhysics(),
          //               // verticalScrollPhysics: NeverScrollableScrollPhysics(),
          //               isScrollbarAlwaysShown: false,
          //               gridLinesVisibility: GridLinesVisibility.none,
          //               headerGridLinesVisibility: GridLinesVisibility.none,
          //               allowEditing: true,
          //               columnWidthMode: MediaQuery.of(context).size.width > 450
          //                   ? ColumnWidthMode.fill
          //                   : ColumnWidthMode.none,
          //               headerRowHeight: 30,
          //               editingGestureType: EditingGestureType.doubleTap,
          //               source: dailyAnalysisController.dailyAnalysisSource,
          //               columns: [
          //                 GridColumn(
          //                   columnName: 'Date',
          //                   label: _buildGridColumnLabel('Date'),
          //                   autoFitPadding: EdgeInsets.zero,
          //                 ),
          //                 GridColumn(
          //                   columnName: 'GrossSale',
          //                   label: _buildGridColumnLabel('Gross Sale'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'Return',
          //                   label: _buildGridColumnLabel('Return'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'Discount',
          //                   label: _buildGridColumnLabel('Disc'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'Tax',
          //                   label: _buildGridColumnLabel('Tax'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'RoundOff',
          //                   label: _buildGridColumnLabel('Misc'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'NetSale',
          //                   label: _buildGridColumnLabel('Net Sale'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'Cost',
          //                   label: _buildGridColumnLabel('Cost'),
          //                 ),
          //                 GridColumn(
          //                   columnName: 'Profit',
          //                   label: _buildGridColumnLabel('Profit'),
          //                 ),
          //               ],
          //             ),
          //           );
          //   }),
          // )
        ],
      ),
      floatingActionButton: CommonFilterControls.buildFilterButton(context,
          filter: _buildFilter(context)),
    );
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
          Obx(
            () => CommonFilterControls.buildDateRageDropdown(
              context,
              dropValue: DateRangeSelector
                  .dateRange[dailyAnalysisController.dateIndex.value],
              onChanged: (value) {
                selectedValue = value;
                dailyAnalysisController.selectDateRange(selectedValue.value,
                    DateRangeSelector.dateRange.indexOf(selectedValue));
              },
              fromController: TextEditingController(
                text: DateFormatter.dateFormat
                    .format(dailyAnalysisController.fromDate.value)
                    .toString(),
              ),
              toController: TextEditingController(
                text: DateFormatter.dateFormat
                    .format(dailyAnalysisController.toDate.value)
                    .toString(),
              ),
              onTapFrom: () {
                dailyAnalysisController.selectDate(context, true);
              },
              onTapTo: () {
                dailyAnalysisController.selectDate(context, false);
              },
              isFromEnable: dailyAnalysisController.isFromDate.value,
              isToEnable: dailyAnalysisController.isToDate.value,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(() => CommonFilterControls.buildLocationFilter(
                context,
                onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: dailyAnalysisController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: dailyAnalysisController.selectedLocationList, 
            isRange: dailyAnalysisController.isRangeLocation, isProduct: false);},
                locationController:
                    dailyAnalysisController.locationController.value,
              )),
          SizedBox(
            height: 15,
          ),
          // Obx(() => CommonFilterControls.buildLocationCombo(
          //       context,
          //       groupValue: dailyAnalysisController.locationRadio.value,
          //       onChanged: (value) {
          //         dailyAnalysisController.updateLocationRadio(value.toString());
          //       },
          //       isMultiple: dailyAnalysisController.isMultipleLocation.value,
          //       isSingle: dailyAnalysisController.isSingleLocation.value,
          //       fromController: TextEditingController(text:dailyAnalysisController.fromLocation.value.name ?? ' ',),
          //       toController: TextEditingController(text: dailyAnalysisController.toLocation.value.name ?? ' ',),
          //       singleController: TextEditingController(text: dailyAnalysisController.singleLocation.value.name ?? ' ',),
          //       onTapFrom: () {
          //           dailyAnalysisController.selectLocation('from', context);
          //         },
          //         onTapTo: () {
          //           dailyAnalysisController.selectLocation('to', context);
          //         },
          //         onTapSingle: () {
          //     dailyAnalysisController.selectLocation('single', context);
          //   },
          //     )),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                dailyAnalysisController.getDailyAnalysis(context);
              },
              child: Obx(() => dailyAnalysisController.isLoadingReport.value
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
    // if (_key.currentState != null) {
    dailyAnalysisController.isPrintingProgress.value = true;
    //   final ByteData data =
    //       await rootBundle.load('assets/images/axolon_logo.png');
    //   final PdfDocument document = _key.currentState!.exportToPdfDocument(
    //       fitAllColumnsInOnePage: true,
    //       cellExport: (DataGridCellPdfExportDetails details) {
    //         if (details.cellType == DataGridExportCellType.columnHeader) {
    //           details.pdfCell.style = PdfGridCellStyle(
    //               borders: PdfBorders(
    //                   top: PdfPen(PdfColor(0, 0, 0), width: 0.5),
    //                   right: PdfPen(PdfColor(0, 0, 0), width: 0.5),
    //                   left: PdfPen(PdfColor(0, 0, 0), width: 0.5),
    //                   bottom: PdfPen(PdfColor(0, 0, 0), width: 2)),
    //               font: PdfStandardFont(PdfFontFamily.helvetica, 10,
    //                   style: PdfFontStyle.bold),
    //               format: PdfStringFormat(
    //                 alignment: PdfTextAlignment.center,
    //                 lineAlignment: PdfVerticalAlignment.middle,
    //               ));
    //         } else if (details.cellType == DataGridExportCellType.row &&
    //             details.columnName == 'Date') {
    //           details.pdfCell.style = PdfGridCellStyle(
    //               borders: PdfBorders(
    //                   top: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   right: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   left: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   bottom: PdfPen(PdfColor(255, 255, 255), width: 0.5)),
    //               format: PdfStringFormat(alignment: PdfTextAlignment.left));
    //         } else {
    //           details.pdfCell.style = PdfGridCellStyle(
    //               borders: PdfBorders(
    //                   top: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   right: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   left: PdfPen(PdfColor(255, 255, 255), width: 0.5),
    //                   bottom: PdfPen(PdfColor(255, 255, 255), width: 0.5)),
    //               format: PdfStringFormat(alignment: PdfTextAlignment.right));
    //         }
    //       },
    //       headerFooterExport: (DataGridPdfHeaderFooterExportDetails details) {
    //         final double width = details.pdfPage.getClientSize().width;
    //         final PdfPageTemplateElement header =
    //             PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));

    //         // header.graphics.drawImage(
    //         //     PdfBitmap(data.buffer
    //         //         .asUint8List(data.offsetInBytes, data.lengthInBytes)),
    //         //     Rect.fromLTWH(width - 148, 0, 148, 60));

    //         header.graphics.drawString(
    //           'Daily Sales Analysis',
    //           PdfStandardFont(PdfFontFamily.helvetica, 10,
    //               style: PdfFontStyle.bold),
    //           format: PdfStringFormat(alignment: PdfTextAlignment.center),
    //           bounds: Rect.fromLTWH(width / 3, 0, width / 3, 0),
    //         );
    //         header.graphics.drawString(
    //           '\n From : ${DateFormatter.dateFormat.format(dailyAnalysisController.fromDate.value).toString()} - To : ${DateFormatter.dateFormat.format(dailyAnalysisController.toDate.value).toString()}',
    //           PdfStandardFont(PdfFontFamily.helvetica, 10,
    //               style: PdfFontStyle.regular),
    //           bounds: Rect.fromLTRB(width / 3, 10, width / 3, 0),
    //         );

    //         details.pdfDocumentTemplate.top = header;
    //       });
    //   final List<int> bytes = document.saveSync();
    //   if (shareorsave == "share") {
    //     await helper.FileSaveHelper.saveAndLaunchFile(
    //         bytes, 'DailySalesAnalysis.pdf');
    //   } else if (shareorsave == "save") {
    //     helper.FileSaveHelper.saveAndShareFile(bytes, 'DailySalesAnalysis.pdf');
    //   }
    //   dailyAnalysisController.isPrintingProgress.value = false;
    //   document.dispose();
    // } else {
    //   SnackbarServices.errorSnackbar('Please Add Details !');
    // }
    dailyAnalysisController.isPrintingProgress.value = true;
    final List<int> bytes =
        base64.decode(dailyAnalysisController.baseString.value);
    if (shareorsave == "share") {
      await helper.FileSaveHelper.saveAndLaunchFile(
          bytes, 'DailySalesAnalysis.pdf');
    } else if (shareorsave == "save") {
      helper.FileSaveHelper.saveAndShareFile(bytes, 'DailySalesAnalysis.pdf');
    }
    dailyAnalysisController.isPrintingProgress.value = false;
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
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }
}
