// To parse this JSON data, do
//
//     final getStageListModel = getStageListModelFromJson(jsonString);

import 'dart:convert';

GetStageListModel getStageListModelFromJson(String str) =>
    GetStageListModel.fromJson(json.decode(str));

String getStageListModelToJson(GetStageListModel data) =>
    json.encode(data.toJson());

class GetStageListModel {
  GetStageListModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<StageModel>? modelobject;

  factory GetStageListModel.fromJson(Map<String, dynamic> json) =>
      GetStageListModel(
        result: json["result"],
        modelobject: List<StageModel>.from(
            json["Modelobject"].map((x) => StageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class StageModel {
  StageModel({
     this.code,
     this.name,
     this.genericListType,
  });

  String? code;
  String? name;
  int? genericListType;

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
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
