import 'dart:convert';

EmployeeGroupModel employeeGroupModelFromJson(String str) => EmployeeGroupModel.fromJson(json.decode(str));

String employeeGroupModelToJson(EmployeeGroupModel data) => json.encode(data.toJson());

class EmployeeGroupModel {
    EmployeeGroupModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeeGroupSingleModel> model;
    String msg;

    factory EmployeeGroupModel.fromJson(Map<String, dynamic> json) => EmployeeGroupModel(
        res: json["res"],
        model: List<EmployeeGroupSingleModel>.from(json["model"].map((x) => EmployeeGroupSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeeGroupSingleModel {
    EmployeeGroupSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory EmployeeGroupSingleModel.fromJson(Map<String, dynamic> json) => EmployeeGroupSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
