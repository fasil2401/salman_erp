// To parse this JSON data, do
//
//     final getAreaListModel = getAreaListModelFromJson(jsonString);

import 'dart:convert';

GetAreaListModel getAreaListModelFromJson(String str) =>
    GetAreaListModel.fromJson(json.decode(str));

String getAreaListModelToJson(GetAreaListModel data) =>
    json.encode(data.toJson());

class GetAreaListModel {
  GetAreaListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<AreaModel>? modelobject;

  factory GetAreaListModel.fromJson(Map<String, dynamic> json) =>
      GetAreaListModel(
        result: json["result"],
        modelobject: List<AreaModel>.from(
            json["Modelobject"].map((x) => AreaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class AreaModel {
  AreaModel({
    this.code,
    this.name,
    this.countryId,
  });

  String? code;
  String? name;
  String? countryId;

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        code: json["Code"],
        name: json["Name"],
        countryId: json["CountryID"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "CountryID": countryId,
      };
}
