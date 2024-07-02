// To parse this JSON data, do
//
//     final getCostCategoryList = getCostCategoryListFromJson(jsonString);

import 'dart:convert';

GetCostCategoryList getCostCategoryListFromJson(String str) => GetCostCategoryList.fromJson(json.decode(str));

String getCostCategoryListToJson(GetCostCategoryList data) => json.encode(data.toJson());

class GetCostCategoryList {
    int? result;
    List<CostCategoryModel>? modelobject;

    GetCostCategoryList({
        this.result,
        this.modelobject,
    });

    factory GetCostCategoryList.fromJson(Map<String, dynamic> json) => GetCostCategoryList(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<CostCategoryModel>.from(json["Modelobject"]!.map((x) => CostCategoryModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class CostCategoryModel {
    String? code;
    String? name;
    int? costTypeId;

    CostCategoryModel({
        this.code,
        this.name,
        this.costTypeId,
    });

    factory CostCategoryModel.fromJson(Map<String, dynamic> json) => CostCategoryModel(
        code: json["Code"],
        name: json["Name"],
        costTypeId: json["CostTypeID"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "CostTypeID": costTypeId,
    };
}
