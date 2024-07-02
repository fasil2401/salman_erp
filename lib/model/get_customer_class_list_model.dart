// To parse this JSON data, do
//
//     final getCustomerClassListModel = getCustomerClassListModelFromJson(jsonString);

import 'dart:convert';

GetCustomerClassListModel getCustomerClassListModelFromJson(String str) =>
    GetCustomerClassListModel.fromJson(json.decode(str));

String getCustomerClassListModelToJson(GetCustomerClassListModel data) =>
    json.encode(data.toJson());

class GetCustomerClassListModel {
  GetCustomerClassListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<CustomerClassModel>? modelobject;

  factory GetCustomerClassListModel.fromJson(Map<String, dynamic> json) =>
      GetCustomerClassListModel(
        result: json["result"],
        modelobject: List<CustomerClassModel>.from(
            json["Modelobject"].map((x) => CustomerClassModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class CustomerClassModel {
  CustomerClassModel({
     this.code,
     this.name,
  });

  String? code;
  String? name;

  factory CustomerClassModel.fromJson(Map<String, dynamic> json) => CustomerClassModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
