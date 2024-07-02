import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_purchase_analysis_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesPurchaseAnalysisScreen extends StatefulWidget {
  const SalesPurchaseAnalysisScreen({super.key});

  @override
  State<SalesPurchaseAnalysisScreen> createState() =>
      _SalesPurchaseAnalysisScreenState();
}

class _SalesPurchaseAnalysisScreenState
    extends State<SalesPurchaseAnalysisScreen> {
  final salesPurchaseAnalysisController =
      Get.put(SalesPurchaseAnalysisController());
  var selectedValue;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, buildFilter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: salesPurchaseAnalysisController.baseString.value,
              name: "Sales Purchase Analysis"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() => salesPurchaseAnalysisController.baseString.value.isEmpty
                ? CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<SalesPurchaseAnalysisController>(
                    builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
        ],
      ),
        floatingActionButton: CommonFilterControls.buildFilterButton(context,
            filter: buildFilter(context)));
  }

  buildFilter(BuildContext context) {
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
                .dateRange[salesPurchaseAnalysisController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              salesPurchaseAnalysisController.selectDateRange(
                  selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesPurchaseAnalysisController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesPurchaseAnalysisController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              salesPurchaseAnalysisController.selectDate(context, true);
            },
            onTapTo: () {
              salesPurchaseAnalysisController.selectDate(context, false);
            },
            isFromEnable: salesPurchaseAnalysisController.isFromDate.value,
            isToEnable: salesPurchaseAnalysisController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: salesPurchaseAnalysisController.selectedLocationList, 
            isRange: salesPurchaseAnalysisController.isRangeLocation, isProduct: false);},
              locationController:
                  salesPurchaseAnalysisController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen:
                salesPurchaseAnalysisController.productAccordion.value,
            onToggle: (value) {
              salesPurchaseAnalysisController.showProductAccordian();
            },
            productController: salesPurchaseAnalysisController.productControl,
            classController: salesPurchaseAnalysisController.classControl,
            categoryController: salesPurchaseAnalysisController.categoryControl,
            brandController: salesPurchaseAnalysisController.brandControl,
            manufacturerController:
                salesPurchaseAnalysisController.manufacturerControl,
            originController: salesPurchaseAnalysisController.originControl,
            styleController: salesPurchaseAnalysisController.styleControl,

onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.productControl, filterOptions: FilterComboOptions.Item, 
            selectedList: salesPurchaseAnalysisController.selectedProductList, 
            isRange: salesPurchaseAnalysisController.isRangeProduct, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.classControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: salesPurchaseAnalysisController.selectedclassList, 
            isRange: salesPurchaseAnalysisController.isRangeClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.categoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: salesPurchaseAnalysisController.selectedCategoryList, 
            isRange: salesPurchaseAnalysisController.isRangeCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.brandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: salesPurchaseAnalysisController.selectedBrandList, 
            isRange: salesPurchaseAnalysisController.isRangeBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.manufacturerControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: salesPurchaseAnalysisController.selectedManufacturerList, 
            isRange: salesPurchaseAnalysisController.isRangeManufacturer, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.originControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: salesPurchaseAnalysisController.selectedOriginList, 
            isRange: salesPurchaseAnalysisController.isRangeOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPurchaseAnalysisController.styleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: salesPurchaseAnalysisController.selectedStyleList, 
            isRange: salesPurchaseAnalysisController.isRangeStyle, isProduct: false);}

           )),
        Align(
          alignment: Alignment.center,
          child: Obx(() => SizedBox(
                width: 130,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: AppColors.mutedColor),
                  child: CheckboxListTile(
                    title: Text(
                      'Average',
                      style:
                          TextStyle(fontSize: 16, color: AppColors.mutedColor),
                    ),
                    dense: true,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.white,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: salesPurchaseAnalysisController.isAverage.value,
                    onChanged: (value) {
                      salesPurchaseAnalysisController.changeIsAverage(value!);
                    },
                  ),
                ),
              )),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: salesPurchaseAnalysisController.isLoading.value,
                onTap: () async {
                  await salesPurchaseAnalysisController.getSalesPurchaseAnalysisReport(context);
                },
              ),
            )),
      ],
    );
  }
}
