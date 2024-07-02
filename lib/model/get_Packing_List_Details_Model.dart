// To parse this JSON data, do
//
//     final getPackingListDetailsModel = getPackingListDetailsModelFromJson(jsonString);

import 'dart:convert';

GetPackingListDetailsModel getPackingListDetailsModelFromJson(String str) =>
    GetPackingListDetailsModel.fromJson(json.decode(str));

String getPackingListDetailsModelToJson(GetPackingListDetailsModel data) =>
    json.encode(data.toJson());

class GetPackingListDetailsModel {
  int? res;
  List<PackingDetailModel>? modelobject;

  GetPackingListDetailsModel({
    this.res,
    this.modelobject,
  });

  factory GetPackingListDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetPackingListDetailsModel(
        res: json["res"],
        modelobject: List<PackingDetailModel>.from(
            json["Modelobject"].map((x) => PackingDetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class PackingDetailModel {
  String? docId;
  String? voucherId;
  String? vendorName;
  DateTime? transactionDate;
  String? containerNumber;
  String? bolNumber;
  dynamic atd;
  dynamic eta;
  DateTime? freeTimeExpiry;
  String? shipperName;
  String? shipper;
  String? port;
  String? loadingPort;
  String? actionstatuslog;
  DateTime? logDate;
  String? itemCategory;
  String? nonPo;
  String? comments;
  String? hexColorCode;
  String? reference1;
  String? reference2;

  PackingDetailModel({
    this.docId,
    this.voucherId,
    this.vendorName,
    this.transactionDate,
    this.containerNumber,
    this.bolNumber,
    this.atd,
    this.eta,
    this.freeTimeExpiry,
    this.shipperName,
    this.shipper,
    this.port,
    this.loadingPort,
    this.actionstatuslog,
    this.logDate,
    this.itemCategory,
    this.nonPo,
    this.comments,
    this.hexColorCode,
    this.reference1,
    this.reference2,
  });

  factory PackingDetailModel.fromJson(Map<String, dynamic> json) =>
      PackingDetailModel(
        docId: json["DocID"],
        voucherId: json["VoucherId"],
        vendorName: json["VendorName"],
        transactionDate: json["TransactionDate"] == null
            ? null
            : DateTime.parse(json["TransactionDate"]),
        containerNumber: json["ContainerNumber"],
        bolNumber: json["BolNumber"],
        atd: json["ATD"],
        eta: json["ETA"],
        freeTimeExpiry: json["FreeTimeExpiry"] == null
            ? null
            : DateTime.parse(json["FreeTimeExpiry"]),
        shipperName: json["ShipperName"],
        shipper: json["Shipper"],
        port: json["Port"],
        loadingPort: json["LoadingPort"],
        actionstatuslog: json["Actionstatuslog"],
        logDate:
            json["LogDate"] == null ? null : DateTime.parse(json["LogDate"]),
        itemCategory: json["ItemCategory"],
        nonPo: json["NonPO"],
        comments: json["Comments"],
        hexColorCode: json["HexColorCode"],
        reference1: json["Reference1"],
        reference2: json["Reference2"],
      );

  Map<String, dynamic> toJson() => {
        "DocID": docId,
        "VoucherId": voucherId,
        "VendorName": vendorName,
        "TransactionDate": transactionDate!.toIso8601String(),
        "ContainerNumber": containerNumber,
        "BolNumber": bolNumber,
        "ATD": atd,
        "ETA": eta,
        "FreeTimeExpiry": freeTimeExpiry!.toIso8601String(),
        "ShipperName": shipperName,
        "Shipper": shipper,
        "Port": port,
        "LoadingPort": loadingPort,
        "Actionstatuslog": actionstatuslog,
        "LogDate": logDate,
        "ItemCategory": itemCategory,
        "NonPO": nonPo,
        "Comments": comments,
        "HexColorCode": hexColorCode,
        "Reference1": reference1,
        "Reference2": reference2,
      };
}
