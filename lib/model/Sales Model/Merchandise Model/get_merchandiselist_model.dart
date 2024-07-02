// To parse this JSON data, do
//
//     final getMercahndiseOpenListModel = getMercahndiseOpenListModelFromJson(jsonString);

import 'dart:convert';

GetMercahndiseOpenListModel getMercahndiseOpenListModelFromJson(String str) => GetMercahndiseOpenListModel.fromJson(json.decode(str));

String getMercahndiseOpenListModelToJson(GetMercahndiseOpenListModel data) => json.encode(data.toJson());

class GetMercahndiseOpenListModel {
    int? res;
    List<Model>? model;
    String? msg;

    GetMercahndiseOpenListModel({
        this.res,
        this.model,
        this.msg,
    });

    factory GetMercahndiseOpenListModel.fromJson(Map<String, dynamic> json) => GetMercahndiseOpenListModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<Model>.from(json["model"]!.map((x) => Model.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class Model {
    String? docId;
    String? docNumber;
    String? partyId;
    dynamic partyName;
    DateTime? transactionDate;
    String? salesperson;
    dynamic quantity;
    String? ref1;
    String? ref2;
    String? transactionType;
    DateTime? expiryDate;

    Model({
        this.docId,
        this.docNumber,
        this.partyId,
        this.partyName,
        this.transactionDate,
        this.salesperson,
        this.quantity,
        this.ref1,
        this.ref2,
        this.transactionType,
        this.expiryDate,
    });

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        docId: json["Doc ID"],
        docNumber: json["Doc Number"],
        partyId: json[" Party ID"],
        partyName: json["PARTY NAME"],
        transactionDate: json["TransactionDate"] == null ? null : DateTime.parse(json["TransactionDate"]),
        salesperson: json["Salesperson"],
        quantity: json["Quantity"],
        ref1: json["Ref1"],
        ref2: json["Ref2"],
        transactionType: json["TransactionType"],
        expiryDate: json["ExpiryDate"] == null ? null : DateTime.parse(json["ExpiryDate"]),
    );

    Map<String, dynamic> toJson() => {
        "Doc ID": docId,
        "Doc Number": docNumber,
        " Party ID": partyId,
        "PARTY NAME": partyName,
        "TransactionDate": transactionDate?.toIso8601String(),
        "Salesperson": salesperson,
        "Quantity": quantity,
        "Ref1": ref1,
        "Ref2": ref2,
        "TransactionType": transactionType,
        "ExpiryDate": expiryDate?.toIso8601String(),
    };
}
