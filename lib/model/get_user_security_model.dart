import 'dart:convert';

GetUserSecurityModel getUserSecurityModelFromJson(String str) => GetUserSecurityModel.fromJson(json.decode(str));

String getUserSecurityModelToJson(GetUserSecurityModel data) => json.encode(data.toJson());

class GetUserSecurityModel {
    GetUserSecurityModel({
       required this.result,
       required this.menuSecurityObj,
       required this.screenSecurityObj,
       required this.defaultsObj,
    });

    int result;
    List<MenuSecurityObj> menuSecurityObj;
    List<ScreenSecurityObj> screenSecurityObj;
    List<DefaultsObj> defaultsObj;

    factory GetUserSecurityModel.fromJson(Map<String, dynamic> json) => GetUserSecurityModel(
        result: json["result"],
        menuSecurityObj: List<MenuSecurityObj>.from(json["MenuSecurityObj"].map((x) => MenuSecurityObj.fromJson(x))),
        screenSecurityObj: List<ScreenSecurityObj>.from(json["ScreenSecurityObj"].map((x) => ScreenSecurityObj.fromJson(x))),
        defaultsObj: List<DefaultsObj>.from(json["DefaultsObj"].map((x) => DefaultsObj.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "MenuSecurityObj": List<dynamic>.from(menuSecurityObj.map((x) => x.toJson())),
        "ScreenSecurityObj": List<dynamic>.from(screenSecurityObj.map((x) => x.toJson())),
        "DefaultsObj": List<dynamic>.from(defaultsObj.map((x) => x.toJson())),
    };
}

class DefaultsObj {
    DefaultsObj({
        this.defaultSalespersonId,
        this.defaultInventoryLocationId,
        this.defaultTransactionLocationId,
        this.defaultTransactionRegisterId,
        this.defaultCompanyDivisionId,
    });

    String? defaultSalespersonId;
    String? defaultInventoryLocationId;
    String? defaultTransactionLocationId;
    String? defaultTransactionRegisterId;
    String? defaultCompanyDivisionId;

    factory DefaultsObj.fromJson(Map<String, dynamic> json) => DefaultsObj(
        defaultSalespersonId: json["DefaultSalespersonID"],
        defaultInventoryLocationId: json["DefaultInventoryLocationID"],
        defaultTransactionLocationId: json["DefaultTransactionLocationID"],
        defaultTransactionRegisterId: json["DefaultTransactionRegisterID"],
        defaultCompanyDivisionId: json["DefaultCompanyDivisionID"],
    );

    Map<String, dynamic> toJson() => {
        "DefaultSalespersonID": defaultSalespersonId,
        "DefaultInventoryLocationID": defaultInventoryLocationId,
        "DefaultTransactionLocationID": defaultTransactionLocationId,
        "DefaultTransactionRegisterID": defaultTransactionRegisterId,
        "DefaultCompanyDivisionID": defaultCompanyDivisionId,
    };
}

class MenuSecurityObj {
    MenuSecurityObj({
        this.menuId,
        this.subMenuId,
        this.dropDownId,
        this.enable,
        this.visible,
        this.userId,
        this.groupId,
    });

    String? menuId;
    dynamic subMenuId;
    dynamic dropDownId;
    bool? enable;
    bool? visible;
    dynamic userId;
    dynamic groupId;

    factory MenuSecurityObj.fromJson(Map<String, dynamic> json) => MenuSecurityObj(
        menuId: json["MenuID"],
        subMenuId: json["SubMenuID"],
        dropDownId: json["DropDownID"],
        enable: json["Enable"],
        visible: json["Visible"],
        userId: json["UserID"],
        groupId: json["GroupID"],
    );

    Map<String, dynamic> toJson() => {
        "MenuID": menuId,
        "SubMenuID": subMenuId,
        "DropDownID": dropDownId,
        "Enable": enable,
        "Visible": visible,
        "UserID": userId,
        "GroupID": groupId,
    };
}

class ScreenSecurityObj {
    ScreenSecurityObj({
        this.screenId,
        this.viewRight,
        this.newRight,
        this.editRight,
        this.deleteRight,
        this.userId,
        this.groupId,
    });

    String? screenId;
    bool? viewRight;
    bool? newRight;
    bool? editRight;
    bool? deleteRight;
    dynamic userId;
    dynamic groupId;

    factory ScreenSecurityObj.fromJson(Map<String, dynamic> json) => ScreenSecurityObj(
        screenId: json["ScreenID"],
        viewRight: json["ViewRight"],
        newRight: json["NewRight"],
        editRight: json["EditRight"],
        deleteRight: json["DeleteRight"],
        userId: json["UserID"],
        groupId: json["GroupID"],
    );

    Map<String, dynamic> toJson() => {
        "ScreenID": screenId,
        "ViewRight": viewRight,
        "NewRight": newRight,
        "EditRight": editRight,
        "DeleteRight": deleteRight,
        "UserID": userId,
        "GroupID": groupId,
    };
}
