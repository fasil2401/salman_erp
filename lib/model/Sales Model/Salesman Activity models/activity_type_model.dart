// To parse this JSON data, do
//
//     final activityTypeListModel = activityTypeListModelFromJson(jsonString);

import 'dart:convert';

ActivityTypeListModel activityTypeListModelFromJson(String str) =>
    ActivityTypeListModel.fromJson(json.decode(str));

String activityTypeListModelToJson(ActivityTypeListModel data) =>
    json.encode(data.toJson());

class ActivityTypeListModel {
  ActivityTypeListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<ActivityTypeModel>? modelobject;

  factory ActivityTypeListModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypeListModel(
        result: json["result"],
        modelobject: List<ActivityTypeModel>.from(
            json["Modelobject"].map((x) => ActivityTypeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject!.map((x) => x.toJson())),
      };
}

class ActivityTypeModel {
  ActivityTypeModel({
     this.code,
     this.name,
     this.genericListType,
  });

  String? code;
  String? name;
  int? genericListType;

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypeModel(
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
