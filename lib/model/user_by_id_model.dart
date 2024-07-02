
import 'dart:convert';

UserByIdModel userByIdModelFromJson(String str) =>
    UserByIdModel.fromJson(json.decode(str));

String userByIdModelToJson(UserByIdModel data) => json.encode(data.toJson());

class UserByIdModel {
  UserByIdModel({
    required this.res,
    required this.model,
  });

  int res;
  List<UserModel> model;

  factory UserByIdModel.fromJson(Map<String, dynamic> json) => UserByIdModel(
        res: json["res"],
        model: List<UserModel>.from(json["model"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "model": List<dynamic>.from(model.map((x) => x.toJson())),
      };
}

class UserModel {
  UserModel({
    this.userId,
    this.userName,
    this.employeeId,
    this.defaultSalesPersonId,
    this.defaultInventoryLocationId,
    this.defaultCompanyDivisionId,
    this.defaultTransactionLocationId,
    this.defaultTransactionRegisterId,
    this.locationId,
    this.phone,
    this.isClUser,
    this.clUserPass,
    this.email,
    this.password,
    this.note,
    this.inactive,
    this.isAdmin,
    this.canCreateCard,
    this.canEditCard,
    this.canDeleteCard,
    this.canCreateTransaction,
    this.canEditTransaction,
    this.canDeleteTransaction,
    this.partyType,
    this.partyId,
    this.isWebUser,
    this.userSignature,
    this.createdBy,
    this.updatedBy,
    this.dateCreated,
    this.dateUpdated,
    this.hasPhoto,
  });

  String? userId;
  String? userName;
  String? employeeId;
  String? defaultSalesPersonId;
  String? defaultInventoryLocationId;
  String? defaultCompanyDivisionId;
  String? defaultTransactionLocationId;
  String? defaultTransactionRegisterId;
  String? locationId;
  String? phone;
  bool? isClUser;
  dynamic clUserPass;
  String? email;
  dynamic password;
  String? note;
  bool? inactive;
  bool? isAdmin;
  dynamic canCreateCard;
  dynamic canEditCard;
  dynamic canDeleteCard;
  dynamic canCreateTransaction;
  dynamic canEditTransaction;
  dynamic canDeleteTransaction;
  dynamic partyType;
  dynamic partyId;
  dynamic isWebUser;
  dynamic userSignature;
  String? createdBy;
  String? updatedBy;
  String? dateCreated;
  String? dateUpdated;
  int? hasPhoto;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["UserID"],
        userName: json["UserName"],
        employeeId: json["EmployeeID"],
        defaultSalesPersonId: json["DefaultSalesPersonID"],
        defaultInventoryLocationId: json["DefaultInventoryLocationID"],
        defaultCompanyDivisionId: json["DefaultCompanyDivisionID"],
        defaultTransactionLocationId: json["DefaultTransactionLocationID"],
        defaultTransactionRegisterId: json["DefaultTransactionRegisterID"],
        locationId: json["LocationID"],
        phone: json["Phone"],
        isClUser: json["IsCLUser"],
        clUserPass: json["CLUserPass"],
        email: json["Email"],
        password: json["Password"],
        note: json["Note"],
        inactive: json["Inactive"],
        isAdmin: json["IsAdmin"],
        canCreateCard: json["CanCreateCard"],
        canEditCard: json["CanEditCard"],
        canDeleteCard: json["CanDeleteCard"],
        canCreateTransaction: json["CanCreateTransaction"],
        canEditTransaction: json["CanEditTransaction"],
        canDeleteTransaction: json["CanDeleteTransaction"],
        partyType: json["PartyType"],
        partyId: json["PartyID"],
        isWebUser: json["IsWebUser"],
        userSignature: json["UserSignature"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        dateCreated: json["DateCreated"],
        dateUpdated: json["DateUpdated"],
        hasPhoto: json["HasPhoto"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserName": userName,
        "EmployeeID": employeeId,
        "DefaultSalesPersonID": defaultSalesPersonId,
        "DefaultInventoryLocationID": defaultInventoryLocationId,
        "DefaultCompanyDivisionID": defaultCompanyDivisionId,
        "DefaultTransactionLocationID": defaultTransactionLocationId,
        "DefaultTransactionRegisterID": defaultTransactionRegisterId,
        "LocationID": locationId,
        "Phone": phone,
        "IsCLUser": isClUser,
        "CLUserPass": clUserPass,
        "Email": email,
        "Password": password,
        "Note": note,
        "Inactive": inactive,
        "IsAdmin": isAdmin,
        "CanCreateCard": canCreateCard,
        "CanEditCard": canEditCard,
        "CanDeleteCard": canDeleteCard,
        "CanCreateTransaction": canCreateTransaction,
        "CanEditTransaction": canEditTransaction,
        "CanDeleteTransaction": canDeleteTransaction,
        "PartyType": partyType,
        "PartyID": partyId,
        "IsWebUser": isWebUser,
        "UserSignature": userSignature,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "DateCreated": dateCreated,
        "DateUpdated": dateUpdated,
        "HasPhoto": hasPhoto,
      };
}
