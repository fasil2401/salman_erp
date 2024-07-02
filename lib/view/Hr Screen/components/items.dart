import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:get/get.dart';

// final homeController = Get.put(HomeController());

class HrScreenItems {
  static const String attendanceId =
      'timeSheetPunchInOutUserToolStripMenuItem1';
  static const String requestId = 'mhrelLeaveReq';
  static const String employeeLedgerId = 'mreEmpLeg';
  static const String employeeProfileId = 'mreEmpProfile';
  static const String leaveMenuId = 'LeaveMenu';
  static const String reimbursementMenuId = 'ReimbursementMenu';
  static const String employeeDocumentMenuId = 'mhrhcEmpDoc';
  static const String letterMenuId = 'LetterMenu';
  static const String payslipMenuId = 'employeeSalarySlipToolStripMenuItem';
  static const String myTaskMenuId = 'Project Task';
  static const String myTaskfollowupMenuId = 'Task Follow Up';

  static List<ScreenItemModel> HrItems = [
    ScreenItemModel(
        title: 'Attendance',
        menuId: attendanceId,
        screenId: HrScreenId.employeePunchInOut,
        route: '${RouteManager.attendance}',
        icon: AppIcons.approved),
    ScreenItemModel(
        title: 'Leave Request',
        menuId: leaveMenuId,
        screenId: HrScreenId.employeeLeaveRequest,
        route: '${RouteManager.leaveRequest}',
        icon: AppIcons.request),
    ScreenItemModel(
        title: 'Letter Request',
        menuId: letterMenuId,
        screenId: HrScreenId.employeeLetterIssueRequest,
        route: '${RouteManager.letterRequest}',
        icon: AppIcons.request),
    ScreenItemModel(
        title: 'Reimbursement Request',
        menuId: reimbursementMenuId,
        screenId: HrScreenId.employeeReimbursementRequest,
        route: '${RouteManager.reimbursementRequest}',
        icon: AppIcons.request),
    ScreenItemModel(
        title: 'Employee Douments',
        menuId: employeeDocumentMenuId,
        screenId: HrScreenId.employeeDocumentRequest,
        route: '${RouteManager.employeeDocument}',
        icon: AppIcons.request),
    ScreenItemModel(
        title: 'Pay Slip',
        menuId: payslipMenuId,
        screenId: HrScreenId.employeePayslip,
        route: '${RouteManager.payslip}',
        icon: AppIcons.request),
    ScreenItemModel(
        title: 'My Task',
        menuId: myTaskfollowupMenuId,
        screenId: HrScreenId.myTaskFollowup,
        route: '${RouteManager.myTask}',
        icon: AppIcons.request),
  ];

  static List<ScreenItemModel> HrReportItems = [
    ScreenItemModel(
        title: 'Employee Ledger',
        menuId: employeeLedgerId,
        screenId: HrScreenId.employeeBalanceDetailsReport,
        route: '${RouteManager.employeeLedger}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Employee Profile',
        menuId: employeeProfileId,
        screenId: HrScreenId.employeeProfileReport,
        route: '${RouteManager.employeeProfile}',
        icon: AppIcons.report),
  ];
}
