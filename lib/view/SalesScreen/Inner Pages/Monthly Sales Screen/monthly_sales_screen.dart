import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/monthly_sales_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MonthlySalesScreen extends StatefulWidget {
  const MonthlySalesScreen({super.key});

  @override
  State<MonthlySalesScreen> createState() => _MonthlySalesScreenState();
}

class _MonthlySalesScreenState extends State<MonthlySalesScreen> {
  final monthlySalesController = Get.put(MonthlySalesController());
  final homeController = Get.put(HomeController());

  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, _buildFilter(context));
    });
    super.initState();
  }

  var selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: monthlySalesController.baseString.value,
              name: 'Monthly Sales'))),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(() => monthlySalesController.baseString.value.isEmpty
                  ? CommonFilterControls.buildEmptyPlaceholder()
                  : GetBuilder<MonthlySalesController>(builder: (controller) {
                      return CommonFilterControls.buildPdfView(
                          controller.bytes.value);
                    })),
            ),
          ]),
      // body: Obx(() => monthlySalesController.pdfBytes.value.isEmpty
      //     ? Container(
      //         child: Center(
      //           child: Text('No data'),
      //         ),
      //       )
      //     : PDFView(
      //         filePath: "",
      //         pdfData: monthlySalesController.pdfBytes.value,
      //       )),
      floatingActionButton: CommonFilterControls.buildFilterButton(context,
          filter: _buildFilter(context)),
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
                .dateRange[monthlySalesController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              monthlySalesController.selectDateRange(selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(monthlySalesController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(monthlySalesController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              monthlySalesController.selectDate(context, true);
            },
            onTapTo: () {
              monthlySalesController.selectDate(context, false);
            },
            isFromEnable: monthlySalesController.isFromDate.value,
            isToEnable: monthlySalesController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // Obx(() => CommonFilterControls.buildLocationCombo(
        //       context,
        //       groupValue: monthlySalesController.locationRadio.value,
        //       onChanged: (value) {
        //         monthlySalesController.updateLocationRadio(value.toString());
        //       },
        //       isMultiple: monthlySalesController.isMultipleLocation.value,
        //       isSingle: monthlySalesController.isSingleLocation.value,
        //       fromController: TextEditingController(
        //         text: monthlySalesController.fromLocation.value.name ?? ' ',
        //       ),
        //       toController: TextEditingController(
        //         text: monthlySalesController.toLocation.value.name ?? ' ',
        //       ),
        //       singleController: TextEditingController(
        //         text: monthlySalesController.singleLocation.value.name ?? ' ',
        //       ),
        //       onTapFrom: () {
        //         monthlySalesController.selectLocation('from', context);
        //       },
        //       onTapTo: () {
        //         monthlySalesController.selectLocation('to', context);
        //       },
        //       onTapSingle: () {
        //         monthlySalesController.selectLocation('single', context);
        //       },
        //     )),
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: monthlySalesController.selectedLocationList, 
            isRange: monthlySalesController.isRangeLocation, isProduct: false);},
              locationController:
                  monthlySalesController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen: monthlySalesController.productAccordion.value,
            onToggle: (value) {
              monthlySalesController.showProductAccordian();
            },
            productController: monthlySalesController.productsControl,
            classController: monthlySalesController.productClassControl,
            categoryController: monthlySalesController.productCategoryControl,
            brandController: monthlySalesController.productBrandControl,
            manufacturerController:
                monthlySalesController.productManufactureControl,
            originController: monthlySalesController.ProductOriginControl,
            styleController: monthlySalesController.ProductStyleControl,

onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.productsControl, filterOptions: FilterComboOptions.Item, 
            selectedList: monthlySalesController.selectedProductList, 
            isRange: monthlySalesController.isRangeProducts, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.productClassControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: monthlySalesController.selectedProductClassList, 
            isRange: monthlySalesController.isRangeProductClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.productCategoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: monthlySalesController.selectedProductCategoryList, 
            isRange: monthlySalesController.isRangeProductCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.productBrandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: monthlySalesController.selectedProductBrandList, 
            isRange: monthlySalesController.isRangeProductBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.productManufactureControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: monthlySalesController.selectedProductManufactureList, 
            isRange: monthlySalesController.isRangeProductManufacture, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.ProductOriginControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: monthlySalesController.selectedProductOriginList, 
            isRange: monthlySalesController.isRangeProductOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.ProductStyleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: monthlySalesController.selectedProductStyleList, 
            isRange: monthlySalesController.isRangeProductStyle, isProduct: false);}

           )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildSalesPersonrFilter(context,
            isAccordionOpen: monthlySalesController.salePersonAccordion.value,
            onToggle: (value) {
              monthlySalesController.showsalePersonAccordian();
            },
            salespersonController: monthlySalesController.salesPersonControl,
            divisionController: monthlySalesController.salesDivisionControl,
            groupController: monthlySalesController.salesGroupControl,
            areaController: monthlySalesController.salesAreaControl,
            countryController: monthlySalesController.salesCountryControl,

onTapSalesperson: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.salesPersonControl, filterOptions: FilterComboOptions.SalesPerson, 
            selectedList: monthlySalesController.selectedSalesPersonList, 
            isRange: monthlySalesController.isRangeSalesPerson, isProduct: false);},

onTapDivision: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.salesDivisionControl, filterOptions: FilterComboOptions.SalesPersonDivision, 
            selectedList: monthlySalesController.selectedSalesDivisionList, 
            isRange: monthlySalesController.isRangeSalesDivision, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.salesGroupControl, filterOptions: FilterComboOptions.SalesPersonGroup, 
            selectedList: monthlySalesController.selectedSalesGroupList, 
            isRange: monthlySalesController.isRangeSalesGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.salesAreaControl, filterOptions: FilterComboOptions.Area, 
            selectedList: monthlySalesController.selectedSalesAreaList, 
            isRange: monthlySalesController.isRangeSalesArea, isProduct: false);},

onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: monthlySalesController.salesCountryControl, filterOptions: FilterComboOptions.Country, 
            selectedList: monthlySalesController.selectedSalesCountryList, 
            isRange: monthlySalesController.isRangeSalesCountry, isProduct: false);},

           )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: monthlySalesController.reportTypes,
            selectedValue: monthlySalesController.reportType.value,
            onChanged: (value) {
              monthlySalesController.changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => CommonFilterControls.buildDisplayButton(
              isLoading: monthlySalesController.isLoadingReport.value,
              onTap: () {
                monthlySalesController.getMonthlySalesReport(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
