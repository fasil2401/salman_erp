import 'dart:convert';
import 'dart:typed_data';

import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/Api Services/api_services.dart';
import '../../../utils/constants/snackbar.dart';
import '../../Api Controls/login_token_controller.dart';
import '../home_controller.dart';

class EmployeeLedgerController extends GetxController {
  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var bytes = Uint8List(10000000).obs;
  var baseString = ''.obs;

  //------------------- Employees start -----------------------------//
  TextEditingController employeeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController sponsorController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  var isRangeEmployees = false.obs;
  var isRangeEmployeeDepartment = false.obs;
  var isRangeEmployeeLocation = false.obs;
  var isRangeEmployeeType = false.obs;
  var isRangeEmployeeDivision = false.obs;
  var isRangeEmployeeSponsor = false.obs;
  var isRangeEmployeeGroup = false.obs;
  var isRangeEmployeeGrade = false.obs;
  var isRangeEmployeePosition = false.obs;
  var isRangeBank = false.obs;
  var isRangeAccount = false.obs;

  var selectedEmployeesList = [].obs;
  var selectedEmployeeDepartmentList = [].obs;
  var selectedEmployeeLocationList = [].obs;
  var selectedEmployeeTypeList = [].obs;
  var selectedEmployeeDivisionList = [].obs;
  var selectedEmployeeSponsorList = [].obs;
  var selectedEmployeeGroupList = [].obs;
  var selectedEmployeeGradeList = [].obs;
  var selectedEmployeePositionList = [].obs;
  var selectedBankList = [].obs;
  var selectedAccountList = [].obs;

  //------------------- Employees end -----------------------------//
  var isLoadingReport = false.obs;
  //--------------------------Date---------------------------------//
  DateTime date = DateTime.now();
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var dateIndex = 0.obs;
  selectDate(context, bool isFrom) async {
    DateTime? newDate =
        await CommonFilterControls.getCalender(context, fromDate.value);
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
  }

  //-----------------------------------------------------------------------//
  //---------inactive toggles start -------------//
  var isZeroBalanceEmployees = false.obs;
  toggleZeroBalanceEmployees() {
    isZeroBalanceEmployees.value = !isZeroBalanceEmployees.value;
  }

  //---------inactive toggles end -------------//
  //--------------------employee-----------------//
  var showaccordian = false.obs;
  showAccordian() {
    showaccordian.value = !showaccordian.value;
  }

  getEmployeeLedgerReport(BuildContext context) async {
    isLoadingReport.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String fromDate = this.fromDate.value.toIso8601String();
    String toDate = this.toDate.value.toIso8601String();
    baseString.value = '';
    final data = jsonEncode({
      "PrintResultData": {
        "FileName": "Employee Ledger",
        "SysDocType": 0,
        "FileType": 1
      },
// "token": "$token",
//   "fromEmployee": '',
//   "toEmployee": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployees.value, false, selectedEmployeesList),
//   "fromDepartment": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeDepartment.value, false, selectedEmployeeDepartmentList),
//   "toDepartment": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeDepartment.value, false, selectedEmployeeDepartmentList),
//   "fromLocation": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeLocation.value, false, selectedEmployeeLocationList),
//   "toLocation": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeLocation.value, false, selectedEmployeeLocationList),
//   "DateFrom": "$fromDate",
//   "DateTo": "$toDate",
//   "fromType": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeType.value, false, selectedEmployeeTypeList),
//   "toType": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeType.value, false, selectedEmployeeTypeList),
//   "fromDivision": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeDivision.value, false, selectedEmployeeDivisionList),
//   "toDivision": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeDivision.value, false, selectedEmployeeDivisionList),
//   "fromSponsor": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeSponsor.value, false, selectedEmployeeSponsorList),
//   "toSponsor": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeSponsor.value, false, selectedEmployeeSponsorList),
//   "fromGroup": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeGroup.value, false, selectedEmployeeGroupList),
//   "toGroup": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeGroup.value, false, selectedEmployeeGroupList),
//   "fromGrade": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeeGrade.value, false, selectedEmployeeGradeList),
//   "toGrade": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeeGrade.value, false, selectedEmployeeGradeList),
//   "fromPosition": CommonFilterControls.getJsonFromToFilter(true, isRangeEmployeePosition.value, false, selectedEmployeePositionList),
//   "toPosition": CommonFilterControls.getJsonFromToFilter(false, isRangeEmployeePosition.value, false, selectedEmployeePositionList),
//   "fromBank": CommonFilterControls.getJsonFromToFilter(true, isRangeBank.value, false, selectedBankList),
//   "toBank": CommonFilterControls.getJsonFromToFilter(false, isRangeBank.value, false, selectedBankList),
//   "fromAccount": CommonFilterControls.getJsonFromToFilter(true, isRangeAccount.value, false, selectedAccountList),
//   "toAccount": CommonFilterControls.getJsonFromToFilter(false, isRangeAccount.value, false, selectedAccountList),
//   "showZeroBalance": isZeroBalanceEmployees.value,
//   "EmployeeIDs": CommonFilterControls.getJsonListFilter(employeeController, isRangeEmployees.value, selectedEmployeesList, false),
//   "DepartmentIDs": CommonFilterControls.getJsonListFilter(departmentController, isRangeEmployeeDepartment.value, selectedEmployeeDepartmentList, false),
//   "LocationIDs": CommonFilterControls.getJsonListFilter(locationController, isRangeEmployeeLocation.value, selectedEmployeeLocationList, false),
//   "TypeIDs": CommonFilterControls.getJsonListFilter(typeController, isRangeEmployeeType.value, selectedEmployeeTypeList, false),
//   "DivisionIDs": CommonFilterControls.getJsonListFilter(divisionController, isRangeEmployeeDivision.value, selectedEmployeeDivisionList, false),
//   "SponsorIDs": CommonFilterControls.getJsonListFilter(sponsorController, isRangeEmployeeSponsor.value, selectedEmployeeSponsorList, false),
//   "GroupIDs": CommonFilterControls.getJsonListFilter(groupController, isRangeEmployeeGroup.value, selectedEmployeeGroupList, false),
//   "GradeIDs": CommonFilterControls.getJsonListFilter(gradeController, isRangeEmployeeGrade.value, selectedEmployeeGradeList, false),
//   "PositionIDs": CommonFilterControls.getJsonListFilter(positionController, isRangeEmployeePosition.value, selectedEmployeePositionList, false),
//   "BankIDs": CommonFilterControls.getJsonListFilter(bankController, isRangeBank.value, selectedBankList, false),
      // "AccountsIDs": CommonFilterControls.getJsonListFilter(accountController, isRangeAccount.value, selectedAccountList, false),

      // "token": "$token",
      // "fromEmployee": '',
      // "toEmployee": '',
      // "fromDepartment": '',
      // "toDepartment": '',
      // "fromLocation": '',
      // "toLocation": '',
      // "DateFrom": "$fromDate",
      // "DateTo": "$toDate",
      // "fromType": '',
      // "toType": '',
      // "fromDivision": '',
      // "toDivision": '',
      // "fromSponsor": '',
      // "toSponsor": '',
      // "fromGroup": '',
      // "toGroup": '',
      // "fromGrade": '',
      // "toGrade": '',
      // "fromPosition": '',
      // "toPosition": '',
      // "fromBank": '',
      // "toBank": '',
      // "fromAccount": '',
      // "toAccount": '',
      // "showZeroBalance": isZeroBalanceEmployees.value,
      // "EmployeeIDs": "'${homeController.userEmployee.value.employeeId ?? ''}'",
      // "DepartmentIDs":
      //     "'${homeController.userEmployee.value.departmentId ?? ''}'",
      // "LocationIDs": "'${homeController.userEmployee.value.locationId ?? ''}'",
      // "TypeIDs": "'${homeController.userEmployee.value.contractType ?? ''}'",
      // "DivisionIDs": "'${homeController.userEmployee.value.divisionId ?? ''}'",
      // "SponsorIDs": "'${homeController.userEmployee.value.sponsorId ?? ''}'",
      // "GroupIDs": "'${homeController.userEmployee.value.groupId ?? ''}'",
      // "GradeIDs": "'${homeController.userEmployee.value.gradeId ?? ''}'",
      // "PositionIDs": "'${homeController.userEmployee.value.positionId ?? ''}'",
      // "BankIDs": "'${homeController.userEmployee.value.bankId ?? ''}'",
      // "AccountsIDs": "'${homeController.userEmployee.value.accountId ?? ''}'",

      "token": "$token",
      "fromEmployee": homeController.employeeId.value,
      "toEmployee": homeController.employeeId.value,
      "fromDepartment": '',
      "toDepartment": '',
      "fromLocation": '',
      "toLocation": '',
      "DateFrom": "$fromDate",
      "DateTo": "$toDate",
      "fromType": '',
      "toType": '',
      "fromDivision": '',
      "toDivision": '',
      "fromSponsor": '',
      "toSponsor": '',
      "fromGroup": '',
      "toGroup": '',
      "fromGrade": '',
      "toGrade": '',
      "fromPosition": '',
      "toPosition": '',
      "fromBank": '',
      "toBank": '',
      "fromAccount": '',
      "toAccount": '',
      "showZeroBalance": isZeroBalanceEmployees.value,
      "EmployeeIDs": "",
      "DepartmentIDs": "",
      "LocationIDs": "",
      "TypeIDs": "",
      "DivisionIDs": "",
      "SponsorIDs": "",
      "GroupIDs": "",
      "GradeIDs": "",
      "PositionIDs": "",
      "BankIDs": "",
      "AccountsIDs": "",
    });
    try {
      print(data);
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api: 'GetEmployeeLedgerReport', data: data);
      if (feedback != null) {
        // if (feedback['result'] == 0) {
        //   isLoadingReport.value = false;
        // }

        // response.value = feedback['result'];

        // log("${feedback}");

        baseString.value = '';
        // developer.log("${feedback}");
        isLoadingReport.value = false;
        if (feedback['Modelobject'] != null) {
          baseString.value = feedback['Modelobject'];
          bytes.value = base64.decode(feedback['Modelobject']);
          update();
          print(baseString.value);
        }
      }
    } finally {
      isLoadingReport.value = false;
      if (baseString.value.isNotEmpty) {
        Navigator.pop(context);
        // developer.log(dailyAnalysisSource[0].toString(), name: 'Report Name');
      } else {
        SnackbarServices.errorSnackbar('No Data Found !!');
      }
    }
  }
}
