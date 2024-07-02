// To parse this JSON data, do
//
//     final getCompanyInfoModel = getCompanyInfoModelFromJson(jsonString);

import 'dart:convert';

GetCompanyInfoModel getCompanyInfoModelFromJson(String str) =>
    GetCompanyInfoModel.fromJson(json.decode(str));

String getCompanyInfoModelToJson(GetCompanyInfoModel data) =>
    json.encode(data.toJson());

class GetCompanyInfoModel {
  int? result;
  List<CompanyInfoModel>? modelobject;

  GetCompanyInfoModel({
    this.result,
    this.modelobject,
  });

  factory GetCompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      GetCompanyInfoModel(
        result: json["result"],
        modelobject: List<CompanyInfoModel>.from(
            json["Modelobject"].map((x) => CompanyInfoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class CompanyInfoModel {
  String? companyName;
  String? notes;
  String? baseCurrencyId;
  int? minPriceSaleAction;
  int? pricelessCostAction;

  CompanyInfoModel({
    this.companyName,
    this.notes,
    this.baseCurrencyId,
    this.minPriceSaleAction,
    this.pricelessCostAction,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      CompanyInfoModel(
        companyName: json["CompanyName"],
        notes: json["Notes"],
        baseCurrencyId: json["BaseCurrencyID"],
        minPriceSaleAction: json["MinPriceSaleAction"],
        pricelessCostAction: json["PricelessCostAction"]
      );

  Map<String, dynamic> toJson() => {
        "CompanyName": companyName,
        "Notes": notes,
        "BaseCurrencyID": baseCurrencyId,
        "MinPriceSaleAction": minPriceSaleAction,
        "PricelessCostAction": pricelessCostAction
      };
}
