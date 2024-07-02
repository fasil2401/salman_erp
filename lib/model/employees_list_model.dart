import 'dart:convert';

EmployeesModel employeesModelFromJson(String str) => EmployeesModel.fromJson(json.decode(str));

String employeesModelToJson(EmployeesModel data) => json.encode(data.toJson());

class EmployeesModel {
    EmployeesModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<EmployeesSingleModel> model;
    String msg;

    factory EmployeesModel.fromJson(Map<String, dynamic> json) => EmployeesModel(
        res: json["res"],
        model: List<EmployeesSingleModel>.from(json["model"].map((x) => EmployeesSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class EmployeesSingleModel {
    EmployeesSingleModel({
        this.code,
        this.name,
        this.isTerminated,
        this.positionID,
        this.sponsorId,
    });

    String? code;
    String? name;
    bool? isTerminated;
    String? positionID;
    String? sponsorId;

    factory EmployeesSingleModel.fromJson(Map<String, dynamic> json) => EmployeesSingleModel(
        code: json["Code"],
        name: json["Name"],
        isTerminated: json["IsTerminated"],
        positionID: json["PositionID"],
        sponsorId: json["SponsorId"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "IsTerminated": isTerminated,
        "PositionID": positionID,
        "SponsorId": sponsorId,
    };
}
