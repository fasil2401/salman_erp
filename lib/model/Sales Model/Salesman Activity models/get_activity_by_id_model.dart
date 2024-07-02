import 'dart:convert';

GetActivityByIdModel getActivityByIdModelFromJson(String str) =>
    GetActivityByIdModel.fromJson(json.decode(str));

String getActivityByIdModelToJson(GetActivityByIdModel data) =>
    json.encode(data.toJson());

class GetActivityByIdModel {
  GetActivityByIdModel({
     this.result,
     this.modelobject,
  });

  int? result;
  List<ActivitybyIdModel>? modelobject;

  factory GetActivityByIdModel.fromJson(Map<String, dynamic> json) =>
      GetActivityByIdModel(
        result: json["result"],
        modelobject: List<ActivitybyIdModel>.from(
            json["Modelobject"].map((x) => ActivitybyIdModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject?.map((x) => x.toJson())??[]),
      };
}

class ActivitybyIdModel {
  ActivitybyIdModel({
     this.sysDocId,
     this.voucherId,
     this.activityName,
     this.activityType,
     this.reasonId,
     this.relatedId,
     this.relatedType,
    this.contactId,
     this.ownerId,
     this.activityDateTime,
     this.note,
     this.dateCreated,
    this.dateUpdated,
     this.createdBy,
    this.updatedBy,
  });

  String? sysDocId;
  String? voucherId;
  String? activityName;
  String? activityType;
  String? reasonId;
  String? relatedId;
  int? relatedType;
  dynamic contactId;
  String? ownerId;
  DateTime? activityDateTime;
  String? note;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;

  factory ActivitybyIdModel.fromJson(Map<String, dynamic> json) => ActivitybyIdModel(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        activityName: json["ActivityName"],
        activityType: json["ActivityType"],
        reasonId: json["ReasonID"],
        relatedId: json["RelatedID"],
        relatedType: json["RelatedType"],
        contactId: json["ContactID"],
        ownerId: json["OwnerID"],
        activityDateTime: DateTime.parse(json["ActivityDateTime"]),
        note: json["Note"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ActivityName": activityName,
        "ActivityType": activityType,
        "ReasonID": reasonId,
        "RelatedID": relatedId,
        "RelatedType": relatedType,
        "ContactID": contactId,
        "OwnerID": ownerId,
        "ActivityDateTime": activityDateTime!.toIso8601String(),
        "Note": note,
        "DateCreated": dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
