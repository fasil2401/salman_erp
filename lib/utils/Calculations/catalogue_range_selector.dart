import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/date_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';

class CatalogueRangeSelector {
  final loginController = Get.put(LoginTokenController());
  static List catalogueRange = [
    DateFilterModel(label: 'Product', value: 1),
    DateFilterModel(label: 'Product by parent', value: 2),
  ];

  static getCatalogueRange(int range) async {
int catalogueID = 0;
    switch (range) {
      case 1:
        catalogueID = range;
        break;
      case 2:
        catalogueID = range;
        break;
      default:
    }

    developer.log(catalogueID.toString(),
        name: 'CatalogueRangeSelector catalogueID');
    return catalogueID;
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
