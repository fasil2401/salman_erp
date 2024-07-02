// To parse this JSON data, do
//
//     final getEntityCommentListModel = getEntityCommentListModelFromJson(jsonString);

import 'dart:convert';

GetEntityCommentListModel getEntityCommentListModelFromJson(String str) =>
    GetEntityCommentListModel.fromJson(json.decode(str));

String getEntityCommentListModelToJson(GetEntityCommentListModel data) =>
    json.encode(data.toJson());

class GetEntityCommentListModel {
  GetEntityCommentListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<EntityCommentModel>? modelobject;

  factory GetEntityCommentListModel.fromJson(Map<String, dynamic> json) =>
      GetEntityCommentListModel(
        result: json["result"],
        modelobject: List<EntityCommentModel>.from(
            json["Modelobject"].map((x) => EntityCommentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class EntityCommentModel {
  EntityCommentModel({
    this.commentId,
    this.entityType,
    this.entityId,
    this.entitySysDocId,
    this.rowIndex,
    this.note,
    this.userId,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  int? commentId;
  int? entityType;
  String? entityId;
  dynamic entitySysDocId;
  dynamic rowIndex;
  String? note;
  dynamic userId;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;

  factory EntityCommentModel.fromJson(Map<String, dynamic> json) =>
      EntityCommentModel(
        commentId: json["CommentID"],
        entityType: json["EntityType"],
        entityId: json["EntityID"],
        entitySysDocId: json["EntitySysDocID"],
        rowIndex: json["RowIndex"],
        note: json["Note"],
        userId: json["UserID"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "CommentID": commentId,
        "EntityType": entityType,
        "EntityID": entityId,
        "EntitySysDocID": entitySysDocId,
        "RowIndex": rowIndex,
        "Note": note,
        "UserID": userId,
        "DateCreated": dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
