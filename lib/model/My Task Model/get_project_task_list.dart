// To parse this JSON data, do
//
//     final getProjectTaskList = getProjectTaskListFromJson(jsonString);

import 'dart:convert';

GetProjectTaskList getProjectTaskListFromJson(String str) => GetProjectTaskList.fromJson(json.decode(str));

String getProjectTaskListToJson(GetProjectTaskList data) => json.encode(data.toJson());

class GetProjectTaskList {
    int? res;
    List<GetProjectTaskModel>? model;
    String? msg;

    GetProjectTaskList({
        this.res,
        this.model,
        this.msg,
    });

    factory GetProjectTaskList.fromJson(Map<String, dynamic> json) => GetProjectTaskList(
        res: json["res"],
        model: json["model"] == null ? [] : List<GetProjectTaskModel>.from(json["model"]!.map((x) => GetProjectTaskModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class GetProjectTaskModel {
    String? taskCode;
    String? description;
    String? jobCode;
    dynamic job;
    dynamic taskGroup;
    DateTime? startDate;
    DateTime? endDate;
    DateTime? actStartDate;
    DateTime? actEndDate;
    dynamic assignedTo;
    dynamic requestedBy;
    dynamic costCategoryName;
    String? priorityId;
    dynamic priority;
    String? team;
    int? completed;
    String? status;
    String? createdBy;

    GetProjectTaskModel({
        this.taskCode,
        this.description,
        this.jobCode,
        this.job,
        this.taskGroup,
        this.startDate,
        this.endDate,
        this.actStartDate,
        this.actEndDate,
        this.assignedTo,
        this.requestedBy,
        this.costCategoryName,
        this.priorityId,
        this.priority,
        this.team,
        this.completed,
        this.status,
        this.createdBy,
    });

    factory GetProjectTaskModel.fromJson(Map<String, dynamic> json) => GetProjectTaskModel(
        taskCode: json["Task Code"],
        description: json["Description"],
        jobCode: json["Job Code"],
        job: json["Job"],
        taskGroup: json["Task Group"],
        startDate: json["Start Date"] == null ? null : DateTime.parse(json["Start Date"]),
        endDate: json["End Date"] == null ? null : DateTime.parse(json["End Date"]),
        actStartDate: json["Act Start Date"] == null ? null : DateTime.parse(json["Act Start Date"]),
        actEndDate: json["Act End Date"] == null ? null : DateTime.parse(json["Act End Date"]),
        assignedTo: json["Assigned To"],
        requestedBy: json["Requested By"],
        costCategoryName: json["CostCategoryName"],
        priorityId: json["PriorityID"],
        priority: json["Priority"],
        team: json["Team"],
        completed: json["Completed %"],
        status: json["Status"],
        createdBy: json["CreatedBy"],
    );

    Map<String, dynamic> toJson() => {
        "Task Code": taskCode,
        "Description": description,
        "Job Code": jobCode,
        "Job": job,
        "Task Group": taskGroup,
        "Start Date": startDate?.toIso8601String(),
        "End Date": endDate?.toIso8601String(),
        "Act Start Date": actStartDate?.toIso8601String(),
        "Act End Date": actEndDate?.toIso8601String(),
        "Assigned To": assignedTo,
        "Requested By": requestedBy,
        "CostCategoryName": costCategoryName,
        "PriorityID": priorityId,
        "Priority": priority,
         "Team": team,
        "Completed %": completed,
        "Status": status,
        "CreatedBy": createdBy,
    };
}
