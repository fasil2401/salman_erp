import 'dart:convert';

EmployeeSponsorModel employeeSponsorModelFromJson(String str) => EmployeeSponsorModel.fromJson(json.decode(str));

String employeeSponsorModelToJson(EmployeeSponsorModel data) => json.encode(data.toJson());

class EmployeeSponsorModel {
    EmployeeSponsorModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeSponsorSingleModel> model;
    String msg;

    factory EmployeeSponsorModel.fromJson(Map<String, dynamic> json) => EmployeeSponsorModel(
        res: json["res"],
        model: List<EmployeeSponsorSingleModel>.from(json["model"].map((x) => EmployeeSponsorSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeSponsorSingleModel {
    EmployeeSponsorSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeSponsorSingleModel.fromJson(Map<String, dynamic> json) => EmployeeSponsorSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
