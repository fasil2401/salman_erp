import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptsController extends GetxController {
  TextEditingController registerController = TextEditingController();
  TextEditingController costCenterController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController recievedFromController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController recievedForController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  var voucherNumber = ''.obs;
  var sysDocName = ' '.obs;
  var isVoucherLoading = false.obs;
  var isRegisterLoading = false.obs;
  var date = DateTime.now().obs;
  var isLoadingSave = false.obs;
  selectDate(context) async {
    DateTime? newDate =
        await CommonFilterControls.getCalender(context, date.value);
    if (newDate != null) {
      date.value = newDate;
    }
    update();
  }
}
