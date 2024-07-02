// To parse this JSON data, do
//
//     final getAdditionCodeListModel = getAdditionCodeListModelFromJson(jsonString);

import 'dart:convert';

GetAdditionCodeListModel getAdditionCodeListModelFromJson(String str) =>
    GetAdditionCodeListModel.fromJson(json.decode(str));

String getAdditionCodeListModelToJson(GetAdditionCodeListModel data) =>
    json.encode(data.toJson());

class GetAdditionCodeListModel {
  int? res;
  List<AdditionalCodeModel>? model;
  String? msg;

  GetAdditionCodeListModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetAdditionCodeListModel.fromJson(Map<String, dynamic> json) =>
      GetAdditionCodeListModel(
        res: json["res"],
        model: List<AdditionalCodeModel>.from(
            json["model"].map((x) => AdditionalCodeModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class AdditionalCodeModel {
  String? benefitCode;
  String? benefitName;
  String? note;
  bool? inactive;

  AdditionalCodeModel({
    this.benefitCode,
    this.benefitName,
    this.note,
    this.inactive,
  });

  factory AdditionalCodeModel.fromJson(Map<String, dynamic> json) =>
      AdditionalCodeModel(
        benefitCode: json["Benefit Code"],
        benefitName: json["Benefit Name"],
        note: json["Note"],
        inactive: json["Inactive"],
      );

  Map<String, dynamic> toJson() => {
        "Benefit Code": benefitCode,
        "Benefit Name": benefitName,
        "Note": note,
        "Inactive": inactive,
      };
}
