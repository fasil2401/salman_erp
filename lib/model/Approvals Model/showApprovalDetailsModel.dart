// To parse this JSON data, do
//
//     final showApprovalDetailsModel = showApprovalDetailsModelFromJson(jsonString);

import 'dart:convert';

ShowApprovalDetailsModel showApprovalDetailsModelFromJson(String str) =>
    ShowApprovalDetailsModel.fromJson(json.decode(str));

String showApprovalDetailsModelToJson(ShowApprovalDetailsModel data) =>
    json.encode(data.toJson());

class ShowApprovalDetailsModel {
  int? result;
  List<TaskDetailsModel>? modelobject;

  ShowApprovalDetailsModel({
    this.result,
    this.modelobject,
  });

  factory ShowApprovalDetailsModel.fromJson(Map<String, dynamic> json) =>
      ShowApprovalDetailsModel(
        result: json["result"],
        modelobject: List<TaskDetailsModel>.from(
            json["Modelobject"].map((x) => TaskDetailsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject":
            List<dynamic>.from(modelobject?.map((x) => x.toJson()) ?? []),
      };
}

class TaskDetailsModel {
  int? groupId;
  int? taskId;
  int? levelId;
  int? status;
  String? sysDocId;
  String? voucherId;
  String? userId;
  String? userName;
  DateTime? dateApproved;
  bool? isExpired;
  dynamic remarks;
  String? assigneeId;
  String? userList;
  String? assignedTo;
  String? approverId;

  TaskDetailsModel({
    this.groupId,
    this.taskId,
    this.levelId,
    this.status,
    this.sysDocId,
    this.voucherId,
    this.userId,
    this.userName,
    this.dateApproved,
    this.isExpired,
    this.remarks,
    this.assigneeId,
    this.userList,
    this.assignedTo,
    this.approverId,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) =>
      TaskDetailsModel(
        groupId: json["GroupID"],
        taskId: json["TaskID"],
        levelId: json["LevelID"],
        status: json["Status"],
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        userId: json["UserID"],
        userName: json["UserName"],
        dateApproved: DateTime.parse(json["DateApproved"]),
        isExpired: json["IsExpired"],
        remarks: json["Remarks"],
        assigneeId: json["AssigneeID"],
        userList: json["UserList"],
        assignedTo: json["AssignedTo"],
        approverId: json["ApproverID"],
      );

  Map<String, dynamic> toJson() => {
        "GroupID": groupId,
        "TaskID": taskId,
        "LevelID": levelId,
        "Status": status,
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "UserID": userId,
        "UserName": userName,
        "DateApproved": dateApproved!.toIso8601String(),
        "IsExpired": isExpired,
        "Remarks": remarks,
        "AssigneeID": assigneeId,
        "UserList": userList,
      };
}
