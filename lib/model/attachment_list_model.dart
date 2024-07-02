import 'dart:convert';

GetAttachmentListModel getAttachmentListModelFromJson(String str) => GetAttachmentListModel.fromJson(json.decode(str));

String getAttachmentListModelToJson(GetAttachmentListModel data) => json.encode(data.toJson());

class GetAttachmentListModel {
    int? result;
    List<AttachmentListModel>? modelobject;

    GetAttachmentListModel({
        this.result,
        this.modelobject,
    });

    factory GetAttachmentListModel.fromJson(Map<String, dynamic> json) => GetAttachmentListModel(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<AttachmentListModel>.from(json["Modelobject"]!.map((x) => AttachmentListModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class AttachmentListModel {
    String? token;
    String? entityId;
    int? entityType;
    String? entitySysDocId;
    String? entityDocName;
    String? entityDocDesc;
    String? entityDocKeyword;
    String? entityDocPath;
    int? rowIndex;
    String? fileData;

    AttachmentListModel({
        this.token,
        this.entityId,
        this.entityType,
        this.entitySysDocId,
        this.entityDocName,
        this.entityDocDesc,
        this.entityDocKeyword,
        this.entityDocPath,
        this.rowIndex,
        this.fileData,
    });

    factory AttachmentListModel.fromJson(Map<String, dynamic> json) => AttachmentListModel(
        token: json["token"],
        entityId: json["EntityID"],
        entityType: json["EntityType"],
        entitySysDocId: json["EntitySysDocID"],
        entityDocName: json["EntityDocName"],
        entityDocDesc: json["EntityDocDesc"],
        entityDocKeyword: json["EntityDocKeyword"],
        entityDocPath: json["EntityDocPath"],
        rowIndex: json["RowIndex"],
        fileData: json["FileData"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "EntityID": entityId,
        "EntityType": entityType,
        "EntitySysDocID": entitySysDocId,
        "EntityDocName": entityDocName,
        "EntityDocDesc": entityDocDesc,
        "EntityDocKeyword": entityDocKeyword,
        "EntityDocPath": entityDocPath,
        "RowIndex": rowIndex,
        "FileData": fileData,
    };
}
