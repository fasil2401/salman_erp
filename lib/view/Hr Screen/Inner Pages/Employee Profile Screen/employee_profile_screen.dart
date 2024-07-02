import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/employee_profile_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/app controls/home_controller.dart';
import '../../../../services/enums.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final employeeProfileController = Get.put(EmployeeProfileController());
  final homeController = Get.put(HomeController());
  var selectedValue;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      // CommonFilterControls.buildBottomSheet(context, buildFilter(context));
      employeeProfileController.getEmployeeProfileReport(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: employeeProfileController.baseString.value,
              name: "Employee Profile Report"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() => employeeProfileController.baseString.value.isEmpty
                ? employeeProfileController.isLoadingReport.value
                    ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<EmployeeProfileController>(builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
        ],
      ),
      // floatingActionButton: CommonFilterControls.buildFilterButton(context,
      //     filter: buildFilter(context))
    );
  }

  buildFilter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
//         Obx(() => CommonFilterControls.buildEmployeeFilter(context,
//                 isAccordionOpen: employeeProfileController.showaccordian.value,
//                 onToggle: (p0) {
//               employeeProfileController.showAccordian();
//             },
//                 employeeController:
//                     employeeProfileController.employeeController,
//                 departmentController:
//                     employeeProfileController.departmentController,
//                 locationController:
//                     employeeProfileController.locationController,
//                 typeController: employeeProfileController.typeController,
//                 divisionController:
//                     employeeProfileController.divisionController,
//                 sponsorController: employeeProfileController.sponsorController,
//                 groupController: employeeProfileController.groupController,
//                 gradeController: employeeProfileController.gradeController,
//                 positionController:
//                     employeeProfileController.positionController,
//                 bankController: employeeProfileController.bankController,
//                 accountController: employeeProfileController.accountController,

//                   onTapEmployee: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.employeeController, filterOptions: FilterComboOptions.Employees,
//             selectedList: employeeProfileController.selectedEmployeesList,
//             isRange: employeeProfileController.isRangeEmployees, isProduct: false);},

//             onTapDepartment: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.departmentController, filterOptions: FilterComboOptions.EmployeeDepartment,
//             selectedList: employeeProfileController.selectedEmployeeDepartmentList,
//             isRange: employeeProfileController.isRangeEmployeeDepartment, isProduct: false);},

//             onTapLocation: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.locationController, filterOptions: FilterComboOptions.EmployeeLocation,
//             selectedList: employeeProfileController.selectedEmployeeLocationList,
//             isRange: employeeProfileController.isRangeEmployeeLocation, isProduct: false);},

//             onTapType: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.typeController, filterOptions: FilterComboOptions.EmployeeType,
//             selectedList: employeeProfileController.selectedEmployeeTypeList,
//             isRange: employeeProfileController.isRangeEmployeeType, isProduct: false);},

//  onTapDivision: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.divisionController, filterOptions: FilterComboOptions.SalesPersonDivision,
//             selectedList: employeeProfileController.selectedEmployeeDivisionList,
//             isRange: employeeProfileController.isRangeEmployeeDivision, isProduct: false);},

//             onTapSponsor: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.sponsorController, filterOptions: FilterComboOptions.EmployeeSponsor,
//             selectedList: employeeProfileController.selectedEmployeeSponsorList,
//             isRange: employeeProfileController.isRangeEmployeeSponsor, isProduct: false);},

//                           onTapGroup: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.groupController, filterOptions: FilterComboOptions.EmployeeGroup,
//             selectedList: employeeProfileController.selectedEmployeeGroupList,
//             isRange: employeeProfileController.isRangeEmployeeGroup, isProduct: false);},

// onTapGrade: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.gradeController, filterOptions: FilterComboOptions.EmployeeGrade,
//             selectedList: employeeProfileController.selectedEmployeeGradeList,
//             isRange: employeeProfileController.isRangeEmployeeGrade, isProduct: false);},

//  onTapPosition: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.positionController, filterOptions: FilterComboOptions.EmployeePosition,
//             selectedList: employeeProfileController.selectedEmployeePositionList,
//             isRange: employeeProfileController.isRangeEmployeePosition, isProduct: false);},

//           onTapBank: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.bankController, filterOptions: FilterComboOptions.Bank,
//             selectedList: employeeProfileController.selectedBankList,
//             isRange: employeeProfileController.isRangeBank, isProduct: false);},

//     onTapAccount: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context,
//             txtController: employeeProfileController.accountController, filterOptions: FilterComboOptions.Account,
//             selectedList: employeeProfileController.selectedAccountList,
//             isRange: employeeProfileController.isRangeAccount, isProduct: false);},

//                 )),
        // Obx(() => CommonFilterControls.buildToggleTile(
        //       toggleText: 'Show Inactive Employees',
        //       switchValue: employeeProfileController.isInactiveEmployees.value,
        //       onToggled: (bool? value) {
        //         employeeProfileController.toggleInactiveEmployees();
        //       },
        //     )),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: employeeProfileController.isLoadingReport.value,
                onTap: () async {
                  await employeeProfileController
                      .getEmployeeProfileReport(context);
                },
              ),
            )),
      ],
    );
  }
}
