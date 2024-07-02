import 'dart:convert';

GetLeadOpenListModel getLeadOpenListModelFromJson(String str) =>
    GetLeadOpenListModel.fromJson(json.decode(str));

String getLeadOpenListModelToJson(GetLeadOpenListModel data) =>
    json.encode(data.toJson());

class GetLeadOpenListModel {
  GetLeadOpenListModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<Modelobject>? modelobject;

  factory GetLeadOpenListModel.fromJson(Map<String, dynamic> json) =>
      GetLeadOpenListModel(
        result: json["result"],
        modelobject: List<Modelobject>.from(
            json["Modelobject"].map((x) => Modelobject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class Modelobject {
  Modelobject({
    this.i,
    this.leadCode,
    this.name,
    this.company,
    this.city,
    this.phone,
    this.mobile,
    this.source,
    this.owner,
    this.industry,
    this.salesperson,
    this.contactName,
    this.status,
    this.country,
    this.area,
    this.stage,
    this.rating,
    this.leadSince,
    this.fax,
    this.email,
  });

  bool? i;
  String? leadCode;
  String? name;
  String? company;
  String? city;
  String? phone;
  String? mobile;
  dynamic source;
  String? owner;
  dynamic industry;
  String? salesperson;
  String? contactName;
  dynamic status;
  String? country;
  dynamic area;
  dynamic stage;
  dynamic rating;
  dynamic leadSince;
  String? fax;
  String? email;

  factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        i: json["I"] ?? false,
        leadCode: json["Lead Code"] ?? '',
        name: json["Name"] ?? '',
        company: json["Company"] ?? '',
        city: json["City"] ?? '',
        phone: json["Phone"] ?? '',
        mobile: json["Mobile"] ?? '',
        source: json["Source"] ?? '',
        owner: json["Owner"] ?? '',
        industry: json["Industry"] ?? '',
        salesperson: json["Salesperson"] ?? '',
        contactName: json["ContactName"] ?? '',
        status: json["Status"] ?? '',
        country: json["Country"] ?? '',
        area: json["Area"] ?? '',
        stage: json["Stage"] ?? '',
        rating: json["Rating"] ?? '',
        leadSince: json["Lead Since"] ?? '',
        fax: json["Fax"] ?? '',
        email: json["Email"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "I": i,
        "Lead Code": leadCode,
        "Name": name,
        "Company": company,
        "City": city,
        "Phone": phone,
        "Mobile": mobile,
        "Source": source,
        "Owner": owner,
        "Industry": industry,
        "Salesperson": salesperson,
        'ContactName': contactName,
        "Status": status,
        "Country": country,
        "Area": area,
        "Stage": stage,
        "Rating": rating,
        "Lead Since": leadSince,
        "Fax": fax,
        "Email": email,
      };
}
