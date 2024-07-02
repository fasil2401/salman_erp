// To parse this JSON data, do
//
//     final getLeaveRequestDetailsByIdModel = getLeaveRequestDetailsByIdModelFromJson(jsonString);

import 'dart:convert';

GetLeaveRequestDetailsByIdModel getLeaveRequestDetailsByIdModelFromJson(
        String str) =>
    GetLeaveRequestDetailsByIdModel.fromJson(json.decode(str));

String getLeaveRequestDetailsByIdModelToJson(
        GetLeaveRequestDetailsByIdModel data) =>
    json.encode(data.toJson());

class GetLeaveRequestDetailsByIdModel {
  int? res;
  List<LeaveRequestByIdMdel>? model;
  String? msg;

  GetLeaveRequestDetailsByIdModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetLeaveRequestDetailsByIdModel.fromJson(Map<String, dynamic> json) =>
      GetLeaveRequestDetailsByIdModel(
        res: json["res"],
        model: List<LeaveRequestByIdMdel>.from(
            json["model"].map((x) => LeaveRequestByIdMdel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class LeaveRequestByIdMdel {
  int? activityId;
  DateTime? transactionDate;
  String? employeeId;
  String? reference;
  dynamic subject;
  int? activityType;
  String? reason;
  String? note;
  dynamic approvalStatus;
  dynamic verificationStatus;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;

  LeaveRequestByIdMdel({
    this.activityId,
    this.transactionDate,
    this.employeeId,
    this.reference,
    this.subject,
    this.activityType,
    this.reason,
    this.note,
    this.approvalStatus,
    this.verificationStatus,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  factory LeaveRequestByIdMdel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestByIdMdel(
        activityId: json["ActivityID"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
        employeeId: json["EmployeeID"],
        reference: json["Reference"],
        subject: json["Subject"],
        activityType: json["ActivityType"],
        reason: json["Reason"],
        note: json["Note"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "ActivityID": activityId,
        "TransactionDate": transactionDate!.toIso8601String(),
        "EmployeeID": employeeId,
        "Reference": reference,
        "Subject": subject,
        "ActivityType": activityType,
        "Reason": reason,
        "Note": note,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
