// To parse this JSON data, do
//
//     final getMyTaskByIdModel = getMyTaskByIdModelFromJson(jsonString);

import 'dart:convert';

GetMyTaskByIdModel getMyTaskByIdModelFromJson(String str) => GetMyTaskByIdModel.fromJson(json.decode(str));

String getMyTaskByIdModelToJson(GetMyTaskByIdModel data) => json.encode(data.toJson());

class GetMyTaskByIdModel {
    int? res;
    List<GetMyTaskById>? model;
    String? msg;

    GetMyTaskByIdModel({
        this.res,
        this.model,
        this.msg,
    });

    factory GetMyTaskByIdModel.fromJson(Map<String, dynamic> json) => GetMyTaskByIdModel(
        res: json["res"],
        model: json["model"] == null ? [] : List<GetMyTaskById>.from(json["model"]!.map((x) => GetMyTaskById.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class GetMyTaskById {
    String? taskId;
    String? description;
    String? feeId;
    String? jobId;
    String? costCategoryId;
    DateTime? startDate;
    DateTime? endDate;
    DateTime? actualStartDate;
    DateTime? actualEndDate;
    String? assignedToId;
    String? requestedById;
    String? priorityId;
    String? taskDelayReasonId;
    int? totalHours;
    int? completedPercentage;
    String? status;
    String? note;
    String? taskGroupId;
    dynamic teamId;
    String? createdBy;
    dynamic updatedBy;
    DateTime? dateCreated;
    dynamic dateUpdated;

    GetMyTaskById({
        this.taskId,
        this.description,
        this.feeId,
        this.jobId,
        this.costCategoryId,
        this.startDate,
        this.endDate,
        this.actualStartDate,
        this.actualEndDate,
        this.assignedToId,
        this.requestedById,
        this.priorityId,
        this.taskDelayReasonId,
        this.totalHours,
        this.completedPercentage,
        this.status,
        this.note,
        this.taskGroupId,
        this.teamId,
        this.createdBy,
        this.updatedBy,
        this.dateCreated,
        this.dateUpdated,
    });

    factory GetMyTaskById.fromJson(Map<String, dynamic> json) => GetMyTaskById(
        taskId: json["TaskID"],
        description: json["Description"],
        feeId: json["FeeID"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        startDate: json["StartDate"] == null ? null : DateTime.parse(json["StartDate"]),
        endDate: json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
        actualStartDate: json["ActualStartDate"] == null ? null : DateTime.parse(json["ActualStartDate"]),
        actualEndDate: json["ActualEndDate"] == null ? null : DateTime.parse(json["ActualEndDate"]),
        assignedToId: json["AssignedToID"],
        requestedById: json["RequestedByID"],
        priorityId: json["PriorityID"],
        taskDelayReasonId: json["TaskDelayReasonID"],
        totalHours: json["TotalHours"],
        completedPercentage: json["CompletedPercentage"],
        status: json["Status"],
        note: json["Note"],
        taskGroupId: json["TaskGroupID"],
        teamId: json["TeamID"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        dateCreated: json["DateCreated"] == null ? null : DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
    );

    Map<String, dynamic> toJson() => {
        "TaskID": taskId,
        "Description": description,
        "FeeID": feeId,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "ActualStartDate": actualStartDate?.toIso8601String(),
        "ActualEndDate": actualEndDate?.toIso8601String(),
        "AssignedToID": assignedToId,
        "RequestedByID": requestedById,
        "PriorityID": priorityId,
        "TaskDelayReasonID": taskDelayReasonId,
        "TotalHours": totalHours,
        "CompletedPercentage": completedPercentage,
        "Status": status,
        "Note": note,
        "TaskGroupID": taskGroupId,
        "TeamID": teamId,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "DateCreated": dateCreated?.toIso8601String(),
        "DateUpdated": dateUpdated,
    };
}
