// To parse this JSON data, do
//
//     final getDelayReasonComboList = getDelayReasonComboListFromJson(jsonString);

import 'dart:convert';

GetDelayReasonComboList getDelayReasonComboListFromJson(String str) => GetDelayReasonComboList.fromJson(json.decode(str));

String getDelayReasonComboListToJson(GetDelayReasonComboList data) => json.encode(data.toJson());

class GetDelayReasonComboList {
    int? result;
    List<DelayReasonComboList>? modelobject;

    GetDelayReasonComboList({
        this.result,
        this.modelobject,
    });

    factory GetDelayReasonComboList.fromJson(Map<String, dynamic> json) => GetDelayReasonComboList(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<DelayReasonComboList>.from(json["Modelobject"]!.map((x) => DelayReasonComboList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class DelayReasonComboList {
    String? code;
    String? name;
    int? genericListType;

    DelayReasonComboList({
        this.code,
        this.name,
        this.genericListType,
    });

    factory DelayReasonComboList.fromJson(Map<String, dynamic> json) => DelayReasonComboList(
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
