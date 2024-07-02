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

import '../../../../controller/app controls/Inventory Controls/inventory_aging_controller.dart';
import '../../../../services/enums.dart';
import '../../../../utils/Calculations/date_range_selector.dart';
import '../../../../utils/constants/asset_paths.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/snackbar.dart';
import '../../../../utils/date_formatter.dart';
import '../../../Inventory Screen/components/expandedItemsRow.dart';
import '../../../components/common_filter_controls.dart';
import '../../../components/common_text_field.dart';

class InventoryAgingScreen extends StatefulWidget {
  InventoryAgingScreen({super.key});

  @override
  State<InventoryAgingScreen> createState() =>
      _InventoryAgingScreenState();
}

class _InventoryAgingScreenState extends State<InventoryAgingScreen> {
  final inventoryAgingController = Get.put(InventoryAgingController());
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
              baseString: inventoryAgingController.baseString.value,
              name: "Inventory Aging Summary"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() =>
                inventoryAgingController.baseString.value.isEmpty
                    ? CommonFilterControls.buildEmptyPlaceholder()
                    : GetBuilder<InventoryAgingController>(
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
           Row(
          children: [
            Flexible(
                child: Obx(() => CommonTextField.textfield(
                    suffixicon: true,
                    readonly: true,
                    keyboardtype: TextInputType.text,
                    label: 'As of date',
                    ontap: () {
                      inventoryAgingController.selectDate(context);
                    },
                    controller: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(inventoryAgingController.reportDate.value)
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
       
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: inventoryAgingController.selectedLocationList, 
            isRange: inventoryAgingController.isRangeLocation, isProduct: false);},
              locationController:
                  inventoryAgingController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen:
                inventoryAgingController.productAccordion.value,
            onToggle: (value) {
              inventoryAgingController.showProductAccordian();
            },
            productController: inventoryAgingController.productsControl,
            classController: inventoryAgingController.productClassControl,
            categoryController:
                inventoryAgingController.productCategoryControl,
            brandController: inventoryAgingController.productBrandControl,
            manufacturerController:
                inventoryAgingController.productManufactureControl,
            originController: inventoryAgingController.ProductOriginControl,
            styleController: inventoryAgingController.ProductStyleControl,

 onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.productsControl, filterOptions: FilterComboOptions.Item, 
            selectedList: inventoryAgingController.selectedProductList, 
            isRange: inventoryAgingController.isRangeProducts, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.productClassControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: inventoryAgingController.selectedProductClassList, 
            isRange: inventoryAgingController.isRangeProductClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.productCategoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: inventoryAgingController.selectedProductCategoryList, 
            isRange: inventoryAgingController.isRangeProductCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.productBrandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: inventoryAgingController.selectedProductBrandList, 
            isRange: inventoryAgingController.isRangeProductBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.productManufactureControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: inventoryAgingController.selectedProductManufactureList, 
            isRange: inventoryAgingController.isRangeProductManufacture, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.ProductOriginControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: inventoryAgingController.selectedProductOriginList, 
            isRange: inventoryAgingController.isRangeProductOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: inventoryAgingController.ProductStyleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: inventoryAgingController.selectedProductStyleList, 
            isRange: inventoryAgingController.isRangeProductStyle, isProduct: false);},

            )),
        SizedBox(
          height: 15,
        ), 
         Obx(() => CommonFilterControls.buildToggleTile(
                toggleText: 'Show Inactive Products',
                switchValue: inventoryAgingController.isinactiveProducts.value,
                onToggled: (bool? value) {
                  inventoryAgingController.toggleInactiveProducts();
                },
              )),
              Obx(() => CommonFilterControls.buildToggleTile(
                toggleText: 'Show items with zero quantity',
                switchValue: inventoryAgingController.iszeroQtyProducts.value,
                onToggled: (bool? value) {
                  inventoryAgingController.toggleZeroQtyProducts();
                },
              )),
        SizedBox(
          height: 15,
        ), 
         Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => CommonFilterControls.buildDisplayButton(
              isLoading: inventoryAgingController.isLoadingReport.value,
               onTap: () async {
                await inventoryAgingController
                    .getinventoryAgingReport(context);
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