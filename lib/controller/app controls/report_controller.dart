import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // getEmployeeAttendanceHistory();
  }

  final loginController = Get.put(LoginTokenController());
  DateTime date = DateTime.now();
  var isLoading = false.obs;
  var response = 0.obs;
  var attendanceHistoy = [].obs;
  var checkInCount = 10.obs;
  var checkOutCount = 0.obs;
  var breakInCount = 0.obs;
  var breakOutCount = 0.obs;
  getEmployeeAttendanceHistory() async {
    log('getiing attendance history');
    resetChart();
    final now = DateTime.now();
    // var startDate = DateTime(now.year, 1).toIso8601String().toString();
    var startDate =
        DateTime(now.year, now.month, 1).toIso8601String().toString();
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    final String date = DateTime.now().toIso8601String().toString();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetEmployeeAttendanceLog?token=${token}&employeeID=${employeeId}&fromDate=${startDate}&toDate=${date}');
      if (feedback != null) {
        result = EmployeeAttendanceLogModel.fromJson(feedback);
        response.value = result.res;
        attendanceHistoy.value = result.model;
        attendanceHistoy.sort((a, b) => b.logDate.compareTo(a.logDate));
        for (var element in attendanceHistoy) {
          if (element.logFlag == 'CheckIn') {
            checkInCount.value = checkInCount.value + 1;
          }
          if (element.logFlag == 'CheckOut') {
            checkOutCount.value = checkOutCount.value + 1;
          }
          if (element.logFlag == 'BreakIn') {
            breakInCount.value = breakInCount.value + 1;
          }
          if (element.logFlag == 'BreakOut') {
            breakOutCount.value = breakOutCount.value + 1;
          }
        }
      }
      isLoading.value = true;
    } finally {
      if (response.value == 1) {}
      isLoading.value = false;
    }
  }

  resetChart() {
    checkInCount.value = 0;
    checkOutCount.value = 0;
    breakInCount.value = 0;
    breakOutCount.value = 0;
  }
}
