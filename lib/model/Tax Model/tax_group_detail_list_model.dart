import 'dart:convert';

TaxGroupDetailListModel taxGroupDetailListModelFromJson(String str) => TaxGroupDetailListModel.fromJson(json.decode(str));

String taxGroupDetailListModelToJson(TaxGroupDetailListModel data) => json.encode(data.toJson());

class TaxGroupDetailListModel {
    TaxGroupDetailListModel({
        this.res,
        this.model,
    });

    int? res;
    List<Model>? model;

    factory TaxGroupDetailListModel.fromJson(Map<String, dynamic> json) => TaxGroupDetailListModel(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model!.map((x) => x.toJson())),
    };
}

class Model {
    Model({
        this.taxCode,
        this.taxGroupId,
        this.rowIndex,
        this.taxItemName,
        this.taxType,
        this.calculationMethod,
        this.taxRate,
    });

    String? taxCode;
    String? taxGroupId;
    dynamic rowIndex;
    String? taxItemName;
    String? taxType;
    dynamic calculationMethod;
    dynamic taxRate;

    factory Model.fromJson(Map<String, dynamic> json) => Model(
        taxCode: json["TaxCode"],
        taxGroupId: json["TaxGroupID"],
        rowIndex: json["RowIndex"],
        taxItemName: json["TaxItemName"],
        taxType: json["TaxType"],
        calculationMethod: json["CalculationMethod"],
        taxRate: json["TaxRate"],
    );

    Map<String, dynamic> toJson() => {
        "TaxCode": taxCode,
        "TaxGroupID": taxGroupId,
        "RowIndex": rowIndex,
        "TaxItemName": taxItemName,
        "TaxType": taxType,
        "CalculationMethod": calculationMethod,
        "TaxRate": taxRate,
    };
}
