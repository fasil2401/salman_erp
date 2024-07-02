import 'dart:convert';

EmployeeAttendanceLogModel employeeAttendanceLogModelFromJson(String str) => EmployeeAttendanceLogModel.fromJson(json.decode(str));

String employeeAttendanceLogModelToJson(EmployeeAttendanceLogModel data) => json.encode(data.toJson());

class EmployeeAttendanceLogModel {
    EmployeeAttendanceLogModel({
       required this.res,
       required this.model,
    });

    int res;
    List<Model> model;

    factory EmployeeAttendanceLogModel.fromJson(Map<String, dynamic> json) => EmployeeAttendanceLogModel(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
    };
}

class Model {
    Model({
        this.employeeId,
        this.name,
        this.day,
        this.logFlag,
        this.jobId,
        this.locationId,
        this.logDate,
    });

    String? employeeId;
    String? name;
    String? day;
    String? logFlag;
    String? jobId;
    String? locationId;
    String? logDate;

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        employeeId: json["EmployeeID"],
        name: json["Name"],
        day: json["Day"],
        logFlag: json["LogFlag"],
        jobId: json["JobID"],
        locationId: json["LocationID"],
        logDate: json["LogDate"],
    );

    Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "Name": name,
        "Day": day,
        "LogFlag": logFlag,
        "JobID": jobId,
        "LocationID": locationId,
        "LogDate": logDate,
    };
}

