import 'dart:ui';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';

import 'package:axolon_erp/model/Announcement%20Model/get_follow_up_model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class FollowUpController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFollowUpList();
  }

  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var followUpList = <FollowUpModel>[].obs;
  var selectedSTatusIndex = 0.obs;
  var isSelectedStatus = false.obs;

  selectStatus(int index) {
    selectedSTatusIndex.value = index;
    isSelectedStatus.value = true;
    update();
  }

  getFollowUpList() async {
    followUpList.clear();
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetFollowUpList?token=$token');
      if (feedback != null) {
        String username = UserSimplePreferences.getUsername() ?? '';
        result = GetFollowUpModel.fromJson(feedback);
        List<FollowUpModel> list = result.modelobject
            .where(
                (element) => element.nextFollowupById == username.toUpperCase())
            .toList();
        //await containerTrackerController.getActionStatusComboList();
        filterRecentDates(list);
        update();
      }
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      update();
    }
  }

                            
filterRecentDates(List<FollowUpModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.currentfollowupDate!;
        DateTime dateB = b.currentfollowupDate!;
        return dateB.compareTo(dateA); // Descending order
      });
      followUpList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }

  changeStatus({required String followUpId, required int status}) async {
    // followUpList.clear();
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api:
              'UpdateFollowUpStatus?token=$token&followUpID=$followUpId&Status=$status');
      if (feedback != null) {
        if (feedback['res'] == 1) {
          
          getFollowUpList();
        } else {
          SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
        }
        update();
      }
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
