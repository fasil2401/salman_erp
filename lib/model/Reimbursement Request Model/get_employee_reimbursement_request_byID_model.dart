// To parse this JSON data, do
//
//     final getEmployeeReimbursementRequestByIdModel = getEmployeeReimbursementRequestByIdModelFromJson(jsonString);

import 'dart:convert';

GetEmployeeReimbursementRequestByIdModel
    getEmployeeReimbursementRequestByIdModelFromJson(String str) =>
        GetEmployeeReimbursementRequestByIdModel.fromJson(json.decode(str));

String getEmployeeReimbursementRequestByIdModelToJson(
        GetEmployeeReimbursementRequestByIdModel data) =>
    json.encode(data.toJson());

class GetEmployeeReimbursementRequestByIdModel {
  int? result;
  List<Header>? header;
  List<Detail>? detail;

  GetEmployeeReimbursementRequestByIdModel({
    this.result,
    this.header,
    this.detail,
  });

  factory GetEmployeeReimbursementRequestByIdModel.fromJson(
          Map<String, dynamic> json) =>
      GetEmployeeReimbursementRequestByIdModel(
        result: json["result"],
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
        detail:
            List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Header": List<dynamic>.from(header?.map((x) => x.toJson()) ?? []),
        "Detail": List<dynamic>.from(detail?.map((x) => x.toJson()) ?? []),
      };
}

class Detail {
  String? sysDocId;
  String? voucherId;
  String? reimburseItemId;
  int? amount;
  String? refDate;
  int? rowIndex;
  String? description;
  String? des;

  Detail({
    this.sysDocId,
    this.voucherId,
    this.reimburseItemId,
    this.amount,
    this.refDate,
    this.rowIndex,
    this.description,
    this.des,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        reimburseItemId: json["ReimburseItemID"],
        amount: json["Amount"],
        refDate: json["RefDate"],
        rowIndex: json["RowIndex"],
        description: json["Description"],
        des: json["Remarks"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ReimburseItemID": reimburseItemId,
        "Amount": amount,
        "RefDate": refDate,
        "RowIndex": rowIndex,
        "Description": description,
        "Remarks": des,
      };
}

class Header {
  String? sysDocId;
  String? voucherId;
  DateTime? transactionDate;
  String? employeeId;
  String? total;
  dynamic approvalStatus;
  dynamic verificationStatus;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;
  String? remarks;

  Header({
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
    this.remarks,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
        employeeId: json["EmployeeID"],
        total: json["Total"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        remarks: json["Remarks"],
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
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "Remarks": remarks,
      };
}
