import 'dart:convert';

GetUserApprovalsWithPendingTasksModel
    getUserApprovalsWithPendingTasksModelFromJson(String str) =>
        GetUserApprovalsWithPendingTasksModel.fromJson(json.decode(str));

String getUserApprovalsWithPendingTasksModelToJson(
        GetUserApprovalsWithPendingTasksModel data) =>
    json.encode(data.toJson());

class GetUserApprovalsWithPendingTasksModel {
  GetUserApprovalsWithPendingTasksModel({
    this.result,
    this.modelobject,
  });

  int? result;
  List<Modelobject>? modelobject;

  factory GetUserApprovalsWithPendingTasksModel.fromJson(
          Map<String, dynamic> json) =>
      GetUserApprovalsWithPendingTasksModel(
        result: json["result"],
        modelobject: List<Modelobject>.from(
            json["Modelobject"].map((x) => Modelobject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject!.map((x) => x.toJson())),
      };
}

class Modelobject {
  Modelobject({
    this.approvalId,
    this.approvalName,
    this.approvalType,
    this.taskCount,
  });

  String? approvalId;
  String? approvalName;
  int? approvalType;
  int? taskCount;

  Map<String, dynamic> toJson() => {
        "ApprovalID": approvalId,
        "ApprovalName": approvalName,
        "ApprovalType": approvalType,
        "TaskCount": taskCount,
      };

  factory Modelobject.fromJson(Map<String, dynamic> json) => Modelobject(
        approvalId: json["ApprovalID"],
        approvalName: json["ApprovalName"],
        approvalType: json["ApprovalType"],
        taskCount: json["TaskCount"],
      );
}
