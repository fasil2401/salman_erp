import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/date_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';

class ReportTypeSelector {
  final loginController = Get.put(LoginTokenController());
  static List reportRange = [
    DateFilterModel(label: 'Summary', value: 1),
    DateFilterModel(label: 'Detail', value: 2),
    DateFilterModel(label: 'Items', value: 3),
  ];

  static getReportRange(int range) async {
int reportID = 0;
    switch (range) {
      case 1:
        reportID = range;
        break;
      case 2:
        reportID = range;
        break;
      default:
    }

    developer.log(reportID.toString(),
        name: 'ReportTypeSelector reportID');
    return reportID;
  }

  getAllCatalogues() async {
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetOpenFiscalYear?token=${token}');
      if (feedback != null) {
        result = AllDateModel.fromJson(feedback);
        print(result);
      }
    } finally {
      if (result.result == 1) {
        developer.log(result.startDate.toString(), name: 'All Dates Start');

        return DateTimeRange(start: result.startDate, end: result.endDate);
      }
    }
  }
}
