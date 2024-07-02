import 'dart:convert';

GetEmployeeDocumentsListModel getEmployeeDocumentsListModelFromJson(
        String str) =>
    GetEmployeeDocumentsListModel.fromJson(json.decode(str));

String getEmployeeDocumentsListModelToJson(
        GetEmployeeDocumentsListModel data) =>
    json.encode(data.toJson());

class GetEmployeeDocumentsListModel {
  int? res;
  List<EmployeeDocumentModel>? model;
  String? msg;

  GetEmployeeDocumentsListModel({
    this.res,
    this.model,
    this.msg,
  });

  factory GetEmployeeDocumentsListModel.fromJson(Map<String, dynamic> json) =>
      GetEmployeeDocumentsListModel(
        res: json["res"],
        model: json["model"] == null
            ? []
            : List<EmployeeDocumentModel>.from(
                json["model"]!.map((x) => EmployeeDocumentModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null
            ? []
            : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
      };
}

class EmployeeDocumentModel {
  String? employeeId;
  String? documentNumber;
  String? documentTypeId;
  String? issuePlace;
  DateTime? issueDate;
  DateTime? expiryDate;
  String? remarks;
  dynamic rowIndex;
  int? docId;

  EmployeeDocumentModel({
    this.employeeId,
    this.documentNumber,
    this.documentTypeId,
    this.issuePlace,
    this.issueDate,
    this.expiryDate,
    this.remarks,
    this.rowIndex,
    this.docId,
  });

  factory EmployeeDocumentModel.fromJson(Map<String, dynamic> json) =>
      EmployeeDocumentModel(
        employeeId: json["EmployeeID"],
        documentNumber: json["DocumentNumber"],
        documentTypeId: json["DocumentTypeID"],
        issuePlace: json["IssuePlace"],
        issueDate: json["IssueDate"] == null
            ? null
            : DateTime.parse(json["IssueDate"]),
        expiryDate: json["ExpiryDate"] == null
            ? null
            : DateTime.parse(json["ExpiryDate"]),
        remarks: json["Remarks"],
        rowIndex: json["RowIndex"],
        docId: json["DocID"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "DocumentNumber": documentNumber,
        "DocumentTypeID": documentTypeId,
        "IssuePlace": issuePlace,
        "IssueDate": issueDate?.toIso8601String(),
        "ExpiryDate": expiryDate?.toIso8601String(),
        "Remarks": remarks,
        "RowIndex": rowIndex,
        "DocID": docId,
      };
}
