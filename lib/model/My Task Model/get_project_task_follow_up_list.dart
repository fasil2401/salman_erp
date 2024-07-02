// To parse this JSON data, do
//
//     final getProjectTaskFollowUpList = getProjectTaskFollowUpListFromJson(jsonString);

import 'dart:convert';

GetProjectTaskFollowUpList getProjectTaskFollowUpListFromJson(String str) => GetProjectTaskFollowUpList.fromJson(json.decode(str));

String getProjectTaskFollowUpListToJson(GetProjectTaskFollowUpList data) => json.encode(data.toJson());

class GetProjectTaskFollowUpList {
    int? res;
    List<GetProjectTaskFollowUpModel>? model;
    String? msg;

    GetProjectTaskFollowUpList({
        this.res,
        this.model,
        this.msg,
    });

    factory GetProjectTaskFollowUpList.fromJson(Map<String, dynamic> json) => GetProjectTaskFollowUpList(
        res: json["res"],
        model: json["model"] == null ? [] : List<GetProjectTaskFollowUpModel>.from(json["model"]!.map((x) => GetProjectTaskFollowUpModel.fromJson(x))),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "model": model == null ? [] : List<dynamic>.from(model!.map((x) => x.toJson())),
        "msg": msg,
    };
}

class GetProjectTaskFollowUpModel {
    String? taskCode;
    String? description;
    String? jobCode;
    String? job;
    String? taskGroup;
    dynamic startDate;
    dynamic endDate;
    dynamic actStartDate;
    dynamic actEndDate;
    String? assignedTo;
    dynamic requestedBy;
    String? priorityId;
    String? priority;
    int? completed;
    String? status;
    String? createdBy;

    GetProjectTaskFollowUpModel({
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
        this.priorityId,
        this.priority,
        this.completed,
        this.status,
        this.createdBy,
    });

    factory GetProjectTaskFollowUpModel.fromJson(Map<String, dynamic> json) => GetProjectTaskFollowUpModel(
        taskCode: json["Task Code"],
        description: json["Description"],
        jobCode: json["Job Code"],
        job: json["Job"],
        taskGroup: json["Task Group"],
        startDate: json["Start Date"],
        endDate: json["End Date"],
        actStartDate: json["Act Start Date"],
        actEndDate: json["Act End Date"],
        assignedTo: json["Assigned To"],
        requestedBy: json["Requested By"],
        priorityId: json["PriorityID"],
        priority: json["Priority"],
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
        "Start Date": startDate,
        "End Date": endDate,
        "Act Start Date": actStartDate,
        "Act End Date": actEndDate,
        "Assigned To": assignedTo,
        "Requested By": requestedBy,
        "PriorityID": priorityId,
        "Priority": priority,
        "Completed %": completed,
        "Status": status,
        "CreatedBy": createdBy,
    };
}
