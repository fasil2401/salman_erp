import 'dart:convert';

SalesOrderOpenListModel salesOrderOpenListModelFromJson(String str) =>
    SalesOrderOpenListModel.fromJson(json.decode(str));

String salesOrderOpenListModelToJson(SalesOrderOpenListModel data) =>
    json.encode(data.toJson());

class SalesOrderOpenListModel {
  SalesOrderOpenListModel({
    required this.result,
    required this.modelobject,
  });

  int result;
  List<Modelobject> modelobject;

  factory SalesOrderOpenListModel.fromJson(Map<String, dynamic> json) =>
      SalesOrderOpenListModel(
        result: json["result"],
        modelobject: List<Modelobject>.from(
            json["Modelobject"].map((x) => Modelobject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject.map((x) => x.toJson())),
      };
}

class Modelobject {
  Modelobject({
    this.v,
    this.docId,
    this.docNumber,
    this.customerCode,
    this.customerName,
    this.customerPo,
    this.orderDate,
    this.currency,
    this.salesperson,
    this.jobId,
    this.jobName,
    this.amount,
    this.taxoption,
    this.taxAmount,
    this.netAmount,
  });

  bool? v;
  String? docId;
  String? docNumber;
  String? customerCode;
  String? customerName;
  String? customerPo;
  DateTime? orderDate;
  String? currency;
  String? salesperson;
  dynamic jobId;
  dynamic jobName;
  dynamic amount;
  String? taxoption;
  dynamic taxAmount;
  dynamic netAmount;

  factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        v: json["V"],
        docId: json["Doc ID"],
        docNumber: json["Doc Number"],
        customerCode: json["Customer Code"],
        customerName: json["Customer Name"],
        customerPo: json["Customer PO#"],
        orderDate: DateTime.parse(json["Order Date"]),
        currency: json["Currency"],
        salesperson: json["Salesperson"],
        jobId: json["JobID"],
        jobName: json["JobName"],
        amount: json["Amount"].toDouble(),
        taxoption: json["TAXOPTION"],
        taxAmount: json["TaxAmount"],
        netAmount: json["NetAmount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "V": v,
        "Doc ID": docId,
        "Doc Number": docNumber,
        "Customer Code": customerCode,
        "Customer Name": customerName,
        "Customer PO#": customerPo,
        "Order Date": orderDate == null ? null : orderDate!.toIso8601String(),
        "Currency": currency,
        "Salesperson": salesperson,
        "JobID": jobId,
        "JobName": jobName,
        "Amount": amount,
        "TAXOPTION": taxoption,
        "TaxAmount": taxAmount,
        "NetAmount": netAmount,
      };
}
