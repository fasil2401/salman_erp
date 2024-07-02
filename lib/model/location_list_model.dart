import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
    LocationModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<LocationSingleModel> model;
    String msg;

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        res: json["res"],
        model: List<LocationSingleModel>.from(json["model"].map((x) => LocationSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class LocationSingleModel {
    LocationSingleModel({
        this.code,
        this.name,
    });

    String? code;
    String? name;

    factory LocationSingleModel.fromJson(Map<String, dynamic> json) => LocationSingleModel(
        code: json["Code"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
    };
}
