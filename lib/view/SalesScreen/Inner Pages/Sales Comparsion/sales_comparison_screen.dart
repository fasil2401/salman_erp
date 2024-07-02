import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_comparison_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SalesComparisonScreen extends StatefulWidget {
  const SalesComparisonScreen({super.key});

  @override
  State<SalesComparisonScreen> createState() => _SalesComparisonScreenState();
}

class _SalesComparisonScreenState extends State<SalesComparisonScreen> {
  final homeController = Get.put(HomeController());
  final salesComparisonController = Get.put(SalesComparisonController());
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
              baseString: salesComparisonController.baseString.value,
              name: "Sales Comparison"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() => salesComparisonController.baseString.value.isEmpty
                ? CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<SalesComparisonController>(builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
        ],
      ),
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
                .dateRange[salesComparisonController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              salesComparisonController.selectDateRange(selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesComparisonController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesComparisonController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              salesComparisonController.selectDate(context, true);
            },
            onTapTo: () {
              salesComparisonController.selectDate(context, false);
            },
            isFromEnable: salesComparisonController.isFromDate.value,
            isToEnable: salesComparisonController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildSalesPersonrFilter(context,
            isAccordionOpen:
                salesComparisonController.salePersonAccordion.value,
            onToggle: (value) {
              salesComparisonController.showsalePersonAccordian();
            },
            salespersonController:
                salesComparisonController.salesPersonController,
            divisionController: salesComparisonController.divisionController,
            groupController: salesComparisonController.groupController,
            areaController: salesComparisonController.areaController,
            countryController: salesComparisonController.countryController,

onTapSalesperson: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesComparisonController.salesPersonController, filterOptions: FilterComboOptions.SalesPerson, 
            selectedList: salesComparisonController.selectedSalesPersonList, 
            isRange: salesComparisonController.isRangeSalesPerson, isProduct: false);},

onTapDivision: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesComparisonController.divisionController, filterOptions: FilterComboOptions.SalesPersonDivision, 
            selectedList: salesComparisonController.selectedSalesDivisionList, 
            isRange: salesComparisonController.isRangeSalesDivision, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesComparisonController.groupController, filterOptions: FilterComboOptions.SalesPersonGroup, 
            selectedList: salesComparisonController.selectedSalesGroupList, 
            isRange: salesComparisonController.isRangeSalesGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesComparisonController.areaController, filterOptions: FilterComboOptions.Area, 
            selectedList: salesComparisonController.selectedSalesAreaList, 
            isRange: salesComparisonController.isRangeSalesArea, isProduct: false);},

onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesComparisonController.countryController, filterOptions: FilterComboOptions.Country, 
            selectedList: salesComparisonController.selectedSalesCountryList, 
            isRange: salesComparisonController.isRangeSalesCountry, isProduct: false);},

           )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: salesComparisonController.reportTypes,
            selectedValue: salesComparisonController.reportType.value,
            onChanged: (value) {
              salesComparisonController.changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: salesComparisonController.isLoadingReport.value,
                onTap: () async {
                  await salesComparisonController
                      .getSalesComparisonReport(context);
                },
              ),
            )),
      ],
    );
  }
}
