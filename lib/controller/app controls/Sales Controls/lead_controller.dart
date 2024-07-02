import 'dart:convert';
import 'dart:developer';
import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/model/Announcement%20Model/get_follow_up_model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_action_status_log_list_model.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/model/get_lead_list_detail_model.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/salesman_activity_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_area_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_country_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_lead_by_id_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_lead_open_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_source_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Leads%20Model/get_stage_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/api_constants.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadController extends GetxController {
  @override
  void onInit() {
    homeController.chatenabled.value = false;
    getlead();
    enterDatas();
    loadInitial();
    super.onInit();
  }

  final loginController = Get.put(LoginTokenController());
  // final salesmanActivitycontroller = Get.put(SalesmanActivityController());
  final homeController = Get.put(HomeController());
  final attendanceController = Get.put(AttendanceController());
  TextEditingController leadcodecontrol = TextEditingController();
  TextEditingController leadnamecontrol = TextEditingController();
  TextEditingController statuscontrol = TextEditingController();
  TextEditingController reasoncontrol = TextEditingController();
  TextEditingController companynamecontrol = TextEditingController();
  TextEditingController areacontrol = TextEditingController();
  TextEditingController countrycontrol = TextEditingController();
  TextEditingController sourcecontrol = TextEditingController();
  TextEditingController stagecontrol = TextEditingController();
  TextEditingController mobilecontrol = TextEditingController();
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController websitecontrol = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController remarkscontrol = TextEditingController();
  TextEditingController addresscontrol = TextEditingController();
  TextEditingController locationControl = TextEditingController();
  TextEditingController searchControl = TextEditingController();
  TextEditingController followupNoControl = TextEditingController();
  TextEditingController nextFollowupControl = TextEditingController();
  TextEditingController followupControl = TextEditingController();
  TextEditingController followUpStatusControl = TextEditingController();
  TextEditingController followUpRemarksControl = TextEditingController();
  TextEditingController nextFollowUpControl = TextEditingController();
  var searchController = TextEditingController().obs;
  var statusFilterController = TextEditingController(
          text: UserSimplePreferences.getLeadStatusFilter() ?? '')
      .obs;
  var salesPersonFilterController = TextEditingController(
          text: UserSimplePreferences.getSalesPersonFilter() ?? '')
      .obs;
  var leadIdFilterController =
      TextEditingController(text: UserSimplePreferences.getLeadIdFilter() ?? '')
          .obs;
  var response = 0.obs;
  var selectedvalue = ''.obs;
  var isLeadsIdLoading = false.obs;
  var filterList = [].obs;
  var isLoading = false.obs;
  var isOpenListLoading = false.obs;
  var leadsOpenList = [].obs;

  var isNewRecord = true.obs;

  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  var isLoadingsave = false.obs;
  var isLoadingSaveFollowUp = false.obs;
  var address = ''.obs;
  var addressMap = <String, dynamic>{}.obs;
  var isFetchingProgress = false.obs;
  var leadAddressModel = ModelAddress().obs;
  var salesPersonFilter = [].obs;
  var leadFilter = [].obs;
  var statusFilter = [].obs;
  var leadList = <LeadListDetailsModel>[].obs;
  var filterLeadList = <LeadListDetailsModel>[].obs;
  var filterSearchLeadList = <LeadListDetailsModel>[].obs;
  var filterSearchList = [].obs;
  var showCompletedToggle = false.obs;
  var isLeadListLoading = false.obs;
  String statusFilterId = 'Status';
  String salesPersonFilterId = 'SalesPerson';
  String leadFilterId = 'Lead';
  var statusFilterList = [].obs;
  var salesPersonFilterList = <String>[].obs;
  var changedDate = DateTime.now().obs;
  var followUpCalendarDates = <CalendarEvent>[].obs;
  var isCalendarLoading = false.obs;
  var selectedIndex = 0.obs;
//status
  var statusCode = TextEditingController().obs;
  var statusName = TextEditingController().obs;
  var sysDocId = TextEditingController().obs;
  var voucherId = TextEditingController().obs;
  var statusRef1Name = 'Ref 1'.obs;
  var statusRef1Controller = TextEditingController().obs;
  var statusRef2Name = 'Ref 2'.obs;
  var statusRef2Controller = TextEditingController().obs;
  var refDate = DateTime.now().obs;
  var actualDate = DateTime.now().obs;
  var actualtime = TimeOfDay.now().obs;
  var remarks = TextEditingController().obs;
  var isActionListLoading = false.obs;
  var filterActionStatusList = <ActionStatusComboModel>[].obs;
  var filterActionChangingStatusList = <ActionStatusSecuirityModel>[].obs;
  var selectedActionStatus = ActionStatusComboModel().obs;
  var actionStatusLog = <ActionStatusLogModel>[].obs;
  var actionStatusComboList = <ActionStatusComboModel>[].obs;
  var actionStatusChangingList = <ActionStatusSecuirityModel>[].obs;
  var selectedStatusValue = ActionStatusComboModel().obs;

  loadInitial() async {
    int index = UserSimplePreferences.getContainerDateFilter() ?? 8;
    await selectDateRange(
        index + 1,
        DateRangeSelector.dateRange.indexOf(DateRangeSelector.dateRange
            .firstWhere((element) => element.value == index + 1)));
    getLeadList();
  }

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  CreateLead() async {
    isLoadingsave.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    if (leadcodecontrol.text.isEmpty) {
      await getlead();
    }
    if (addressMap.isEmpty && isNewRecord.value) {
      await fetchLocationInfo();
    }
    final String token = loginController.token.value;
    String data = jsonEncode({
      "token": token,
      "Isnewrecord": isNewRecord.value,
      "LeadID": leadcodecontrol.text.trim(),
      "LeadName": leadnamecontrol.text,
      "ReasonID": reasoncontrol.text.split(' - ')[0],
      "CompanyName": companynamecontrol.text,
      "StageID": stagecontrol.text.split(' - ')[0],
      "AreaID": areacontrol.text.split(' - ')[0],
      "CountryID": countrycontrol.text.split(' - ')[0],
      "LeadSourceID": sourcecontrol.text.split(' - ')[0],
      "Remarks": remarkscontrol.text,
      "Status": statuscontrol.text.split(' - ')[0],
      "LeadAddressDetailsApiModel": {
        "Mobile": mobilecontrol.text,
        "Email": emailcontrol.text,
        "Website": websitecontrol.text,
        "ContactName": contactPerson.text,
        "Address1": isNewRecord.value
            ? addressMap['address_components'].length > 0
                ? addressMap['address_components'][0]['long_name']
                : ''
            : leadAddressModel.value.address1,
        "Address2": isNewRecord.value
            ? addressMap['address_components'].length > 1
                ? addressMap['address_components'][1]['long_name']
                : ''
            : leadAddressModel.value.address2,
        "Address3": isNewRecord.value
            ? addressMap['address_components'].length > 2
                ? addressMap['address_components'][2]['long_name']
                : ''
            : leadAddressModel.value.address3,
        "City": isNewRecord.value
            ? addressMap['address_components'].length > 3
                ? addressMap['address_components'][3]['long_name']
                : ''
            : leadAddressModel.value.city,
        "State": isNewRecord.value
            ? addressMap['address_components'].length > 4
                ? addressMap['address_components'][4]['long_name']
                : ''
            : leadAddressModel.value.state,
        "PostalCode": isNewRecord.value
            ? addressMap['address_components'].length > 6
                ? addressMap['address_components'][6]['long_name']
                : ''
            : leadAddressModel.value.postalCode,
        "Country": isNewRecord.value
            ? addressMap['address_components'].length > 5
                ? addressMap['address_components'][5]['long_name']
                : ''
            : leadAddressModel.value.country,
        "Longitude": isNewRecord.value
            ? addressMap['geometry']['location']['lng'].toString()
            : leadAddressModel.value.longitude.toString(),
        "Latitude": isNewRecord.value
            ? addressMap['geometry']['location']['lat'].toString()
            : leadAddressModel.value.latitude.toString()
      }
    });
    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'CreateLead', data: data);
      if (feedback != null) {
        if (feedback["res"] == 0) {
          response.value = feedback["res"];
          SnackbarServices.errorSnackbar("${feedback['err']}");
        } else {
          response.value = feedback["res"];
        }
      }
    } catch (e) {
      SnackbarServices.errorSnackbar("$e");
      isLoadingsave.value = false;
      update();
    } finally {
      if (response.value == 1) {
        SnackbarServices.successSnackbar('Successfully Updated as the lead');
        isLoadingsave.value = false;
        cleardata();
        getlead();
        enterDatas();
      }
    }
  }

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.leadDetails, type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.leadDetails, type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
  }

  cleardata() {
    leadnamecontrol.clear();
    statuscontrol.clear();
    reasoncontrol.clear();
    companynamecontrol.clear();
    stagecontrol.clear();
    areacontrol.clear();
    countrycontrol.clear();
    sourcecontrol.clear();
    mobilecontrol.clear();
    emailcontrol.clear();
    websitecontrol.clear();
    remarkscontrol.clear();
    addresscontrol.clear();
    contactPerson.clear();
    isNewRecord.value = true;
    addressMap.value = {};
    leadAddressModel.value = ModelAddress();
  }

  enterDatas() async {
    if (homeController.statusList.isEmpty) {
      await homeController.getStatusList();
    }

    if (homeController.stageList.isEmpty) {
      await homeController.getStageList();
    }
    if (homeController.sourceList.isEmpty) {
      await homeController.getSourceList();
    }
    if (homeController.regardinglist.isEmpty) {
      await homeController.getRegardingList();
    }
    if (homeController.countryList.isEmpty) {
      await homeController.getCountryList();
    }
    statuscontrol.text =
        '${homeController.statusList[0].code} - ${homeController.statusList[0].name}';
    stagecontrol.text =
        '${homeController.stageList[0].code} - ${homeController.stageList[0].name}';
    sourcecontrol.text =
        '${homeController.sourceList[0].code} - ${homeController.sourceList[0].name}';
    reasoncontrol.text =
        '${homeController.regardinglist[0].code} - ${homeController.regardinglist[0].name}';
    countrycontrol.text =
        '${homeController.countryList[0].code} - ${homeController.countryList[0].name}';
  }

  getlead() async {
    isLoading.value = true;
    isEnanbled();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetLeadCode?token=$token');
      if (feedback != null) {
        if (feedback['result'] == 1) {
          response.value = feedback['result'];
          leadcodecontrol.text = feedback['code'];
          isLoading.value = false;
        }
      }
    } finally {
      if (response.value == 1) {
        log(leadcodecontrol.text);
        isLoading.value = false;
      }
    }
  }

  bool validateField() {
    if (leadcodecontrol.text.isEmpty && leadnamecontrol.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please Enter required fields");
    } else if (leadcodecontrol.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please Enter Lead Code");
      return false;
    } else if (leadnamecontrol.text.isEmpty) {
      SnackbarServices.errorSnackbar("Please Enter Lead name");
      return false;
    }
    return true;
  }

  // //---------------------date----------------------------------//
  // DateTime date = DateTime.now();
  // var fromDate =
  //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //         .obs;
  // var toDate = DateTime.now().add(Duration(days: 1)).obs;
  // var isToDate = false.obs;
  // var isFromDate = false.obs;
  // var isCustomDate = false.obs;
  // var isEqualDate = false.obs;
  // var dateIndex = 0.obs;

  // // selectDateRange(int value, int index) async {
  // //   dateIndex.value = index;
  // //   isEqualDate.value = false;
  // //   isFromDate.value = false;
  // //   isToDate.value = false;
  // //   if (value == 16) {
  // //     isFromDate.value = true;
  // //     isToDate.value = true;
  // //   } else if (value == 15) {
  // //     isFromDate.value = true;
  // //     isEqualDate.value = true;
  // //   } else {
  // //     DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
  // //     fromDate.value = dateTime.start;
  // //     toDate.value = dateTime.end;
  // //   }
  // // }

  // // selectDate(context, bool isFrom) async {
  // //   DateTime? newDate = await CommonFilterControls.getCalender(
  // //       context, isFrom ? fromDate.value : toDate.value);
  // //   if (newDate != null) {
  // //     isFrom ? fromDate.value = newDate : toDate.value = newDate;
  // //     if (isEqualDate.value) {
  // //       toDate.value = fromDate.value;
  // //     }
  // //   }
  // //   update();
  // // }
  // //---------date start -------------//
//  DateTime date = DateTime.now();

  Future<DateTime> selectDate(context, var dates) async {
    DateTime? newDate = await CommonFilterControls.getCalender(context, dates);
    if (newDate != null) {
      dates = newDate;
    }
    update();
    return dates;
  }

// date end
//------------TIME----------------------------------------//
//D//ateTime time = DateTime.now();
  var lastFollowUpTime = TimeOfDay.now().obs;
  var nextFollowUpTime = TimeOfDay.now().obs;
  Future<TimeOfDay> selectTime(context, TimeOfDay times) async {
    TimeOfDay? newDate =
        await CommonFilterControls.getTimePicker(context, times);
    if (newDate != null) {
      times = newDate;
    }
    update();
    return times;
  }

  //------------------------------------------------------------//
  getLeadOpenList() async {
    isOpenListLoading.value = true;
    final salesPersonId = homeController.user.value.isAdmin == true
        ? ''
        : homeController.salesPersonId;
    log("username $salesPersonId");
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    var result;
    try {
      final feedback = await ApiServices.fetchDataCRM(
          api: homeController.user.value.isAdmin == true
              ? 'GetLeadOpenList?token=$token'
              : 'GetLeadOpenList?token=$token&defaultSalespersonID=$salesPersonId');
      log("$feedback");
      if (feedback != null) {
        result = GetLeadOpenListModel.fromJson(feedback);
        log("{$result}");

        leadsOpenList.value = result.modelobject;
        filterList.value = leadsOpenList.value;
        isOpenListLoading.value = false;
      }
    } finally {
      isOpenListLoading.value = false;
    }
  }

  getLeadById(String leadID) async {
    final username = UserSimplePreferences.getUsername() ?? '';

    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    var result;
    try {
      final feedback = await ApiServices.fetchDataCRM(
          api: 'GetLeadByID?token=$token&leadID=$leadID');
      if (feedback != null) {
        result = GetLeadByIdModel.fromJson(feedback);
        leadAddressModel.value = result.modelAddress[0];
      }
    } finally {
      final itemModelobject = result.modelobject[0];
      final itemModelAddress = result.modelAddress[0];
      leadcodecontrol.text = '${itemModelobject.leadId ?? ' '}';
      leadnamecontrol.text = '${itemModelobject.leadName ?? ' '}';
      statuscontrol.text = '${itemModelobject.leadStatus ?? ' '}';
      stagecontrol.text = '${itemModelobject.stageId ?? ' '}';
      sourcecontrol.text = '${itemModelobject.leadSourceId ?? ' '}';
      reasoncontrol.text = '${itemModelobject.reasonId ?? ' '}';
      companynamecontrol.text = '${itemModelobject.companyName ?? ' '}';
      mobilecontrol.text = '${itemModelAddress.mobile}';
      emailcontrol.text = '${itemModelAddress.email ?? ' '}';
      websitecontrol.text = '${itemModelAddress.website}';
      countrycontrol.text = '${itemModelobject.countryId ?? ' '}';
      areacontrol.text = '${itemModelobject.areaId ?? ' '}';
      remarkscontrol.text = '${itemModelobject.remarks ?? ' '}';
      contactPerson.text = '${itemModelAddress.contactName ?? ''}';
    }
  }

//------------------------url launcher------------------------------//
  Future<void> phoneCallLaunch(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  whatsAppLaunch(String number) {
    FocusManager.instance.primaryFocus?.unfocus();

    var whatsappUrl = "whatsapp://send?phone=${number}";
    try {
      launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      //To handle error and display error message
      SnackbarServices.errorSnackbar("Unable to open whatsapp");
    }
  }

  emailLaunch(String text) async {
    String email = Uri.encodeComponent(text);
    //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$email");
    if (await launchUrl(mail)) {
      //email app opened
    } else {
      //email app is not opened
    }
  }

  Future<void> launchInBrowser(String websitelink) async {
    log("${websitecontrol.text.contains('http')}");
    final website = websitecontrol.text.contains('http://')
        ? websitelink
        : 'http://$websitelink';
    if (!await launchUrl(
      Uri.parse(website),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $websitelink');
    }
  }

  //--------------------url laucnher-----------------------------//
  search(String value, var list) {
    filterList.value = list.value
        .where((element) =>
            element.leadCode.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()) ||
            element.company.toLowerCase().contains(value.toLowerCase()) ||
            element.city.toLowerCase().contains(value.toLowerCase()) ||
            element.phone.toLowerCase().contains(value.toLowerCase()) ||
            element.mobile.toLowerCase().contains(value.toLowerCase()) ||
            element.source.toLowerCase().contains(value.toLowerCase()) ||
            element.owner.toLowerCase().contains(value.toLowerCase()) ||
            element.country.toLowerCase().contains(value.toLowerCase()) ||
            element.area.toLowerCase().contains(value.toLowerCase()) as bool)
        .toList();
  }

  var lastFollowUpDate = DateTime.now().obs;
  var nextFollowUpDate = DateTime.now().obs;
  followUp(BuildContext context) {
    followupControl.text = UserSimplePreferences.getUsername() ?? '';
    nextFollowupControl.text = UserSimplePreferences.getUsername() ?? '';
    getFollowUpNo();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Center(
                child: Text(
                  "Follow Up",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          disabledTextfield("Follow Up No:", followupNoControl),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    disabledTextfield(
                      "Last Follow Up on",
                      TextEditingController(
                        text:
                            "${DateFormatter.dateFormat.format(lastFollowUpDate.value).toString()} ${lastFollowUpTime.value.format(context)}",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    disabledTextfield(
                      "Follow Up By",
                      followupControl,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // CommonTextField.textfield(isDisabled: false,
                    //   suffixicon: true,
                    //   readonly: true,
                    //   keyboardtype: TextInputType.text,
                    //   label: "Status",
                    //   ontap: () {
                    //     homeController.selectCRMList(
                    //       context: context,
                    //       text: "Follow Up Status",
                    //       controller: followUpStatusControl,
                    //       list: homeController.followUpStatusList,
                    //       oneditingcomplete: () async {
                    //         await salesmanActivitycontroller
                    //             .changeFocus(context);
                    //       },
                    //     );
                    //   },
                    //   icon: Icons.arrow_drop_down,
                    //   controller: followUpStatusControl,
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.text,
                              ontap: () async {
                                nextFollowUpDate.value = await selectDate(
                                    context, nextFollowUpDate.value);
                              },
                              label: "Next Follow Up on",
                              controller: TextEditingController(
                                text: DateFormatter.dateFormat
                                    .format(nextFollowUpDate.value)
                                    .toString(),
                              ),
                              icon: Icons.calendar_month),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            ontap: () async {
                              nextFollowUpTime.value = await selectTime(
                                  context, nextFollowUpTime.value);
                            },
                            label: "",
                            controller: TextEditingController(
                              text: nextFollowUpTime.value.format(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CommonTextField.textfield(
                        suffixicon: true,
                        readonly: true,
                        keyboardtype: TextInputType.text,
                        label: "Next Follow Up By",
                        ontap: () {
                          homeController.selectCRMList(
                            context: context,
                            text: "Next Follow Up By",
                            controller: nextFollowupControl,
                            list: homeController.nextFollowUpList,
                            oneditingcomplete: () async {
                              // await salesmanActivitycontroller
                              //     .changeFocus(context);
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          );
                        },
                        controller: nextFollowupControl,
                        icon: Icons.arrow_drop_down),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        child: TextField(
                      style:
                          TextStyle(fontSize: 12, color: AppColors.mutedColor),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.mutedColor, width: 0.1),
                        ),
                        labelText: "Remarks",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                      ),
                      autofocus: false,
                      maxLines: null,
                      controller: followUpRemarksControl,
                      keyboardType: TextInputType.text,
                    )

                        // salesmanActivitycontroller.multilinetextfield(
                        //     label: "Remarks",
                        //     controller: followUpRemarksControl)
                        ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          clearData();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          //  fixedSize: Size(60, 40),
                          maximumSize: Size(70, 35),
                          minimumSize: Size(60, 32),
                          backgroundColor: AppColors.mutedBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await createFollowUp();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        //  fixedSize: Size(60, 40),
                        maximumSize: Size(70, 35),
                        minimumSize: Size(60, 32),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoadingsave.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ))
                          : Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  createFollowUp() async {
    isLoadingSaveFollowUp.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final followUpDate = this.lastFollowUpDate.value.toString().split(' ')[0];
    final followUpTime = timeformat(this.lastFollowUpTime.value);

    final nextFollowUpDate =
        this.nextFollowUpDate.value.toString().split(' ')[0];
    final nextFollowUpTime = timeformat(this.nextFollowUpTime.value);

    log("$followUpDate $followUpTime");
    final String token = loginController.token.value;
    String data = jsonEncode({
      "token": token,
      "Isnewrecord": true,
      "LeadID": leadcodecontrol.text,
      "FollowupID": followupNoControl.text,
      "ThisFollowupDate": "${followUpDate}T$followUpTime",
      "NextFollowupDate": "${nextFollowUpDate}T$nextFollowUpTime",
      "ThisFollowupByID": followupControl.text.split(' - ')[0],
      "NextFollowupByID": nextFollowupControl.text.split(' - ')[0],
      "ThisFollowupStatusID": followUpStatusControl.text.split(' - ')[0],
      "Remark": followUpRemarksControl.text
    });
    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'CreateFollowUp', data: data);
      log("$feedback");
      if (feedback != null) {
        if (feedback["res"] == 0) {
          isLoadingSaveFollowUp.value = false;
          SnackbarServices.errorSnackbar("${feedback['err']}");
          response.value = feedback["res"];
        } else {
          log("${feedback['err']}");
          response.value = feedback["res"];
        }
      }
    } finally {
      if (response.value == 1) {
        isLoadingSaveFollowUp.value = false;
        log(response.toString());
        SnackbarServices.successSnackbar('Successfully Created the Follow Up');

        clearData();
      }
    }
  }

  clearData() {
    followupNoControl.clear();
    lastFollowUpDate.value = DateTime.now();
    nextFollowUpDate.value = DateTime.now();
    lastFollowUpTime.value = TimeOfDay.now();
    nextFollowUpTime.value = TimeOfDay.now();
    followUpRemarksControl.clear();
    followUpStatusControl.clear();
    followupControl.clear();
    nextFollowupControl.clear();
  }

  timeformat(TimeOfDay followUpTime) {
    final dateTime = DateTime(0, 0, 0, followUpTime.hour, followUpTime.minute);

    final formatter = DateFormat('HH:mm:ss.SSS');
    final formattedTime = formatter.format(dateTime);
    return formattedTime;
  }

  getFollowUpNo() async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetFollowUpNember?token=$token');
      if (feedback != null) {
        followupNoControl.text = feedback['code'];
      }
    } finally {}
  }

  disabledTextfield(
    String label,
    TextEditingController controller,
  ) {
    return SizedBox(
      // height: 35.0,
      child: TextField(
        maxLines: 1,
        controller: controller,
        enabled: false,
        style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isCollapsed: true,
          isDense: true,
          fillColor: AppColors.lightGrey,
          //  filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.mutedColor, width: 0.1),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.mutedColor,
          ),
        ),
      ),
    );
  }

  Future<void> fetchLocationInfo({int? index}) async {
    log('Fetching Location');
    isFetchingProgress.value = true;
    selectedIndex.value = index ?? 0;
    await attendanceController.getCurrentLocation();
    double lat = double.parse(UserSimplePreferences.getLatitude() ?? "");
    double lng = double.parse(UserSimplePreferences.getLongitude() ?? "");
    final String apiKey = Api.getGoogleApiKey();

    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['results'].isNotEmpty) {
          addressMap.value = decoded['results'][0];
          if (decoded['results'][0]['formatted_address'].toString().length <
              200) {
            address.value =
                decoded['results'][0]['formatted_address'].toString();
          } else {
            address.value = decoded['results'][0]['formatted_address']
                .toString()
                .substring(200);
          }
        } else {
          address.value = '';
        }
        log(address.value);
      }
      // }
    } catch (e) {
      print(e);
      SnackbarServices.errorSnackbar("${e}");
      // address.value = "Error fetching location";
    } finally {
      isFetchingProgress.value = false;
    }
  }

  getLeadList() async {
    if (isLeadListLoading.value) {
      return;
    }
    isLeadListLoading.value = true;
    update();
    searchController.value.clear();
    leadList.clear();
    filterLeadList.clear();
    filterSearchLeadList.clear();
    leadFilter.clear();
    salesPersonFilter.clear();
    statusFilter.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String statusParams = statusFilterList.isNotEmpty
        ? "&statuslist='${statusFilterList.join("','")}'"
        : '';
    String salesPersonParams = salesPersonFilterList.isNotEmpty
        ? "&salespersonList='${salesPersonFilterList.join("','")}'"
        : '';
    String leadIdParams = leadIdFilterController.value.text.isNotEmpty
        ? "&leadID=${leadIdFilterController.value.text.split('-')[0]}"
        : '';

    String defaultSalespersonParams = homeController.user.value.isAdmin == true
        ? ''
        : '&defaultSalesPerson=${homeController.salesPersonId}';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api:
              "GetLeadListDetails?token=$token$statusParams$defaultSalespersonParams&showCompleted=${showCompletedToggle.value}$salesPersonParams$leadIdParams");
      if (feedback != null) {
        result = GetLeadListDetailsModel.fromJson(feedback);
        leadList.value = result.modelobject;
        filterSearchLeadList.value = result.modelobject;

        filterLeadList.value = leadList;
        filterLeadListAccordingTodate();

        leadFilter.value = result.modelobject
            .map((item) =>
                "${item.docId.toString()}-${item.leadName.toString()}")
            .toList()
            .toSet()
            .toList();
        statusFilter.value = result.modelobject
            .map((item) => item.status.toString())
            .toList()
            .toSet()
            .toList();
        if (homeController.user.value.isAdmin == true) {
          await homeController.getSalesPersonList();
          var list = result.modelobject
              .map((item) => item.salesperson.toString())
              .toList()
              .toSet()
              .toList();
          salesPersonFilter.value = homeController.salesPersonList
              .where(
                  (element) => list.any((element2) => element.name == element2))
              .toList();
          update();
        }
        update();
      }
      await getActionStatusComboList();
      isLeadListLoading.value = false;
      update();
    } finally {
      isLeadListLoading.value = false;
      // await homeController.getLeadList();

      // salesPersonFilter.value = homeController.salesPersonList;
      update();
    }
  }

  toggleCompleted() {
    showCompletedToggle.value = !showCompletedToggle.value;
    update();
  }
  //--------------------------Date---------------------------------//

  DateTime date = DateTime.now();
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var isCustomDate = false.obs;
  var isEqualDate = false.obs;
  var dateIndex = 0.obs;

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
    UserSimplePreferences.setLeadDateFilter(dateIndex.value);
  }

  selectDates(context, bool isFrom) async {
    DateTime? newDate = await CommonFilterControls.getCalender(
        context, isFrom ? fromDate.value : toDate.value);
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  //-----------------------------------------------------------------------//
  searchLeadLIst(String value) {
    List<LeadListDetailsModel> list = filterLeadList
        .where((element) =>
            (element.docId != null &&
                element.docId!.toLowerCase().contains(value.toLowerCase())) ||
            (element.leadName != null &&
                element.leadName!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.status != null &&
                element.status!.toLowerCase().contains(value.toLowerCase())) ||
            (element.salesperson != null &&
                element.salesperson!
                    .toLowerCase()
                    .contains(value.toLowerCase())))
        .toList();
    filterRecentDates(list);
    update();
  }

  clearSearch() {
    if (searchController.value.text.isNotEmpty) {
      searchController.value.clear();
      searchLeadLIst('');
    }

    update();
  }

  clearFilter() {
    leadIdFilterController.value.clear();
    statusFilterController.value.clear();
    salesPersonFilterController.value.clear();
    statusFilterList.clear();
    salesPersonFilterList.clear();
    filterLeadSearchList();
    update();
  }

  filterLeadSearchList() {
    log(statusFilterList.toString(), name: 'Port');
    filterLeadList.value = leadList
        .where((element) =>
            (
                // element.vendorName != null &&
                //   vendorFilterController.value.text.isNotEmpty &&
                element.salesperson.toString().toLowerCase().contains(
                    salesPersonFilterController.value.text.toLowerCase())) &&
            (statusFilterList.isNotEmpty
                ? (
                        // element.actionstatuslog != null &&
                        //   statusFilterController.value.text.isNotEmpty &&
                        statusFilterList.any((item) =>
                            item.toLowerCase() ==
                            element.status.toString().toLowerCase())
                    // element.actionstatuslog.toString().toLowerCase().contains(
                    //     statusFilterController.value.text.toLowerCase())
                    )
                : true) &&
            (element.docId
                .toString()
                .toLowerCase()
                .contains(leadIdFilterController.value.text.toLowerCase())))
        .toList();
    update();
    filterSearchLeadList.value = filterLeadList;
    update();

    UserSimplePreferences.setLeadIdFilter(leadIdFilterController.value.text);
    UserSimplePreferences.setLeadStatusFilter(
        statusFilterController.value.text);
    UserSimplePreferences.setSalesPersonFilter(
        salesPersonFilterController.value.text);
    update();
  }

  searchFilter({required String filterId, required String value}) {
    if (filterId == statusFilterId) {
      filterSearchList.value = statusFilter
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
      update();
    } else if (filterId == salesPersonFilterId) {
      filterSearchList.value = salesPersonFilter
          .where((element) =>
              element.code.toLowerCase().contains(value.toLowerCase()) ||
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      update();
    } else if (filterId == leadFilterId) {
      filterSearchList.value = leadFilter
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
      update();
    }
  }

  selectFilterValue({required String filterId, required String value}) {
    if (filterId == statusFilterId) {
      if (statusFilterList.contains(value)) {
        statusFilterList.remove(value);
      } else {
        statusFilterList.add(value);
      }
      statusFilterController.value.text = statusFilterList.join(' , ');

      update();
    } else if (filterId == leadFilterId) {
      leadIdFilterController.value.text = value;
      update();
    } else if (filterId == salesPersonFilterId) {
      if (salesPersonFilterList.contains(value)) {
        salesPersonFilterList.remove(value);
      } else {
        salesPersonFilterList.add(value);
      }
      salesPersonFilterController.value.text =
          salesPersonFilterList.join(' , ');

      update();
    }
  }

  filterLeadListAccordingTodate() {
    log("${fromDate.value} ${toDate.value}");
    filterLeadList.value = leadList
        .where((element) =>
            element.leadCreated!.isAfter(DateTime(fromDate.value.year,
                fromDate.value.month, fromDate.value.day, 00, 00, 00)) &&
            element.leadCreated!.isBefore(DateTime(toDate.value.year,
                toDate.value.month, toDate.value.day, 59, 59, 59)))
        .toList();
    if (searchController.value.text.isNotEmpty) {
      searchLeadLIst(searchController.value.text.trim());
    } else {
      filterRecentDates(filterLeadList);
      update();
    }

    update();
  }

  filterRecentDates(List<LeadListDetailsModel> dates) {
    if (dates != null && dates.isNotEmpty) {
      dates.sort((a, b) {
        DateTime dateA = a.leadCreated!;
        DateTime dateB = b.leadCreated!;
        return dateB.compareTo(dateA); // Descending order
      });
      filterSearchLeadList.value = dates;
      update();
    } else {
      // Handle empty or null list here
    }
  }

  getActionStatusComboList() async {
    if (actionStatusComboList.isNotEmpty) {
      await getActionStatusSecurityList();
      return;
    }
    isLoading.value = true;
    actionStatusComboList.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetActionStatusComboList?token=$token');
      if (feedback != null) {
        result = GetActionStatusComboListModel.fromJson(feedback);
        actionStatusComboList.value = result.modelobject;
        filterActionStatusList.value = actionStatusComboList;
        await getActionStatusSecurityList();
      }
      isLoading.value = false;
      update();
    } finally {}
  }

  getActionStatusSecurityList() async {
    isLoading.value = true;
    // actionStatusChangingList.value.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetActionStatusSecurity?token=$token');
      if (feedback != null) {
        result = GetActionStatusSecurityModel.fromJson(feedback);
        var list = result.modelobject;
        actionStatusChangingList.value = list
            .where(
                (element) => element.statusType == 2 && element.isView == true)
            .toList();
        filterActionChangingStatusList.value = actionStatusChangingList;
        if (filterActionChangingStatusList.isNotEmpty) {
          filterActionStatusList.value = actionStatusComboList
              .where((element) => containsMatchingObject(element))
              .toList();
          update();
        } else {
          filterActionStatusList.value = actionStatusComboList
              .where((element) => element.statusType == 2)
              .toList();
          update();
        }
      }
      isLoading.value = false;
      update();
    } finally {}
  }

  bool containsMatchingObject(var element) {
    return filterActionChangingStatusList.any((obj2) {
      return obj2.statusId == element.code;
    });
  }

  ActionStatusComboModel? getActionStatus(String statusId) {
    return actionStatusComboList
        .firstWhere((element) => element.code == statusId, orElse: null);
  }

  ActionStatusComboModel getActionStatusCombo(String code) {
    ActionStatusComboModel combo = actionStatusComboList.firstWhere(
      (element) => element.code == code,
      orElse: () => ActionStatusComboModel(name: ''),
    );
    return combo;
  }

  getActionStatusLogList(String docid) async {
    isActionListLoading.value = true;
    actionStatusLog.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api: 'GetActionStatusLogList?token=$token&VoucherID=${docid}');
      if (feedback != null) {
        result = GetActionStatusLogListModel.fromJson(feedback);
        actionStatusLog.value = result.modelobject.reversed.toList();
      }
      isActionListLoading.value = false;
      update();
    } finally {
      isActionListLoading.value = false;
      update();
    }
  }

  searchStatusLIst(String value) {
    filterActionStatusList.value = actionStatusComboList
        .where((element) =>
            element.code!.toLowerCase().contains(value.toLowerCase()) &&
                containsMatchingObject(element) ||
            element.name!.toLowerCase().contains(value.toLowerCase()) &&
                containsMatchingObject(element))
        .toList();
    update();
  }

  getLeadByidFromListScreen(LeadListDetailsModel item) {
    leadcodecontrol.text = item.docId ?? '';
    leadnamecontrol.text = item.leadName ?? '';
    statuscontrol.text = item.status ?? '';
    stagecontrol.text = item.stage ?? '';
    sourcecontrol.text = item.source ?? '';
    reasoncontrol.text = item.reason ?? '';
    companynamecontrol.text = item.companyName ?? '';
    // nextFollowUpControl.text=item.n
    contactPerson.text = item.contactName ?? '';

    mobilecontrol.text = item.mobile ?? '';
    emailcontrol.text = item.email ?? '';
    websitecontrol.text = item.website ?? '';
    countrycontrol.text = item.countryName ?? '';
    areacontrol.text = item.areaName ?? '';
    remarkscontrol.text = item.remarks ?? '';
    isNewRecord.value = false;
    update();
  }

  createActionLogStatus(
    int index,
  ) async {
    final username = UserSimplePreferences.getUsername() ?? '';

    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    var data = jsonEncode({
      "token": token,
      "SysDocID": "",
      // sysDocId.value.text,
      "VoucherID": voucherId.value.text,
      "Isnewrecord": true,
      "IsCard": false,
      "DocType": 0,
      "LogStatus": statusCode.value.text,
      "Remarks": remarks.value.text,
      "Reference1": statusRef1Controller.value.text,
      "Reference2": statusRef2Controller.value.text,
      "ReferenceDate": refDate.value.toIso8601String(),
      "StatusType": ActionStatusType.Lead.value,
      "UpdatedBy": username,
      "DateUpdated": DateTime.now().toIso8601String(),
      "ActualDateTime": DateTime(
              actualDate.value.year,
              actualDate.value.month,
              actualDate.value.day,
              actualtime.value.hour,
              actualtime.value.minute)
          .toIso8601String()
    });

    try {
      log("${data}");
      var feedback = await ApiServices.fetchDataRawBodyInventory(
          api: 'CreateActionLogStatus', data: data);
      if (feedback != null) {
        log("message");
        getLeadList();
      }
      update();
    } finally {}
  }

  getNextFollowUpDatesList({required String leadId, required int index}) async {
    isCalendarLoading.value = true;
    selectedIndex.value = index;
    // update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    GetFollowUpModel result;
    try {
      var feedback =
          await ApiServices.fetchDataCRM(api: 'GetFollowUpList?token=$token');
      if (feedback != null) {
        result = GetFollowUpModel.fromJson(feedback);
        followUpCalendarDates.value = result.modelobject!
            .where((element) => element.sourceVoucherId == leadId)
            .toList()
            .map(mapObjects)
            .toList();
        update();
      }
      // isCalendarLoading.value = false;
    } finally {
      isCalendarLoading.value = false;
      update();
    }
  }

  CalendarEvent mapObjects(FollowUpModel sourceObject) {
    // Perform the mapping logic here
    DateTime eventDate = sourceObject.nextfollowupDate ?? DateTime.now();
    String eventName =
        sourceObject.remark != null && sourceObject.remark!.isNotEmpty
            ? sourceObject.remark!
            : 'No Remarks';
    Color eventBackColor = sourceObject.followUpStatus == null
        ? AppColors.mutedColor
        : sourceObject.followUpStatus == FollowUpStatus.Open.value
            ? FollowUpStatus.Open.color
            : sourceObject.followUpStatus == FollowUpStatus.InProgress.value
                ? FollowUpStatus.InProgress.color
                : sourceObject.followUpStatus == FollowUpStatus.Completed.value
                    ? FollowUpStatus.Completed.color
                    : AppColors.mutedColor;
    String eventId = sourceObject.followupId ?? '';
    // Create and return a new DestinationObject
    return CalendarEvent(
        eventDate: eventDate,
        eventName: eventName,
        eventBackgroundColor: eventBackColor,
        eventID: eventId);
  }
}
