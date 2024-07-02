// To parse this JSON data, do
//
//     final getCustomerGroupListModel = getCustomerGroupListModelFromJson(jsonString);

import 'dart:convert';

GetCustomerGroupListModel getCustomerGroupListModelFromJson(String str) =>
    GetCustomerGroupListModel.fromJson(json.decode(str));

String getCustomerGroupListModelToJson(GetCustomerGroupListModel data) =>
    json.encode(data.toJson());

class GetCustomerGroupListModel {
  GetCustomerGroupListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<CustomerGroupModel>? modelobject;

  factory GetCustomerGroupListModel.fromJson(Map<String, dynamic> json) =>
      GetCustomerGroupListModel(
        result: json["result"],
        modelobject: List<CustomerGroupModel>.from(
            json["Modelobject"].map((x) => CustomerGroupModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class CustomerGroupModel {
  CustomerGroupModel({
     this.code,
     this.name,
  });

  String? code;
  String? name;

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) => CustomerGroupModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
