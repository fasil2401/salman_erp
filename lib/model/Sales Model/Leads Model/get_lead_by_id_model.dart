// To parse this JSON data, do
//
//     final getLeadByIdModel = getLeadByIdModelFromJson(jsonString);

import 'dart:convert';

GetLeadByIdModel getLeadByIdModelFromJson(String str) =>
    GetLeadByIdModel.fromJson(json.decode(str));

String getLeadByIdModelToJson(GetLeadByIdModel data) =>
    json.encode(data.toJson());

class GetLeadByIdModel {
  GetLeadByIdModel({
    this.result,
    this.modelobject,
    this.modelAddress,
  });

  int? result;
  List<Modelobject>? modelobject;
  List<ModelAddress>? modelAddress;

  factory GetLeadByIdModel.fromJson(Map<String, dynamic> json) =>
      GetLeadByIdModel(
        result: json["result"],
        modelobject: List<Modelobject>.from(
            json["Modelobject"].map((x) => Modelobject.fromJson(x))),
        modelAddress: List<ModelAddress>.from(
            json["ModelAddress"].map((x) => ModelAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
        "ModelAddress":
            List<dynamic>.from(modelAddress?.map((x) => x.toJson()) ?? []),
      };
}

class ModelAddress {
  ModelAddress({
    this.addressId,
    this.leadId,
    this.contactName,
    this.address1,
    this.address2,
    this.address3,
    this.addressPrintFormat,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.department,
    this.phone1,
    this.phone2,
    this.fax,
    this.mobile,
    this.email,
    this.website,
    this.comment,
    this.suffix,
    this.contactTitle,
    this.gender,
    this.birthDay,
    this.children,
    this.hobbies,
    this.language,
    this.spouseName,
    this.twitter,
    this.facebook,
    this.skype,
    this.linkedIn,
    this.inactive,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
    this.latitude,
    this.longitude,
  });

  String? addressId;
  String? leadId;
  String? contactName;
  String? address1;
  String? address2;
  String? address3;
  String? addressPrintFormat;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? department;
  String? phone1;
  String? phone2;
  String? fax;
  String? mobile;
  String? email;
  String? website;
  String? comment;
  dynamic suffix;
  dynamic contactTitle;
  dynamic gender;
  dynamic birthDay;
  dynamic children;
  dynamic hobbies;
  dynamic language;
  dynamic spouseName;
  dynamic twitter;
  dynamic facebook;
  dynamic skype;
  dynamic linkedIn;
  dynamic inactive;
  dynamic dateCreated;
  dynamic dateUpdated;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic latitude;
  dynamic longitude;

  factory ModelAddress.fromJson(Map<String, dynamic> json) => ModelAddress(
        addressId: json["AddressID"],
        leadId: json["LeadID"],
        contactName: json["ContactName"],
        address1: json["Address1"],
        address2: json["Address2"],
        address3: json["Address3"],
        addressPrintFormat: json["AddressPrintFormat"],
        city: json["City"],
        state: json["State"],
        country: json["Country"],
        postalCode: json["PostalCode"],
        department: json["Department"],
        phone1: json["Phone1"],
        phone2: json["Phone2"],
        fax: json["Fax"],
        mobile: json["Mobile"],
        email: json["Email"],
        website: json["Website"],
        comment: json["Comment"],
        suffix: json["Suffix"],
        contactTitle: json["ContactTitle"],
        gender: json["Gender"],
        birthDay: json["BirthDay"],
        children: json["Children"],
        hobbies: json["Hobbies"],
        language: json["Language"],
        spouseName: json["SpouseName"],
        twitter: json["Twitter"],
        facebook: json["Facebook"],
        skype: json["Skype"],
        linkedIn: json["LinkedIn"],
        inactive: json["Inactive"],
        dateCreated: json["DateCreated"],
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
      );

  Map<String, dynamic> toJson() => {
        "AddressID": addressId,
        "LeadID": leadId,
        "ContactName": contactName,
        "Address1": address1,
        "Address2": address2,
        "Address3": address3,
        "AddressPrintFormat": addressPrintFormat,
        "City": city,
        "State": state,
        "Country": country,
        "PostalCode": postalCode,
        "Department": department,
        "Phone1": phone1,
        "Phone2": phone2,
        "Fax": fax,
        "Mobile": mobile,
        "Email": email,
        "Website": website,
        "Comment": comment,
        "Suffix": suffix,
        "ContactTitle": contactTitle,
        "Gender": gender,
        "BirthDay": birthDay,
        "Children": children,
        "Hobbies": hobbies,
        "Language": language,
        "SpouseName": spouseName,
        "Twitter": twitter,
        "Facebook": facebook,
        "Skype": skype,
        "LinkedIn": linkedIn,
        "Inactive": inactive,
        "DateCreated": dateCreated,
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}

class Modelobject {
  Modelobject({
    this.leadId,
    this.leadName,
    this.foreignName,
    this.companyName,
    this.contactName,
    this.areaId,
    this.stageId,
    this.isInactive,
    this.isLeadSince,
    this.note,
    this.salesPersonId,
    this.parentLeadId,
    this.campaignId,
    this.countryId,
    this.leadSourceId,
    this.leadOwnerId,
    this.industryId,
    this.leadStatus,
    this.companySize,
    this.emailOptOut,
    this.annualTurnOver,
    this.employeeCount,
    this.referredBy,
    this.shortName,
    this.subAreaId,
    this.rating,
    this.dateEstablished,
    this.divisionId,
    this.creditReviewBy,
    this.creditReviewDate,
    this.profileDetails,
    this.userDefined1,
    this.userDefined2,
    this.userDefined3,
    this.userDefined4,
    this.primaryAddressId,
    this.expectValue,
    this.reasonId,
    this.remarks,
    this.createdBy,
    this.dateCreated,
    this.updatedBy,
    this.dateUpdated,
    this.sourceLeadId,
    this.photo,
    this.approvalStatus,
    this.verificationStatus,
  });

  String? leadId;
  String? leadName;
  String? foreignName;
  String? companyName;
  dynamic contactName;
  dynamic areaId;
  dynamic stageId;
  bool? isInactive;
  dynamic isLeadSince;
  String? note;
  String? salesPersonId;
  dynamic parentLeadId;
  dynamic campaignId;
  String? countryId;
  String? leadSourceId;
  String? leadOwnerId;
  dynamic industryId;
  dynamic leadStatus;
  dynamic companySize;
  dynamic emailOptOut;
  dynamic annualTurnOver;
  int? employeeCount;
  dynamic referredBy;
  String? shortName;
  dynamic subAreaId;
  dynamic rating;
  dynamic dateEstablished;
  dynamic divisionId;
  dynamic creditReviewBy;
  dynamic creditReviewDate;
  String? profileDetails;
  dynamic userDefined1;
  dynamic userDefined2;
  dynamic userDefined3;
  dynamic userDefined4;
  String? primaryAddressId;
  int? expectValue;
  dynamic reasonId;
  String? remarks;
  String? createdBy;
  DateTime? dateCreated;
  dynamic updatedBy;
  dynamic dateUpdated;
  dynamic sourceLeadId;
  dynamic photo;
  dynamic approvalStatus;
  dynamic verificationStatus;

  factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        leadId: json["LeadID"],
        leadName: json["LeadName"],
        foreignName: json["ForeignName"],
        companyName: json["CompanyName"],
        contactName: json["ContactName"],
        areaId: json["AreaID"],
        stageId: json["StageID"],
        isInactive: json["IsInactive"],
        isLeadSince: json["IsLeadSince"],
        note: json["Note"],
        salesPersonId: json["SalesPersonID"],
        parentLeadId: json["ParentLeadID"],
        campaignId: json["CampaignID"],
        countryId: json["CountryID"],
        leadSourceId: json["LeadSourceID"],
        leadOwnerId: json["LeadOwnerID"],
        industryId: json["IndustryID"],
        leadStatus: json["LeadStatus"],
        companySize: json["CompanySize"],
        emailOptOut: json["EmailOptOut"],
        annualTurnOver: json["AnnualTurnOver"],
        employeeCount: json["EmployeeCount"],
        referredBy: json["ReferredBy"],
        shortName: json["ShortName"],
        subAreaId: json["SubAreaID"],
        rating: json["Rating"],
        dateEstablished: json["DateEstablished"],
        divisionId: json["DivisionID"],
        creditReviewBy: json["CreditReviewBy"],
        creditReviewDate: json["CreditReviewDate"],
        profileDetails: json["ProfileDetails"],
        userDefined1: json["UserDefined1"],
        userDefined2: json["UserDefined2"],
        userDefined3: json["UserDefined3"],
        userDefined4: json["UserDefined4"],
        primaryAddressId: json["PrimaryAddressID"],
        expectValue: json["ExpectValue"],
        reasonId: json["ReasonID"],
        remarks: json["Remarks"],
        createdBy: json["CreatedBy"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        updatedBy: json["UpdatedBy"],
        dateUpdated: json["DateUpdated"],
        sourceLeadId: json["SourceLeadID"],
        photo: json["Photo"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
      );

  Map<String, dynamic> toJson() => {
        "LeadID": leadId,
        "LeadName": leadName,
        "ForeignName": foreignName,
        "CompanyName": companyName,
        "ContactName": contactName,
        "AreaID": areaId,
        "StageID": stageId,
        "IsInactive": isInactive,
        "IsLeadSince": isLeadSince,
        "Note": note,
        "SalesPersonID": salesPersonId,
        "ParentLeadID": parentLeadId,
        "CampaignID": campaignId,
        "CountryID": countryId,
        "LeadSourceID": leadSourceId,
        "LeadOwnerID": leadOwnerId,
        "IndustryID": industryId,
        "LeadStatus": leadStatus,
        "CompanySize": companySize,
        "EmailOptOut": emailOptOut,
        "AnnualTurnOver": annualTurnOver,
        "EmployeeCount": employeeCount,
        "ReferredBy": referredBy,
        "ShortName": shortName,
        "SubAreaID": subAreaId,
        "Rating": rating,
        "DateEstablished": dateEstablished,
        "DivisionID": divisionId,
        "CreditReviewBy": creditReviewBy,
        "CreditReviewDate": creditReviewDate,
        "ProfileDetails": profileDetails,
        "UserDefined1": userDefined1,
        "UserDefined2": userDefined2,
        "UserDefined3": userDefined3,
        "UserDefined4": userDefined4,
        "PrimaryAddressID": primaryAddressId,
        "ExpectValue": expectValue,
        "ReasonID": reasonId,
        "Remarks": remarks,
        "CreatedBy": createdBy,
        "DateCreated": dateCreated!.toIso8601String(),
        "UpdatedBy": updatedBy,
        "DateUpdated": dateUpdated,
        "SourceLeadID": sourceLeadId,
        "Photo": photo,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
      };
}
