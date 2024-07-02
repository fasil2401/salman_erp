// To parse this JSON data, do
//
//     final getOpenSalesOrdersSummaryModel = getOpenSalesOrdersSummaryModelFromJson(jsonString);

import 'dart:convert';

GetOpenSalesOrdersSummaryModel getOpenSalesOrdersSummaryModelFromJson(String str) => GetOpenSalesOrdersSummaryModel.fromJson(json.decode(str));

String getOpenSalesOrdersSummaryModelToJson(GetOpenSalesOrdersSummaryModel data) => json.encode(data.toJson());

class GetOpenSalesOrdersSummaryModel {
    int? res;
    List<OpenSalesOrdersSummar>? model;
    String? msg;

    GetOpenSalesOrdersSummaryModel({
        this.res,
        this.model,
        this.msg,
    });

    factory GetOpenSalesOrdersSummaryModel.fromJson(Map<String, dynamic> json) => GetOpenSalesOrdersSummaryModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<OpenSalesOrdersSummar>.from(json["model"]!.map((x) => OpenSalesOrdersSummar.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class OpenSalesOrdersSummar {
    String? docId;
    String? number;
    String? payeeTaxGroupId;
    DateTime? date;
    String? customer;
    String? customerPo;
    dynamic jobName;
    dynamic salesPerson;
    String? reference1;
    String? reference2;

    OpenSalesOrdersSummar({
        this.docId,
        this.number,
        this.payeeTaxGroupId,
        this.date,
        this.customer,
        this.customerPo,
        this.jobName,
        this.salesPerson,
        this.reference1,
        this.reference2,
    });

    factory OpenSalesOrdersSummar.fromJson(Map<String, dynamic> json) => OpenSalesOrdersSummar(
        docId: json["Doc ID"],
        number: json["Number"],
        payeeTaxGroupId: json["PayeeTaxGroupID"],
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
        customer: json["Customer"],
        customerPo: json["Customer PO#"],
        jobName: json["JobName"],
        salesPerson: json["SalesPerson"],
        reference1: json["Reference1"],
        reference2: json["Reference2"],
    );

    Map<String, dynamic> toJson() => {
        "Doc ID": docId,
        "Number": number,
        "PayeeTaxGroupID": payeeTaxGroupId,
        "Date": date?.toIso8601String(),
        "Customer": customer,
        "Customer PO#": customerPo,
        "JobName": jobName,
        "SalesPerson": salesPerson,
        "Reference1": reference1,
        "Reference2": reference2,
    };
}
