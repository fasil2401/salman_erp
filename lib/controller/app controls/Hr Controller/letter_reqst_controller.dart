import 'dart:convert';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Letter%20Request%20Model/get_latter_request_model.dart';
import 'package:axolon_erp/model/Letter%20Request%20Model/get_letter_rqst_byId_model.dart';
import 'package:axolon_erp/model/system_doc_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Sales Controls/sales_screen_controller.dart';

class LetterReqController extends GetxController {
  @override
  void onInit() {
    loadInitials();
    super.onInit();
  }

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  var selectedDocId = SysDocModel().obs;
  var selectedtype = LetterModel().obs;
  var selectedLetter = LetterByIdModel().obs;

  var isLoading = false.obs;
  var isSaving = false.obs;
  var dateIndex = 0.obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var rqstDate = DateTime.now().obs;
  var validDate = DateTime.now().obs;
  var isNewRecord = false.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var docnumberController = TextEditingController().obs;
  var date = DateTime.now().obs;
  var rqstdetailsController = TextEditingController().obs;
  var remarkController = TextEditingController().obs;
  var docIdList = [].obs;
  var response = 0.obs;
  var letterList = <LetterModel>[].obs;
  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  loadInitials() async {
    int index = 8;
    await selectDateRange(
        index,
        DateRangeSelector.dateRange.indexOf(DateRangeSelector.dateRange
            .firstWhere((element) => element.value == index)));

    getLetterRequestDetailList();
    isEnanbled();
  }

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeLetterIssueRequest,
        type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: HrScreenId.employeeLetterIssueRequest,
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

  Future<DateTime> selectDateStartDate(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
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
              'GetNextDocumentNo?token=${token}&sysDocID=${sysDocId}&dateTime=${date}');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        docnumberController.value.text = result.model;
      }
    } finally {}
  }

  getDocId() {
    docIdList.clear();
    if (salesScreenController.sysDocList.isEmpty) {
      salesScreenController.getSystemDocList();
    }
    docIdList.value = salesScreenController.sysDocList
        .where((element) =>
            element.sysDocType == SysdocType.EmployeeLetterIssueRequest.value)
        .toList();
    selectedDocId.value = docIdList.first;
    getVoucherNumber(selectedDocId.value.code ?? '');
    update();
  }

  getLetterRequestDetailList() async {
    isLoading.value = true;
    update();
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
              'GetEmployeeLetterIssueRequestList?token=$token&from=${fromDate.value.toIso8601String()}&to=${toDate.value.toIso8601String()}&showVoid=false&sysDocID=${selectedDocId.value.code}');

      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetLetterRequestDetailListModel.fromJson(feedback);
          String employeeId = homeController.employeeId.value;
          List<LetterModel> list = result.model
              .where((element) => element.employeeId == employeeId)
              .toList();
          filterRecentDates(list);
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  filterRecentDates(List<LetterModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.letterIssueDate!;
        DateTime dateB = b.letterIssueDate!;
        return dateB.compareTo(dateA); // Descending order
      });
      letterList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }

  createLetterRequest() async {
    isSaving.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    var data = jsonEncode({
      "token": token,
      "SysDocID": "${selectedDocId.value.code}",
      "VoucherID": docnumberController.value.text,
      "EmployeeID": employeeId,
      "DivisionID": "",
      "TransactionDate": DateTime.now().toIso8601String(),
      "Reference": "",
      "Isnewrecord": isNewRecord.value,
      "StartDate": validDate.value.toIso8601String(),
      "RequestedDate": rqstDate.value.toIso8601String(),
      "RequestDetails": rqstdetailsController.value.text,
      "RequestedBy": selectedtype.value.name,
      "LetterType": "",
      "Remarks": remarkController.value.text,
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: 'CreateEmployeeLetterIssueRequest', data: data);
      if (feedback != null) {
        if (feedback['res'] == 1) {
          clearData();
          SnackbarServices.successSnackbar(
              "Created Employee Letter Request Successfully");
          getVoucherNumber(selectedDocId.value.code ?? '');
        
        } else {
          SnackbarServices.errorSnackbar("${feedback['err']}");
        }
      }
    } finally {
      isSaving.value = false;
    }
  }

  getLetterRequestDetailById(LetterModel item) async {
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
              'GetEmployeeLetterIssueRequestByID?token=$token&sysDocID=${item.docId}&voucherID=${item.docNumber}');
      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetLetterRequestByIdListModel.fromJson(feedback);
          selectedLetter.value = result.model[0];
          selectedDocId.value = docIdList.firstWhere(
            (element) => item.docId == element.code,
            orElse: () {
              SysDocModel();
            },
          );
          docnumberController.value.text = item.docNumber ?? '';
          rqstDate.value = item.requestedDate ?? DateTime.now();
          selectedDocId.value.code = selectedLetter.value.sysDocId ?? "";
          //selectedLetter.value.requestedDate ?? DateTime.now();

          remarkController.value.text = selectedLetter.value.remarks ?? '';
          rqstdetailsController.value.text =
              selectedLetter.value.requestDetails ?? '';
          isNewRecord.value = false;
          update();
          // validDate.value=selectedLetter.value.
        }
      }
    } finally {}
  }

  clearData() {
    rqstDate.value = DateTime.now();
    validDate.value = DateTime.now();
    rqstdetailsController.value.clear();
    remarkController.value.clear();

    isNewRecord.value = false;
    update();
  }
}
