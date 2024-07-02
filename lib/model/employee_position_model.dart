import 'dart:convert';

EmployeePositionModel employeePositionModelFromJson(String str) => EmployeePositionModel.fromJson(json.decode(str));

String employeePositionModelToJson(EmployeePositionModel data) => json.encode(data.toJson());

class EmployeePositionModel {
    EmployeePositionModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeePositionSingleModel> model;
    String msg;

    factory EmployeePositionModel.fromJson(Map<String, dynamic> json) => EmployeePositionModel(
        res: json["res"],
        model: List<EmployeePositionSingleModel>.from(json["model"].map((x) => EmployeePositionSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeePositionSingleModel {
    EmployeePositionSingleModel({
        this.code,
        this.name,
        this.costPerHour,
    });

    String? code;
    String? name;
    dynamic costPerHour;

    factory EmployeePositionSingleModel.fromJson(Map<String, dynamic> json) => EmployeePositionSingleModel(
        code: json["Code"],
        name: json["Name"],
        costPerHour: json["CostPerHour"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "CostPerHour": costPerHour,
    };
}
