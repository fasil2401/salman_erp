import 'dart:convert';

CreateSalesOrderResponseModel createSalesOrderResponseModelFromJson(String str) => CreateSalesOrderResponseModel.fromJson(json.decode(str));

String createSalesOrderResponseModelToJson(CreateSalesOrderResponseModel data) => json.encode(data.toJson());

class CreateSalesOrderResponseModel {
    CreateSalesOrderResponseModel({
        this.res,
        this.msg,
        this.docNo,
    });

    int? res;
    String? msg;
    String? docNo;

    factory CreateSalesOrderResponseModel.fromJson(Map<String, dynamic> json) => CreateSalesOrderResponseModel(
        res: json["res"],
        msg: json["msg"],
        docNo: json["docNo"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "msg": msg,
        "docNo": docNo,
    };
}
