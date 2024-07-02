import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_by_customers_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesByCustomersScreen extends StatefulWidget {
  const SalesByCustomersScreen({super.key});

  @override
  State<SalesByCustomersScreen> createState() => _SalesByCustomersScreenState();
}

class _SalesByCustomersScreenState extends State<SalesByCustomersScreen> {
  final salesbycustomerController = Get.put(SalesByCustomerController());
  final homeController = Get.put(HomeController());
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
                baseString: salesbycustomerController.baseString.value,
                name: "Sales By Customers"))),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Expanded(
            child: Obx(() => salesbycustomerController.baseString.value.isEmpty
                ? CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<SalesByCustomerController>(builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
        ]),
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
                .dateRange[salesbycustomerController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              salesbycustomerController.selectDateRange(selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesbycustomerController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(salesbycustomerController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              salesbycustomerController.selectDate(context, true);
            },
            onTapTo: () {
              salesbycustomerController.selectDate(context, false);
            },
            isFromEnable: salesbycustomerController.isFromDate.value,
            isToEnable: salesbycustomerController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildCustomerFilter(context,
            isAccordionOpen: salesbycustomerController.showaccordian.value,
            onToggle: (p0) {
              salesbycustomerController.showAccordian();
            },
            customerController: salesbycustomerController.customersControl,
            classController: salesbycustomerController.classControl,
            groupController: salesbycustomerController.groupControl,
            areaController: salesbycustomerController.areaControl,
            countryController: salesbycustomerController.countryControl,

onTapCustomer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesbycustomerController.customersControl, filterOptions: FilterComboOptions.Customer, 
            selectedList: salesbycustomerController.selectedCustomerList, 
            isRange: salesbycustomerController.isRangeCustomers, isProduct: false);},

onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesbycustomerController.classControl, filterOptions: FilterComboOptions.Class, 
            selectedList: salesbycustomerController.selectedClassList, 
            isRange: salesbycustomerController.isRangeClass, isProduct: false);},

onTapGroup: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesbycustomerController.groupControl, filterOptions: FilterComboOptions.Group, 
            selectedList: salesbycustomerController.selectedGroupList, 
            isRange: salesbycustomerController.isRangeGroup, isProduct: false);},

onTapArea: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesbycustomerController.areaControl, filterOptions: FilterComboOptions.Area, 
            selectedList: salesbycustomerController.selectedAreaList, 
            isRange: salesbycustomerController.isRangeArea, isProduct: false);},

          onTapCountry: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: salesbycustomerController.countryControl, filterOptions: FilterComboOptions.Country, 
            selectedList: salesbycustomerController.selectedCountryList, 
            isRange: salesbycustomerController.isRangeCountry, isProduct: false);},

           )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildReportTypeDropdown(
            reportTypes: salesbycustomerController.reportTypes,
            selectedValue: salesbycustomerController.reportType.value,
            onChanged: (value) {
              salesbycustomerController.changeReportType(value.toString());
            })),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: salesbycustomerController.isLoading.value,
                onTap: () {
                  salesbycustomerController
                      .getSalesByCustomerSummaryReport(context);
                },
              ),
            )),
      ],
    );
  }
}
