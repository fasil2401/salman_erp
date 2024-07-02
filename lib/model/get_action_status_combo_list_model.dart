import 'dart:convert';

GetActionStatusComboListModel getActionStatusComboListModelFromJson(
        String str) =>
    GetActionStatusComboListModel.fromJson(json.decode(str));

String getActionStatusComboListModelToJson(
        GetActionStatusComboListModel data) =>
    json.encode(data.toJson());

class GetActionStatusComboListModel {
  int? res;
  List<ActionStatusComboModel>? modelobject;

  GetActionStatusComboListModel({
    this.res,
    this.modelobject,
  });

  factory GetActionStatusComboListModel.fromJson(Map<String, dynamic> json) =>
      GetActionStatusComboListModel(
        res: json["res"],
        modelobject: List<ActionStatusComboModel>.from(
            json["Modelobject"].map((x) => ActionStatusComboModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class ActionStatusComboModel {
    String? code;
    String? name;
    int? statusType;
    String? hexColorCode;
    String? ref1Name;
    String? ref2Name;

    ActionStatusComboModel({
        this.code,
        this.name,
        this.statusType,
        this.hexColorCode,
        this.ref1Name,
        this.ref2Name,
    });

    factory ActionStatusComboModel.fromJson(Map<String, dynamic> json) => ActionStatusComboModel(
        code: json["Code"],
        name: json["Name"],
        statusType: json["StatusType"],
        hexColorCode: json["HexColorCode"],
        ref1Name: json["Ref1Name"],
        ref2Name: json["Ref2Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "StatusType": statusType,
        "HexColorCode": hexColorCode,
        "Ref1Name": ref1Name,
        "Ref2Name": ref2Name,
    };
}
