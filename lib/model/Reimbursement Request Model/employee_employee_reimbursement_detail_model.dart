class EmployeeEmployeeReimbursementDetailModel {
  int? rowIndex;
  String? reimburseItemId;
  String? reimburseItemName;
  String? refDate;
  double? amount;
  String? des;

  EmployeeEmployeeReimbursementDetailModel({
    this.rowIndex,
    this.reimburseItemId,
    this.reimburseItemName,
    this.refDate,
    this.amount,
    this.des,
  });

  factory EmployeeEmployeeReimbursementDetailModel.fromJson(
          Map<String, dynamic> json) =>
      EmployeeEmployeeReimbursementDetailModel(
        rowIndex: json["RowIndex"],
        reimburseItemId: json["ReimburseItemID"],
        refDate: json["RefDate"],
        amount: json["Amount"],
        des: json["Remarks"],
      );

  Map<String, dynamic> toJson() => {
        "RowIndex": rowIndex,
        "ReimburseItemID": reimburseItemId,
        "RefDate": refDate,
        "Amount": amount,
        "Remarks": des,
      };
}
