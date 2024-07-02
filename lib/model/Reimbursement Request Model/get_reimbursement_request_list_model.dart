// To parse this JSON data, do
//
//     final getReimbursementRequestListModel = getReimbursementRequestListModelFromJson(jsonString);

import 'dart:convert';

GetReimbursementRequestListModel getReimbursementRequestListModelFromJson(
        String str) =>
    GetReimbursementRequestListModel.fromJson(json.decode(str));

String getReimbursementRequestListModelToJson(
        GetReimbursementRequestListModel data) =>
    json.encode(data.toJson());

class GetReimbursementRequestListModel {
  int? res;
  List<ReimbursementRequestModel>? model;
  String? msg;

  GetReimbursementRequestListModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetReimbursementRequestListModel.fromJson(
          Map<String, dynamic> json) =>
      GetReimbursementRequestListModel(
        res: json["res"],
        model: List<ReimbursementRequestModel>.from(
            json["model"].map((x) => ReimbursementRequestModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class ReimbursementRequestModel {
  String? sysDocId;
  String? voucherId;
  DateTime? transactionDate;
  String? employeeId;
  int? total;
  dynamic approvalStatus;
  dynamic verificationStatus;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? createdBy;
  String? updatedBy;

  ReimbursementRequestModel({
    this.sysDocId,
    this.voucherId,
    this.transactionDate,
    this.employeeId,
    this.total,
    this.approvalStatus,
    this.verificationStatus,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  factory ReimbursementRequestModel.fromJson(Map<String, dynamic> json) =>
      ReimbursementRequestModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
        employeeId: json["EmployeeID"],
        total: json["Total"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: DateTime.parse(
            json["DateUpdated"] ?? DateTime.now().toIso8601String()),
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "TransactionDate": transactionDate!.toIso8601String(),
        "EmployeeID": employeeId,
        "Total": total,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated?.toIso8601String(),
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
