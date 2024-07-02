import 'dart:convert';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/model/Approvals%20Model/getUserApprovalsWithPendingTasksModel.dart';
import 'package:axolon_erp/model/Approvals%20Model/getUserPendingApprovalTasksModel.dart';
import 'package:axolon_erp/model/Approvals%20Model/showApprovalDetailsModel.dart';
import 'package:axolon_erp/model/common_response_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;

class ApprovalController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // getApprovalCategories();
  }

  final loginController = Get.put(LoginTokenController());

  var remarkscontrol = TextEditingController().obs;
  var isCategoryLoading = false.obs;
  var isListLoading = false.obs;
  var isApproving = false.obs;
  var isRejecting = false.obs;
  var isPreviewLoading = false.obs;
  var isTaskDetailsLoading = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var categories = [].obs;
  var approvalCategoryModel = GetUserApprovalsWithPendingTasksModel().obs;
  var approvalList = [].obs;
  var selectedCategoryIndex = 0.obs;
  var selectedApprovalIndex = 0.obs;
  var totalCount = 0.obs;
  var dontshow = false.obs;
  var readMore = false.obs;
  var taskDetails = <TaskDetailsModel>[].obs;
  var activeTaskDetails = <TaskDetailsModel>[].obs;
  var expiredTaskDetails = <TaskDetailsModel>[].obs;

  dontShowthisAgain() async {
    dontshow.value = !dontshow.value;
  }

  getApprovalCategories() async {
    dontshow.value = false;
    isCategoryLoading.value = true;
    isListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetUserApprovalsWithPendingTasks?token=${token}&approvalType=1');
      if (feedback != null) {
        result = GetUserApprovalsWithPendingTasksModel.fromJson(feedback);
        response.value = result.result;
        categories.value = result.modelobject;
        if (categories.isNotEmpty) {
          categories.value = categories.value
              .where((element) => element.taskCount > 0)
              .toList();
        }
        approvalCategoryModel.value = result;
        isCategoryLoading.value = false;
      }
      if (response.value == 1) {
        response.value = 0;
        totalCount.value = 0;
        if (categories.isNotEmpty) {
          categories.forEach((element) {
            if (element.taskCount != null) {
              totalCount.value += element.taskCount as int;
            }
          });
          developer.log(
              'GetUserApprovalsWithPendingTasks==========${totalCount.value}');
          getApprovalList(categories[0].approvalId, 0);
        } else {
          isListLoading.value = false;
        }
      }
    } finally {
      // isListLoading.value = false;
    }
  }

  // readMoreText(index) {
  //   if (taskDetails[index].readMore == true) {
  //     taskDetails[index].readMore = false;
  //     update();
  //   } else {
  //     taskDetails[index].readMore = true;
  //     update();
  //   }
  //   developer.log("${taskDetails[index].readMore}");
  //   taskDetails.refresh();
  // }

  getApprovalList(String approvalId, int index) async {
    selectedCategoryIndex.value = index;
    update();
    isListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetUserPendingApprovalTasks?token=${token}&approvalType=1&approvalID=${approvalId}');
      if (feedback != null) {
        result = GetUserPendingApprovalTasksModel.fromJson(feedback);
        response.value = result.result;
        approvalList.value = result.modelobject;
        // developer.log(approvalList[1].dateUpdated.toString(),
        //     name: 'Approval date');
        await sortByDate();
        isListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {}
    }
  }

  sortByDate() {
    approvalList.sort((a, b) {
      // Compare the most recent date, whether it's dateUpdated or dateCreated
      DateTime aDate = a.dateUpdated ?? a.dateCreated;
      DateTime bDate = b.dateUpdated ?? b.dateCreated;
      return bDate.compareTo(aDate);
    });
    developer.log('Sort Success');
  }

  Future<bool> approveTask(
      {required int index,
      required int objectType,
      required int objectID,
      required int taskID}) async {
    selectedApprovalIndex.value = index;
    response.value = 0;
    isApproving.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'ApproveTask?token=${token}&approvalType=1&objectType=${objectType}&objectID=${objectID}&taskID=${taskID}');
      if (feedback != null) {
        result = CommonResponseModel.fromJson(feedback);
        response.value = result.res;
        message.value = result.msg;
        isApproving.value = false;
      }
    } finally {
      isApproving.value = false;
      if (response.value == 1) {
        remarkscontrol.value.text = ' ';
        approvalList.removeAt(index);
        totalCount.value -= 1;
        categories[selectedCategoryIndex.value].taskCount =
            categories[selectedCategoryIndex.value].taskCount - 1;

        update();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> rejectTask(
      {required int index,
      required int objectType,
      required int objectID,
      required int taskID}) async {
    selectedApprovalIndex.value = index;
    response.value = 0;
    isRejecting.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'RejectTask?token=${token}&approvalType=1&objectType=${objectType}&objectID=${objectID}&taskID=${taskID}');
      if (feedback != null) {
        result = CommonResponseModel.fromJson(feedback);
        response.value = result.res;
        message.value = result.msg;
        isRejecting.value = false;
      }
    } finally {
      isRejecting.value = false;
      if (response.value == 1) {
        approvalList.removeAt(index);
        totalCount.value -= 1;
        categories[selectedCategoryIndex.value].taskCount =
            categories[selectedCategoryIndex.value].taskCount - 1;
        update();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> getTaskDetails({
    required int index,
    required int objectType,
    required int objectID,
    required String voucherId,
    required String sysDocId,
  }) async {
    selectedApprovalIndex.value = index;
    taskDetails.clear();
    activeTaskDetails.clear();
    expiredTaskDetails.clear();
    response.value = 0;
    isTaskDetailsLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'ShowApprovalDetails?token=${token}&ObjectType=${objectType}&objectID=${objectID}&objectCode=${voucherId}&SysDocID=${sysDocId}');
      if (feedback != null) {
        developer.log("${feedback}");
        result = ShowApprovalDetailsModel.fromJson(feedback);
        response.value = result.result;
        activeTaskDetails.value = result.modelobject;
        taskDetails.value = result.modelobject;
        // taskDetails.value = reorderListByGroupID(taskDetails);
        isTaskDetailsLoading.value = false;
      }
      // for (var item in taskDetails) {
      //   // item.readMore = false;
      //   if (item.isExpired == true) {
      //     expiredTaskDetails.add(item);
      //   } else {
      //     activeTaskDetails.add(item);
      //   }
      // }

      if (taskDetails.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } finally {
      isTaskDetailsLoading.value = false;
    }
  }

  List<TaskDetailsModel> reorderListByGroupID(List<TaskDetailsModel> list) {
    List<TaskDetailsModel> reorderedList = [];
    Map<int, List<TaskDetailsModel>> groupIDMap = {};

    for (TaskDetailsModel item in list) {
      int groupID = item.groupId!;

      if (!groupIDMap.containsKey(groupID)) {
        groupIDMap[groupID] = [];
      }
      groupIDMap[groupID]!.add(item);
    }

    for (TaskDetailsModel item in list) {
      int groupID = item.groupId!;

      if (groupIDMap.containsKey(groupID)) {
        reorderedList.addAll(groupIDMap[groupID]!);
        groupIDMap.remove(groupID);
      }
    }

    return reorderedList;
  }

  AddApproveRemarks({required int index, required int taskID}) async {
    selectedApprovalIndex.value = index;
    response.value = 0;
    if (remarkscontrol.value.text.trim().isEmpty) {
      return;
    }
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'AddApproveRemarks?token=${token}&Remarks=${remarkscontrol.value.text}&TaskID=${taskID}');

      if (feedback != null) {
        developer.log(feedback.toString());
        result = CommonResponseModel.fromJson(feedback);
        response.value = result.res;
      }
    } finally {
      if (response.value == 1) {
        remarkscontrol.value.text = '';
      }
    }
  }

  previewApproval(BuildContext context,
      {required int index,
      required String sysDoc,
      required String voucher,
      required int objectId}) async {
    SysdocType? doc;
    try {
      doc =
          SysdocType.values.firstWhere((element) => element.value == objectId);
    } catch (e) {
      developer.log("Error: $e");
      developer.log("Error: $doc");
    }
    if (doc == null) {
      return;
    }

    selectedApprovalIndex.value = index;
    isPreviewLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    var data = jsonEncode({
      "FileName": doc.name.toString(),
      "SysDocType": objectId,
      "FileType": 1
    });
    var result;
    try {
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api:
              'GetApprovalPreview?token=${token}&SysDocID=${sysDoc}&VoucherID=${voucher}',
          data: data);

      if (feedback != null) {
        developer.log(
            'GetApprovalPreview?token=${token}&SysDocID=${sysDoc}&VoucherID=${voucher}',
            name: 'url');
        developer.log('${data}', name: 'data');
        //     // result = CommonResponseModel.fromJson(feedback);
        //     // response.value = result.res;
        // developer.log(feedback['Modelobject'].toString(), name: 'Preview');
        if (feedback['Modelobject'] != null &&
            feedback['Modelobject'].isNotEmpty) {
          Uint8List bytes = await base64.decode(feedback['Modelobject']);
          // List<int> bytes = base64.decode(feedback['Modelobject']);
          // await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'Approval.pdf');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            '${doc?.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.mutedColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: CommonFilterControls.buildPdfView(bytes))
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
        }

        //     // isPreviewLoading.value = false;
      }
    } finally {
      isPreviewLoading.value = false;
      //   // if (response.value == 1) {
      //   //   remarkscontrol.value.text = ' ';
      //   // }
    }
  }
}
