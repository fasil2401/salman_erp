import 'dart:convert';

import 'package:axolon_erp/utils/constants/json_keys.dart';

GetUserPendingApprovalTasksModel getUserPendingApprovalTasksModelFromJson(
        String str) =>
    GetUserPendingApprovalTasksModel.fromJson(json.decode(str));

String getUserPendingApprovalTasksModelToJson(
        GetUserPendingApprovalTasksModel data) =>
    json.encode(data.toJson());

class GetUserPendingApprovalTasksModel {
  GetUserPendingApprovalTasksModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<Modelobject>? modelobject;

  factory GetUserPendingApprovalTasksModel.fromJson(
          Map<String, dynamic> json) =>
      GetUserPendingApprovalTasksModel(
        result: json["result"],
        modelobject: List<Modelobject>.from(
            json["Modelobject"].map((x) => Modelobject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject!.map((x) => x.toJson())),
      };
}

class Modelobject {
  Modelobject({
    this.objectId,
    this.objectType,
    this.taskId,
    this.sysDocId,
    this.voucherId,
    this.note,
    this.vendorCode,
    this.party,
    this.date,
    this.discount,
    this.amount,
    this.createdBy,
    this.dateCreated,
    this.updatedBy,
    this.dateUpdated,
  });

  int? objectId;
  int? objectType;
  int? taskId;
  String? sysDocId;
  String? voucherId;
  String? note;
  String? vendorCode;
  String? party;
  DateTime? date;
  dynamic discount;
  dynamic amount;
  String? createdBy;
  DateTime? dateCreated;
  String? updatedBy;
  DateTime? dateUpdated;

  factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        objectId: json["ObjectID"],
        objectType: json["ObjectType"],
        taskId: json["TaskID"],
        sysDocId: json[JsonKeys.docId
            .firstWhere((element) => json[element] != null,
                orElse: () => 'null')
            .toString()],
        voucherId: json[JsonKeys.voucherId
            .firstWhere((element) => json[element] != null,
                orElse: () => 'null')
            .toString()],
        note: json[JsonKeys.description
            .firstWhere((element) => json[element] != null,
                orElse: () => 'null')
            .toString()],
        vendorCode: json["Vendor Code"],
        party: json[JsonKeys.party
            .firstWhere((element) => json[element] != null,
                orElse: () => 'null')
            .toString()],
        date: json["Date"] != null ? DateTime.parse(json["Date"]) : null,
        discount: json["Discount"],
        amount: json[JsonKeys.amount
            .firstWhere((element) => json[element] != null,
                orElse: () => 'null')
            .toString()],
        createdBy: json["CreatedBy"],
        dateCreated: json["DateCreated"] != null
            ? DateTime.parse(json["DateCreated"])
            : null,
        updatedBy: json["UpdatedBy"],
        dateUpdated: json["DateUpdated"] != null
            ? DateTime.parse(json["DateUpdated"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "ObjectID": objectId,
        "ObjectType": objectType,
        "TaskID": taskId,
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        'Note': note,
        "Vendor Code": vendorCode,
        "Vendor Name": party,
        "Date": date == null ? null : date!.toIso8601String(),
        "Discount": discount,
        "Total": amount,
        "CreatedBy": createdBy,
        "DateCreated":
            dateCreated == null ? null : dateCreated!.toIso8601String(),
        "UpdatedBy": updatedBy,
        "DateUpdated":
            dateUpdated == null ? null : dateUpdated!.toIso8601String(),
      };
}
