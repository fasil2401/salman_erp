// To parse this JSON data, do
//
//     final getLetterRequestDetailListModel = getLetterRequestDetailListModelFromJson(jsonString);

import 'dart:convert';

GetLetterRequestDetailListModel getLetterRequestDetailListModelFromJson(String str) => GetLetterRequestDetailListModel.fromJson(json.decode(str));

String getLetterRequestDetailListModelToJson(GetLetterRequestDetailListModel data) => json.encode(data.toJson());

class GetLetterRequestDetailListModel {
    int? res;
    List<LetterModel>? model;
    String? msg;

    GetLetterRequestDetailListModel({
        this.res,
        this.model,
        this.msg,
    });

    factory GetLetterRequestDetailListModel.fromJson(Map<String, dynamic> json) => GetLetterRequestDetailListModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<LetterModel>.from(json["model"]!.map((x) => LetterModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class LetterModel {
    String? docId;
    String? docNumber;
    DateTime? letterIssueDate;
    String? employeeId;
    String? name;
    DateTime? requestedDate;
    String? docType;

    LetterModel({
        this.docId,
        this.docNumber,
        this.letterIssueDate,
        this.employeeId,
        this.name,
        this.requestedDate,
        this.docType,
    });

    factory LetterModel.fromJson(Map<String, dynamic> json) => LetterModel(
        docId: json["Doc ID"],
        docNumber: json["Doc Number"],
        letterIssueDate: json["LetterIssue Date"] == null ? null : DateTime.parse(json["LetterIssue Date"]),
        employeeId: json["EmployeeID"],
        name: json["Name"],
        requestedDate: json["RequestedDate"] == null ? null : DateTime.parse(json["RequestedDate"]),
        docType: json["Doc Type"],
    );

    Map<String, dynamic> toJson() => {
        "Doc ID": docId,
        "Doc Number": docNumber,
        "LetterIssue Date": letterIssueDate?.toIso8601String(),
        "EmployeeID": employeeId,
        "Name": name,
        "RequestedDate": requestedDate?.toIso8601String(),
        "Doc Type": docType,
    };
}
