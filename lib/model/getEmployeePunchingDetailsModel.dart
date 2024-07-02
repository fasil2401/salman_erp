// To parse this JSON data, do
//
//     final getEmployeePunchingDetailsModel = getEmployeePunchingDetailsModelFromJson(jsonString);

import 'dart:convert';

GetEmployeePunchingDetailsModel getEmployeePunchingDetailsModelFromJson(
        String str) =>
    GetEmployeePunchingDetailsModel.fromJson(json.decode(str));

String getEmployeePunchingDetailsModelToJson(
        GetEmployeePunchingDetailsModel data) =>
    json.encode(data.toJson());

class GetEmployeePunchingDetailsModel {
  GetEmployeePunchingDetailsModel({
    this.res,
    this.model,
  });

  int? res;
  List<Model>? model;

  factory GetEmployeePunchingDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetEmployeePunchingDetailsModel(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson())??[]),
      };
}

class Model {
  Model({
    this.employeeId,
    this.firstName,
    this.latitude,
    this.longitude,
    this.allowGeoFencingOnPunching,
  });

  String? employeeId;
  String? firstName;
  String? latitude;
  String? longitude;
  bool? allowGeoFencingOnPunching;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        employeeId: json["EmployeeID"],
        firstName: json["FirstName"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        allowGeoFencingOnPunching: json["AllowGeoFencingOnPunching"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "FirstName": firstName,
        "Latitude": latitude,
        "Longitude": longitude,
        "AllowGeoFencingOnPunching": allowGeoFencingOnPunching,
      };
}
