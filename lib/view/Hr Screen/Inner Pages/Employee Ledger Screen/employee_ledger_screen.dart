import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/employee_ledger_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/app controls/home_controller.dart';
import '../../../../services/enums.dart';

class EmployeeLedgerScreen extends StatefulWidget {
  const EmployeeLedgerScreen({super.key});

  @override
  State<EmployeeLedgerScreen> createState() => _EmployeeLedgerScreenState();
}

class _EmployeeLedgerScreenState extends State<EmployeeLedgerScreen> {
  final employeeLedgerController = Get.put(EmployeeLedgerController());
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
                baseString: employeeLedgerController.baseString.value,
                name: "Employee Ledger Report"))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(() => employeeLedgerController.baseString.value.isEmpty
                  ? CommonFilterControls.buildEmptyPlaceholder()
                  : GetBuilder<EmployeeLedgerController>(builder: (controller) {
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
                .dateRange[employeeLedgerController.dateIndex.value],
            onChanged: (value) {
              selectedValue = value;
              employeeLedgerController.selectDateRange(selectedValue.value,
                  DateRangeSelector.dateRange.indexOf(selectedValue));
            },
            fromController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(employeeLedgerController.fromDate.value)
                  .toString(),
            ),
            toController: TextEditingController(
              text: DateFormatter.dateFormat
                  .format(employeeLedgerController.toDate.value)
                  .toString(),
            ),
            onTapFrom: () {
              employeeLedgerController.selectDate(context, true);
            },
            onTapTo: () {
              employeeLedgerController.selectDate(context, false);
            },
            isFromEnable: employeeLedgerController.isFromDate.value,
            isToEnable: employeeLedgerController.isToDate.value,
          ),
        ),
        SizedBox(
          height: 15,
        ),
//         Obx(() => CommonFilterControls.buildEmployeeFilter(context,
//                 isAccordionOpen: employeeLedgerController.showaccordian.value,
//                 onToggle: (Value) {
//               employeeLedgerController.showAccordian();
//             },
//                 employeeController: employeeLedgerController.employeeController,
//                 departmentController:
//                     employeeLedgerController.departmentController,
//                 locationController: employeeLedgerController.locationController,
//                 typeController: employeeLedgerController.typeController,
//                 divisionController: employeeLedgerController.divisionController,
//                 sponsorController: employeeLedgerController.sponsorController,
//                 groupController: employeeLedgerController.groupController,
//                 gradeController: employeeLedgerController.gradeController,
//                 positionController: employeeLedgerController.positionController,
//                 bankController: employeeLedgerController.bankController,
//                 accountController: employeeLedgerController.accountController,
//                  onTapEmployee: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.employeeController, filterOptions: FilterComboOptions.Employees,
//             selectedList: employeeLedgerController.selectedEmployeesList,
//             isRange: employeeLedgerController.isRangeEmployees, isProduct: false);},

//             onTapDepartment: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.departmentController, filterOptions: FilterComboOptions.EmployeeDepartment,
//             selectedList: employeeLedgerController.selectedEmployeeDepartmentList,
//             isRange: employeeLedgerController.isRangeEmployeeDepartment, isProduct: false);},

//             onTapLocation: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.locationController, filterOptions: FilterComboOptions.EmployeeLocation,
//             selectedList: employeeLedgerController.selectedEmployeeLocationList,
//             isRange: employeeLedgerController.isRangeEmployeeLocation, isProduct: false);},

//             onTapType: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.typeController, filterOptions: FilterComboOptions.EmployeeType,
//             selectedList: employeeLedgerController.selectedEmployeeTypeList,
//             isRange: employeeLedgerController.isRangeEmployeeType, isProduct: false);},

//  onTapDivision: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.divisionController, filterOptions: FilterComboOptions.SalesPersonDivision,
//             selectedList: employeeLedgerController.selectedEmployeeDivisionList,
//             isRange: employeeLedgerController.isRangeEmployeeDivision, isProduct: false);},

//             onTapSponsor: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.sponsorController, filterOptions: FilterComboOptions.EmployeeSponsor,
//             selectedList: employeeLedgerController.selectedEmployeeSponsorList,
//             isRange: employeeLedgerController.isRangeEmployeeSponsor, isProduct: false);},

//                           onTapGroup: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.groupController, filterOptions: FilterComboOptions.EmployeeGroup,
//             selectedList: employeeLedgerController.selectedEmployeeGroupList,
//             isRange: employeeLedgerController.isRangeEmployeeGroup, isProduct: false);},

// onTapGrade: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.gradeController, filterOptions: FilterComboOptions.EmployeeGrade,
//             selectedList: employeeLedgerController.selectedEmployeeGradeList,
//             isRange: employeeLedgerController.isRangeEmployeeGrade, isProduct: false);},

//  onTapPosition: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.positionController, filterOptions: FilterComboOptions.EmployeePosition,
//             selectedList: employeeLedgerController.selectedEmployeePositionList,
//             isRange: employeeLedgerController.isRangeEmployeePosition, isProduct: false);},

//           onTapBank: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.bankController, filterOptions: FilterComboOptions.Bank,
//             selectedList: employeeLedgerController.selectedBankList,
//             isRange: employeeLedgerController.isRangeBank, isProduct: false);},

//     onTapAccount: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeLedgerController.accountController, filterOptions: FilterComboOptions.Account,
//             selectedList: employeeLedgerController.selectedAccountList,
//             isRange: employeeLedgerController.isRangeAccount, isProduct: false);},
//                 )),
        // Obx(() => CommonFilterControls.buildToggleTile(
        //       toggleText: 'Show Zero Balance Employees',
        //       switchValue:
        //           employeeLedgerController.isZeroBalanceEmployees.value,
        //       onToggled: (bool? value) {
        //         employeeLedgerController.toggleZeroBalanceEmployees();
        //       },
        //     )),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: employeeLedgerController.isLoadingReport.value,
                onTap: () async {
                  await employeeLedgerController
                      .getEmployeeLedgerReport(context);
                },
              ),
            )),
      ],
    );
  }
}
