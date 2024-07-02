import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
    BankModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<BankSingleModel> model;
    String msg;

    factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        res: json["res"],
        model: List<BankSingleModel>.from(json["model"].map((x) => BankSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class BankSingleModel {
    BankSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory BankSingleModel.fromJson(Map<String, dynamic> json) => BankSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
