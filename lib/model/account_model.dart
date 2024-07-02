import 'dart:convert';

AccountModel accountModelFromJson(String str) => AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
    AccountModel({
       required this.res,
       required this.model,
       required this.msg,
    });

    int res;
    List<AccountSingleModel> model;
    String msg;

    factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        res: json["res"],
        model: List<AccountSingleModel>.from(json["model"].map((x) => AccountSingleModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
        "msg": msg,
    };
}

class AccountSingleModel {
    AccountSingleModel({
        this.code,
        this.name,
        this.subTypeName,
        this.subType,
        this.typeID,
        this.groupID,
        this.currencyID,
    });

    String? code;
    String? name;
    String? subTypeName;
    dynamic subType;
    dynamic typeID;
    String? groupID;
    String? currencyID;

    factory AccountSingleModel.fromJson(Map<String, dynamic> json) => AccountSingleModel(
        code: json["Code"],
        name: json["Name"],
        subTypeName: json["SubTypeName"],
        subType: json["SubType"],
        typeID: json["TypeID"],
        groupID: json["GroupID"],
        currencyID: json["CurrencyID"],
    );

    Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "SubTypeName": subTypeName,
        "SubType": subType,
        "TypeID": typeID,
        "GroupID": groupID,
        "CurrencyID": currencyID,
    };
}
