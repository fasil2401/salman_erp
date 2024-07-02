import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;

import '../../../../controller/app controls/Sales Controls/sales_profitability_controller.dart';
import '../../../../services/enums.dart';
import '../../../../utils/Calculations/date_range_selector.dart';
import '../../../../utils/Calculations/items_range_selector.dart';
import '../../../../utils/Calculations/report_type_selector.dart';
import '../../../../utils/constants/asset_paths.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/snackbar.dart';
import '../../../../utils/date_formatter.dart';
import '../../../Inventory Screen/components/expandedItemsRow.dart';
import '../../../components/common_filter_controls.dart';

class SalesProfitabilityScreen extends StatefulWidget {
  SalesProfitabilityScreen({super.key});

  @override
  State<SalesProfitabilityScreen> createState() =>
      _SalesProfitabilityScreenState();
}

class _SalesProfitabilityScreenState extends State<SalesProfitabilityScreen> {
  final salesProfitabilityController = Get.put(SalesProfitabilityController());
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final ScrollController _scrollController = ScrollController();
  final homeController = Get.put(HomeController());
  var selectedSysdocValue;
  var selectedItemTypeValue;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, _buildFilter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: salesProfitabilityController.baseString.value,
              name: "Sales Profitability"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() =>
                salesProfitabilityController.baseString.value.isEmpty
                    ? CommonFilterControls.buildEmptyPlaceholder()
                    : GetBuilder<SalesProfitabilityController>(
                        builder: (controller) {
                        return CommonFilterControls.buildPdfView(
                            controller.bytes.value);
                      })),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          CommonFilterControls.buildBottomSheet(context, _buildFilter(context));
        },
        child: SvgPicture.asset(AppIcons.filter,
            color: Colors.white, height: 20, width: 20),
      ),
    );
  }

  _buildFilter(BuildContext context) {
    return Column(
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
                .dateRange[salesProfitabilityController.dateIndex.value],
            onChanged: (value) {
              selectedSysdocValue = value;
              salesProfitabilityController.selectDateRange(
                  selectedSysdocValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedSysdocValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesProfitabilityController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesProfitabilityController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              salesProfitabilityController.selectDate(context, true);
            },
            onTapTo: () {
              salesProfitabilityController.selectDate(context, false);
            },
            isFromEnable: salesProfitabilityController.isFromDate.value,
            isToEnable: salesProfitabilityController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // Obx(() => CommonFilterControls.buildLocationCombo(
        //       context,
        //       groupValue: salesProfitabilityController.locationRadio.value,
        //       onChanged: (value) {
        //         salesProfitabilityController
        //             .updateLocationRadio(value.toString());
        //       },
        //       isMultiple: salesProfitabilityController.isMultipleLocation.value,
        //       isSingle: salesProfitabilityController.isSingleLocation.value,
        //       fromController: TextEditingController(
        //         text:
        //             salesProfitabilityController.fromLocation.value.name ?? ' ',
        //       ),
        //       toController: TextEditingController(
        //         text: salesProfitabilityController.toLocation.value.name ?? ' ',
        //       ),
        //       singleController: TextEditingController(
        //         text: salesProfitabilityController.singleLocation.value.name ??
        //             ' ',
        //       ),
        //       onTapFrom: () {
        //         salesProfitabilityController.selectLocation('from', context);
        //       },
        //       onTapTo: () {
        //         salesProfitabilityController.selectLocation('to', context);
        //       },
        //       onTapSingle: () {
        //         salesProfitabilityController.selectLocation('single', context);
        //       },
        //     )),

        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: salesProfitabilityController.selectedLocationList, 
            isRange: salesProfitabilityController.isRangeLocation, isProduct: false);},
              locationController:
                  salesProfitabilityController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: salesProfitabilityController.reportTypes,
            selectedValue: salesProfitabilityController.reportType.value,
            onChanged: (value) {
              salesProfitabilityController.changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen:
                salesProfitabilityController.productAccordion.value,
            onToggle: (value) {
              salesProfitabilityController.showProductAccordian();
            },
            productController: salesProfitabilityController.productsControl,
            classController: salesProfitabilityController.productClassControl,
            categoryController:
                salesProfitabilityController.productCategoryControl,
            brandController: salesProfitabilityController.productBrandControl,
            manufacturerController:
                salesProfitabilityController.productManufactureControl,
            originController: salesProfitabilityController.ProductOriginControl,
            styleController: salesProfitabilityController.ProductStyleControl,

            onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.productsControl, filterOptions: FilterComboOptions.Item, 
            selectedList: salesProfitabilityController.selectedProductList, 
            isRange: salesProfitabilityController.isRangeProducts, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.productClassControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: salesProfitabilityController.selectedProductClassList, 
            isRange: salesProfitabilityController.isRangeProductClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.productCategoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: salesProfitabilityController.selectedProductCategoryList, 
            isRange: salesProfitabilityController.isRangeProductCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.productBrandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: salesProfitabilityController.selectedProductBrandList, 
            isRange: salesProfitabilityController.isRangeProductBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.productManufactureControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: salesProfitabilityController.selectedProductManufactureList, 
            isRange: salesProfitabilityController.isRangeProductManufacture, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.ProductOriginControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: salesProfitabilityController.selectedProductOriginList, 
            isRange: salesProfitabilityController.isRangeProductOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.ProductStyleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: salesProfitabilityController.selectedProductStyleList, 
            isRange: salesProfitabilityController.isRangeProductStyle, isProduct: false);},)),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildSalesPersonrFilter(context,
            isAccordionOpen:
                salesProfitabilityController.salePersonAccordion.value,
            onToggle: (value) {
              salesProfitabilityController.showsalePersonAccordian();
            },
            salespersonController:
                salesProfitabilityController.salesPersonControl,
            divisionController:
                salesProfitabilityController.salesDivisionControl,
            groupController: salesProfitabilityController.salesGroupControl,
            areaController: salesProfitabilityController.salesAreaControl,
            countryController: salesProfitabilityController.salesCountryControl,

onTapSalesperson: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.salesPersonControl, filterOptions: FilterComboOptions.SalesPerson, 
            selectedList: salesProfitabilityController.selectedSalesPersonList, 
            isRange: salesProfitabilityController.isRangeSalesPerson, isProduct: false);},

onTapDivision: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.salesDivisionControl, filterOptions: FilterComboOptions.SalesPersonDivision, 
            selectedList: salesProfitabilityController.selectedSalesDivisionList, 
            isRange: salesProfitabilityController.isRangeSalesDivision, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.salesGroupControl, filterOptions: FilterComboOptions.SalesPersonGroup, 
            selectedList: salesProfitabilityController.selectedSalesGroupList, 
            isRange: salesProfitabilityController.isRangeSalesGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.salesAreaControl, filterOptions: FilterComboOptions.Area, 
            selectedList: salesProfitabilityController.selectedSalesAreaList, 
            isRange: salesProfitabilityController.isRangeSalesArea, isProduct: false);},

onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.salesCountryControl, filterOptions: FilterComboOptions.Country, 
            selectedList: salesProfitabilityController.selectedSalesCountryList, 
            isRange: salesProfitabilityController.isRangeSalesCountry, isProduct: false);},
)),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildCustomerFilter(context,
            isAccordionOpen:
                salesProfitabilityController.customerAccordion.value,
            onToggle: (value) {
              salesProfitabilityController.showCustomerAccordian();
            },
            customerController: salesProfitabilityController.customersControl,
            classController: salesProfitabilityController.classControl,
            groupController: salesProfitabilityController.groupControl,
            areaController: salesProfitabilityController.areaControl,
            countryController: salesProfitabilityController.countryControl,

onTapCustomer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.customersControl, filterOptions: FilterComboOptions.Customer, 
            selectedList: salesProfitabilityController.selectedCustomerList, 
            isRange: salesProfitabilityController.isRangeCustomers, isProduct: false);},

onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.classControl, filterOptions: FilterComboOptions.Class, 
            selectedList: salesProfitabilityController.selectedClassList, 
            isRange: salesProfitabilityController.isRangeClass, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.groupControl, filterOptions: FilterComboOptions.Group, 
            selectedList: salesProfitabilityController.selectedGroupList, 
            isRange: salesProfitabilityController.isRangeGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.areaControl, filterOptions: FilterComboOptions.Area, 
            selectedList: salesProfitabilityController.selectedAreaList, 
            isRange: salesProfitabilityController.isRangeArea, isProduct: false);},

          onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesProfitabilityController.countryControl, filterOptions: FilterComboOptions.Country, 
            selectedList: salesProfitabilityController.selectedCountryList, 
            isRange: salesProfitabilityController.isRangeCountry, isProduct: false);},)),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => CommonFilterControls.buildDisplayButton(
              isLoading: salesProfitabilityController.isLoadingReport.value,
              onTap: () async {
                await salesProfitabilityController
                    .getSalesProfitReport(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  void handleClickOnAppBar(int item) {
    switch (item) {
      case 0:
        // exportDataGridToPdf("share");
        makePdf("save");
        break;
      case 1:
        // exportDataGridToPdf("save");
        makePdf("share");
        break;
    }
  }

  Future<void> makePdf(String rprtType) async {
    // final imagee = await imageFromAssetBundle(Images.finger_print);
    final image = await imageFromAssetBundle(Images.axolon_logo);
    final pdfPrint = pw.Document();
    final pageSize = pdf.PdfPageFormat
        .a4; //(10 * pdf.PdfPageFormat.cm, 10 * pdf.PdfPageFormat.cm);
    var tst = salesProfitabilityController
        .reportList; //salesProfitabilityController.getItemsPrint() ;
    print(tst);
    pdfPrint.addPage(pw.MultiPage(
        pageFormat: pageSize,
        build: (pw.Context context) {
          print('Inside builder');
          List<pw.Widget> widgets = [];
          widgets.add(pw.ListView(
              children: tst
                  .map((element) => pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      margin: pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
                      padding: pw.EdgeInsets.all(4),
                      child:
                          pw.Row(mainAxisSize: pw.MainAxisSize.max, children: [
                        pw.Expanded(
                            flex: 7,
                            child: pw.Container(
                                // color: pdf.PdfColor.fromHex('#054624'),
                                // width: pageSize.width * 0.74,
                                child: pw.Column(children: [
                              pw.Row(children: [
                                pdfPrintText(txt: 'Item Code:', isHead: true),
                                pdfPrintText(
                                    txt: element.productId, isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Description:', isHead: true),
                                pdfPrintText(
                                    txt: element.description, isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Class:', isHead: true),
                                pdfPrintText(
                                    txt: element.className != null
                                        ? element.className.toString()
                                        : '',
                                    isHead: false),
                                pdfPrintText(txt: 'Category:', isHead: true),
                                pdfPrintText(
                                    txt: element.categoryName != null
                                        ? element.categoryName.toString()
                                        : '',
                                    isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Origin:', isHead: true),
                                pdfPrintText(
                                    txt: element.origin != null
                                        ? element.origin.toString()
                                        : '',
                                    isHead: false),
                                pdfPrintText(txt: 'Brand:', isHead: true),
                                pdfPrintText(
                                    txt: element.brandName != null
                                        ? element.brandName.toString()
                                        : '',
                                    isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Unit:', isHead: true),
                                pdfPrintText(
                                    txt: element.unitID != null
                                        ? element.unitID
                                        : '',
                                    isHead: false),
                                pdfPrintText(
                                    txt: 'Qty Per Unit:', isHead: true),
                                pdfPrintText(
                                    txt: element.quantityPerUnit != null
                                        ? element.quantityPerUnit.toString()
                                        : '',
                                    isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Size:', isHead: true),
                                pdfPrintText(
                                    txt: element.size != null
                                        ? element.size
                                        : '',
                                    isHead: false),
                                pdfPrintText(txt: 'Attribute:', isHead: true),
                                pdfPrintText(
                                    txt: element.attribute != null
                                        ? element.attribute
                                        : '',
                                    isHead: false),
                              ]),
                              pw.Row(children: [
                                pdfPrintText(txt: 'Style:', isHead: true),
                                pdfPrintText(
                                    txt: element.styleID != null
                                        ? element.styleID.toString()
                                        : '',
                                    isHead: false),
                                pdfPrintText(txt: 'Weight:', isHead: true),
                                pdfPrintText(
                                    txt: element.weight != null
                                        ? element.weight.toString()
                                        : '',
                                    isHead: false),
                              ]),
                            ]))),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Column(children: [
                                  element.photo != null
                                      ? pw.Image(
                                          pw.MemoryImage(Base64Codec()
                                              .decode(element.photo)),
                                          width: 70,
                                          height: 70,
                                          fit: pw.BoxFit.cover)
                                      : pw.Text('')
                                ]))),
                      ])))
                  .toList()));
          return widgets;
        }));

    if (rprtType == "share") {
      final List<int> bytes = await pdfPrint.save();
      await helper.FileSaveHelper.saveAndShareFile(
          bytes, 'CustomerStatement.pdf');
    } else {
      await Printing.layoutPdf(
          onLayout: (pdf.PdfPageFormat format) async => pdfPrint.save());
    }
  }

  pw.SizedBox pdfPrintText({required String txt, required bool isHead}) {
    return pw.SizedBox(
        width: isHead ? 60 : 120,
        child: pw.Text(txt,
            textAlign: pw.TextAlign.left,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: isHead ? pw.FontWeight.bold : pw.FontWeight.normal,
            )));
  }

  Future<void> exportDataGridToPdf(String shareorsave) async {
    if (_key.currentState != null) {
      salesProfitabilityController.isPrintingProgress.value = true;
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
            header.graphics.drawString(
              'Sales Profitability',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.bold),
              format: PdfStringFormat(alignment: PdfTextAlignment.center),
              bounds: Rect.fromLTWH(width / 3, 0, width / 3, 0),
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
      salesProfitabilityController.isPrintingProgress.value = false;
      document.dispose();
    } else {
      SnackbarServices.errorSnackbar('Please Add Details !');
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

  Card _buildListTile(report) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      if (report.photo != null && report.photo != '') {
                        print(report.photo);
                        Get.defaultDialog(
                          title: report.description,
                          titleStyle: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          titlePadding: EdgeInsets.all(10),
                          content: LimitedBox(
                            maxHeight: 0.5 * height,
                            child: Image.memory(
                              Base64Codec().decode(report.photo),
                              scale: 1,
                              fit: BoxFit.contain,
                              width: 0.7 * width,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      }
                    },
                    child: report.photo != null && report.photo != ''
                        ? Image.memory(base64Decode(report.photo))
                        : Image.asset(Images.placeholder),
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      report.productId,
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
                      report.description,
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
                    report.className != null ? report.className : '',
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
                    report.unitID != null ? report.unitID : '',
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
            Container(
                child: Column(
              children: [
                expandedItemsRow(
                    text1: 'Origin/Style',
                    text2: 'Category',
                    text3: 'Brand',
                    txtStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    topSpace: 8),
                expandedItemsRow(
                    text1:
                        '${report.origin != null && report.origin != '' ? report.origin : ' - '}/${report.styleName != null && report.styleName != '' ? report.styleName : ' - '}',
                    text2:
                        '${report.categoryName != null && report.categoryName != '' ? report.categoryName : ' - '}',
                    text3:
                        '${report.brandName != null && report.brandName != '' ? report.brandName : ' - '}',
                    txtStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    topSpace: 1),
                expandedItemsRow(
                    text1: 'Size/Weight',
                    text2: 'Qty per unit',
                    text3: 'Attribute',
                    txtStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    topSpace: 8),
                expandedItemsRow(
                    text1:
                        '${report.size != null && report.size != '' ? report.size : ' - '}/${report.weight != null && report.weight != '' ? report.weight : ' - '}',
                    text2:
                        '${report.quantityPerUnit != null && report.quantityPerUnit != '' ? report.quantityPerUnit : ' - '}',
                    text3:
                        '${report.attribute != null && report.attribute != '' ? report.attribute : ' - '}',
                    txtStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    topSpace: 1),
              ],
            )),
          ],
        ),
      ),
    );
  }

  TextField _buildTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller,
      required Function() onChange}) {
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
          isDate ? Icons.calendar_month : null,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
      onChanged: onChange(),
    );
  }
}
