// To parse this JSON data, do
//
//     final getActivityListModel = getActivityListModelFromJson(jsonString);

import 'dart:convert';

GetActivityListModel getActivityListModelFromJson(String str) =>
    GetActivityListModel.fromJson(json.decode(str));

String getActivityListModelToJson(GetActivityListModel data) =>
    json.encode(data.toJson());

class GetActivityListModel {
  GetActivityListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<ActivityModel>? modelobject;

  factory GetActivityListModel.fromJson(Map<String, dynamic> json) =>
      GetActivityListModel(
        result: json["result"],
        modelobject: List<ActivityModel>.from(
            json["Modelobject"].map((x) => ActivityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class ActivityModel {
  ActivityModel({
    this.docId,
    this.number,
    this.activityName,
    this.accountType,
    this.accountName,
    this.contact,
    this.activityType,
    this.performedBy,
    this.date,
    this.note,
  });

  String? docId;
  String? number;
  String? activityName;
  String? accountType;
  String? accountName;
  String? contact;
  String? activityType;
  String? performedBy;
  DateTime? date;
  String? note;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        docId: json["Doc ID"] ?? "",
        number: json["Number"] ?? "",
        activityName: json["Activity Name"] ?? "",
        accountType: json["Account Type"] ?? "",
        accountName: json["Account Name"] ?? "",
        contact: json["Contact"] ?? "",
        activityType: json["Activity Type"] ?? "",
        performedBy: json["Performed By"] ?? "",
        date: DateTime.parse(json["Date"]),
        note: json["Note"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Doc ID": docId,
        "Number": number,
        "Activity Name": activityName,
        "Account Type": accountType,
        "Account Name": accountName,
        "Contact": contact,
        "Activity Type": activityType,
        "Performed By": performedBy,
        "Date": date!.toIso8601String(),
        "Note": note,
      };
}
