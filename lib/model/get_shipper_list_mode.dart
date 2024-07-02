// To parse this JSON data, do
//
//     final getShipperListModel = getShipperListModelFromJson(jsonString);

import 'dart:convert';

GetShipperListModel getShipperListModelFromJson(String str) =>
    GetShipperListModel.fromJson(json.decode(str));

String getShipperListModelToJson(GetShipperListModel data) =>
    json.encode(data.toJson());

class GetShipperListModel {
  int? res;
  List<ShipperModel>? modelobject;

  GetShipperListModel({
    this.res,
    this.modelobject,
  });

  factory GetShipperListModel.fromJson(Map<String, dynamic> json) =>
      GetShipperListModel(
        res: json["res"],
        modelobject: List<ShipperModel>.from(
            json["Modelobject"].map((x) => ShipperModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class ShipperModel {
  String? code;
  String? name;
  int? genericListType;

  ShipperModel({
    this.code,
    this.name,
    this.genericListType,
  });

  factory ShipperModel.fromJson(Map<String, dynamic> json) => ShipperModel(
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
