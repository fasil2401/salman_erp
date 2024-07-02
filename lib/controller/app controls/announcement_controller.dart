import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Announcement%20Model/get_announcement_by_employee_id_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAnnouncementByEmployeeID();
  }

  final loginController = Get.put(LoginTokenController());
  var announcemnetList = <AnnouncementByEmployeeIDModel>[].obs;
  var isAnnouncementLoading = false.obs;

  getAnnouncementByEmployeeID() async {
    announcemnetList.clear();
    isAnnouncementLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataEmployee(
          api:
              'GetAnnouncementByEmployeeID?token=$token&employeeID=${employeeId}');
      if (feedback != null) {
        result = GetAnnouncementByEmployeeIdModel.fromJson(feedback);
        if (result.model != null && result.model is List) {
          List<AnnouncementByEmployeeIDModel> list =
              result.model.cast<AnnouncementByEmployeeIDModel>();
          await filterRecentDates(list);
          update();
        }
      }
      isAnnouncementLoading.value = false;
      update();
    } catch (e) {
      // Handle exceptions here
      print(e.toString());
    } finally {
      isAnnouncementLoading.value = false;
      update();
    }
  }

  filterRecentDates(List<AnnouncementByEmployeeIDModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = DateTime.parse(a.announcementDate ?? '');
        DateTime dateB = DateTime.parse(b.announcementDate ?? '');
        return dateB.compareTo(dateA); // Descending order
      });
      announcemnetList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }
}
