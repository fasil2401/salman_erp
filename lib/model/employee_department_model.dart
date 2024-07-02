import 'dart:convert';

EmployeeDepartmentModel employeeDepartmentModelFromJson(String str) => EmployeeDepartmentModel.fromJson(json.decode(str));

String employeeDepartmentModelToJson(EmployeeDepartmentModel data) => json.encode(data.toJson());

class EmployeeDepartmentModel {
    EmployeeDepartmentModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeDepartmentSingleModel> model;
    String msg;

    factory EmployeeDepartmentModel.fromJson(Map<String, dynamic> json) => EmployeeDepartmentModel(
        res: json["res"],
        model: List<EmployeeDepartmentSingleModel>.from(json["model"].map((x) => EmployeeDepartmentSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeDepartmentSingleModel {
    EmployeeDepartmentSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeDepartmentSingleModel.fromJson(Map<String, dynamic> json) => EmployeeDepartmentSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
