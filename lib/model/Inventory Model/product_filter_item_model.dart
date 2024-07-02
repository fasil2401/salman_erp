import 'dart:convert';

ProductFilterItemModel productFilterItemModelFromJson(String str) => ProductFilterItemModel.fromJson(json.decode(str));

String productFilterItemModelToJson(ProductFilterItemModel data) => json.encode(data.toJson());

class ProductFilterItemModel {
    ProductFilterItemModel({
        this.res,
        this.model,
        this.msg,
    });

    int? res;
    List<Model>? model;
    String? msg;

    factory ProductFilterItemModel.fromJson(Map<String, dynamic> json) => ProductFilterItemModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class Model {
    Model({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
