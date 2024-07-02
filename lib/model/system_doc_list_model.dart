import 'dart:convert';

SystemDoccumentListModel systemDoccumentListModelFromJson(String str) =>
    SystemDoccumentListModel.fromJson(json.decode(str));

String systemDoccumentListModelToJson(SystemDoccumentListModel data) =>
    json.encode(data.toJson());

class SystemDoccumentListModel {
  SystemDoccumentListModel({
    required this.res,
    required this.model,
  });

  int res;
  List<SysDocModel> model;

  factory SystemDoccumentListModel.fromJson(Map<String, dynamic> json) =>
      SystemDoccumentListModel(
        res: json["res"],
        model: List<SysDocModel>.from(
            json["mdel"].map((x) => SysDocModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "mdel": List<dynamic>.from(model.map((x) => x.toJson())),
      };
}

class SysDocModel {
  SysDocModel({
    this.code,
    this.name,
    this.sysDocType,
    this.locationId,
    this.printAfterSave,
    this.doPrint,
    this.printTemplateName,
    this.priceIncludeTax,
    this.divisionId,
    this.nextNumber,
    this.lastNumber,
    this.numberPrefix,
  });

  String? code;
  String? name;
  int? sysDocType;
  String? locationId;
  int? printAfterSave;
  int? doPrint;
  String? printTemplateName;
  int? priceIncludeTax;
  String? divisionId;
  int? nextNumber;
  String? lastNumber;
  String? numberPrefix;

  factory SysDocModel.fromJson(Map<String, dynamic> json) => SysDocModel(
        code: json["Code"],
        name: json["Name"],
        sysDocType: json["SysDocType"],
        locationId: json["LocationID"],
        printAfterSave: json["PrintAfterSave"] == true ? 1 : 0,
        doPrint: json["DoPrint"] == true ? 1 : 0,
        printTemplateName: json["PrintTemplateName"],
        priceIncludeTax: json["PriceIncludeTax"] == true ? 1 : 0,
        divisionId: json["DivisionID"],
        nextNumber: json["NextNumber"],
        lastNumber: json["LastNumber"],
        numberPrefix: json["NumberPrefix"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "SysDocType": sysDocType,
        "LocationID": locationId,
        "PrintAfterSave": printAfterSave,
        "DoPrint": doPrint,
        "PrintTemplateName": printTemplateName,
        "PriceIncludeTax": priceIncludeTax,
        "DivisionID": divisionId,
        "NextNumber": nextNumber,
        "LastNumber": lastNumber == null ? null : lastNumber,
        "NumberPrefix": numberPrefix,
      };
}
