import 'dart:convert';

GetActionStatusLogListModel getActionStatusLogListModelFromJson(String str) =>
    GetActionStatusLogListModel.fromJson(json.decode(str));

String getActionStatusLogListModelToJson(GetActionStatusLogListModel data) =>
    json.encode(data.toJson());

class GetActionStatusLogListModel {
  int? res;
  List<ActionStatusLogModel>? modelobject;

  GetActionStatusLogListModel({
    this.res,
    this.modelobject,
  });

  factory GetActionStatusLogListModel.fromJson(Map<String, dynamic> json) =>
      GetActionStatusLogListModel(
        res: json["res"],
        modelobject: List<ActionStatusLogModel>.from(
            json["Modelobject"].map((x) => ActionStatusLogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class ActionStatusLogModel {
  String? sysDocId;
  String? voucherId;
  String? status;
  DateTime? statusDate;
  DateTime? dateUpdated;
  String? updatedBy;
  String? reference1;
  String? reference2;
  DateTime? referenceDate;
  int? logId;
  String? remarks;
  dynamic leadName;
  String? hexColorCode;

  ActionStatusLogModel({
    this.sysDocId,
    this.voucherId,
    this.status,
    this.statusDate,
    this.dateUpdated,
    this.updatedBy,
    this.reference1,
    this.reference2,
    this.referenceDate,
    this.logId,
    this.remarks,
    this.leadName,
    this.hexColorCode,
  });

  factory ActionStatusLogModel.fromJson(Map<String, dynamic> json) =>
      ActionStatusLogModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        status: json["Status"],
        statusDate: DateTime.parse(json["StatusDate"]),
        dateUpdated: DateTime.parse(json["DateUpdated"]),
        updatedBy: json["UpdatedBy"],
        reference1: json["Reference1"],
        reference2: json["Reference2"],
        referenceDate: DateTime.parse(json["ReferenceDate"]),
        logId: json["LogID"],
        remarks: json["Remarks"],
        leadName: json["LeadName"],
        hexColorCode: json["HexColorCode"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "Status": status,
        "StatusDate": statusDate!.toIso8601String(),
        "DateUpdated": dateUpdated!.toIso8601String(),
        "UpdatedBy": updatedBy,
        "Reference1": reference1,
        "Reference2": reference2,
        "ReferenceDate": referenceDate!.toIso8601String(),
        "LogID": logId,
        "Remarks": remarks,
        "LeadName": leadName,
        "HexColorCode": hexColorCode,
      };
}
