// To parse this JSON data, do
//
//     final getTeamComboListModel = getTeamComboListModelFromJson(jsonString);

import 'dart:convert';

GetTeamComboListModel getTeamComboListModelFromJson(String str) => GetTeamComboListModel.fromJson(json.decode(str));

String getTeamComboListModelToJson(GetTeamComboListModel data) => json.encode(data.toJson());

class GetTeamComboListModel {
    int? result;
    List<TeamComboList>? modelobject;

    GetTeamComboListModel({
        this.result,
        this.modelobject,
    });

    factory GetTeamComboListModel.fromJson(Map<String, dynamic> json) => GetTeamComboListModel(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<TeamComboList>.from(json["Modelobject"]!.map((x) => TeamComboList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class TeamComboList {
    String? code;
    String? name;
    int? type;

    TeamComboList({
        this.code,
        this.name,
        this.type,
    });

    factory TeamComboList.fromJson(Map<String, dynamic> json) => TeamComboList(
        code: json["Code"],
        name: json["Name"],
        type: json["Type"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "Type": type,
    };
}
