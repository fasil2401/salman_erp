import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/date_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';

class ItemsRangeSelector {
  final loginController = Get.put(LoginTokenController());
  static List itemRange = [
    DateFilterModel(label: 'All Items', value: 1),
    DateFilterModel(label: 'Single', value: 2),
    DateFilterModel(label: 'Range', value: 3),
    DateFilterModel(label: 'Item Class', value: 4),
    DateFilterModel(label: 'Item Category', value: 5),
    DateFilterModel(label: 'Item Brand', value: 6),
    DateFilterModel(label: 'Manufacturer', value: 7),
    DateFilterModel(label: 'Origin', value: 8),
    DateFilterModel(label: 'Style', value: 9),
  ];

  static getItemsRange(int range) async {
int ItemID = 0;
    switch (range) {
      case 1:
        ItemID = range;
        break;
      case 2:
        ItemID = range;
        break;
      default:
    }

    developer.log(ItemID.toString(),
        name: 'ItemsRangeSelector ItemID');
    return ItemID;
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
