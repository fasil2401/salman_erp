import 'dart:convert';

GetFilterSysDoclistModel getFilterSysDoclistModelFromJson(String str) =>
    GetFilterSysDoclistModel.fromJson(json.decode(str));

String getFilterSysDoclistModelToJson(GetFilterSysDoclistModel data) =>
    json.encode(data.toJson());

class GetFilterSysDoclistModel {
  int? res;
  List<FilterSysDocModel>? modelobject;

  GetFilterSysDoclistModel({
    this.res,
    this.modelobject,
  });

  factory GetFilterSysDoclistModel.fromJson(Map<String, dynamic> json) =>
      GetFilterSysDoclistModel(
        res: json["res"],
        modelobject: List<FilterSysDocModel>.from(
            json["Modelobject"].map((x) => FilterSysDocModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class FilterSysDocModel {
  String? sysDocId;
  String? entityId;
  int? entityType;
  int? sysDocType;

  FilterSysDocModel({
    this.sysDocId,
    this.entityId,
    this.entityType,
    this.sysDocType,
  });

  factory FilterSysDocModel.fromJson(Map<String, dynamic> json) =>
      FilterSysDocModel(
        sysDocId: json["SysDocID"],
        entityId: json["EntityID"],
        entityType: json["EntityType"],
        sysDocType: json["SysDocType"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "EntityID": entityId,
        "EntityType": entityType,
        "SysDocType": sysDocType,
      };
}
