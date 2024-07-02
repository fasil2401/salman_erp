import 'dart:convert';

EmployeeTypeModel employeeTypeModelFromJson(String str) => EmployeeTypeModel.fromJson(json.decode(str));

String employeeTypeModelToJson(EmployeeTypeModel data) => json.encode(data.toJson());

class EmployeeTypeModel {
    EmployeeTypeModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeTypeSingleModel> model;
    String msg;

    factory EmployeeTypeModel.fromJson(Map<String, dynamic> json) => EmployeeTypeModel(
        res: json["res"],
        model: List<EmployeeTypeSingleModel>.from(json["model"].map((x) => EmployeeTypeSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeTypeSingleModel {
    EmployeeTypeSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeTypeSingleModel.fromJson(Map<String, dynamic> json) => EmployeeTypeSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
