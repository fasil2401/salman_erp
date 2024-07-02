import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/credirlimit_byid_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/credit_limit_open_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/get_customersnap_balance_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditLimitController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      getAllCustomers();
    });
  }

  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  final homeController = Get.put(HomeController());
  DateTime date = DateTime.now();

  var isLoading = false.obs;

  var isCustomerLoading = false.obs;
  var isVoucherLoading = false.obs;

  var response = 0.obs;

  var sysDocList = [].obs;

  var customerList = [].obs;

  var voucherNumber = ''.obs;
  var sysDocName = ' '.obs;
  var sysDocId = ''.obs;

  var dueDate = DateTime.now().obs;
  var transactionDate = DateTime.now().obs;
  var isNewRecord = true.obs;
  var isToken = false.obs;
  var customerFilterList = [].obs;
  var isSearching = false.obs;
  var customer = CustomerModel().obs;
  var customerId = ''.obs;

  var isSaving = false.obs;

  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;

  var creditDate = DateTime.now().obs;
  var validFrom = DateTime.now().obs;
  var validTo = DateTime.now().obs;
  var referenceController = TextEditingController().obs;
  var amountController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var noteController = TextEditingController().obs;
  var inActive = false.obs;
  var hold = false.obs;
  var token = false.obs;
  var isCLSaving = false.obs;
  var isCLisnewRecord = true.obs;

  var isCreditLimitOpenListLoading = false.obs;
  var creditlimitOpenList = [].obs;
  var selecteditem = CreditByIdModel().obs;
  var code = ' '.obs;
  var name = ' '.obs;
  var status = ' '.obs;
  var creditstatus = ' '.obs;
  var balance = ' '.obs;
  var creditlimit = ' '.obs;
  var insAmount = ' '.obs;
  var dueAmount = ' '.obs;
  var unsecPdc = ' '.obs;
  var maxduedays = ' '.obs;
  var pdc = ' '.obs;
  var uninvoicedd = ' '.obs;
  var net = ' '.obs;
  var credit = ''.obs;
  var available = ' '.obs;

  RxDouble invoice = 0.0.obs;
  RxDouble receipt = 0.0.obs;
  RxDouble returnTotal = 0.0.obs;
  var customerremarks = ' '.obs;
  var iscustomerLoading = false.obs;

  var selectedmodel = CustomerSnapBalanceModel().obs;

  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.creditlimit, type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.creditlimit, type: ScreenRightOptions.Edit);
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

  Future<DateTime> selectDateStartDate(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    customerId.value = this.customer.value.code ?? '';
  }

  resetCustomerList() {
    customerFilterList.value = customerList;
  }

  generateCreditLimitSysDocList() {
    sysDocList.clear();
    for (var element in salesScreenController.sysDocList) {
      if (element.sysDocType == SysdocType.CLVoucher.value) {
        sysDocList.add(element);
      }
    }
  }

  getVoucherNumber(String sysDocId, String name) async {
    isNewRecord.value = true;
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    isVoucherLoading.value = true;
    this.sysDocId.value = sysDocId;
    sysDocName.value = name;
    await loginController.getToken();
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
        voucherNumber.value = result.model;
        isVoucherLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        log(voucherNumber.value.toString(), name: 'Voucher Number');
      }
    }
  }

  presetSysdoc() async {
    if (!salesScreenController.isLoading.value) {
      await generateCreditLimitSysDocList();
      await getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
      log('Length of sysDocList: ${sysDocList.length}');

      update();
    } else {
      await Future.delayed(Duration(seconds: 0));

      await presetSysdoc();
    }
  }

  getAllCustomers() async {
    isCustomerLoading.value = true;
    await isEnanbled();

    await presetSysdoc();
    await homeController.getCustomerList();
    await generateCustomerList();

    isCustomerLoading.value = false;
  }

  generateCustomerList() async {
    customerList.clear();
    for (var element in homeController.customerList) {
      customerList.add(element);
    }
    customer.value = customerList[0];
    customerId.value = customer.value.code ?? '';
  }

  getCreditLimitOpenList() async {
    isCreditLimitOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    final String fromDate = this.fromDate.value.toIso8601String();
    final String toDate = this.toDate.value.toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataAccount(
          api:
              'GetCLVoucherList?token=${token}&fromDate=${fromDate}&toDate=${toDate}&showVoid=false&type=${CreditControlType.creditlimit.value}');
      if (feedback != null) {
        result = GetCreditLimitOPenLIsttModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        creditlimitOpenList.value = result.model;
        isCreditLimitOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        log(creditlimitOpenList.length.toString(), name: 'All sales open list');
      }
    }
  }

  createCreditLimit() async {
    if (amountController.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter the amount");
      return false;
    }

    isCLSaving.value = true;
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final data = json.encode({
      "token": token,
      "IsnewRecord": isNewRecord.value,
      "SysDocID": sysDocId.value,
      "VoucherID": voucherNumber.value,
      "CustomerID": customerId.value,
      "Reference": referenceController.value.text,
      "VoucherDate": creditDate.value.toIso8601String(),
      "ValidFrom": validFrom.value.toIso8601String(),
      "ValidTo": validTo.value.toIso8601String(),
      "Amount": int.parse(amountController.value.text),
      "Note": noteController.value.text,
      "IsToken": isToken.value,
      "CreditControlType": CreditControlType.creditlimit.value,
      "IsInactive": inActive.value,
      "IsHoldRecord": hold.value
    });
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api: "CreateCLVoucher", data: data);

      if (feedback != null) {
        if (feedback['res'] == 1) {
          SnackbarServices.successSnackbar('Credit Limit added Successfully');

          clearCreditLimt();
          getVoucherNumber(sysDocId.value, sysDocName.value);
          generateCustomerList();

          update();
        }
        isCLSaving.value = false;
      }
      isCLSaving.value = false;
    } finally {
      isCLSaving.value = false;
    }
  }

  getCreditLimitbyid(String sysdocId, voucherId) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    var result;
    try {
      final feedback = await ApiServices.fetchDataAccount(
          api:
              'GetCLVoucherByID?token=$token&sysDocID=$sysdocId&voucherID=$voucherId');
      if (feedback != null) {
        result = GetCreditByIdModel.fromJson(feedback);
        selecteditem.value = result.model[0];
        isNewRecord.value = false;
        // isToken.value = false;
      }
    } finally {
      sysDocId.value = selecteditem.value.sysDocId ?? "";
      voucherNumber.value = selecteditem.value.voucherId ?? "";

      referenceController.value.text = selecteditem.value.reference ?? "";

      validFrom.value = selecteditem.value.validFrom ?? DateTime.now();
      validTo.value = selecteditem.value.validTo ?? DateTime.now();
      creditDate.value = selecteditem.value.dateCreated ?? DateTime.now();

      amountController.value.text = selecteditem.value.amount.toString();

      referenceController.value.text = selecteditem.value.reference ?? "";
      noteController.value.text = selecteditem.value.note ?? "";
      hold.value = selecteditem.value.isHold ?? false;
      inActive.value = selecteditem.value.isInactive ?? false;
      isToken.value = selecteditem.value.isToken ?? false;
      customerId.value = selecteditem.value.customerId ?? "";

      if (homeController.customerList.isEmpty) {
        await homeController.getCustomerList();
      }
      customer.value = homeController.customerList.firstWhere(
          (element) => element.code == customerId.value,
          orElse: (() => log('eroorrrrrrr')));
    }
  }

  getCustomerSanpBalance() async {
    iscustomerLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCustomer(
          api:
              'GetCustomerSnapBalanceData?token=${token}&CustomerID=${customerId.value}');
      if (feedback != null) {
        result = GetCustomerSnapBalanceModel.fromJson(feedback);
        print(result);
        response.value = result.result;

        selectedmodel.value = result.modelobject![0];
        code.value = selectedmodel.value.customerId ?? "";
        name.value = selectedmodel.value.customerName ?? "";
        balance.value = selectedmodel.value.balance.toString();
        creditlimit.value = selectedmodel.value.creditAmount?.toString() ?? "";
        insAmount.value = selectedmodel.value.insuranceAmount?.toString() ?? "";
        unsecPdc.value =
            selectedmodel.value.pdcUnsecuredLimitAmount?.toString() ?? "0";
        pdc.value = selectedmodel.value.pdcAmount?.toString() ?? "";

        net.value = selectedmodel.value.netBalance?.toString() ?? "0";

        credit.value = selectedmodel.value.creditAmount?.toString() ?? "";
        dueAmount.value = selectedmodel.value.dueAmount?.toString() ?? "0";
        maxduedays.value = selectedmodel.value.dueDays?.toString() ?? "0";
        uninvoicedd.value = selectedmodel.value.unInvoiced?.toString() ?? "0";
        available.value = selectedmodel.value.balanceAmount?.toString() ?? "0";

        status.value = selectedmodel.value.customerStatus.toString() ?? "";
        creditstatus.value = selectedmodel.value.creditStatus.toString();
        customerremarks.value = selectedmodel.value.remarks ?? "";

        //  customerremarks.value = selectedmodel.value.re.toString() ?? "";
        update();
      }
    } finally {
      iscustomerLoading.value = false;
      if (response.value == 1) {}
    }
  }

  clearCreditLimt() {
    customerId.value = "";
    creditDate.value = DateTime.now();
    validFrom.value = DateTime.now();
    validTo.value = DateTime.now();
    amountController.value.clear();
    remarksController.value.clear();
    noteController.value.clear();
    referenceController.value.clear();
    hold.value = false;
    inActive.value = false;
    isToken.value = false;

    generateCreditLimitSysDocList();
  }

  validation() {
    if (amountController.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter the amount");
      return false;
    }

    return true;
  }
}
