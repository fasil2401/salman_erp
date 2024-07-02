// To parse this JSON data, do
//
//     final getLetterRequestByIdListModel = getLetterRequestByIdListModelFromJson(jsonString);

import 'dart:convert';

GetLetterRequestByIdListModel getLetterRequestByIdListModelFromJson(String str) => GetLetterRequestByIdListModel.fromJson(json.decode(str));

String getLetterRequestByIdListModelToJson(GetLetterRequestByIdListModel data) => json.encode(data.toJson());

class GetLetterRequestByIdListModel {
    int? res;
    List<LetterByIdModel>? model;
    String? msg;

    GetLetterRequestByIdListModel({
        this.res,
        this.model,
        this.msg,
    });

    factory GetLetterRequestByIdListModel.fromJson(Map<String, dynamic> json) => GetLetterRequestByIdListModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<LetterByIdModel>.from(json["model"]!.map((x) => LetterByIdModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class LetterByIdModel {
    String? sysDocId;
    String? voucherId;
    String? employeeId;
    DateTime? transactionDate;
    String? letterType;
    DateTime? requestedDate;
    String? requestDetails;
    String? remarks;
    dynamic requestedBy;
    dynamic isVoid;
    dynamic companyId;
    String? divisionId;
    dynamic approvalStatus;
    dynamic verificationStatus;
    DateTime? dateCreated;
    dynamic dateUpdated;
    String? createdBy;
    dynamic updatedBy;

    LetterByIdModel({
        this.sysDocId,
        this.voucherId,
        this.employeeId,
        this.transactionDate,
        this.letterType,
        this.requestedDate,
        this.requestDetails,
        this.remarks,
        this.requestedBy,
        this.isVoid,
        this.companyId,
        this.divisionId,
        this.approvalStatus,
        this.verificationStatus,
        this.dateCreated,
        this.dateUpdated,
        this.createdBy,
        this.updatedBy,
    });

    factory LetterByIdModel.fromJson(Map<String, dynamic> json) => LetterByIdModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        employeeId: json["EmployeeID"],
        transactionDate: json["TransactionDate"] == null ? null : DateTime.parse(json["TransactionDate"]),
        letterType: json["LetterType"],
        requestedDate: json["RequestedDate"] == null ? null : DateTime.parse(json["RequestedDate"]),
        requestDetails: json["RequestDetails"],
        remarks: json["Remarks"],
        requestedBy: json["RequestedBy"],
        isVoid: json["IsVoid"],
        companyId: json["CompanyID"],
        divisionId: json["DivisionID"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: json["DateCreated"] == null ? null : DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
    );

    Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "EmployeeID": employeeId,
        "TransactionDate": transactionDate?.toIso8601String(),
        "LetterType": letterType,
        "RequestedDate": requestedDate?.toIso8601String(),
        "RequestDetails": requestDetails,
        "Remarks": remarks,
        "RequestedBy": requestedBy,
        "IsVoid": isVoid,
        "CompanyID": companyId,
        "DivisionID": divisionId,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated?.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
    };
}
