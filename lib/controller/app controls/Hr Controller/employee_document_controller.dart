import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Employee%20Document%20Model/get_employee_document_list_model.dart';
import 'package:axolon_erp/model/attachment_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDocumentController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getEmployeeDocumentList();
  }

  final loginController = Get.put(LoginTokenController());
  var docNumberController = TextEditingController().obs;
  var issuePlaceController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var employeeDocumentList = <EmployeeDocumentModel>[].obs;
  var attachmentList = <AttachmentListModel>[].obs;
  var selectedDocType = ''.obs;
  var issueDate = DateTime.now().obs;
  var expiryDate = DateTime.now().obs;
  var isLoading = false.obs;
  var isAttachmentListLoading = false.obs;

  Future<DateTime> selectDatesForCreating(
      BuildContext context, DateTime date) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
  }

  getEmployeeDocumentList() async {
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api: 'GetEmployeeDocuments?token=$token&employeeID=$employeeId');

      if (feedback != null) {
        if (feedback['res'] == 1) {
          result = GetEmployeeDocumentsListModel.fromJson(feedback);
          employeeDocumentList.value = result.model;
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  getAttachment(String docId) async {
    isAttachmentListLoading.value = true;
    attachmentList.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetAttachment?token=$token&entityType=4&EntitySysDocID=$employeeId&EntityID=$employeeId/EmpDocs/$docId');
      if (feedback != null) {
        result = GetAttachmentListModel.fromJson(feedback);
        attachmentList.value = result.modelobject;
        isAttachmentListLoading.value = false;
        update();
      }
    } finally {
      isAttachmentListLoading.value = false;
    }
  }
}
