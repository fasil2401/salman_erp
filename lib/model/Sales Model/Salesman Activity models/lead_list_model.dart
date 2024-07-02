// To parse this JSON data, do
//
//     final leadListModel = leadListModelFromJson(jsonString);

import 'dart:convert';

LeadListModel leadListModelFromJson(String str) =>
    LeadListModel.fromJson(json.decode(str));

String leadListModelToJson(LeadListModel data) => json.encode(data.toJson());

class LeadListModel {
  LeadListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<LeadModel>? modelobject;

  factory LeadListModel.fromJson(Map<String, dynamic> json) => LeadListModel(
        result: json["result"],
        modelobject: List<LeadModel>.from(
            json["Modelobject"].map((x) => LeadModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject!.map((x) => x.toJson())),
      };
}

class LeadModel {
  LeadModel({
     this.code,
     this.name,
    this.salesPersonId,
  });

  String? code;
  String? name;
  String? salesPersonId;

  factory LeadModel.fromJson(Map<String, dynamic> json) => LeadModel(
        code: json["Code"],
        name: json["Name"],
        salesPersonId: json["SalesPersonID"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "SalesPersonID": salesPersonId,
      };
}


