import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/controller/app%20controls/report_controller.dart';
import 'package:axolon_erp/model/common_response_model.dart';
import 'package:axolon_erp/model/employee_attendance_log_model.dart';
import 'package:axolon_erp/model/getEmployeePunchingDetailsModel.dart';
import 'package:axolon_erp/model/get_job_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:open_location_code/open_location_code.dart' as olc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateFormatter.dateFormat.format(date);
    H.value = DateTime.now().hour;
    h.value = (DateTime.now().hour > 12)
        ? DateTime.now().hour - 12
        : (DateTime.now().hour == 0)
            ? 12
            : DateTime.now().hour;
    m.value = DateTime.now().minute;
    s.value = DateTime.now().second;
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
    Timer.periodic(
        Duration(seconds: 1), (Timer t) => getLogTime(DateTime.now()));
    selectedDateIso.value = DateTime.now().toIso8601String().toString();
  }

  final loginController = Get.put(LoginTokenController());
  final reportController = Get.put(ReportController());
  final homeController = Get.put(HomeController());
  DateTime date = DateTime.now();
  var H = 0.obs;
  var h = 0.obs;
  var m = 0.obs;
  var s = 0.obs;
  var selectedDate = ''.obs;
  var selectedDateIso = ''.obs;
  var jobId = 'Select Job Id'.obs;
  var isLoading = false.obs;
  var isJobListLoading = false.obs;
  var isLoadingAttendance = false.obs;
  var response = 0.obs;
  var attendanceLog = [].obs;
  var jobList = [].obs;
  var jobIdCode = ''.obs;
  var errorMessage = ''.obs;
  var logFlag = 0.obs;
  var logTime = DateTime.now().obs;
  var isLogActive = false.obs;
  var locationLat = "".obs;
  var locationLong = "".obs;
  var radius = 5.0.obs;
  var filterJobList = [].obs;
  var allowGeoFencingOnPunching = false.obs;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> allmarkers = Set();
  Set<Circle> _circles = HashSet<Circle>();
  int _markerIdCounter = 1;

  setJobId(JobModel job) {
    jobId.value = job.name!;
    jobIdCode.value = job.code!;
    update();
  }

  initPage() async {
    radius.value = double.parse(
        homeController.getCompanyOption(CompanyOptions.AttendanceRadius.value));

    await getEmployeePunchingDetails();
    await getEmployeeAttendanceLog();
    await reportController.getEmployeeAttendanceHistory();
    await getCurrentLocation();
    // await getJobList();
  }

  location() async {
    final String latitude = UserSimplePreferences.getLatitude() ?? '';
    final String longitude = UserSimplePreferences.getLongitude() ?? '';
    LatLng sourceLocation =
        LatLng(double.parse(latitude), double.parse(longitude));
    final iconData = Icons.circle;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);
    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 48.0,
          fontFamily: iconData.fontFamily,
          color: Colors.blue,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(48, 48);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final bitmapDescriptor =
        BitmapDescriptor.fromBytes(bytes?.buffer.asUint8List() ?? Uint8List(5));
    Marker sourceMarker = Marker(
        markerId: MarkerId('startPoint'),
        infoWindow: InfoWindow(title: 'Your location'),
        icon: bitmapDescriptor,
        position: sourceLocation);

    allmarkers.add(sourceMarker);
    _setGeoFence(
      LatLng(double.parse(locationLat.value), double.parse(locationLong.value)),
      radius.value,
    );
  }

  void _setGeoFence(LatLng point, double radius) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    _circles.add(Circle(
      circleId: CircleId(markerIdVal),
      center: point,
      radius: radius,
      fillColor: Colors.green,
      strokeWidth: 3,
    ));
  }

  googleMapView(BuildContext context) async {
    await location();
    final String latitude = UserSimplePreferences.getLatitude() ?? '';
    final String longitude = UserSimplePreferences.getLongitude() ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Card(child: Icon(Icons.close))),
          ),
          content: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: GoogleMap(
              initialCameraPosition: (CameraPosition(
                  target:
                      LatLng(double.parse(latitude), double.parse(longitude)),
                  zoom: 20)),
              circles: _circles,
              markers: Set<Marker>.of(allmarkers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        );
      },
    );
  }

  selectDate(context) async {
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
      selectedDate.value = DateFormatter.dateFormat.format(newDate).toString();
      selectedDateIso.value = newDate.toIso8601String().toString();
      getEmployeeAttendanceLog();
    }

    update();
  }

  getTime() {
    super.onInit();
    H.value = DateTime.now().hour;
    h.value = (DateTime.now().hour > 12)
        ? DateTime.now().hour - 12
        : (DateTime.now().hour == 0)
            ? 12
            : DateTime.now().hour;
    m.value = DateTime.now().minute;
    s.value = DateTime.now().second;
  }

  getLogTime(DateTime logTime) {
    String previousLogTime = UserSimplePreferences.getAttendanceLogTime() ?? '';
    if (previousLogTime != '') {
      DateTime previousLogTimeDate = DateTime.parse(previousLogTime);
      var diff = logTime.difference(previousLogTimeDate);
      if (diff.inMinutes >= 1) {
        // return true;
        isLogActive.value = true;
      } else {
        // return false;
        isLogActive.value = false;
      }
    } else {
      // return true;
      isLogActive.value = true;
    }
  }

  refreshLog() async {
    UserSimplePreferences.setAttendanceLogTime('');
    isLogActive.value = true;
  }

  getEmployeeAttendanceLog() async {
    isLoading.value = true;
    await loginController.getToken();
    final String token = loginController.token.value;
    final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetEmployeeAttendanceLog?token=${token}&employeeID=${employeeId}&fromDate=${selectedDateIso.value}&toDate=${selectedDateIso.value}');
      if (feedback != null) {
        result = EmployeeAttendanceLogModel.fromJson(feedback);
        response.value = result.res;
        attendanceLog.value = result.model;
      }
      isLoading.value = false;
    } finally {
      if (response.value == 1) {}
      isLoading.value = false;
    }
  }

  getJobList() async {
    jobList.clear();
    filterJobList.clear();

    isJobListLoading.value = true;
    update();
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback =
          await ApiServices.fetchData(api: 'GetJobList?token=${token}');
      if (feedback != null) {
        result = GetJobListModel.fromJson(feedback);
        developer.log(feedback.toString(), name: 'GetJobList');
        response.value = result.res;
        jobList.value = result.model;
        filterJobList.value = jobList;
        update();
      }
      isJobListLoading.value = false;
      update();
    } finally {
      isJobListLoading.value = false;
      update();
    }
  }

  Future<Position> _determinePosition() async {
    // bool serviceEnabled;
    LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   await Geolocator.openLocationSettings();
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  getEmployeePunchingDetails() async {
    await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    bool isConnected = await ApiServices.isConnected();
    if (isConnected) {
      try {
        var feedback = await ApiServices.fetchData(
            api:
                'GetEmployeePunchingDetails?token=${token}&employeeID=${homeController.employeeId.value}');
        if (feedback != null) {
          result = GetEmployeePunchingDetailsModel.fromJson(feedback);
          locationLat.value = result.model[0].latitude;
          locationLong.value = result.model[0].longitude;
          allowGeoFencingOnPunching.value =
              result.model[0].allowGeoFencingOnPunching;
        }
      } finally {}
    }
  }

  getCurrentLocation() async {
    Position position = await _determinePosition();
    // developer.log("${position.latitude}");
    // developer.log("${position.longitude}");
// Get the distance between the two locations
    // developer.log("${userInsideOrOut()}", name: "user inside maybe");
    // double distanceInMeters = await Geolocator.distanceBetween(
    //   10.0088339,
    //   76.3083830,
    //   position.latitude,
    //   position.longitude,
    // );
    // developer.log("${distanceInMeters}");
    // if (distanceInMeters <= 200) {
    //   developer.log('user inside');
    // } else {
    //   developer.log('user outside');
    // }
    // var codeFromLatLon =
    //     olc.encode(position.latitude, position.longitude, codeLength: 1000000);
    // developer.log(codeFromLatLon.toString());
    UserSimplePreferences.setLatitude(position.latitude.toString());
    UserSimplePreferences.setLongitude(position.longitude.toString());
  }

  getToastMessage(int logFlag) {
    String message = '';
    switch (logFlag) {
      case 1:
        {
          message = 'Check In Success';
        }
        break;

      case 2:
        {
          message = 'Checkout Success';
        }
        break;

      case 3:
        {
          message = 'Break In Success';
        }
        break;

      case 4:
        {
          message = 'Break Out Success';
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
    return message;
  }

  getToastColor(int logFlag) {
    Color color = AppColors.mutedColor;
    switch (logFlag) {
      case 1:
        {
          color = AppColors.darkGreen;
        }
        break;

      case 2:
        {
          color = AppColors.darkRed;
        }
        break;

      case 3:
        {
          color = AppColors.primary;
        }
        break;

      case 4:
        {
          color = AppColors.primary;
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
    return color;
  }

  checkForParameters() {
    final String latitude = UserSimplePreferences.getLatitude() ?? '';
    if (jobIdCode.value == '') {
      errorMessage.value = 'Please Select Job Id';
      return true;
      // return false;
    } else if (latitude == '') {
      errorMessage.value = 'Please Enable Location';
      return false;
    } else {
      return true;
    }
  }

  Future<bool> userInsideOrOut() async {
    final currenLatitude = UserSimplePreferences.getLatitude();
    final currenLongitude = UserSimplePreferences.getLongitude();
    developer.log("${double.parse(locationLat.value)}");
    double distanceInMeters = await Geolocator.distanceBetween(
      double.parse(locationLat.value),
      double.parse(locationLong.value),
      double.parse(currenLatitude!),
      double.parse(currenLongitude!),
    );

    developer.log("${distanceInMeters}distance in meters");
    if (distanceInMeters <= radius.value) {
      developer.log('user inside');
      return true;
    } else {
      developer.log('user outside');
      return false;
    }
  }

  createAttendanceLog(int logFlag, BuildContext context) async {
    developer.log('creating log');
    logTime.value = DateTime.now();
    await UserSimplePreferences.setAttendanceLogTime(logTime.value.toString());
    this.logFlag.value = logFlag;
    if (checkForParameters()) {
      isLoadingAttendance.value = true;
      await loginController.getToken();
      final String token = loginController.token.value;
      final String employeeId = UserSimplePreferences.getEmployeeId() ?? '';
      final String latitude = UserSimplePreferences.getLatitude() ?? '';
      final String longitude = UserSimplePreferences.getLongitude() ?? '';
      final data = jsonEncode({
        "token": token,
        "LogID": 0,
        "EmployeeID": employeeId,
        "LogDate": DateTime.now().toIso8601String().toString(),
        "RowIndex": 0,
        "ShiftID": "",
        "LocationID": "",
        "JobID": jobIdCode.value,
        "LogValue": logFlag,
        "Latitude": latitude,
        "Longitude": longitude
      });
      print(data);
      dynamic result;

      try {
        var feedback = await ApiServices.fetchDataRawBodyEmployee(
            api: 'CreateAttendanceLog', data: data);
        if (feedback != null) {
          result = CommonResponseModel.fromJson(feedback);
          response.value = result.res;
        }
        isLoadingAttendance.value = false;
      } finally {
        isLoadingAttendance.value = false;
        if (response.value == 1) {
          GFToast.showToast(getToastMessage(logFlag), context,
              toastPosition: GFToastPosition.BOTTOM,
              textStyle: TextStyle(fontSize: 12, color: GFColors.LIGHT),
              backgroundColor: getToastColor(logFlag),
              toastBorderRadius: 10.0);
          await getEmployeeAttendanceLog();
          reportController.getEmployeeAttendanceHistory();
        } else {
          SnackbarServices.errorSnackbar('Something went wrong');
        }
      }
    } else {
      SnackbarServices.errorSnackbar(errorMessage.value);
    }
  }

  filterJobLists(String value) {
    filterJobList.value = jobList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    //selectedJob.value = value.toString();
    update();
  }
}
