import 'dart:convert';

SalesPersonFilterItemModel salesPersonFilterItemModelFromJson(String str) => SalesPersonFilterItemModel.fromJson(json.decode(str));

String salesPersonFilterItemModelToJson(SalesPersonFilterItemModel data) => json.encode(data.toJson());

class SalesPersonFilterItemModel {
    SalesPersonFilterItemModel({
        this.result,
        this.modelobject,
    });

    int? result;
    List<Modelobject>? modelobject;

    factory SalesPersonFilterItemModel.fromJson(Map<String, dynamic> json) => SalesPersonFilterItemModel(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<Modelobject>.from(json["Modelobject"].map((x) => Modelobject.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class Modelobject {
    Modelobject({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
