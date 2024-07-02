// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

LocationFilter LocationFilterFromJson(String str) =>
    LocationFilter.fromJson(json.decode(str));

String LocationFilterToJson(LocationFilter data) => json.encode(data.toJson());

class LocationFilter {
  int res;
  List<Model> model;

  LocationFilter({
    required this.res,
    required this.model,
  });

  factory LocationFilter.fromJson(Map<String, dynamic> json) => LocationFilter(
        res: json["res"],
        model: List<Model>.from(json["model"].map((x) => Model.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
      };
}

class Model {
  String? code;
  String? name;
  dynamic isConsignOutLocation;
  dynamic isConsignInLocation;
  dynamic isposLocation;
  dynamic isWarehouse;
  dynamic isUserLocation;

  Model({
    this.code,
    this.name,
    this.isConsignOutLocation,
    this.isConsignInLocation,
    this.isposLocation,
    this.isWarehouse,
    this.isUserLocation,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        code: json["Code"],
        name: json["Name"],
        isConsignOutLocation: json["IsConsignOutLocation"],
        isConsignInLocation: json["IsConsignInLocation"],
        isposLocation: json["ISPOSLocation"],
        isWarehouse: json["IsWarehouse"],
        isUserLocation: json["IsUserLocation"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "IsConsignOutLocation": isConsignOutLocation,
        "IsConsignInLocation": isConsignInLocation,
        "ISPOSLocation": isposLocation,
        "IsWarehouse": isWarehouse,
        "IsUserLocation": isUserLocation,
      };
}
