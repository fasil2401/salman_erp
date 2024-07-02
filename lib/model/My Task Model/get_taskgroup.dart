// To parse this JSON data, do
//
//     final getProjectTaskGroupComboList = getProjectTaskGroupComboListFromJson(jsonString);

import 'dart:convert';

GetProjectTaskGroupComboList getProjectTaskGroupComboListFromJson(String str) => GetProjectTaskGroupComboList.fromJson(json.decode(str));

String getProjectTaskGroupComboListToJson(GetProjectTaskGroupComboList data) => json.encode(data.toJson());

class GetProjectTaskGroupComboList {
    int? res;
    List<TaskGroupModel>? model;
    String? msg;

    GetProjectTaskGroupComboList({
        this.res,
        this.model,
        this.msg,
    });

    factory GetProjectTaskGroupComboList.fromJson(Map<String, dynamic> json) => GetProjectTaskGroupComboList(
        res: json["res"],
        model: json["model"] == null ? [] : List<TaskGroupModel>.from(json["model"]!.map((x) => TaskGroupModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class TaskGroupModel {
    String? code;
    String? name;

    TaskGroupModel({
        this.code,
        this.name,
    });

    factory TaskGroupModel.fromJson(Map<String, dynamic> json) => TaskGroupModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
