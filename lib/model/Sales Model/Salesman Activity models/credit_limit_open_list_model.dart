// To parse this JSON data, do
//
//     final getCreditLimitOPenLIsttModel = getCreditLimitOPenLIsttModelFromJson(jsonString);

import 'dart:convert';

GetCreditLimitOPenLIsttModel getCreditLimitOPenLIsttModelFromJson(String str) =>
    GetCreditLimitOPenLIsttModel.fromJson(json.decode(str));

String getCreditLimitOPenLIsttModelToJson(GetCreditLimitOPenLIsttModel data) =>
    json.encode(data.toJson());

class GetCreditLimitOPenLIsttModel {
  int? result;
  List<CreditLimitOPenLIsttModel>? model;

  GetCreditLimitOPenLIsttModel({
    this.result,
    this.model,
  });

  factory GetCreditLimitOPenLIsttModel.fromJson(Map<String, dynamic> json) =>
      GetCreditLimitOPenLIsttModel(
        result: json["result"],
        model: json["Model"] == null
            ? []
            : List<CreditLimitOPenLIsttModel>.from(json["Model"]!.map((x) => CreditLimitOPenLIsttModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Model": model == null
            ? []
            : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

class CreditLimitOPenLIsttModel {
  String? docId;
  String? docNumber;
  DateTime? date;
  String? customer;
  DateTime? validFrom;
  DateTime? validTo;
  dynamic amount;

  CreditLimitOPenLIsttModel({
    this.docId,
    this.docNumber,
    this.date,
    this.customer,
    this.validFrom,
    this.validTo,
    this.amount,
  });

  factory CreditLimitOPenLIsttModel.fromJson(Map<String, dynamic> json) => CreditLimitOPenLIsttModel(
        docId: json["Doc ID"],
        docNumber: json["Doc Number"],
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
        customer: json["Customer"],
        validFrom: json["Valid From"] == null
            ? null
            : DateTime.parse(json["Valid From"]),
        validTo:
            json["Valid To"] == null ? null : DateTime.parse(json["Valid To"]),
        amount: json["Amount"],
      );

  Map<String, dynamic> toJson() => {
        "Doc ID": docId,
        "Doc Number": docNumber,
        "Date": date?.toIso8601String(),
        "Customer": customer,
        "Valid From": validFrom?.toIso8601String(),
        "Valid To": validTo?.toIso8601String(),
        "Amount": amount,
      };
}
