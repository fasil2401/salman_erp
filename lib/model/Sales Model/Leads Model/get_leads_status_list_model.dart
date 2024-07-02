import 'dart:convert';

GetLeadStatusListModel getLeadStatusListModelFromJson(String str) =>
    GetLeadStatusListModel.fromJson(json.decode(str));

String getLeadStatusListModelToJson(GetLeadStatusListModel data) =>
    json.encode(data.toJson());

class GetLeadStatusListModel {
  GetLeadStatusListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<StatusModel>? modelobject;

  factory GetLeadStatusListModel.fromJson(Map<String, dynamic> json) =>
      GetLeadStatusListModel(
        result: json["result"],
        modelobject: List<StatusModel>.from(
            json["Modelobject"].map((x) => StatusModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class StatusModel {
  StatusModel({
    this.code,
    this.name,
    this.statusType,
  });

  String? code;
  String? name;
  int? statusType;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        code: json["Code"],
        name: json["Name"],
        statusType: json["StatusType"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "StatusType": statusType,
      };
}
