// To parse this JSON data, do
//
//     final getLeadListDetailsModel = getLeadListDetailsModelFromJson(jsonString);

import 'dart:convert';

GetLeadListDetailsModel getLeadListDetailsModelFromJson(String str) =>
    GetLeadListDetailsModel.fromJson(json.decode(str));

String getLeadListDetailsModelToJson(GetLeadListDetailsModel data) =>
    json.encode(data.toJson());

class GetLeadListDetailsModel {
  int? res;
  List<LeadListDetailsModel>? modelobject;

  GetLeadListDetailsModel({
    this.res,
    this.modelobject,
  });

  factory GetLeadListDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetLeadListDetailsModel(
        res: json["res"],
        modelobject: List<LeadListDetailsModel>.from(
            json["Modelobject"].map((x) => LeadListDetailsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class LeadListDetailsModel {
  String? docId;
  String? leadName;
  DateTime? leadCreated;
  String? company;
  String? city;
  String? phone;
  String? mobile;
  dynamic source;
  dynamic industry;
  String? salesperson;
  String? followupStatus;
  dynamic followupDate;
  String? followupBy;
  dynamic nextFollowupDate;
  String? nextFollowupBy;
  String? followUpId;
  String? email;
  String? website;
  dynamic voucherId;
  dynamic sysDocId;
  String? followupId1;
  dynamic sourceSysDocId;
  dynamic sourceVoucherId;
  String? fpSourceVoucherId;
  String? status;
  dynamic activity;
  String? comments;
  dynamic stage;
  String? hexColorCode;
  dynamic quotedAmount;
  dynamic quotedVoucherNo;
  int? expectValue;
  dynamic divisionName;
  DateTime? leadDate;
  dynamic customerName;
  String? companyName;
  String? foreignName;
  String? contactName;
  dynamic leadOwnerName;
  dynamic leadSourceName;
  dynamic sourceLeadId;
  dynamic campaignName;
  dynamic companySize;
  dynamic emailOptOut;
  dynamic annualTurnOver;
  dynamic rating;
  int? employeeCount;
  dynamic countryName;
  dynamic areaName;
  dynamic dateEstablished;
  dynamic isLeadSince;
  dynamic referredBy;
  bool? isInactive;
  dynamic reason;
  String? remarks;
  String? profileDetails;
  String? note;
  dynamic channel;
  dynamic subChannel;

  LeadListDetailsModel({
    this.docId,
    this.leadName,
    this.leadCreated,
    this.company,
    this.city,
    this.phone,
    this.mobile,
    this.source,
    this.industry,
    this.salesperson,
    this.followupStatus,
    this.followupDate,
    this.followupBy,
    this.nextFollowupDate,
    this.nextFollowupBy,
    this.followUpId,
    this.email,
    this.website,
    this.voucherId,
    this.sysDocId,
    this.followupId1,
    this.sourceSysDocId,
    this.sourceVoucherId,
    this.fpSourceVoucherId,
    this.status,
    this.activity,
    this.comments,
    this.stage,
    this.hexColorCode,
    this.quotedAmount,
    this.quotedVoucherNo,
    this.expectValue,
    this.divisionName,
    this.leadDate,
    this.customerName,
    this.companyName,
    this.foreignName,
    this.contactName,
    this.leadOwnerName,
    this.leadSourceName,
    this.sourceLeadId,
    this.campaignName,
    this.companySize,
    this.emailOptOut,
    this.annualTurnOver,
    this.rating,
    this.employeeCount,
    this.countryName,
    this.areaName,
    this.dateEstablished,
    this.isLeadSince,
    this.referredBy,
    this.isInactive,
    this.reason,
    this.remarks,
    this.profileDetails,
    this.note,
    this.channel,
    this.subChannel,
  });

  factory LeadListDetailsModel.fromJson(Map<String, dynamic> json) =>
      LeadListDetailsModel(
        docId: json["DocID"],
        leadName: json["LeadName"],
        leadCreated: DateTime.parse(json["LeadCreated"]),
        company: json["Company"],
        city: json["City"],
        phone: json["Phone"],
        mobile: json["Mobile"],
        source: json["Source"],
        industry: json["Industry"],
        salesperson: json["Salesperson"],
        followupStatus: json["FollowupStatus"],
        followupDate: json["FollowupDate"],
        followupBy: json["FollowupBy"],
        nextFollowupDate: json["NextFollowupDate"],
        nextFollowupBy: json["NextFollowupBy"],
        followUpId: json["FollowUpID"],
        email: json["Email"],
        website: json["Website"],
        voucherId: json["VoucherID"],
        sysDocId: json["SysDocID"],
        followupId1: json["FollowupID1"],
        sourceSysDocId: json["SourceSysDocID"],
        sourceVoucherId: json["SourceVoucherID"],
        fpSourceVoucherId: json["FPSourceVoucherID"],
        status: json["Status"],
        activity: json["Activity"],
        comments: json["Comments"],
        stage: json["Stage"],
        hexColorCode: json["HexColorCode"],
        quotedAmount: json["QuotedAmount"],
        quotedVoucherNo: json["QuotedVoucherNo"],
        expectValue: json["ExpectValue"],
        divisionName: json["DivisionName"],
        leadDate: DateTime.parse(json["LeadDate"]),
        customerName: json["CustomerName"],
        companyName: json["CompanyName"],
        foreignName: json["ForeignName"],
        contactName: json["ContactName"],
        leadOwnerName: json["LeadOwnerName"],
        leadSourceName: json["LeadSourceName"],
        sourceLeadId: json["SourceLeadID"],
        campaignName: json["CampaignName"],
        companySize: json["CompanySize"],
        emailOptOut: json["EmailOptOut"],
        annualTurnOver: json["AnnualTurnOver"],
        rating: json["Rating"],
        employeeCount: json["EmployeeCount"],
        countryName: json["CountryName"],
        areaName: json["AreaName"],
        dateEstablished: json["DateEstablished"],
        isLeadSince: json["IsLeadSince"],
        referredBy: json["ReferredBy"],
        isInactive: json["IsInactive"],
        reason: json["Reason"],
        remarks: json["Remarks"],
        profileDetails: json["ProfileDetails"],
        note: json["Note"],
        channel: json["Channel"],
        subChannel: json["SubChannel"],
      );

  Map<String, dynamic> toJson() => {
        "DocID": docId,
        "LeadName": leadName,
        "LeadCreated": leadCreated?.toIso8601String(),
        "Company": company,
        "City": city,
        "Phone": phone,
        "Mobile": mobile,
        "Source": source,
        "Industry": industry,
        "Salesperson": salesperson,
        "FollowupStatus": followupStatus,
        "FollowupDate": followupDate?.toIso8601String(),
        "FollowupBy": followupBy,
        "NextFollowupDate": nextFollowupDate?.toIso8601String(),
        "NextFollowupBy": nextFollowupBy,
        "FollowUpID": followUpId,
        "Email": email,
        "Website": website,
        "VoucherID": voucherId,
        "SysDocID": sysDocId,
        "FollowupID1": followupId1,
        "SourceSysDocID": sourceSysDocId,
        "SourceVoucherID": sourceVoucherId,
        "FPSourceVoucherID": fpSourceVoucherId,
        "Status": status,
        "Activity": activity,
        "Comments": comments,
        "Stage": stage,
        "HexColorCode": hexColorCode,
        "QuotedAmount": quotedAmount,
        "QuotedVoucherNo": quotedVoucherNo,
        "ExpectValue": expectValue,
        "DivisionName": divisionName,
        "LeadDate": leadDate?.toIso8601String(),
        "CustomerName": customerName,
        "CompanyName": companyName,
        "ForeignName": foreignName,
        "ContactName": contactName,
        "LeadOwnerName": leadOwnerName,
        "LeadSourceName": leadSourceName,
        "SourceLeadID": sourceLeadId,
        "CampaignName": campaignName,
        "CompanySize": companySize,
        "EmailOptOut": emailOptOut,
        "AnnualTurnOver": annualTurnOver,
        "Rating": rating,
        "EmployeeCount": employeeCount,
        "CountryName": countryName,
        "AreaName": areaName,
        "DateEstablished": dateEstablished,
        "IsLeadSince": isLeadSince?.toIso8601String(),
        "ReferredBy": referredBy,
        "IsInactive": isInactive,
        "Reason": reason,
        "Remarks": remarks,
        "ProfileDetails": profileDetails,
        "Note": note,
        "Channel": channel,
        "SubChannel": subChannel,
      };
}
