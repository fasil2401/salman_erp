// To parse this JSON data, do
//
//     final getCreditByIdModel = getCreditByIdModelFromJson(jsonString);

import 'dart:convert';

GetCreditByIdModel getCreditByIdModelFromJson(String str) => GetCreditByIdModel.fromJson(json.decode(str));

String getCreditByIdModelToJson(GetCreditByIdModel data) => json.encode(data.toJson());

class GetCreditByIdModel {
    int? result;
    List<CreditByIdModel>? model;

    GetCreditByIdModel({
        this.result,
        this.model,
    });

    factory GetCreditByIdModel.fromJson(Map<String, dynamic> json) => GetCreditByIdModel(
        result: json["result"],
        model: json["Model"] == null ? [] : List<CreditByIdModel>.from(json["Model"]!.map((x) => CreditByIdModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
    };
}

class CreditByIdModel {
    String? sysDocId;
    String? voucherId;
    String? customerId;
    DateTime? voucherDate;
    DateTime? validFrom;
    DateTime? validTo;
    dynamic reason;
    dynamic amount;
    String? note;
    String? reference;
    dynamic approvedBy;
    dynamic isVoid;
   dynamic creditControlType;
    bool? isToken;
    dynamic invoiceSysDocId;
    dynamic usedVoucherId;
    dynamic approvalStatus;
    dynamic verificationStatus;
    DateTime? dateCreated;
    dynamic dateUpdated;
    String? createdBy;
    dynamic updatedBy;
    bool? isInactive;
    bool? isHold;

    CreditByIdModel({
        this.sysDocId,
        this.voucherId,
        this.customerId,
        this.voucherDate,
        this.validFrom,
        this.validTo,
        this.reason,
        this.amount,
        this.note,
        this.reference,
        this.approvedBy,
        this.isVoid,
        this.creditControlType,
        this.isToken,
        this.invoiceSysDocId,
        this.usedVoucherId,
        this.approvalStatus,
        this.verificationStatus,
        this.dateCreated,
        this.dateUpdated,
        this.createdBy,
        this.updatedBy,
        this.isInactive,
        this.isHold,
    });

    factory CreditByIdModel.fromJson(Map<String, dynamic> json) => CreditByIdModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        customerId: json["CustomerID"],
        voucherDate: json["VoucherDate"] == null ? null : DateTime.parse(json["VoucherDate"]),
        validFrom: json["ValidFrom"] == null ? null : DateTime.parse(json["ValidFrom"]),
        validTo: json["ValidTo"] == null ? null : DateTime.parse(json["ValidTo"]),
        reason: json["Reason"],
        amount: json["Amount"],
        note: json["Note"],
        reference: json["Reference"],
        approvedBy: json["ApprovedBy"],
        isVoid: json["IsVoid"],
        creditControlType: json["CreditControlType"],
        isToken: json["IsToken"],
        invoiceSysDocId: json["InvoiceSysDocID"],
        usedVoucherId: json["UsedVoucherID"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: json["DateCreated"] == null ? null : DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        isInactive: json["IsInactive"],
        isHold: json["IsHold"],
    );

    Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "CustomerID": customerId,
        "VoucherDate": voucherDate?.toIso8601String(),
        "ValidFrom": validFrom?.toIso8601String(),
        "ValidTo": validTo?.toIso8601String(),
        "Reason": reason,
        "Amount": amount,
        "Note": note,
        "Reference": reference,
        "ApprovedBy": approvedBy,
        "IsVoid": isVoid,
        "CreditControlType": creditControlType,
        "IsToken": isToken,
        "InvoiceSysDocID": invoiceSysDocId,
        "UsedVoucherID": usedVoucherId,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated?.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "IsInactive": isInactive,
        "IsHold": isHold,
    };
}
