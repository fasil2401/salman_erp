import 'dart:convert';

ContactListModel contactListModelFromJson(String str) =>
    ContactListModel.fromJson(json.decode(str));

String contactListModelToJson(ContactListModel data) =>
    json.encode(data.toJson());

class ContactListModel {
  ContactListModel({
    required this.result,
    required this.modelobject,
  });

  int result;
  List<ContactsModel> modelobject;

  factory ContactListModel.fromJson(Map<String, dynamic> json) =>
      ContactListModel(
        result: json["result"],
        modelobject: List<ContactsModel>.from(
            json["Modelobject"].map((x) => ContactsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject.map((x) => x.toJson())),
      };
}

class ContactsModel {
  ContactsModel({
    required this.code,
    required this.name,
  });

  String code;
  String name;

  factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
        code: json["Code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
      };
}
