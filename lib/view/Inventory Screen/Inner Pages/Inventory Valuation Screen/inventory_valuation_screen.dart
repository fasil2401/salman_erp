import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
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

import '../../../../controller/app controls/Inventory Controls/inventory_valuation_controller.dart';
import '../../../../services/enums.dart';
import '../../../../utils/Calculations/date_range_selector.dart';
import '../../../../utils/constants/asset_paths.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/snackbar.dart';
import '../../../../utils/date_formatter.dart';
import '../../../Inventory Screen/components/expandedItemsRow.dart';
import '../../../components/common_filter_controls.dart';
import '../../../components/common_text_field.dart';

class InventoryValuationScreen extends StatefulWidget {
  InventoryValuationScreen({super.key});

  @override
  State<InventoryValuationScreen> createState() =>
      _InventoryValuationScreenState();
}

class _InventoryValuationScreenState extends State<InventoryValuationScreen> {
  final inventoryValuationController = Get.put(InventoryValuationController());
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
        // appBar: AppBar(
        //   title: const Text('Inventory Valuation'),
        //   actions: <Widget>[
        //     PopupMenuButton<int>(
        //       onSelected: (item) => handleClickOnAppBar(item),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       padding: const EdgeInsets.all(0),
        //       position: PopupMenuPosition.under,
        //       itemBuilder: (context) => [
        //         PopupMenuItem<int>(
        //           value: 0,
        //           padding: const EdgeInsets.all(0),
        //           height: 30,
        //           child: Row(
        //             children: [
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10),
        //                 child: Icon(
        //                   Icons.print_outlined,
        //                   size: 20,
        //                   color: AppColors.mutedColor,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10),
        //                 child: Text('Print to PDF'),
        //               ),
        //             ],
        //           ),
        //         ),
        //         PopupMenuItem<int>(
        //           value: 1,
        //           padding: const EdgeInsets.all(0),
        //           height: 30,
        //           child: Row(
        //             children: [
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10),
        //                 child: Icon(
        //                   Icons.share,
        //                   size: 20,
        //                   color: AppColors.mutedColor,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10),
        //                 child: Text('Share'),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),

        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Obx(() => CommonFilterControls.reportAppbar(
                baseString: inventoryValuationController.baseString.value,
                name: "Inventory Valuation"))),
        // body: Obx(() => inventoryValuationController.reportList.isEmpty
        //     ? Center(
        //         child: Text('No Data Found'),
        //       )
        //     : Stack(
        //         children: [
        //           SfDataGrid(
        //             key: _key,
        //             verticalScrollController: _scrollController,
        //             isScrollbarAlwaysShown: false,
        //             gridLinesVisibility: GridLinesVisibility.none,
        //             headerGridLinesVisibility: GridLinesVisibility.none,
        //             allowEditing: true,
        //             columnWidthMode: MediaQuery.of(context).size.width > 450
        //                 ? ColumnWidthMode.fill
        //                 : ColumnWidthMode.none,
        //             headerRowHeight: 30,
        //             editingGestureType: EditingGestureType.doubleTap,
        //             source: inventoryValuationController.reportSource,
        //             columns: [
        //               GridColumn(
        //                 columnName: 'Product ID',
        //                 label: _buildGridColumnLabel('Product ID'),
        //                 autoFitPadding: EdgeInsets.zero,
        //               ),
        //               GridColumn(
        //                 columnName: 'Name',
        //                 label: _buildGridColumnLabel('Name'),
        //               ),
        //               GridColumn(
        //                 columnName: 'Class Name',
        //                 label: _buildGridColumnLabel('Class Name'),
        //               ),
        //               GridColumn(
        //                 columnName: 'Unit',
        //                 label: _buildGridColumnLabel('Unit'),
        //               ),
        //             ],
        //           ),
        //           Container(
        //             height: MediaQuery.of(context).size.height,
        //             width: MediaQuery.of(context).size.width,
        //             color: AppColors.white,
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Expanded(
        //                   child: Container(
        //                 padding: const EdgeInsets.only(
        //                     left: 10, right: 10, top: 5, bottom: 0),
        //                 decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   boxShadow: [
        //                     BoxShadow(
        //                       color: AppColors.mutedColor.withOpacity(0.2),
        //                       spreadRadius: 1,
        //                       blurRadius: 1,
        //                       offset: const Offset(
        //                           0, 1), // changes position of shadow
        //                     ),
        //                   ],
        //                   borderRadius: const BorderRadius.only(
        //                     topLeft: Radius.circular(30),
        //                     topRight: Radius.circular(30),
        //                   ),
        //                 ),
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.max,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Expanded(
        //                       child: Obx(() => ListView.separated(
        //                             shrinkWrap: true,
        //                             physics: const BouncingScrollPhysics(),
        //                             itemCount: inventoryValuationController
        //                                 .reportList.length,
        //                             itemBuilder: (context, index) {
        //                               var report = inventoryValuationController
        //                                   .reportList[index];
        //                               return _buildListTile(report);
        //                             },
        //                             separatorBuilder: (context, index) =>
        //                                 SizedBox(
        //                               height: 10,
        //                             ),
        //                           )),
        //                     ),
        //                   ],
        //                 ),
        //               )),
        //             ],
        //           ),
        //         ],
        //       )),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(() =>
                  inventoryValuationController.baseString.value.isEmpty
                      ? CommonFilterControls.buildEmptyPlaceholder()
                      : GetBuilder<InventoryValuationController>(
                          builder: (controller) {
                          return CommonFilterControls.buildPdfView(
                              controller.bytes.value);
                        })),
            ),
          ],
        ),
        floatingActionButton: CommonFilterControls.buildFilterButton(context,
            filter: _buildFilter(context)));
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: AppColors.primary,
    //     onPressed: () {
    //       CommonFilterControls.buildBottomSheet(context, _buildFilter(context));
    //     },
    //     child: SvgPicture.asset(AppIcons.filter,
    //         color: Colors.white, height: 20, width: 20),
    //   ),
    // );
  }

  _buildFilter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
                child: Obx(() => CommonTextField.textfield(
                    suffixicon: true,
                    readonly: true,
                    keyboardtype: TextInputType.text,
                    label: 'As of Date',
                    ontap: () {
                      inventoryValuationController.selectDate(context);
                    },
                    controller: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(inventoryValuationController.reportDate.value)
                          .toString(),
                    ),
                    icon: Icons.calendar_month))),
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
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: inventoryValuationController.reportTypes,
            selectedValue: inventoryValuationController.reportType.value,
            onChanged: (value) {
              inventoryValuationController.changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: inventoryValuationController.selectedLocationList, 
            isRange: inventoryValuationController.isRangeLocation, isProduct: false);},
              locationController:
                  inventoryValuationController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen:
                inventoryValuationController.productAccordion.value,
            onToggle: (value) {
              inventoryValuationController.showProductAccordian();
            },
            productController: inventoryValuationController.productsControl,
            classController: inventoryValuationController.productClassControl,
            categoryController:
                inventoryValuationController.productCategoryControl,
            brandController: inventoryValuationController.productBrandControl,
            manufacturerController:
                inventoryValuationController.productManufactureControl,
            originController: inventoryValuationController.ProductOriginControl,
            styleController: inventoryValuationController.ProductStyleControl,

onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.productsControl, filterOptions: FilterComboOptions.Item, 
            selectedList: inventoryValuationController.selectedProductList, 
            isRange: inventoryValuationController.isRangeProducts, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.productClassControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: inventoryValuationController.selectedProductClassList, 
            isRange: inventoryValuationController.isRangeProductClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.productCategoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: inventoryValuationController.selectedProductCategoryList, 
            isRange: inventoryValuationController.isRangeProductCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.productBrandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: inventoryValuationController.selectedProductBrandList, 
            isRange: inventoryValuationController.isRangeProductBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.productManufactureControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: inventoryValuationController.selectedProductManufactureList, 
            isRange: inventoryValuationController.isRangeProductManufacture, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.ProductOriginControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: inventoryValuationController.selectedProductOriginList, 
            isRange: inventoryValuationController.isRangeProductOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryValuationController.ProductStyleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: inventoryValuationController.selectedProductStyleList, 
            isRange: inventoryValuationController.isRangeProductStyle, isProduct: false);})),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildToggleTile(
              toggleText: 'Show items with zero quantity',
              switchValue: inventoryValuationController.iszeroQtyProducts.value,
              onToggled: (bool? value) {
                inventoryValuationController.toggleZeroQtyProducts();
              },
            )),
        Obx(() => CommonFilterControls.buildToggleTile(
              toggleText: 'Show Inactive Products',
              switchValue:
                  inventoryValuationController.isinactiveProducts.value,
              onToggled: (bool? value) {
                inventoryValuationController.toggleInactiveProducts();
              },
            )),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => CommonFilterControls.buildDisplayButton(
              isLoading: inventoryValuationController.isLoadingReport.value,
              onTap: () {
                inventoryValuationController
                    .getInventoryValuationReport(context);
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

  Future<void> makePdf(String rprtType) async {}

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

  Future<void> exportDataGridToPdf(String shareorsave) async {}

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
}
