import 'dart:convert';

ErrorResponseModel errorResponseModelFromJson(String str) => ErrorResponseModel.fromJson(json.decode(str));

String errorResponseModelToJson(ErrorResponseModel data) => json.encode(data.toJson());

class ErrorResponseModel {
    ErrorResponseModel({
        this.res,
        this.err,
    });

    int? res;
    String? err;

    factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
        res: json["res"],
        err: json["err"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "err": err,
    };
}
