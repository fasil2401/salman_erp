// To parse this JSON data, do
//
//     final getActionStatusSecurityModel = getActionStatusSecurityModelFromJson(jsonString);

import 'dart:convert';

GetActionStatusSecurityModel getActionStatusSecurityModelFromJson(String str) =>
    GetActionStatusSecurityModel.fromJson(json.decode(str));

String getActionStatusSecurityModelToJson(GetActionStatusSecurityModel data) =>
    json.encode(data.toJson());

class GetActionStatusSecurityModel {
  int? res;
  List<ActionStatusSecuirityModel>? modelobject;

  GetActionStatusSecurityModel({
    this.res,
    this.modelobject,
  });

  factory GetActionStatusSecurityModel.fromJson(Map<String, dynamic> json) =>
      GetActionStatusSecurityModel(
        res: json["res"],
        modelobject: List<ActionStatusSecuirityModel>.from(json["Modelobject"]
            .map((x) => ActionStatusSecuirityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class ActionStatusSecuirityModel {
  String? statusId;
  bool? isUpdate;
  bool? isView;
  dynamic userId;
  dynamic groupId;
  dynamic rowIndex;
  DateTime? dateUpdated;
  DateTime? dateCreated;
  dynamic createdBy;
  dynamic updatedBy;
  int? statusType;

  ActionStatusSecuirityModel({
    this.statusId,
    this.isUpdate,
    this.isView,
    this.userId,
    this.groupId,
    this.rowIndex,
    this.dateUpdated,
    this.dateCreated,
    this.createdBy,
    this.updatedBy,
    this.statusType,
  });

  factory ActionStatusSecuirityModel.fromJson(Map<String, dynamic> json) =>
      ActionStatusSecuirityModel(
        statusId: json["StatusID"],
        isUpdate: json["IsUpdate"],
        isView: json["IsView"],
        userId: json["UserID"],
        groupId: json["GroupID"],
        rowIndex: json["RowIndex"],
        dateUpdated: DateTime.parse(json["DateUpdated"]),
        dateCreated: DateTime.parse(json["DateCreated"]),
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        statusType: json["StatusType"],
      );

  Map<String, dynamic> toJson() => {
        "StatusID": statusId,
        "IsUpdate": isUpdate,
        "IsView": isView,
        "UserID": userId,
        "GroupID": groupId,
        "RowIndex": rowIndex,
        "DateUpdated": dateUpdated!.toIso8601String(),
        "DateCreated": dateCreated!.toIso8601String(),
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "StatusType": statusType,
      };
}
