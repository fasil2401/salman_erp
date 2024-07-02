import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) =>
    CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) =>
    json.encode(data.toJson());

class CommonResponseModel {
  CommonResponseModel({
    this.res,
    this.msg,
  });

  int? res;
  String? msg;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        res: json["res"] ?? json["result"],
        msg: json["msg"] ?? json["err"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
      };
}
