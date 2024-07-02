
import 'dart:convert';

CompanyPreferencerModel companyPreferencerModelFromJson(String str) => CompanyPreferencerModel.fromJson(json.decode(str));

String companyPreferencerModelToJson(CompanyPreferencerModel data) => json.encode(data.toJson());

class CompanyPreferencerModel {
    int? result;
    List<CompanyOptionModel>? model;

    CompanyPreferencerModel({
        this.result,
        this.model,
    });

    factory CompanyPreferencerModel.fromJson(Map<String, dynamic> json) => CompanyPreferencerModel(
        result: json["result"],
        model: json["model"] == null ? [] : List<CompanyOptionModel>.from(json["model"]!.map((x) => CompanyOptionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
    };
}

class CompanyOptionModel {
    String? optionId;
    String? optionValue;

    CompanyOptionModel({
        this.optionId,
        this.optionValue,
    });

    factory CompanyOptionModel.fromJson(Map<String, dynamic> json) => CompanyOptionModel(
        optionId: json["OptionID"],
        optionValue: json["OptionValue"],
    );

    Map<String, dynamic> toJson() => {
        "OptionID": optionId,
        "OptionValue": optionValue,
    };
}
