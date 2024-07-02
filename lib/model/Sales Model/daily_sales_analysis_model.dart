import 'dart:convert';

DailySalesAnalysisModel dailySalesAnalysisModelFromJson(String str) =>
    DailySalesAnalysisModel.fromJson(json.decode(str));

String dailySalesAnalysisModelToJson(DailySalesAnalysisModel data) =>
    json.encode(data.toJson());

class DailySalesAnalysisModel {
  DailySalesAnalysisModel({
    required this.result,
    required this.modelobject,
  });

  int result;
  List<AnalysisModel> modelobject;

  factory DailySalesAnalysisModel.fromJson(Map<String, dynamic> json) =>
      DailySalesAnalysisModel(
        result: json["result"],
        modelobject: List<AnalysisModel>.from(
            json["Modelobject"].map((x) => AnalysisModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject.map((x) => x.toJson())),
      };
}

class AnalysisModel {
  AnalysisModel({
    required this.date,
    this.discount,
    this.roundOff,
    this.tax,
    this.cost,
    this.cashSaleTax,
    this.creditSaleTax,
    this.cashSale,
    this.creditSale,
    this.discountReturn,
    this.roundOffReturn,
    this.taxReturn,
    this.costReturn,
    this.salesReturn,
  });

  DateTime date;
  dynamic discount;
  dynamic roundOff;
  dynamic tax;
  dynamic cost;
  dynamic cashSaleTax;
  dynamic creditSaleTax;
  dynamic cashSale;
  dynamic creditSale;
  dynamic discountReturn;
  dynamic roundOffReturn;
  dynamic taxReturn;
  dynamic costReturn;
  dynamic salesReturn;

  factory AnalysisModel.fromJson(Map<String, dynamic> json) => AnalysisModel(
        date: DateTime.parse(json["Date"]),
        discount: json["Discount"] == null ? null : json["Discount"].toDouble(),
        roundOff: json["RoundOff"] == null ? null : json["RoundOff"],
        tax: json["Tax"] == null ? null : json["Tax"].toDouble(),
        cost: json["Cost"] == null ? null : json["Cost"].toDouble(),
        cashSaleTax: json["CashSaleTax"] == null ? null : json["CashSaleTax"],
        creditSaleTax: json["CreditSaleTax"] == null
            ? null
            : json["CreditSaleTax"].toDouble(),
        cashSale: json["CashSale"] == null ? null : json["CashSale"],
        creditSale:
            json["CreditSale"] == null ? null : json["CreditSale"].toDouble(),
        discountReturn: json["DiscountReturn"] == null
            ? null
            : json["DiscountReturn"].toDouble(),
        roundOffReturn:
            json["RoundOffReturn"] == null ? null : json["RoundOffReturn"],
        taxReturn:
            json["TaxReturn"] == null ? null : json["TaxReturn"].toDouble(),
        costReturn: json["CostReturn"] == null ? null : json["CostReturn"],
        salesReturn:
            json["SalesReturn"] == null ? null : json["SalesReturn"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Date": date.toIso8601String(),
        "Discount": discount == null ? null : discount,
        "RoundOff": roundOff == null ? null : roundOff,
        "Tax": tax == null ? null : tax,
        "Cost": cost == null ? null : cost,
        "CashSaleTax": cashSaleTax == null ? null : cashSaleTax,
        "CreditSaleTax": creditSaleTax == null ? null : creditSaleTax,
        "CashSale": cashSale == null ? null : cashSale,
        "CreditSale": creditSale == null ? null : creditSale,
        "DiscountReturn": discountReturn == null ? null : discountReturn,
        "RoundOffReturn": roundOffReturn == null ? null : roundOffReturn,
        "TaxReturn": taxReturn == null ? null : taxReturn,
        "CostReturn": costReturn == null ? null : costReturn,
        "SalesReturn": salesReturn == null ? null : salesReturn,
      };
}
