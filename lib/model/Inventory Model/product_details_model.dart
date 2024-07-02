import 'dart:convert';

import 'package:axolon_erp/model/Tax%20Model/tax_model.dart';

ProductDetailsModel ProductDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

String ProductDetailsModelToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  ProductDetailsModel({
    required this.res,
    required this.model,
    required this.unitmodel,
    required this.productlocationmodel,
    this.taxList,
    required this.msg,
  });

  int res;
  List<SingleProduct> model;
  List<Unitmodel> unitmodel;
  List<Productlocationmodel> productlocationmodel;
  List<TaxModel>? taxList;
  String msg;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModel(
        res: json["res"],
        model: List<SingleProduct>.from(
            json["model"].map((x) => SingleProduct.fromJson(x))),
        unitmodel: List<Unitmodel>.from(
            json["unitmodel"].map((x) => Unitmodel.fromJson(x))),
        productlocationmodel: List<Productlocationmodel>.from(
            json["productlocationmodel"]
                .map((x) => Productlocationmodel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "unitmodel": List<dynamic>.from(unitmodel.map((x) => x.toJson())),
        "productlocationmodel":
            List<dynamic>.from(productlocationmodel.map((x) => x.toJson())),
        "msg": msg,
      };
}

class SingleProduct {
  SingleProduct(
      {this.taxOption,
      this.origin,
      this.productId,
      this.productimage,
      this.isTrackLot,
      this.upc,
      this.unitId,
      this.updatedUnitId,
      this.taxGroupId,
      this.locationId,
      this.quantity,
      this.updatedQuantity,
      this.taxAmount,
      this.specialPrice,
      this.price1,
      this.updatedPrice,
      this.price2,
      this.size,
      this.rackBin,
      this.description,
      this.reorderLevel,
      this.minPrice,
      this.category,
      this.style,
      this.modelClass,
      this.brand,
      this.age,
      this.manufacturer,
      this.selectedStock,
      this.remarks,
      this.itemType,
      this.categoryId,
      this.expiryDate,
      this.cost});

  dynamic taxOption;
  String? origin;
  String? productId;
  String? productimage;
  bool? isTrackLot;
  String? upc;
  String? unitId;
  String? updatedUnitId;
  dynamic taxAmount;
  String? taxGroupId;
  String? locationId;
  dynamic quantity;
  dynamic updatedQuantity;
  dynamic specialPrice;
  dynamic price1;
  dynamic updatedPrice;
  dynamic price2;
  String? size;
  String? rackBin;
  String? description;
  dynamic reorderLevel;
  dynamic unitPrice1;
  dynamic unitPrice2;
  dynamic unitPrice3;
  dynamic minPrice;
  dynamic unit;
  String? category;
  String? style;
  String? modelClass;
  String? brand;
  dynamic age;
  String? manufacturer;
  dynamic selectedStock;
  String? remarks;
  int? itemType;
  String? categoryId;
  int? cost;
  DateTime? expiryDate;

  factory SingleProduct.fromJson(Map<String, dynamic> json) => SingleProduct(
        taxOption: json["TaxOption"],
        origin: json["Origin"],
        productId: json["ProductID"],
        productimage: json["productimage"],
        isTrackLot: json["IsTrackLot"],
        upc: json["UPC"],
        unitId: json["UnitID"],
        taxGroupId: json["TaxGroupID"],
        locationId: json["LocationID"],
        quantity: json["Quantity"],
        specialPrice: json["SpecialPrice"],
        price1: json["Price1"],
        price2: json["Price2"],
        size: json["Size"],
        rackBin: json["RackBin"],
        description: json["Description"],
        reorderLevel: json["ReorderLevel"],
        minPrice: json["MinPrice"],
        category: json["Category"],
        style: json["Style"],
        modelClass: json["Class"],
        brand: json["Brand"],
        age: json["Age"],
        manufacturer: json["Manufacturer"],
        itemType: json["ItemType"],
        categoryId: json["CategoryID"],
        cost: json["Cost"],
      );

  Map<String, dynamic> toJson() => {
        "TaxOption": taxOption,
        "Origin": origin,
        "ProductID": productId,
        "productimage": productimage,
        "IsTrackLot": isTrackLot,
        "UPC": upc,
        "UnitID": unitId,
        "TaxGroupID": taxGroupId,
        "LocationID": locationId,
        "Quantity": quantity,
        "SpecialPrice": specialPrice,
        "Price1": price1,
        "Price2": price2,
        "Size": size,
        "RackBin": rackBin,
        "Description": description,
        "ReorderLevel": reorderLevel,
        "MinPrice": minPrice,
        "Category": category,
        "Style": style,
        "Class": modelClass,
        "Brand": brand,
        "Age": age,
        "Manufacturer": manufacturer,
        "ItemType": itemType,
        "CategoryID": categoryId,
        "Cost": cost,
      };
}

class Productlocationmodel {
  Productlocationmodel({
    this.locationId,
    this.productId,
    this.quantity,
  });

  String? locationId;
  String? productId;
  dynamic quantity;

  factory Productlocationmodel.fromJson(Map<String, dynamic> json) =>
      Productlocationmodel(
        locationId: json["LocationID"],
        productId: json["ProductID"],
        quantity: json["Quantity"],
      );

  Map<String, dynamic> toJson() => {
        "LocationID": locationId,
        "ProductID": productId,
        "Quantity": quantity,
      };
}

class Unitmodel {
  Unitmodel({
    this.code,
    this.name,
    this.productId,
    this.factorType,
    this.factor,
    this.isMainUnit,
  });

  String? code;
  String? name;
  String? productId;
  String? factorType;
  String? factor;
  bool? isMainUnit;

  factory Unitmodel.fromJson(Map<String, dynamic> json) => Unitmodel(
        code: json["Code"],
        name: json["Name"],
        productId: json["ProductID"],
        factorType: json["FactorType"],
        factor: json["Factor"],
        isMainUnit: json["IsMainUnit"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "ProductID": productId,
        "FactorType": factorType,
        "Factor": factor,
        "IsMainUnit": isMainUnit,
      };
}
