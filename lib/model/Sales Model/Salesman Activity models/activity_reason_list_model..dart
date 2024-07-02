// To parse this JSON data, do
//
//     final activityReasonListModel = activityReasonListModelFromJson(jsonString);

import 'dart:convert';

ActivityReasonListModel activityReasonListModelFromJson(String str) =>
    ActivityReasonListModel.fromJson(json.decode(str));

String activityReasonListModelToJson(ActivityReasonListModel data) =>
    json.encode(data.toJson());

class ActivityReasonListModel {
  ActivityReasonListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<ActivityReasonModel>? modelobject;

  factory ActivityReasonListModel.fromJson(Map<String, dynamic> json) =>
      ActivityReasonListModel(
        result: json["result"],
        modelobject: List<ActivityReasonModel>.from(
            json["Modelobject"].map((x) => ActivityReasonModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject!.map((x) => x.toJson())),
      };
}

class ActivityReasonModel {
  ActivityReasonModel({
     this.code,
     this.name,
     this.genericListType,
  });

  String? code;
  String? name;
  int? genericListType;

  factory ActivityReasonModel.fromJson(Map<String, dynamic> json) => ActivityReasonModel(
        code: json["Code"],
        name: json["Name"],
        genericListType: json["GenericListType"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "GenericListType": genericListType,
      };
}
