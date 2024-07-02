// To parse this JSON data, do
//
//     final getAnnouncementByEmployeeIdModel = getAnnouncementByEmployeeIdModelFromJson(jsonString);

import 'dart:convert';

GetAnnouncementByEmployeeIdModel getAnnouncementByEmployeeIdModelFromJson(
        String str) =>
    GetAnnouncementByEmployeeIdModel.fromJson(json.decode(str));

String getAnnouncementByEmployeeIdModelToJson(
        GetAnnouncementByEmployeeIdModel data) =>
    json.encode(data.toJson());

class GetAnnouncementByEmployeeIdModel {
  int? res;
  List<AnnouncementByEmployeeIDModel>? model;
  String? msg;

  GetAnnouncementByEmployeeIdModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetAnnouncementByEmployeeIdModel.fromJson(
          Map<String, dynamic> json) =>
      GetAnnouncementByEmployeeIdModel(
        res: json["res"],
        model: List<AnnouncementByEmployeeIDModel>.from(json["model"]
            .map((x) => AnnouncementByEmployeeIDModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class AnnouncementByEmployeeIDModel {
  String? sysDocId;
  String? voucherId;
  String? transactionDate;
  String? departmentId;
  String? divisionId;
  String? gradeId;
  String? typeId;
  String? groupId;
  String? workLocationId;
  String? positionId;
  String? employeeId;
  String? announcementDate;
  String? validUntil;
  int? priority;
  int? type;
  String? notification;
  String? subject;
  dynamic approvalStatus;
  dynamic verificationStatus;
  String? dateCreated;
  String? dateUpdated;
  String? createdBy;
  String? updatedBy;

  AnnouncementByEmployeeIDModel({
    this.sysDocId,
    this.voucherId,
    this.transactionDate,
    this.departmentId,
    this.divisionId,
    this.gradeId,
    this.typeId,
    this.groupId,
    this.workLocationId,
    this.positionId,
    this.employeeId,
    this.announcementDate,
    this.validUntil,
    this.priority,
    this.type,
    this.notification,
    this.subject,
    this.approvalStatus,
    this.verificationStatus,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  factory AnnouncementByEmployeeIDModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementByEmployeeIDModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        transactionDate: json["TransactionDate"],
        departmentId: json["DepartmentID"],
        divisionId: json["DivisionID"],
        gradeId: json["GradeID"],
        typeId: json["TypeID"],
        groupId: json["GroupID"],
        workLocationId: json["WorkLocationID"],
        positionId: json["PositionID"],
        employeeId: json["EmployeeID"],
        announcementDate: json["AnnouncementDate"],
        validUntil: json["ValidUntil"],
        priority: json["Priority"],
        type: json["Type"],
        notification: json["Notification"],
        subject: json["Subject"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: json["DateCreated"],
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "TransactionDate": transactionDate,
        "DepartmentID": departmentId,
        "DivisionID": divisionId,
        "GradeID": gradeId,
        "TypeID": typeId,
        "GroupID": groupId,
        "WorkLocationID": workLocationId,
        "PositionID": positionId,
        "EmployeeID": employeeId,
        "AnnouncementDate": announcementDate,
        "ValidUntil": validUntil,
        "Priority": priority,
        "Type": type,
        "Notification": notification,
        "Subject": subject,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated,
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
