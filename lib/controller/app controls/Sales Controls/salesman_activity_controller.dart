import 'dart:convert';
import 'dart:developer';
import 'package:axolon_erp/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/attendancde_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/activity_reason_list_model..dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/activity_type_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/entity_comment_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/contacts_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/get_activity_by_id_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/get_activity_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/get_users_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:geocoding/geocoding.dart';

class SalesmanActivityController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    homeController.chatenabled.value = false;
    presetSysdoc();
    enterDatas();
  }

  final attendanceController = Get.put(AttendanceController());
  final loginController = Get.put(LoginTokenController());
  final salesscreenController = Get.put(SalesController());
  final homeController = Get.put(HomeController());
  TextEditingController activityNameControl = TextEditingController(text: " ");
  TextEditingController activityTypeControl = TextEditingController(text: " ");
  TextEditingController regardingControl = TextEditingController(text: " ");
  TextEditingController relatedToControl = TextEditingController(text: " ");
  var relatedtoitemscontrol = TextEditingController(text: " ").obs;
  TextEditingController contactControl = TextEditingController(text: " ");
  TextEditingController activityByControl = TextEditingController(text: " ");
  TextEditingController noteControl = TextEditingController(text: " ");
  TextEditingController chatControl = TextEditingController();
  TextEditingController sysDocIdControl = TextEditingController(text: " ");
  TextEditingController voucherControl = TextEditingController(text: " ");
  DateTime date = DateTime.now();
  var address = "".obs;
  var relatedTo = RelatedtypeOptions.Lead.obs;
  var isSelectedRelatedto = false.obs;
  var selectedvalue = ''.obs;
  var sysDocId = ''.obs;
  var sysDocName = ' '.obs;
  var voucherNumber = ''.obs;
  var isVoucherLoading = false.obs;
  var sysDocList = [].obs;
  var isSalesOrderByIdLoading = false.obs;
  var relatedtolist = [{}].obs;
  var chatList = [].obs;
  var isLoading = false.obs;
  var isLoadingSave = false.obs;
  var response = 0.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var isEqualDate = false.obs;
  var isToDate = false.obs;
  var isFromDate = false.obs;
  var dateIndex = 0.obs;
  var isOpenListLoading = false.obs;
  var salesmanActivityOpenList = [].obs;
  var isNewRecord = true.obs;
  var chatsend = false.obs; //for chat screen

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  presetSysdoc() async {
    if (salesscreenController.isLoading.value == false) {
      await generateSysDocList();
      getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
    } else {
      await Future.delayed(Duration(seconds: 0));
      presetSysdoc();
    }
  }

  enterDatas() async {
    if (homeController.activitytypelist.isEmpty) {
      await homeController.getActivityTypeList();
    }
    if (homeController.regardinglist.isEmpty) {
      await homeController.getRegardingList();
    }
    if (homeController.contactlist.isEmpty) {
      await homeController.getContactsList();
    }
    if (homeController.activitybylist.isEmpty) {
      await homeController.getActivitybyList();
    }
    activityTypeControl.text =
        "${homeController.activitytypelist[0].code} - ${homeController.activitytypelist[0].name}";
    regardingControl.text =
        "${homeController.regardinglist[0].code} - ${homeController.regardinglist[0].name}";
    contactControl.text =
        "${homeController.contactlist[0].code} - ${homeController.contactlist[0].name}";
    activityByControl.text =
        "${homeController.activitybylist[0].code} - ${homeController.activitybylist[0].name}";
  }

  generateSysDocList() async {
    sysDocList.clear();
    for (var element in salesscreenController.sysDocList) {
      if (element.sysDocType == 114) {
        sysDocList.add(element);
      }
    }
  }

  getVoucherNumber(String sysDocId, String name) async {
    isVoucherLoading.value = true;
    this.sysDocId.value = sysDocId;
    sysDocName.value = name;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String date = DateTime.now().toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetNextDocumentNo?token=${token}&sysDocID=${sysDocId}&dateTime=${date}');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        voucherNumber.value = result.model;
        isVoucherLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(voucherNumber.value.toString(), name: 'Voucher Number');
      }
    }
  }

  Widget textfield(
          {Function()? ontap,
          String? label,
          TextEditingController? controller,
          required bool suffixicon,
          required bool readonly,
          required TextInputType keyboardtype}) =>
      TextField(
        controller: controller!.text.isEmpty
            ? TextEditingController(text: ' ')
            : controller,
        // enabled: false,
        readOnly: readonly,
        onTap: ontap,
        onChanged: (value) {
          if (controller.text.isEmpty) {
            controller.text = " ";
          }
        },

        keyboardType: keyboardtype,
        style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.mutedColor, width: 0.1),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
          suffixIcon: suffixicon == true
              ? Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ),
      );
  multilinetextfield({
    String? label,
    TextEditingController? controller,
  }) =>
      TextField(
        style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
        decoration: InputDecoration(
          isCollapsed: true,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.mutedColor, width: 0.1),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        ),
        autofocus: false,
        maxLines: null,
        controller: controller,
        keyboardType: TextInputType.text,
      );
  createActivity() async {
    isLoadingSave.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    await attendanceController.getCurrentLocation();
    await fetchLocationInfo(
        double.parse(UserSimplePreferences.getLatitude() ?? ""),
        double.parse(UserSimplePreferences.getLongitude() ?? ""));
    String data = jsonEncode({
      "token": token,
      "SysDocID": sysDocId.value,
      "VoucherID": voucherNumber.value,
      "Isnewrecord": isNewRecord.value,
      "ActivityName": activityNameControl.text,
      "ActivityType": activityTypeControl.text.split(' - ')[0],
      "ReasonID": regardingControl.text.split(' - ')[0],
      "RelatedID": relatedtoitemscontrol.value.text.split(' - ')[0],
      "RelatedType": relatedTo.value == RelatedtypeOptions.Lead ? 1 : 2,
      "ContactID": contactControl.text.split(" - ")[0],
      "OwnerID": activityByControl.text.split(' - ')[0],
      "Note": noteControl.text,
      "Latitude": UserSimplePreferences.getLatitude().toString(),
      "Longitude": UserSimplePreferences.getLongitude().toString(),
      "Area": address.value,
    });
    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'CreateActivity', data: data);
      log("$feedback");
      if (feedback != null) {
        if (feedback["res"] == 0) {
          isLoadingSave.value = false;
          SnackbarServices.errorSnackbar("${feedback['err']}");
          response.value = feedback["res"];
        } else {
          log("${feedback['err']}");
          response.value = feedback["res"];
        }
      }
    } finally {
      if (response.value == 1) {
        if (homeController.result.value != FilePickerResult([])) {
          await homeController.addAttachment(
              sysDocId.value, voucherNumber.value, EntityType.Transactions,);
        }
        isLoadingSave.value = false;
        log("${response.toString()}");
        SnackbarServices.successSnackbar('Successfully Created the Activity');

        clearData();
        getVoucherNumber(sysDocId.value, sysDocName.value);
        enterDatas();
      }
    }
  }

  Future<void> fetchLocationInfo(double lat, double lng) async {
    final String apiKey = Api.getGoogleApiKey();
    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['results'].isNotEmpty) {
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
        developer.log(address.value);
        // developer.log(decoded['results'][0]['formatted_address'].toString());
      }
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   lat,
      //   lng,
      //   localeIdentifier: 'en_US',
      // );

      // if (placemarks.isNotEmpty) {
      //   Placemark placemark = placemarks.first;
      //   if (placemark.subLocality!.length < 200) {
      //     address.value = "${placemark.locality}";
      //   } else {
      //     address.value = placemark.locality!.substring(200);
      //   }
      // } else {
      //   address.value = "Location not found";
      // }
    } catch (e) {
      print(e);

      address.value = "Error fetching location";
    }
  }

  clearData() {
    activityNameControl.text = ' ';
    activityTypeControl.text = ' ';
    regardingControl.text = ' ';
    relatedtoitemscontrol.value.text = ' ';
    contactControl.text = ' ';
    activityByControl.text = ' ';
    noteControl.text = ' ';
    homeController.result.value = FilePickerResult([]);
    homeController.chatenabled.value = false;
    relatedTo.value = RelatedtypeOptions.Lead;
    isNewRecord.value = true;
  }

  bool validateField() {
    if (activityTypeControl.text == ' ' &&
            activityNameControl.text == ' ' &&
            activityByControl.text == ' ' &&
            contactControl.text == ' ' &&
            relatedtoitemscontrol.value.text == ' '
        // &&
        // regardingControl.text == ' '
        ) {
      SnackbarServices.errorSnackbar("Please enter required datas");
      return false;
    } else if (activityNameControl.text == ' ') {
      SnackbarServices.errorSnackbar("Please select Activity name");
      return false;
    } else if (activityTypeControl.text == ' ') {
      SnackbarServices.errorSnackbar("Please select Activity type");
      return false;
    }
    // else if (regardingControl.text == ' ') {
    //   SnackbarServices.errorSnackbar("Please select Regarding");
    //   return false;
    // }
    else if (relatedtoitemscontrol.value.text == ' ') {
      SnackbarServices.errorSnackbar(
          "Please select ${relatedTo.value == RelatedtypeOptions.Lead ? "Lead" : "Customer"}");
      return false;
    } else if (contactControl.text == ' ') {
      SnackbarServices.errorSnackbar("Please select Contact");
      return false;
    } else if (activityByControl.text == ' ') {
      SnackbarServices.errorSnackbar("Please select Activity By");
      return false;
    }
    return true;
  }
  //---for chat screen

  sendChat() async {
    chatsend.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    try {
      var feedback = await ApiServices.fetchDataRawBody(
          api:
              'SaveComment?token=${token}&entityType=${relatedTo.value == RelatedtypeOptions.Lead ? 5 : 1}&entityID=${relatedtoitemscontrol.value.text.split(' - ')[0]}&comment=${chatControl.text}');
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
            entityId: "${voucherNumber}",
            entitySysDocId: null,
            entityType: 5,
            note: "${chatControl.text}",
            rowIndex: null,
            updatedBy: null,
            userId: null));
        chatList.value = chatList.reversed.toList();
        chatControl.clear();
        log(response.string);
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
              'GetEntityCommentList?token=${token}&entityType=${relatedTo.value == RelatedtypeOptions.Lead ? 5 : 1}&entityID=${relatedtoitemscontrol.value.text.split(' - ')[0]}');

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
  //-------------

  //------------------------open list----------------------------//
  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }

  getSalesmanActivityOpenList() async {
    isOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    log("${loginController.token}");
    final String token = loginController.token.value;
    final String fromDate = this.fromDate.value.toIso8601String();
    final String toDate = this.toDate.value.toIso8601String();
    dynamic result;
    log("${fromDate}      ${toDate}");
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api:
              'GetActivityList?token=${token}&fromDate=${fromDate}&toDate=${toDate}');

      if (feedback != null) {
        result = GetActivityListModel.fromJson(feedback);

        response.value = result.result;
        salesmanActivityOpenList.value = result.modelobject;
        isOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        isOpenListLoading.value = false;
        developer.log(salesmanActivityOpenList.length.toString(),
            name: 'All sales open list');
      }
    }
  }

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
  }

  getActivityByID(String sysdocId, String voucherId) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    log("${loginController.token}");
    final String token = loginController.token.value;

    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCRM(
          api:
              'GetActivityByID?token=${token}&sysDocID=${sysdocId}&VoucherID=${voucherId}');
      log(" feedback ${feedback}");
      if (feedback != null) {
        result = GetActivityByIdModel.fromJson(feedback);
        sysDocName.value = sysDocList
            .firstWhere((element) =>
                element.code.toLowerCase() ==
                result.modelobject[0].sysDocId.toLowerCase())
            .name
            .toString();
        if (homeController.activitytypelist != []) {
          isLoading.value = false;
          this.homeController.activitytypelist =
              homeController.activitytypelist;
        }
        if (this.homeController.activitytypelist.isEmpty) {
          await homeController.getActivityTypeList();
        }
        if (homeController.regardinglist != []) {
          isLoading.value = false;
          this.homeController.regardinglist = homeController.regardinglist;
        }
        if (this.homeController.regardinglist.isEmpty) {
          await homeController.getRegardingList();
        }
        if (homeController.contactlist != []) {
          isLoading.value = false;
          this.homeController.contactlist = homeController.contactlist;
        }
        if (this.homeController.contactlist.isEmpty) {
          await homeController.getContactsList();
        }
        if (homeController.activitybylist != []) {
          isLoading.value = false;
          this.homeController.activitybylist = homeController.activitybylist;
        }
        if (this.homeController.activitybylist.isEmpty) {
          await homeController.getActivitybyList();
        }
        if (result.modelobject[0].relatedType == 1) {
          relatedTo.value = RelatedtypeOptions.Lead;
          relatedToControl.text = "Lead";
          isSelectedRelatedto.value = true;
          if (homeController.leadList != []) {
            isLoading.value = false;
            this.homeController.leadList = homeController.leadList;
          }
          if (this.homeController.leadList.isEmpty) {
            await homeController.getLeadList();
          }
        } else {
          relatedTo.value = RelatedtypeOptions.Customers;
          if (homeController.customerList == []) {
            isLoading.value = false;
            homeController.customerList = homeController.customerList;
          }
          if (homeController.customerList == []) {
            isLoading.value = true;
            homeController.getCustomerList();
            isLoading.value = false;
          }
          isSelectedRelatedto.value = true;
        }
        log("activity ${homeController.activitytypelist}");
        sysDocId.value = result.modelobject[0].sysDocId;
        voucherNumber.value = result.modelobject[0].voucherId;
        activityNameControl.text = result.modelobject[0].activityName;
        activityTypeControl.text =
            "${result.modelobject[0].activityType} - ${homeController.activitytypelist.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].activityType.toLowerCase()).name.toString()}";
        regardingControl.text =
            "${result.modelobject[0].reasonId} - ${homeController.regardinglist.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].reasonId.toLowerCase()).name.toString()}";

        if (result.modelobject[0].relatedType == 1) {
          relatedTo.value = RelatedtypeOptions.Lead;
          relatedToControl.text = "Lead";
          isSelectedRelatedto.value = true;
          relatedtoitemscontrol.value.text =
              "${result.modelobject[0].relatedId} - ${homeController.leadList.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].relatedId.toLowerCase()).name.toString()}";
        } else {
          relatedTo.value = RelatedtypeOptions.Customers;
          isSelectedRelatedto.value = true;
          relatedtoitemscontrol.value.text =
              "${result.modelobject[0].relatedId} - ${homeController.customerList.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].ownerId.toLowerCase()).name.toString()}";
        }
        homeController.chatenabled.value = true;
        contactControl.text =
            "${result.modelobject[0].contactId} - ${homeController.contactlist.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].contactId.toLowerCase()).name.toString()}";
        activityByControl.text =
            "${result.modelobject[0].ownerId} - ${homeController.activitybylist.firstWhere((element) => element.code.toLowerCase() == result.modelobject[0].ownerId.toLowerCase()).name.toString()}";
        noteControl.text = result.modelobject[0].note;

        // response.value = result.result;
        // salesmanActivityOpenList.value = result.modelobject;
      }
    } finally {
      if (response.value == 1) {
        developer.log(salesmanActivityOpenList.length.toString(),
            name: 'All sales open list');
      }
    }
  }
}
