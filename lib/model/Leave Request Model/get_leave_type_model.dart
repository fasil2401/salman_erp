// To parse this JSON data, do
//
//     final getLeaveTypeModel = getLeaveTypeModelFromJson(jsonString);

import 'dart:convert';

GetLeaveTypeModel getLeaveTypeModelFromJson(String str) =>
    GetLeaveTypeModel.fromJson(json.decode(str));

String getLeaveTypeModelToJson(GetLeaveTypeModel data) =>
    json.encode(data.toJson());

class GetLeaveTypeModel {
  int? res;
  List<LeaveTypeModel>? model;
  String? msg;

  GetLeaveTypeModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetLeaveTypeModel.fromJson(Map<String, dynamic> json) =>
      GetLeaveTypeModel(
        res: json["res"],
        model: List<LeaveTypeModel>.from(json["model"].map((x) => LeaveTypeModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class LeaveTypeModel {
  String? typeCode;
  String? typeName;
  int? days;
  bool? payable;
  bool? cumulative;
  bool? inactive;

  LeaveTypeModel({
    this.typeCode,
    this.typeName,
    this.days,
    this.payable,
    this.cumulative,
    this.inactive,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
        typeCode: json["Type Code"],
        typeName: json["Type Name"],
        days: json["Days"],
        payable: json["Payable"],
        cumulative: json["Cumulative"],
        inactive: json["Inactive"],
      );

  Map<String, dynamic> toJson() => {
        "Type Code": typeCode,
        "Type Name": typeName,
        "Days": days,
        "Payable": payable,
        "Cumulative": cumulative,
        "Inactive": inactive,
      };
}
