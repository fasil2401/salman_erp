import 'dart:convert';

GetUsersLIstModel getUsersLIstModelFromJson(String str) =>
    GetUsersLIstModel.fromJson(json.decode(str));

String getUsersLIstModelToJson(GetUsersLIstModel data) =>
    json.encode(data.toJson());

class GetUsersLIstModel {
  GetUsersLIstModel({
    required this.result,
    required this.modelobject,
  });

  int result;
  List<UsersModel> modelobject;

  factory GetUsersLIstModel.fromJson(Map<String, dynamic> json) =>
      GetUsersLIstModel(
        result: json["result"],
        modelobject: List<UsersModel>.from(
            json["Modelobject"].map((x) => UsersModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject.map((x) => x.toJson())),
      };
}

class UsersModel {
  UsersModel({
    required this.code,
    required this.name,
  });

  String code;
  String name;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
