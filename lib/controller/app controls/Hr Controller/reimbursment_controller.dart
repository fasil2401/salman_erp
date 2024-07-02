import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Reimbursement%20Request%20Model/get_addition_code_list.dart';
import 'package:axolon_erp/model/Reimbursement%20Request%20Model/get_employee_reimbursement_request_byID_model.dart';
import 'package:axolon_erp/model/Reimbursement%20Request%20Model/get_reimbursement_request_list_model.dart';
import 'package:axolon_erp/model/employee_location.dart';
import 'package:axolon_erp/model/system_doc_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/Reimbursement Request Model/employee_employee_reimbursement_detail_model.dart';
import '../../../services/enums.dart';
import '../Sales Controls/sales_screen_controller.dart';

class ReimbursementController extends GetxController {
  @override
  void onInit() {
    loadInitials();
    super.onInit();
  }

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  var descriptionController = TextEditingController().obs;
  var amountController = TextEditingController().obs;
  var descontroller = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var additionalCodeList = <AdditionalCodeModel>[].obs;
  var filterAdditionalCodeList = <AdditionalCodeModel>[].obs;
  var total = 0.0.obs;
  var date = DateTime.now().obs;
  var refDate = DateTime.now().obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var isNewRecord = false.obs;
  var docIdList = [].obs;
  var selectedDocId = SysDocModel().obs;
  var voucherNumber = "".obs;
  var reimbursmentList = <ReimbursementRequestModel>[].obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var reimbursmentListCreated =
      <EmployeeEmployeeReimbursementDetailModel>[].obs;
  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  loadInitials() async {
    int index = 8;
    await selectDateRange(
        index,
        DateRangeSelector.dateRange.indexOf(DateRangeSelector.dateRange
            .firstWhere((element) => element.value == index)));

    getReimbursementRequestList();
    isEnanbled();
  }

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeReimbursementRequest,
        type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeReimbursementRequest,
        type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
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

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await CommonFilterControls.getCalender(
        context, isFrom ? fromDate.value : toDate.value);
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  getDocId() {
    docIdList.clear();
    if (salesScreenController.sysDocList.isEmpty) {
      salesScreenController.getSystemDocList();
    }
    docIdList.value = salesScreenController.sysDocList
        .where((element) =>
            element.sysDocType == SysdocType.EmployeeReimbursementRequest.value)
        .toList();
    selectedDocId.value = docIdList.first;
    getVoucherNumber(selectedDocId.value.code ?? '');
    update();
  }

  getVoucherNumber(
    String sysDocId,
  ) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String date = DateTime.now().toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetNextDocumentNo?token=$token&sysDocID=$sysDocId&dateTime=$date');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        voucherNumber.value = result.model;
      }
    } finally {}
  }

  Future<DateTime> selectDatesForApplying(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  getReimbursementRequestList() async {
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api:
              'GetReimbursementRequestList?token=$token&from=${fromDate.value.toIso8601String()}&to=${toDate.value.toIso8601String()}&showVoid=false');

      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetReimbursementRequestListModel.fromJson(feedback);
          String employeeId = homeController.employeeId.value;
          List<ReimbursementRequestModel> lists = result.model
              .where((element) => element.employeeId == employeeId)
              .toList();
          filterRecentDates(lists);
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  filterRecentDates(List<ReimbursementRequestModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.transactionDate!;
        DateTime dateB = b.transactionDate!;
        return dateB.compareTo(dateA); // Descending order
      });
      reimbursmentList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }

  clearData() {
    date.value = DateTime.now();
    descriptionController.value.clear();
    reimbursmentListCreated.clear();
    remarksController.value.clear();
    descontroller.value.clear();
    total.value = 0;
    update();
  }

  getAdditionCodeList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetAdditionCodeList?token=$token');
      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetAdditionCodeListModel.fromJson(feedback);
          additionalCodeList.value = result.model;
          filterAdditionalCodeList.value = additionalCodeList;
        }
      }
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    update();
  }

  filterAdditionalCode(String value) {
    filterAdditionalCodeList.value = additionalCodeList
        .where((element) =>
            element.benefitCode
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()) ||
            element.benefitName
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
        .toList();
    update();
  }

  addItem(AdditionalCodeModel item) {
    reimbursmentListCreated.add(EmployeeEmployeeReimbursementDetailModel(
      amount: amountController.value.text.contains(".")
          ? double.parse(amountController.value.text)
          : double.tryParse(amountController.value.text) ?? 0.0,
      refDate: refDate.value.toIso8601String(),
      reimburseItemId: item.benefitCode ?? '',
      reimburseItemName: item.benefitName ?? '',
      des: descontroller.value.text,
    ));
    calculateTotal();
    update();
  }

  removeItem(int index) {
    reimbursmentListCreated.removeAt(index);
    calculateTotal();
    update();
  }

  clearPopupData() {
    amountController.value.clear();
    refDate.value = DateTime.now();
    descontroller.value.clear();
    update();
  }

  updateItem(int index) {
    reimbursmentListCreated[index].amount =
        amountController.value.text.contains(".")
            ? double.parse(amountController.value.text)
            : double.tryParse(amountController.value.text) ?? 0.0;
    reimbursmentListCreated[index].refDate = refDate.value.toIso8601String();
    reimbursmentListCreated[index].des = descontroller.value.text;
    calculateTotal();
    update();
  }

  createReimbursmentRequest() async {
    if (reimbursmentListCreated.isEmpty) {
      SnackbarServices.errorSnackbar("Please add Additional Codes");
      return;
    }
    isSaving.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    List<EmployeeEmployeeReimbursementDetailModel> list = [];
    int rowIndex = 0;
    for (var item in reimbursmentListCreated) {
      list.add(EmployeeEmployeeReimbursementDetailModel(
          amount: item.amount ?? 0.0,
          refDate: item.refDate,
          reimburseItemId: item.reimburseItemId ?? '',
          des: item.des ?? "",
          rowIndex: rowIndex));
      rowIndex++;
    }
    var data = jsonEncode({
      "token": token,
      "SysDocID": "${selectedDocId.value.code}",
      "VoucherID": voucherNumber.value,
      "TransactionDate": date.value.toIso8601String(),
      "Isnewrecord": isNewRecord.value,
      "EmployeeID": employeeId,
      "Total": total.value,
      "Remarks": remarksController.value.text,
      "EmployeeEmployeeReimbursementDetailModel": list
    });
    try {
      log(data);
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'CreateEmployeeReimbursementRequest', data: data);
      log("$feedback");
      if (feedback != null) {
        if (feedback['res'] == 1) {
          clearData();
          SnackbarServices.successSnackbar(
              "Created Employee Reimbursment Request Successfully");
          getVoucherNumber(selectedDocId.value.code ?? '');
        } else {
          SnackbarServices.errorSnackbar("${feedback['err']}");
        }
      }
    } finally {
      isSaving.value = false;
    }
  }

  calculateTotal() {
    total.value = reimbursmentListCreated.fold(
        0, (previousValue, element) => previousValue + (element.amount ?? 0.0));
    update();
  }

  getEmployeeReimbursementRequestByID(String sysDocId, String voucheriD) async {
    reimbursmentListCreated.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    if (selectedDocId.value.code == null) {
      await getDocId();
    }
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api:
              'GetEmployeeReimbursementRequestByID?token=$token&sysDocID=$sysDocId&voucherID=$voucheriD');
      if (feedback != null) {
        if (feedback['result'] == 1) {
          result = GetEmployeeReimbursementRequestByIdModel.fromJson(feedback);
          selectedDocId.value = docIdList.firstWhere(
            (element) => sysDocId == element.code,
            orElse: () {
              SysDocModel();
            },
          );
          voucherNumber.value = voucheriD;
          for (var item in result.detail) {
            reimbursmentListCreated
                .add(EmployeeEmployeeReimbursementDetailModel(
              amount: double.parse(item.amount.toString()),
              refDate: item.refDate ?? '',
              reimburseItemId: item.reimburseItemId ?? '',
              reimburseItemName: item.description ?? '',
              rowIndex: item.rowIndex,
              des: item.des,
            ));
          }
          date.value = result.header[0].transactionDate;
          remarksController.value.text = result.header[0].remarks;
          total.value = double.parse(result.header[0].total);
          isNewRecord.value = false;
          update();
        }
      }
    } finally {}
    update();
  }
}
