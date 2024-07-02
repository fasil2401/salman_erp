import 'dart:convert';

EmployeeGradeModel employeeGradeModelFromJson(String str) => EmployeeGradeModel.fromJson(json.decode(str));

String employeeGradeModelToJson(EmployeeGradeModel data) => json.encode(data.toJson());

class EmployeeGradeModel {
    EmployeeGradeModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeGradeSingleModel> model;
    String msg;

    factory EmployeeGradeModel.fromJson(Map<String, dynamic> json) => EmployeeGradeModel(
        res: json["res"],
        model: List<EmployeeGradeSingleModel>.from(json["model"].map((x) => EmployeeGradeSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeGradeSingleModel {
    EmployeeGradeSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeGradeSingleModel.fromJson(Map<String, dynamic> json) => EmployeeGradeSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
