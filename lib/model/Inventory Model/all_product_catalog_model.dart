import 'dart:convert';

AllProductCatalogModel allProductCatalogModelFromJson(String str) =>
    AllProductCatalogModel.fromJson(json.decode(str));

String allProductCatalogModelToJson(AllProductCatalogModel data) =>
    json.encode(data.toJson());

class AllProductCatalogModel {
  AllProductCatalogModel({
    required this.res,
    required this.model,
  });

  int res;
  List<ProductCatalogModel> model;

  factory AllProductCatalogModel.fromJson(Map<String, dynamic> json) =>
      AllProductCatalogModel(
        res: json["res"],
        model: List<ProductCatalogModel>.from(
            json["model"].map((x) => ProductCatalogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
      };
}

class ProductCatalogModel {
  ProductCatalogModel({
    this.productID,
      this.description,
      this.description2,
      this.className,
      this.itemType,
      this.categoryName,
      this.quantityPerUnit,
      this.weight,
      this.unitID,
      this.styleID,
      this.styleName,
      this.attribute,
      this.unitPrice1,
      this.unitPrice2,
      this.unitPrice3,
      this.minPrice,
      this.colorID,
      this.colour,
      this.materialID,
      this.material,
      this.finishingID,
      this.finish,
      this.uPC,
      this.photo,
      this.size,
      this.brandName,
      this.origin,
      this.note
  });

  String? productID;
  String? description;
  String? description2;
  dynamic className;
  dynamic itemType;
  dynamic categoryName;
  dynamic quantityPerUnit;
  dynamic weight;
  String? unitID;
  dynamic styleID;
  dynamic styleName;
  String? attribute;
  dynamic unitPrice1;
  dynamic unitPrice2;
  dynamic unitPrice3;
  dynamic minPrice;
  dynamic colorID;
  dynamic colour;
  dynamic materialID;
  dynamic material;
  dynamic finishingID;
  dynamic finish;
  String? uPC;
  dynamic photo;
  String? size;
  dynamic brandName;
  dynamic origin;
  String? note;

  factory ProductCatalogModel.fromJson(Map<String, dynamic> json) => ProductCatalogModel(
        productID : json["ProductID"],
    description : json["Description"],
    description2 : json["Description2"],
    className : json["ClassName"],
    itemType : json["ItemType"],
    categoryName : json["CategoryName"],
    quantityPerUnit : json["QuantityPerUnit"],
    weight : json["Weight"],
    unitID : json["UnitID"],
    styleID : json["StyleID"],
    styleName : json["StyleName"],
    attribute : json["Attribute"],
    unitPrice1 : json["UnitPrice1"],
    unitPrice2 : json["UnitPrice2"],
    unitPrice3 : json["UnitPrice3"],
    minPrice : json["MinPrice"],
    colorID : json["ColorID"],
    colour : json["Colour"],
    materialID : json["MaterialID"],
    material : json["Material"],
    finishingID : json["FinishingID"],
    finish : json["Finish"],
    uPC : json["UPC"],
    photo : json["Photo"],
    size : json["Size"],
    brandName : json["BrandName"],
    origin : json["Origin"],
    note : json["Note"],
      );

  Map<String, dynamic> toJson() => {
        "ProductID" : this.productID,
    "Description" : this.description,
    "Description2" : this.description2,
    "ClassName" : this.className,
    "ItemType" : this.itemType,
    "CategoryName" : this.categoryName,
    "QuantityPerUnit" : this.quantityPerUnit,
    "Weight" : this.weight,
    "UnitID" : this.unitID,
    "StyleID" : this.styleID,
    "StyleName" : this.styleName,
    "Attribute" : this.attribute,
    "UnitPrice1" : this.unitPrice1,
    "UnitPrice2" : this.unitPrice2,
    "UnitPrice3" : this.unitPrice3,
    "MinPrice" : this.minPrice,
    "ColorID" : this.colorID,
    "Colour" : this.colour,
    "MaterialID" : this.materialID,
    "Material" : this.material,
    "FinishingID" : this.finishingID,
    "Finish" : this.finish,
    "UPC" : this.uPC,
    "Photo" : this.photo,
    "Size" : this.size,
    "BrandName" : this.brandName,
    "Origin" : this.origin,
    "Note" : this.note,
      };
}
