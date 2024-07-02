// To parse this JSON data, do
//
//     final getSourceListModel = getSourceListModelFromJson(jsonString);

import 'dart:convert';

GetSourceListModel getSourceListModelFromJson(String str) =>
    GetSourceListModel.fromJson(json.decode(str));

String getSourceListModelToJson(GetSourceListModel data) =>
    json.encode(data.toJson());

class GetSourceListModel {
  GetSourceListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<SourceModel>? modelobject;

  factory GetSourceListModel.fromJson(Map<String, dynamic> json) =>
      GetSourceListModel(
        result: json["result"],
        modelobject: List<SourceModel>.from(
            json["Modelobject"].map((x) => SourceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class SourceModel {
  SourceModel({
     this.code,
     this.name,
     this.genericListType,
  });

  String? code;
  String? name;
  int? genericListType;

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
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
