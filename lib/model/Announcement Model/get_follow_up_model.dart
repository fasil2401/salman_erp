// To parse this JSON data, do
//
//     final getFollowUpModel = getFollowUpModelFromJson(jsonString);

import 'dart:convert';

GetFollowUpModel getFollowUpModelFromJson(String str) => GetFollowUpModel.fromJson(json.decode(str));

String getFollowUpModelToJson(GetFollowUpModel data) => json.encode(data.toJson());

class GetFollowUpModel {
    int? res;
    List<FollowUpModel>? modelobject;
    String? msg;

    GetFollowUpModel({
        this.res,
        this.modelobject,
        this.msg,
    });

    factory GetFollowUpModel.fromJson(Map<String, dynamic> json) => GetFollowUpModel(
        res: json["res"],
        modelobject: json["Modelobject"] == null ? [] : List<FollowUpModel>.from(json["Modelobject"]!.map((x) => FollowUpModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class FollowUpModel {
    String? followupId;
    DateTime? currentfollowupDate;
    DateTime? nextfollowupDate;
    dynamic followupBy;
    dynamic nextFollowupBy;
    String? remark;
    String? sourceVoucherId;
    String? nextFollowupById;
    dynamic leadStatus;
    String? leadName;
    int? followUpStatus;

    FollowUpModel({
        this.followupId,
        this.currentfollowupDate,
        this.nextfollowupDate,
        this.followupBy,
        this.nextFollowupBy,
        this.remark,
        this.sourceVoucherId,
        this.nextFollowupById,
        this.leadStatus,
        this.leadName,
        this.followUpStatus,
    });

    factory FollowUpModel.fromJson(Map<String, dynamic> json) => FollowUpModel(
        followupId: json["FollowupID"],
        currentfollowupDate: json["Currentfollowup Date"] == null ? null : DateTime.parse(json["Currentfollowup Date"]),
        nextfollowupDate: json["Nextfollowup Date"] == null ? null : DateTime.parse(json["Nextfollowup Date"]),
        followupBy: json["Followup By"],
        nextFollowupBy: json["Next Followup By"],
        remark: json["Remark"],
        sourceVoucherId: json["SourceVoucherID"],
        nextFollowupById: json["NextFollowupByID"],
        leadStatus: json["LeadStatus"],
        leadName: json["LeadName"],
        followUpStatus: json["FollowUpStatus"],
    );

    Map<String, dynamic> toJson() => {
        "FollowupID": followupId,
        "Currentfollowup Date": currentfollowupDate?.toIso8601String(),
        "Nextfollowup Date": nextfollowupDate?.toIso8601String(),
        "Followup By": followupBy,
        "Next Followup By": nextFollowupBy,
        "Remark": remark,
        "SourceVoucherID": sourceVoucherId,
        "NextFollowupByID": nextFollowupById,
        "LeadStatus": leadStatus,
        "LeadName": leadName,
        "FollowUpStatus": followUpStatus,
    };
}
