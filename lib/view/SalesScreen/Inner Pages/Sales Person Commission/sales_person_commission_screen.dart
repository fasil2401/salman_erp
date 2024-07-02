import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_person_commision_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SalesPersonCommissionScreen extends StatefulWidget {
  const SalesPersonCommissionScreen({super.key});

  @override
  State<SalesPersonCommissionScreen> createState() =>
      _SalesPersonCommissionScreenState();
}

class _SalesPersonCommissionScreenState
    extends State<SalesPersonCommissionScreen> {
  final homeController = Get.put(HomeController());
  final salesPersonCommissionController =
      Get.put(SalesPersonCommissionController());

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, filter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: salesPersonCommissionController.baseString.value,
              name: "Sales Person Commission"))),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(() =>
                  salesPersonCommissionController.baseString.value.isEmpty
                      ? CommonFilterControls.buildEmptyPlaceholder()
                      : GetBuilder<SalesPersonCommissionController>(
                          builder: (controller) {
                          return CommonFilterControls.buildPdfView(
                              controller.bytes.value);
                        })),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          CommonFilterControls.buildBottomSheet(context, filter(context));
        },
        child: SvgPicture.asset(AppIcons.filter,
            color: Colors.white, height: 20, width: 20),
      ),
    );
  }

  filter(BuildContext context) {
    var selectedValue;
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
                .dateRange[salesPersonCommissionController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              salesPersonCommissionController.selectDateRange(
                  selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesPersonCommissionController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesPersonCommissionController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              salesPersonCommissionController.selectDate(context, true);
            },
            onTapTo: () {
              salesPersonCommissionController.selectDate(context, false);
            },
            isFromEnable: salesPersonCommissionController.isFromDate.value,
            isToEnable: salesPersonCommissionController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: salesPersonCommissionController.selectedLocationList, 
            isRange: salesPersonCommissionController.isRangeLocation, isProduct: false);},
              locationController:
                  salesPersonCommissionController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildItemBrandFilter(context,

    onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.itemBrandController.value, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: salesPersonCommissionController.selectedItemBrandList, 
            isRange: salesPersonCommissionController.isRangeItemBrand, isProduct: false);},

                
                brandController:
                    salesPersonCommissionController.itemBrandController.value)),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildItemCategoryFilter(context,
         onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.itemCategoryController.value, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: salesPersonCommissionController.selectedItemCategoryList, 
            isRange: salesPersonCommissionController.isRangeItemCategory, isProduct: false);},

          
                categoryController: salesPersonCommissionController
                    .itemCategoryController.value)),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildSalesPersonrFilter(context,
            isAccordionOpen:
                salesPersonCommissionController.salePersonAccordion.value,
            onToggle: (value) {
              salesPersonCommissionController.showsalePersonAccordian();
            },
            salespersonController:
                salesPersonCommissionController.salesPersonController,
            divisionController:
                salesPersonCommissionController.divisionController,
            groupController: salesPersonCommissionController.groupController,
            areaController: salesPersonCommissionController.areaController,
            countryController:
                salesPersonCommissionController.countryController,

onTapSalesperson: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.salesPersonController, filterOptions: FilterComboOptions.SalesPerson, 
            selectedList: salesPersonCommissionController.selectedSalesPersonList, 
            isRange: salesPersonCommissionController.isRangeSalesPerson, isProduct: false);},

onTapDivision: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.divisionController, filterOptions: FilterComboOptions.SalesPersonDivision, 
            selectedList: salesPersonCommissionController.selectedSalesDivisionList, 
            isRange: salesPersonCommissionController.isRangeSalesDivision, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.groupController, filterOptions: FilterComboOptions.SalesPersonGroup, 
            selectedList: salesPersonCommissionController.selectedSalesGroupList, 
            isRange: salesPersonCommissionController.isRangeSalesGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.areaController, filterOptions: FilterComboOptions.Area, 
            selectedList: salesPersonCommissionController.selectedSalesAreaList, 
            isRange: salesPersonCommissionController.isRangeSalesArea, isProduct: false);},

onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesPersonCommissionController.countryController, filterOptions: FilterComboOptions.Country, 
            selectedList: salesPersonCommissionController.selectedSalesCountryList, 
            isRange: salesPersonCommissionController.isRangeSalesCountry, isProduct: false);},

         
        )),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 9.w,
          child: CommonTextField.textfield(
              suffixicon: false,
              readonly: false,
              keyboardtype: TextInputType.number,
              controller: salesPersonCommissionController.commissionController,
              label: "Commission",
              onchanged: (p0) {},
              ontap: () {}),
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: salesPersonCommissionController.reportTypes,
            selectedValue: salesPersonCommissionController.reportType.value,
            onChanged: (value) {
              salesPersonCommissionController
                  .changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: salesPersonCommissionController.isLoading.value,
                onTap: () {
                  salesPersonCommissionController
                      .getSalesPersonCommisionReport(context);
                },
              ),
            )),
      ],
    );
  }
}
