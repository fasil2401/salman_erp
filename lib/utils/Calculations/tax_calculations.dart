import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_model.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

final homeController = Get.put(HomeController());

class TaxHelper {
  static calculateTax(
      {required String taxGroupId,
      required double price,
      required bool isExclusive}) async {
    List<TaxModel> list = [];
    if (homeController.taxGroupList.isEmpty) {
      await homeController.getTaxGroupDetailList();
    }
    var currentTaxGroupList = homeController.taxGroupList.where((element) =>
        element.taxGroupId.toLowerCase() == taxGroupId.toLowerCase());

    for (var element in currentTaxGroupList) {
      double itemTax = (price * element.taxRate) / 100;
      TaxModel tax = TaxModel(
        taxGroupId: element.taxGroupId,
        taxItemId: element.taxCode,
        taxRate: element.taxRate,
        calculationMethod: element.calculationMethod.toString(),
        taxAmount: itemTax,
      );
      list.add(tax);
    }
    return list;
  }
}
