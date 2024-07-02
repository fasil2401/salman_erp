import 'dart:convert';

TaxModel taxModelFromJson(String str) => TaxModel.fromJson(json.decode(str));

String taxModelToJson(TaxModel data) => json.encode(data.toJson());

class TaxModel {
  TaxModel({
    this.token,
    this.sysDocId,
    this.voucherId,
    this.taxLevel,
    this.taxGroupId,
    this.taxItemId,
    this.taxItemName,
    this.taxRate,
    this.calculationMethod,
    this.taxAmount,
    this.orderIndex,
    this.rowIndex,
    this.accountId,
    this.currencyId,
    this.currencyRate,
  });

  String? token;
  String? sysDocId;
  String? voucherId;
  dynamic taxLevel;
  String? taxGroupId;
  String? taxItemId;
  String? taxItemName;
  dynamic taxRate;
  String? calculationMethod;
  dynamic taxAmount;
  dynamic orderIndex;
  dynamic rowIndex;
  String? accountId;
  String? currencyId;
  dynamic currencyRate;

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
        token: json["token"],
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        taxLevel: json["TaxLevel"],
        taxGroupId: json["TaxGroupID"],
        taxItemId: json["TaxItemID"],
        taxItemName: json["TaxItemName"],
        taxRate: json["TaxRate"],
        calculationMethod: json["CalculationMethod"],
        taxAmount: json["TaxAmount"],
        orderIndex: json["OrderIndex"],
        rowIndex: json["RowIndex"],
        accountId: json["AccountID"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "TaxLevel": taxLevel,
        "TaxGroupID": taxGroupId,
        "TaxItemID": taxItemId,
        "TaxItemName": taxItemName,
        "TaxRate": taxRate,
        "CalculationMethod": calculationMethod,
        "TaxAmount": taxAmount,
        "OrderIndex": orderIndex,
        "RowIndex": rowIndex,
        "AccountID": accountId,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
      };
}
