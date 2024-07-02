import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Inventory%20Controls/item_catalogue_controller.dart';
import 'package:axolon_erp/controller/app%20controls/common_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/Calculations/catalogue_range_selector.dart';
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

import '../../../../services/enums.dart';
import '../../../../utils/constants/asset_paths.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/snackbar.dart';
import '../../../../utils/date_formatter.dart';
import '../../../components/common_filter_controls.dart';
import '../../components/expandedItemsRow.dart';

class ItemCatalogueScreen extends StatefulWidget {
  ItemCatalogueScreen({super.key});

  @override
  State<ItemCatalogueScreen> createState() => _ItemCatalogueScreenState();
}

class _ItemCatalogueScreenState extends State<ItemCatalogueScreen> {
  final itemCatalogueController = Get.put(ItemCatalogueController());
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  final ScrollController _scrollController = ScrollController();
  final homeController = Get.put(HomeController());

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
        title: const Text('Item Catalogue'),
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
      body: Obx(() => itemCatalogueController.reportList.isEmpty
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
                  source: itemCatalogueController.reportSource,
                  columns: [
                    GridColumn(
                      columnName: 'Product ID',
                      label: _buildGridColumnLabel('Product ID'),
                      autoFitPadding: EdgeInsets.zero,
                    ),
                    GridColumn(
                      columnName: 'Name',
                      label: _buildGridColumnLabel('Name'),
                    ),
                    GridColumn(
                      columnName: 'Class Name',
                      label: _buildGridColumnLabel('Class Name'),
                    ),
                    GridColumn(
                      columnName: 'Unit',
                      label: _buildGridColumnLabel('Unit'),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: AutoSizeText(
                          //     'Transaction History',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Obx(() => ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      itemCatalogueController.reportList.length,
                                  itemBuilder: (context, index) {
                                    var report = itemCatalogueController
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
            )),
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

  _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
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
                ))),
          ),

          Obx(() => CommonFilterControls.buildProductFilter(context,
              isAccordionOpen: itemCatalogueController.productAccordion.value,
              onToggle: (value) {
                itemCatalogueController.showProductAccordian();
              },
              productController: itemCatalogueController.productsControl,
              classController: itemCatalogueController.productClassControl,
              categoryController:
                  itemCatalogueController.productCategoryControl,
              brandController: itemCatalogueController.productBrandControl,
              manufacturerController:
                  itemCatalogueController.productManufactureControl,
              originController: itemCatalogueController.ProductOriginControl,
              styleController: itemCatalogueController.ProductStyleControl,

onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.productsControl, filterOptions: FilterComboOptions.Item, 
            selectedList: itemCatalogueController.selectedProductList, 
            isRange: itemCatalogueController.isRangeProducts, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.productClassControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: itemCatalogueController.selectedProductClassList, 
            isRange: itemCatalogueController.isRangeProductClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.productCategoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: itemCatalogueController.selectedProductCategoryList, 
            isRange: itemCatalogueController.isRangeProductCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.productBrandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: itemCatalogueController.selectedProductBrandList, 
            isRange: itemCatalogueController.isRangeProductBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.productManufactureControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: itemCatalogueController.selectedProductManufactureList, 
            isRange: itemCatalogueController.isRangeProductManufacture, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.ProductOriginControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: itemCatalogueController.selectedProductOriginList, 
            isRange: itemCatalogueController.isRangeProductOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemCatalogueController.ProductStyleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: itemCatalogueController.selectedProductStyleList, 
            isRange: itemCatalogueController.isRangeProductStyle, isProduct: false);}

              )),

          // Row(
          //   children: [
          //     Flexible(
          //       child: Obx(() => DropdownButtonFormField2(
          //             isDense: true,
          //             value: CatalogueRangeSelector.catalogueRange[
          //                 itemCatalogueController.catalogueIndex.value],
          //             decoration: InputDecoration(
          //               isCollapsed: true,
          //               contentPadding: const EdgeInsets.symmetric(vertical: 5),
          //               label: Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Text(
          //                   'Catalogues',
          //                   style: TextStyle(
          //                     fontSize: 14,
          //                     color: AppColors.primary,
          //                     fontWeight: FontWeight.w400,
          //                     fontFamily: 'Rubik',
          //                   ),
          //                 ),
          //               ),
          //               // contentPadding: EdgeInsets.zero,
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //             ),
          //             isExpanded: true,
          //             icon: Icon(
          //               Icons.arrow_drop_down,
          //               color: AppColors.primary,
          //             ),
          //             buttonPadding: const EdgeInsets.only(left: 20, right: 10),
          //             dropdownDecoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(15),
          //             ),
          //             items: CatalogueRangeSelector.catalogueRange
          //                 .map(
          //                   (item) => DropdownMenuItem(
          //                     value: item,
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           item.label,
          //                           style: TextStyle(
          //                             fontSize: 14,
          //                             color: AppColors.primary,
          //                             fontWeight: FontWeight.w400,
          //                             fontFamily: 'Rubik',
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 )
          //                 .toList(),
          //             onChanged: (value) {
          //               // selectedSysdocValue = value;
          //               // customerStatementController.selectDateRange(
          //               //     selectedSysdocValue.value,
          //               //     DateRangeSelector.dateRange
          //               //         .indexOf(selectedSysdocValue));
          //             },
          //             onSaved: (value) {},
          //           )),
          //     ),
          //     IconButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         icon: Card(
          //             child: Center(
          //           child: Icon(
          //             Icons.close,
          //             size: 15,
          //             color: AppColors.mutedColor,
          //           ),
          //         )))
          //   ],
          // ),

          SizedBox(
            height: 15,
          ),
          Obx(() => CommonFilterControls.buildToggleTile(
                toggleText: 'Show Inactive Products',
                switchValue: itemCatalogueController.isinactiveProducts.value,
                onToggled: (bool? value) {
                  itemCatalogueController.toggleInactiveProducts();
                },
              )),
               Obx(() => CommonFilterControls.buildToggleTile(
                toggleText: 'Show items with zero quantity',
                switchValue: itemCatalogueController.iszeroQtyProducts.value,
                onToggled: (bool? value) {
                  itemCatalogueController.toggleZeroQtyProducts();
                },
              )),
     
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                itemCatalogueController.getProductCatalogReport(context: context);
              },
              child: Obx(() => itemCatalogueController.isLoadingReport.value
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
    var tst = itemCatalogueController
        .reportList; //itemCatalogueController.getItemsPrint() ;
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
                                    txt: element.productID, isHead: false),
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
                                // color: pdf.PdfColor.fromHex('#885544'),
                                alignment: pw.Alignment.center,
                                // width: pageSize.width * 0.24,
                                child: pw.Column(children: [
                                  // pw.Image(image, width: 70,height: 70 , fit: pw.BoxFit.cover),
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
                  .toList()
              // child: tst
              ));
          return widgets;
          // return tst;
          // return itemCatalogueController.getItemsPrint() ;
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
      itemCatalogueController.isPrintingProgress.value = true;
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
              'Item Catalogue',
              PdfStandardFont(PdfFontFamily.helvetica, 10,
                  style: PdfFontStyle.bold),
              format: PdfStringFormat(alignment: PdfTextAlignment.center),
              bounds: Rect.fromLTWH(width / 3, 0, width / 3, 0),
            );
            // header.graphics.drawString(
            //   '\n From : ${DateFormatter.dateFormat.format(customerStatementController.fromDate.value).toString()} - To : ${DateFormatter.dateFormat.format(customerStatementController.toDate.value).toString()}',
            //   PdfStandardFont(PdfFontFamily.helvetica, 10,
            //       style: PdfFontStyle.regular),
            //   bounds: Rect.fromLTRB(width / 3, 10, width / 3, 0),
            // );

            details.pdfDocumentTemplate.top = header;
          });
      final List<int> bytes = document.saveSync();
      if (shareorsave == "share") {
        await helper.FileSaveHelper.saveAndLaunchFile(
            bytes, 'CustomerStatement.pdf');
      } else if (shareorsave == "save") {
        helper.FileSaveHelper.saveAndShareFile(bytes, 'CustomerStatement.pdf');
      }
      itemCatalogueController.isPrintingProgress.value = false;
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
                      report.productID,
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

            // SizedBox(height: 5),

            Container(
                // decoration: BoxDecoration(
                //                               color: Colors.white,
                //                               borderRadius:
                //                                   BorderRadius.all(
                //                                       Radius.circular(
                //                                           5)),
                //                               boxShadow: [
                //                                 BoxShadow(blurRadius: 0)
                //                               ]),
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
