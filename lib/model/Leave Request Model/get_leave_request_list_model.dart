// To parse this JSON data, do
//
//     final getLeaveRequestDetailListModel = getLeaveRequestDetailListModelFromJson(jsonString);

import 'dart:convert';

GetLeaveRequestDetailListModel getLeaveRequestDetailListModelFromJson(
        String str) =>
    GetLeaveRequestDetailListModel.fromJson(json.decode(str));

String getLeaveRequestDetailListModelToJson(
        GetLeaveRequestDetailListModel data) =>
    json.encode(data.toJson());

class GetLeaveRequestDetailListModel {
  int? res;
  List<LeaveRequestModel>? model;
  String? msg;

  GetLeaveRequestDetailListModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetLeaveRequestDetailListModel.fromJson(Map<String, dynamic> json) =>
      GetLeaveRequestDetailListModel(
        res: json["res"],
        model: List<LeaveRequestModel>.from(json["model"].map((x) => LeaveRequestModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson())??[]),
        "msg": msg,
      };
}

class LeaveRequestModel {
  String? transactionId;
  String? sysDocId;
  String? docNumber;
  String? employeeId;
  String? employeeName;
  String? leaveTypeName;
  String? leaveTypeId;
  DateTime? startDate;
  DateTime? endDate;
  int? leaveDays;
  String? approvalStatus;

  LeaveRequestModel({
    this.transactionId,
    this.sysDocId,
    this.docNumber,
    this.employeeId,
    this.employeeName,
    this.leaveTypeName,
    this.leaveTypeId,
    this.startDate,
    this.endDate,
    this.leaveDays,
    this.approvalStatus,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestModel(
        transactionId: json["TransactionID"],
        sysDocId: json["SysDocID"],
        docNumber: json["Doc Number"],
        employeeId: json["EmployeeID"],
        employeeName: json["Employee Name"],
        leaveTypeName: json["LeaveTypeName"],
        leaveTypeId: json["LeaveTypeID"],
        startDate: DateTime.parse(json["StartDate"]),
        endDate: DateTime.parse(json["EndDate"]),
        leaveDays: json["LeaveDays"],
        approvalStatus: json["ApprovalStatus"],
      );

  Map<String, dynamic> toJson() => {
        "TransactionID": transactionId,
        "SysDocID": sysDocId,
        "Doc Number": docNumber,
        "EmployeeID": employeeId,
        "Employee Name": employeeName,
        "LeaveTypeName": leaveTypeName,
        "LeaveTypeID": leaveTypeId,
        "StartDate": startDate!.toIso8601String(),
        "EndDate": endDate!.toIso8601String(),
        "LeaveDays": leaveDays,
        "ApprovalStatus": approvalStatus,
      };
}
