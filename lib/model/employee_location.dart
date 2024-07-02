import 'dart:convert';

EmployeeLocationModel employeeEmployeeLocationModelFromJson(String str) => EmployeeLocationModel.fromJson(json.decode(str));

String employeeEmployeeLocationModelToJson(EmployeeLocationModel data) => json.encode(data.toJson());

class EmployeeLocationModel {
    EmployeeLocationModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeLocationSingleModel> model;
    String msg;

    factory EmployeeLocationModel.fromJson(Map<String, dynamic> json) => EmployeeLocationModel(
        res: json["res"],
        model: List<EmployeeLocationSingleModel>.from(json["model"].map((x) => EmployeeLocationSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeLocationSingleModel {
    EmployeeLocationSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeLocationSingleModel.fromJson(Map<String, dynamic> json) => EmployeeLocationSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
