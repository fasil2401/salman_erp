import 'dart:convert';

VoucherNumberModel voucherNumberModelFromJson(String str) => VoucherNumberModel.fromJson(json.decode(str));

String voucherNumberModelToJson(VoucherNumberModel data) => json.encode(data.toJson());

class VoucherNumberModel {
    VoucherNumberModel({
       required this.res,
       required this.model,
    });

    int res;
    String model;

    factory VoucherNumberModel.fromJson(Map<String, dynamic> json) => VoucherNumberModel(
        res: json["res"],
        model: json["model"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model,
    };
}
