// To parse this JSON data, do
//
//     final getLeadFollowUpStatusList = getLeadFollowUpStatusListFromJson(jsonString);

import 'dart:convert';

GetLeadFollowUpStatusList getLeadFollowUpStatusListFromJson(String str) =>
    GetLeadFollowUpStatusList.fromJson(json.decode(str));

String getLeadFollowUpStatusListToJson(GetLeadFollowUpStatusList data) =>
    json.encode(data.toJson());

class GetLeadFollowUpStatusList {
  GetLeadFollowUpStatusList({
    this.result,
    this.modelobject,
  });

  int? result;
  List<FollowUpStatusModel>? modelobject;

  factory GetLeadFollowUpStatusList.fromJson(Map<String, dynamic> json) =>
      GetLeadFollowUpStatusList(
        result: json["result"],
        modelobject: List<FollowUpStatusModel>.from(
            json["Modelobject"].map((x) => FollowUpStatusModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class FollowUpStatusModel {
  FollowUpStatusModel({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory FollowUpStatusModel.fromJson(Map<String, dynamic> json) => FollowUpStatusModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
