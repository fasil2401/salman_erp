import 'dart:convert';

class DateFilterModel {
  DateFilterModel({
    required this.label,
    required this.value,
  });
  String label;
  int value;
}

class DateModel {
  DateModel({
    required this.startDate,
    required this.endDate,
  });
  DateTime startDate;
  DateTime endDate;
}

AllDateModel allDateModelFromJson(String str) => AllDateModel.fromJson(json.decode(str));

String allDateModelToJson(AllDateModel data) => json.encode(data.toJson());

class AllDateModel {
    AllDateModel({
        this.result,
        this.modelobject,
        required this.startDate,
       required this.endDate,
    });

    int? result;
    String? modelobject;
    DateTime startDate;
    DateTime endDate;

    factory AllDateModel.fromJson(Map<String, dynamic> json) => AllDateModel(
        result: json["result"],
        modelobject: json["Modelobject"],
        startDate: DateTime.parse(json["StartDate"]),
        endDate: DateTime.parse(json["EndDate"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
    };
}
