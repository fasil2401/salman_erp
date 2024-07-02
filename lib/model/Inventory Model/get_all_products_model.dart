import 'dart:convert';

GetAllProductsModel getAllProductsModelFromJson(String str) => GetAllProductsModel.fromJson(json.decode(str));

String getAllProductsModelToJson(GetAllProductsModel data) => json.encode(data.toJson());

class GetAllProductsModel {
    GetAllProductsModel({
       required this.res,
       required this.products,
       required this.msg,
    });

    int res;
    List<Products> products;
    String msg;

    factory GetAllProductsModel.fromJson(Map<String, dynamic> json) => GetAllProductsModel(
        res: json["res"],
        products: List<Products>.from(json["model"].map((x) => Products.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(products.map((x) => x.toJson())),
        "msg": msg,
    };
}

class Products {
    Products({
        this.productId,
        this.description,
        this.upc,
        this.quantity,
    });

    String? productId;
    String? description;
    String? upc;
    double? quantity;

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        productId: json["ProductID"],
        description: json["Description"],
        upc: json["UPC"],
        quantity: json["Quantity"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "Description": description,
        "UPC": upc,
        "Quantity": quantity,
    };
}
