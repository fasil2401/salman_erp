import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';
import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_cost_category.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_delay_reason.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_my_task_byId_model.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_priority.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_project_task_follow_up_list.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_project_task_list.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_taskgroup.dart';
import 'package:axolon_erp/model/My%20Task%20Model/get_team_id_model.dart';
import 'package:axolon_erp/model/My%20Task%20Model/my_task_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/entity_comment_list_model.dart';
import 'package:axolon_erp/model/employees_list_model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_job_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTaskController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isEnanbled();
    homeController.getActionStatusComboList();
    homeController.getNextCardNumber();
    getMyTaskFollowUpList();
  }

  var scheduleStartDate = DateTime.now().obs;
  var scheduleendDate = DateTime.now().obs;
  var actualStartDate = DateTime.now().obs;
  var actualEndDate = DateTime.now().obs;

  var teamidController = TextEditingController().obs;
  var descriptionController = TextEditingController().obs;
  var noteController = TextEditingController().obs;
  var commentsController = TextEditingController().obs;
  var totalhourscontrol = TextEditingController().obs;
 TextEditingController chatControl = TextEditingController();
  var statuscontrol = TextEditingController().obs;
  var percCompletedcontrol = TextEditingController().obs;
  var delayReasoncontrol = TextEditingController().obs;
  var prioritycontrol = TextEditingController().obs;
  var taskgroupcontrol = TextEditingController().obs;
  var requesteedtocontrol = TextEditingController().obs;
  var assignedtocontrol = TextEditingController().obs;
  var costCategorycontrol = TextEditingController().obs;
  var taskcodecontrol = TextEditingController().obs;
  var projectcontrol = TextEditingController().obs;
  var searchController = TextEditingController().obs;
  var statusFilterController = TextEditingController(text: '').obs;
  TextEditingController myTaskIdFilterController =
      TextEditingController(text: MyTask.values.first.name);

  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());

  var dateIndex = 0.obs;
  DateTime date = DateTime.now();
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var isMyTaskListLoading = false.obs;
  var filterSearchList = [].obs;

  var myTaskFilter = [].obs;
  var statusFilter = [].obs;
  var taskGroupList = <TaskGroupModel>[].obs;
  var teamIdList = <TeamComboList>[].obs;
  var priorityList = <PriorityComboModel>[].obs;
  var delayReasonList = <DelayReasonComboList>[].obs;
  var projectTaskFollowUpList = [].obs;
  var costCategoryList = <CostCategoryModel>[].obs;
  var employeesList = <EmployeesSingleModel>[].obs;
  var myTaskList = <GetProjectTaskModel>[].obs;
  var myTaskListsearchlist = <GetProjectTaskModel>[].obs;
  var filterSearchMyTaskList = <GetProjectTaskModel>[].obs;
  var actionStatusComboList = <ActionStatusComboModel>[].obs;
  var jobList = <JobModel>[].obs;
  var chatsend = false.obs;
  var chatList = [].obs;
  var response = 0.obs;
  var isLoading = false.obs;
  var isLoadingOpenlist = false.obs;

  var isSaveloading = false.obs;
  var isNewRecord = true.obs;

  var isViewEnabled = false.obs;
  var selectedPublicFilter = MyTask.AssignedToMe.obs;
  var selectedtask = GetMyTaskById().obs;
  var filterMytaskList = <GetProjectTaskModel>[].obs;
  Future<DateTime> selectDate(context, var dates) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, dates);
    if (newDate != null) {
      dates = newDate;
    }
    update();
    return dates;
  }

  isEnanbled() async {
    bool isView = homeController.isScreenRightAvailable(
        screenId: HrScreenId.myTask, type: ScreenRightOptions.Add);

    if (isView) {
      isViewEnabled.value = true;
    }
  }

  // Rx<TimeOfDay> totalHours = TimeOfDay.now().obs;

  // Future<void> selectStartTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: totalHours.value,
  //   );
  //   if (picked != null && picked != totalHours.value) {
  //     totalHours.value = picked;
  //   }
  // }

  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
    UserSimplePreferences.setLeadDateFilter(index);
  }

  addDatas() async {
    if (actionStatusComboList.isEmpty) {
      await homeController.getActionStatusComboList();
    }
    if (employeesList.isEmpty) {
      await homeController.getEmployeesList();
    }
    if (jobList.isEmpty) {
      await homeController.getJobList();
    }
    if (taskGroupList.isEmpty) {
      await getTaskGroup();
    }
    if (priorityList.isEmpty) {
      await getPriority();
    }
    if (delayReasonList.isEmpty) {
      await getDelayReason();
    }

    if (costCategoryList.isEmpty) {
      await getCostCategory();
    }
    if (teamIdList.isEmpty) {
      await getTeamId();
    }

    statuscontrol.value.text =
        '${homeController.actionStatusComboList[0].code} - ${homeController.actionStatusComboList[0].name}';
    assignedtocontrol.value.text =
        '${homeController.employeesList[0].code} - ${homeController.employeesList[0].name}';
    requesteedtocontrol.value.text =
        '${homeController.employeesList[0].code} - ${homeController.employeesList[0].name}';
    taskgroupcontrol.value.text =
        '${taskGroupList[0].code} - ${taskGroupList[0].name}';
    costCategorycontrol.value.text = '${costCategoryList[0].code}';

    prioritycontrol.value.text =
        '${priorityList[0].code} - ${priorityList[0].name}';
    teamidController.value.text =
        '${teamIdList[0].code} - ${teamIdList[0].name}';
    delayReasoncontrol.value.text =
        '${delayReasonList[0].code} - ${delayReasonList[0].name}';
    projectcontrol.value.text =
        '${homeController.jobList[0].code} - ${homeController.jobList[0].name}';
  }

  createMyTask() async {
    isSaveloading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    if (homeController.nextcardnumbercontrol.text.isEmpty) {
      await homeController.getNextCardNumber();
    }
    final String token = loginController.token.value;
    String data = jsonEncode({
      "token": token,
      "Isnewrecord": isNewRecord.value,
      "TaskID": homeController.nextcardnumbercontrol.text,
      "TaskIDStatus": statuscontrol.value.text.split(' - ')[0],
      "TotalHours": int.parse(totalhourscontrol.value.text),
      "CompletedPercentage": int.parse(percCompletedcontrol.value.text),
      "TaskDelayReasonID": delayReasoncontrol.value.text.split(' - ')[0],
      "TeamID": teamidController.value.text.split(' - ')[0],
      "PriorityID": prioritycontrol.value.text.split(' - ')[0],
      "TaskGroupID": taskgroupcontrol.value.text.split(' - ')[0],
      "AssignedToID": assignedtocontrol.value.text.split(' - ')[0],
      "ActualEndDate": actualStartDate.value.toIso8601String(),
      "ActualStartDate": actualEndDate.value.toIso8601String(),
      "EndDate": scheduleendDate.value.toIso8601String(),
      "StartDate": scheduleStartDate.value.toIso8601String(),
      "JobID": projectcontrol.value.text.split(' - ')[0],
      "FeeID": "6666",
      "Note": noteController.value.text,
      "CostCategoryID": costCategorycontrol.value.text.split(' - ')[0],
      "Description": descriptionController.value.text,
      "RequestedByID": requesteedtocontrol.value.text.split(' - ')[0],
    });
    // print("JSON Data: $data");
    try {
      var feedback = await ApiServices.fetchDataRawBodyProject(
          api: 'CreateProjectTask', data: data);
      if (feedback != null) {
        if (feedback["res"] == 0) {
          response.value = feedback["res"];
          SnackbarServices.errorSnackbar("${feedback['err']}");
        } else {
          response.value = feedback["res"];
          log("Feedback Response: $data");
        }
      }
    } catch (e) {
      SnackbarServices.errorSnackbar("$e");
      isSaveloading.value = false;
      update();
    } finally {
      if (response.value == 1) {
        if (homeController.result.value != FilePickerResult([])) {
          await homeController.addAttachment(
            "",
            homeController.nextcardnumbercontrol.text,
            EntityType.JobTask,
          );
        }
        SnackbarServices.successSnackbar('Successfully Created');
        isSaveloading.value = false;
        clearData();
        homeController.getNextCardNumber();
        addDatas();
        getMyTaskFollowUpList();
      }
    }
  }

  getMyTaskbyid(String taskId) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    var result;
    try {
      final feedback = await ApiServices.fetchDataProject(
          api: 'GetProjectTaskByID?token=$token&id=$taskId');
      if (feedback != null) {
        result = GetMyTaskByIdModel.fromJson(feedback);
        selectedtask.value = result.model[0];
      }
    } finally {
      homeController.nextcardnumbercontrol.value =
          TextEditingValue(text: selectedtask.value.taskId ?? "");

      statuscontrol.value.text = selectedtask.value.status ?? "";
      descriptionController.value.text = selectedtask.value.description ?? "";
      taskgroupcontrol.value.text = selectedtask.value.taskGroupId ?? '';
      projectcontrol.value.text = selectedtask.value.jobId ?? "";
      costCategorycontrol.value.text = selectedtask.value.costCategoryId ?? "";
      prioritycontrol.value.text = selectedtask.value.priorityId ?? "";
      scheduleStartDate.value = selectedtask.value.startDate ?? DateTime.now();
      scheduleendDate.value = selectedtask.value.endDate ?? DateTime.now();
      actualStartDate.value =
          selectedtask.value.actualStartDate ?? DateTime.now();
      actualEndDate.value = selectedtask.value.actualEndDate ?? DateTime.now();

      totalhourscontrol.value.text = selectedtask.value.totalHours.toString();
      percCompletedcontrol.value.text =
          selectedtask.value.completedPercentage.toString();

      requesteedtocontrol.value.text = selectedtask.value.requestedById ?? "";
      assignedtocontrol.value.text = selectedtask.value.assignedToId ?? "";
      delayReasoncontrol.value.text =
          selectedtask.value.taskDelayReasonId ?? "";
      noteController.value.text = selectedtask.value.note ?? "";
      isNewRecord.value = false;
    }
  }

  getMyTaskFollowUpList() async {
    if (isMyTaskListLoading.value == true) {
      return;
    }
    isMyTaskListLoading.value = true;
    update();
    searchController.value.clear();
    filterMytaskList.clear();
    filterSearchList.clear();
    filterSearchMyTaskList.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataProject(
          api:
              'GetProjectTaskFollowUpList?token=$token&filterMode=${selectedPublicFilter.value.value}');
      if (feedback != null) {
        myTaskList.clear();
        result = GetProjectTaskList.fromJson(feedback);
        myTaskList.value = result.model;
        filterSearchMyTaskList.value = result.model;
        isMyTaskListLoading.value = false;
        filterSearchMyTaskList.value = myTaskList;
        filterMytaskList.value = myTaskList;
        update();
      }
    } finally {
      isMyTaskListLoading.value = false;
      update();
    }
  }

  getTeamId() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetTeamComboList?token=$token');
      if (feedback != null) {
        result = GetTeamComboListModel.fromJson(feedback);
        response.value = result.result;
        teamIdList.value = result.modelobject;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getTaskGroup() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetProjectTaskGroupComboList?token=$token');
      if (feedback != null) {
        result = GetProjectTaskGroupComboList.fromJson(feedback);
        response.value = result.res;
        taskGroupList.value = result.model;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getPriority() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetPriorityComboList?token=$token');
      if (feedback != null) {
        result = GetPriorityComboList.fromJson(feedback);
        response.value = result.result;
        priorityList.value = result.modelobject;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getDelayReason() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetDelayReasonComboList?token=$token');
      if (feedback != null) {
        result = GetDelayReasonComboList.fromJson(feedback);
        response.value = result.result;
        delayReasonList.value = result.modelobject;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getProjectTaskList() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetProjectTaskList?token=$token');
      if (feedback != null) {
        result = GetProjectTaskFollowUpList.fromJson(feedback);
        response.value = result.res;
        projectTaskFollowUpList.value = result.model;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  getCostCategory() async {
    isLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;

    try {
      var feedback = await ApiServices.fetchDataProject(
          api: 'GetCostCategoryList?token=${token}');
      if (feedback != null) {
        result = GetCostCategoryList.fromJson(feedback);
        response.value = result.result;
        costCategoryList.value = result.modelobject;
        isLoading.value = false;
        update();
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  filterRecentDates(List<GetProjectTaskModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.actStartDate!;
        DateTime dateB = b.actEndDate!;
        return dateB.compareTo(dateA); // Descending order
      });
      filterSearchMyTaskList.value = dates;
      update();
    } else {}
  }

  clearData() {
    homeController.getNextCardNumber();
    homeController.nextcardnumbercontrol.value =
        TextEditingValue(text: selectedtask.value.taskId ?? "");
    // taskcodecontrol.value.clear();
    statuscontrol.value.clear();
    taskgroupcontrol.value.clear();
    descriptionController.value.clear();
    taskgroupcontrol.value.clear();
    projectcontrol.value.clear();
    costCategorycontrol.value.clear();
    prioritycontrol.value.clear();
    totalhourscontrol.value.clear();
    percCompletedcontrol.value.clear();
    requesteedtocontrol.value.clear();
    assignedtocontrol.value.clear();
    delayReasoncontrol.value.clear();
    teamidController.value.clear();
    noteController.value.clear();
    scheduleStartDate.value = DateTime.now();
    scheduleendDate.value = DateTime.now();
    actualEndDate.value = DateTime.now();
    actualStartDate.value = DateTime.now();
    homeController.result.value = FilePickerResult([]);
    isNewRecord.value = true;
    update();
  }

  searchMytaskLIst(String value) {
    List<GetProjectTaskModel> list = filterMytaskList
        .where((element) =>
            (element.taskCode != null &&
                element.taskCode!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.createdBy != null &&
                element.createdBy!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.status != null &&
                element.status!.toLowerCase().contains(value.toLowerCase())) ||
            (element.requestedBy != null &&
                element.requestedBy!
                    .toLowerCase()
                    .contains(value.toLowerCase())))
        .toList();
    filterRecentDates(list);
    update();
  }

  validation() {
    if (statuscontrol.value.text.isEmpty &&
        descriptionController.value.text.isEmpty &&
        taskgroupcontrol.value.text.isEmpty &&
        descriptionController.value.text.isEmpty &&
        projectcontrol.value.text.isEmpty &&
        costCategorycontrol.value.text.isEmpty &&
        prioritycontrol.value.text.isEmpty &&
        totalhourscontrol.value.text.isEmpty &&
        percCompletedcontrol.value.text.isEmpty &&
        requesteedtocontrol.value.text.isEmpty &&
        assignedtocontrol.value.text.isEmpty &&
        delayReasoncontrol.value.text.isEmpty &&
        noteController.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please fill the details");
      return false;
    }
    // if (taskcodecontrol.value.text.isEmpty) {
    //   SnackbarServices.errorSnackbar("Please enter task code details");
    //   return false;
    // }

    if (statuscontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter status details");
      return false;
    }

    if (descriptionController.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter desccription details");
      return false;
    }

    if (taskgroupcontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter task group details");
      return false;
    }

    if (projectcontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter project details");
      return false;
    }

    if (costCategorycontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter cost category details");
      return false;
    }

    if (prioritycontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter priority details");
      return false;
    }

    if (totalhourscontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter total hours details");
      return false;
    }

    if (percCompletedcontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar(
          "Please enter percentage completed details");
      return false;
    }

    if (requesteedtocontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter requested by details");
      return false;
    }

    if (assignedtocontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter assigned to details");
      return false;
    }

    if (delayReasoncontrol.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter delay reason details");
      return false;
    }

    if (noteController.value.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please enter note details");
      return false;
    }

    return true;
  }

  searchMyTask(String value) {
    update();
  }

  clearSearch() {
    homeController.getJobList();
    homeController.getEmployeesList();
    update();
  }

  sendChat() async {
    chatsend.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api:
              'SaveComment?token=${token}&entityType=${EntityType.JobTask.value}&entityID=${homeController.nextcardnumbercontrol.text}&comment=${chatControl.text}');
      if (feedback != null) {
        if (feedback['res'] == 0) {
          SnackbarServices.errorSnackbar("${feedback['err']}");
        }
      }
    } finally {
      if (response.value == 1) {
        chatsend.value = false;
        chatList.value = chatList.reversed.toList();
        chatList.add(EntityCommentModel(
            commentId: 1,
            createdBy: UserSimplePreferences.getUsername(),
            dateCreated: DateTime.now(),
            dateUpdated: null,
            entityId: "${homeController.nextcardnumbercontrol.value}",
            entitySysDocId: null,
            entityType: EntityType.JobTask.value,
            note: "${chatControl.text}",
            rowIndex: null,
            updatedBy: null,
            userId: null));
        chatList.value = chatList.reversed.toList();
        chatControl.clear();
        log("${response.string}response string");
      }
    }
  }

  getChat() async {
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api:
              'GetEntityCommentList?token=${token}&entityType=${EntityType.JobTask.value}&entityID=${homeController.nextcardnumbercontrol.text}');

      if (feedback != null) {
        if (feedback['res'] == 0) {
          SnackbarServices.errorSnackbar("${feedback['err']}");
        } else {
          result = GetEntityCommentListModel.fromJson(feedback);
          response.value = result.result;
          chatList.value = result.modelobject.reversed.toList();
        }
      }
    } finally {
      if (response.value == 1) {
        log(response.string);
      }
    }
  }

  // RxList<ChatMessage> chatList = <ChatMessage>[].obs;

  // void sendChat() {
  //   chatsend.value = true;

  //   ChatMessage newMessage = ChatMessage(
  //     createdBy: UserSimplePreferences.getUsername().toString(),
  //     messageContent: chatControl.value.text,
  //     timestamp: DateTime.now(),
  //   );
  //   chatsend.value = false;
  //   chatControl.value.clear();

  //   chatList.insert(0, newMessage);
  // }

  void populateChatList() {
    chatList.value = [
      ChatMessage(
        createdBy: 'sa',
        messageContent: 'Hello',
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        createdBy: 'sa',
        messageContent: 'Hi',
        timestamp: DateTime.now(),
      ),
    ];
  }

  getColor(String code) {
    String colorcode = homeController.actionStatusComboList.firstWhere(
          (element) {
            // log("${element.code} ${code}");
            return element.code == code;
          },
          orElse: () => ActionStatusComboModel(),
        ).hexColorCode ??
        '';
    //log("${colorcode} colors");
    return colorcode;
  }

  filterJobLists(String value) async {
    homeController.filterJobList.value = homeController.jobList
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  filterEmployeeLists(String value) async {
    homeController.employeesFilterList.value = homeController.employeesList
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  List<MyTask> myTaskfiltermodeList = MyTask.values;
}

class ChatMessage {
  final String createdBy;
  final String messageContent;
  final DateTime timestamp;

  ChatMessage({
    required this.createdBy,
    required this.messageContent,
    required this.timestamp,
  });
}
