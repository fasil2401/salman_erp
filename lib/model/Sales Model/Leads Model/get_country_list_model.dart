// To parse this JSON data, do
//
//     final getCountryListModel = getCountryListModelFromJson(jsonString);

import 'dart:convert';

GetCountryListModel getCountryListModelFromJson(String str) =>
    GetCountryListModel.fromJson(json.decode(str));

String getCountryListModelToJson(GetCountryListModel data) =>
    json.encode(data.toJson());

class GetCountryListModel {
  GetCountryListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<CountryModel>? modelobject;

  factory GetCountryListModel.fromJson(Map<String, dynamic> json) =>
      GetCountryListModel(
        result: json["result"],
        modelobject: List<CountryModel>.from(
            json["Modelobject"].map((x) => CountryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class CountryModel {
  CountryModel({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
