// To parse this JSON data, do
//
//     final salesInvoiceOpenListModel = salesInvoiceOpenListModelFromJson(jsonString);

import 'dart:convert';

SalesInvoiceOpenListModel salesInvoiceOpenListModelFromJson(String str) =>
    SalesInvoiceOpenListModel.fromJson(json.decode(str));

String salesInvoiceOpenListModelToJson(SalesInvoiceOpenListModel data) =>
    json.encode(data.toJson());

class SalesInvoiceOpenListModel {
  int? result;
  List<SalesInvoiceOpenModel>? modelobject;

  SalesInvoiceOpenListModel({
    this.result,
    this.modelobject,
  });

  factory SalesInvoiceOpenListModel.fromJson(Map<String, dynamic> json) =>
      SalesInvoiceOpenListModel(
        result: json["result"],
        modelobject: List<SalesInvoiceOpenModel>.from(
            json["Modelobject"].map((x) => SalesInvoiceOpenModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class SalesInvoiceOpenModel {
  bool? v;
  String? docId;
  String? docNumber;
  String? customerCode;
  String? customerName;
  String? customerPo;
  String? address;
  DateTime? invoiceDate;
  DateTime? dueDate;
  dynamic term;
  String? ref1;
  String? ref2;
  String? currency;
  dynamic jobId;
  dynamic jobName;
  String? type;
  dynamic paymentMethod;
  String? salesperon;
  dynamic amount;
  dynamic taxAmount;
  dynamic expense;
  dynamic netAmount;

  SalesInvoiceOpenModel({
    this.v,
    this.docId,
    this.docNumber,
    this.customerCode,
    this.customerName,
    this.customerPo,
    this.address,
    this.invoiceDate,
    this.dueDate,
    this.term,
    this.ref1,
    this.ref2,
    this.currency,
    this.jobId,
    this.jobName,
    this.type,
    this.paymentMethod,
    this.salesperon,
    this.amount,
    this.taxAmount,
    this.expense,
    this.netAmount,
  });

  factory SalesInvoiceOpenModel.fromJson(Map<String, dynamic> json) =>
      SalesInvoiceOpenModel(
        v: json["V"],
        docId: json["Doc ID"],
        docNumber: json["Doc Number"],
        customerCode: json["Customer Code"],
        customerName: json["Customer Name"],
        customerPo: json["Customer PO#"],
        address: json["Address"],
        invoiceDate: DateTime.parse(json["Invoice Date"]),
        dueDate: DateTime.parse(json["Due Date"]),
        term: json["Term"],
        ref1: json["Ref1"],
        ref2: json["Ref2"],
        currency: json["Currency"],
        jobId: json["JobID"],
        jobName: json["JobName"],
        type: json["Type"],
        paymentMethod: json["PaymentMethod"],
        salesperon: json["Salesperon"],
        amount: json["Amount"],
        taxAmount: json["TaxAmount"],
        expense: json["Expense"],
        netAmount: json["NetAmount"],
      );

  Map<String, dynamic> toJson() => {
        "V": v,
        "Doc ID": docId,
        "Doc Number": docNumber,
        "Customer Code": customerCode,
        "Customer Name": customerName,
        "Customer PO#": customerPo,
        "Address": address,
        "Invoice Date": invoiceDate!.toIso8601String(),
        "Due Date": dueDate!.toIso8601String(),
        "Term": term,
        "Ref1": ref1,
        "Ref2": ref2,
        "Currency": currency,
        "JobID": jobId,
        "JobName": jobName,
        "Type": type,
        "PaymentMethod": paymentMethod,
        "Salesperon": salesperon,
        "Amount": amount,
        "TaxAmount": taxAmount,
        "Expense": expense,
        "NetAmount": netAmount,
      };
}
