// To parse this JSON data, do
//
//     final getPriorityComboList = getPriorityComboListFromJson(jsonString);

import 'dart:convert';

GetPriorityComboList getPriorityComboListFromJson(String str) => GetPriorityComboList.fromJson(json.decode(str));

String getPriorityComboListToJson(GetPriorityComboList data) => json.encode(data.toJson());

class GetPriorityComboList {
    int? result;
    List<PriorityComboModel>? modelobject;

    GetPriorityComboList({
        this.result,
        this.modelobject,
    });

    factory GetPriorityComboList.fromJson(Map<String, dynamic> json) => GetPriorityComboList(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<PriorityComboModel>.from(json["Modelobject"]!.map((x) => PriorityComboModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class PriorityComboModel {
    String? code;
    String? name;
    int? genericListType;

    PriorityComboModel({
        this.code,
        this.name,
        this.genericListType,
    });

    factory PriorityComboModel.fromJson(Map<String, dynamic> json) => PriorityComboModel(
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
