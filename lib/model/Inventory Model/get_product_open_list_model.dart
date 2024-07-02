// To parse this JSON data, do
//
//     final getProductOpenListModel = getProductOpenListModelFromJson(jsonString);

import 'dart:convert';

GetProductOpenListModel getProductOpenListModelFromJson(String str) =>
    GetProductOpenListModel.fromJson(json.decode(str));

String getProductOpenListModelToJson(GetProductOpenListModel data) =>
    json.encode(data.toJson());

class GetProductOpenListModel {
  int? res;
  List<Model>? model;
  List<Detail>? details;
  String? msg;

  GetProductOpenListModel({
    this.res,
    this.model,
    this.details,
    this.msg,
  });

  factory GetProductOpenListModel.fromJson(Map<String, dynamic> json) =>
      GetProductOpenListModel(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model?.map((x) => x.toJson()) ?? []),
        "details": List<dynamic>.from(details?.map((x) => x.toJson()) ?? []),
        "msg": msg,
      };
}

class Detail {
  String? entityId;
  String? flagId;
  int? entityType;
  String? flagName;
  int? color;

  Detail({
    this.entityId,
    this.flagId,
    this.entityType,
    this.flagName,
    this.color,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        entityId: json["EntityID"],
        flagId: json["FlagID"],
        entityType: json["EntityType"],
        flagName: json["FlagName"],
        color: json["Color"],
      );

  Map<String, dynamic> toJson() => {
        "EntityID": entityId,
        "FlagID": flagId,
        "EntityType": entityType,
        "FlagName": flagName,
        "Color": color,
      };
}

class Model {
  bool? i;
  int? p;
  String? f;
  String? itemCode;
  dynamic matrixCode;
  String? description;
  String? alias;
  dynamic type;
  dynamic unitPrice1;
  dynamic unitPrice2;
  dynamic unitPrice3;
  dynamic minPrice;
  dynamic avgCost;
  String? unit;
  String? category;
  dynamic lastSale;
  String? attribute1;
  String? attribute2;
  String? attribute3;
  String? vendorRef;
  dynamic quantityPerUnit;
  dynamic weight;
  dynamic reorderLevel;
  String? origin;
  String? size;
  String? style;
  String? modelClass;
  String? brand;
  dynamic age;
  String? manufacturer;
  String? upc;
  dynamic onhand;
  dynamic value;
  dynamic totalWeight;

  Model({
    this.i,
    this.p,
    this.f,
    this.itemCode,
    this.matrixCode,
    this.description,
    this.alias,
    this.type,
    this.unitPrice1,
    this.unitPrice2,
    this.unitPrice3,
    this.minPrice,
    this.avgCost,
    this.unit,
    this.category,
    this.lastSale,
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.vendorRef,
    this.quantityPerUnit,
    this.weight,
    this.reorderLevel,
    this.origin,
    this.size,
    this.style,
    this.modelClass,
    this.brand,
    this.age,
    this.manufacturer,
    this.upc,
    this.onhand,
    this.value,
    this.totalWeight,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        i: json["I"],
        p: json["P"],
        f: json["F"],
        itemCode: json["Item Code"],
        matrixCode: json["Matrix Code"],
        description: json["Description"],
        alias: json["ALIAS"],
        type: json["Type"],
        unitPrice1: json["UnitPrice1"],
        unitPrice2: json["UnitPrice2"],
        unitPrice3: json["UnitPrice3"],
        minPrice: json["MinPrice"],
        avgCost: json["Avg Cost"],
        unit: json["Unit"],
        category: json["Category"],
        lastSale: json["LastSale"],
        attribute1: json["Attribute1"],
        attribute2: json["Attribute2"],
        attribute3: json["Attribute3"],
        vendorRef: json["VendorRef"],
        quantityPerUnit: json["QuantityPerUnit"],
        weight: json["Weight"],
        reorderLevel: json["ReorderLevel"],
        origin: json["Origin"],
        size: json["Size"],
        style: json["Style"],
        modelClass: json["Class"],
        brand: json["Brand"],
        age: json["Age"],
        manufacturer: json["Manufacturer"],
        upc: json["UPC"],
        onhand: json["Onhand"],
        value: json["Value"],
        totalWeight: json["TotalWeight"],
      );

  Map<String, dynamic> toJson() => {
        "I": i,
        "P": p,
        "F": f,
        "Item Code": itemCode,
        "Matrix Code": matrixCode,
        "Description": description,
        "ALIAS": alias,
        "Type": type,
        "UnitPrice1": unitPrice1,
        "UnitPrice2": unitPrice2,
        "UnitPrice3": unitPrice3,
        "MinPrice": minPrice,
        "Avg Cost": avgCost,
        "Unit": unit,
        "Category": category,
        "LastSale": lastSale,
        "Attribute1": attribute1,
        "Attribute2": attribute2,
        "Attribute3": attribute3,
        "VendorRef": vendorRef,
        "QuantityPerUnit": quantityPerUnit,
        "Weight": weight,
        "ReorderLevel": reorderLevel,
        "Origin": origin,
        "Size": size,
        "Style": style,
        "Class": modelClass,
        "Brand": brand,
        "Age": age,
        "Manufacturer": manufacturer,
        "UPC": upc,
        "Onhand": onhand,
        "Value": value,
        "TotalWeight": totalWeight,
      };
}
