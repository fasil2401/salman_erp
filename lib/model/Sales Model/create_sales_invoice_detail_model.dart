// To parse this JSON data, do
//
//     final createSalesInvoiceDetailModel = createSalesInvoiceDetailModelFromJson(jsonString);

import 'dart:convert';

CreateSalesInvoiceDetailModel createSalesInvoiceDetailModelFromJson(
        String str) =>
    CreateSalesInvoiceDetailModel.fromJson(json.decode(str));

String createSalesInvoiceDetailModelToJson(
        CreateSalesInvoiceDetailModel data) =>
    json.encode(data.toJson());

class CreateSalesInvoiceDetailModel {
  String? itemcode;
  String? description;
  dynamic quantity;
  dynamic focQuantity;
  String? refProductId;
  String? remarks;
  int? rowindex;
  String? unitid;
  String? specificationid;
  String? styleid;
  int? itemtype;
  String? locationid;
  String? jobid;
  String? costcategoryid;
  String? ordersdocid;
  String? ordervoucherid;
  int? orderrowindex;
  dynamic unitprice;
  dynamic cost;
  dynamic amount;
  int? taxoption;
  dynamic taxamount;
  String? taxgroupid;
  dynamic discount;
  int? rowSource;

  CreateSalesInvoiceDetailModel({
    this.itemcode,
    this.description,
    this.quantity,
    this.focQuantity,
    this.refProductId,
    this.remarks,
    this.rowindex,
    this.unitid,
    this.specificationid,
    this.styleid,
    this.itemtype,
    this.locationid,
    this.jobid,
    this.costcategoryid,
    this.ordersdocid,
    this.ordervoucherid,
    this.orderrowindex,
    this.unitprice,
    this.cost,
    this.amount,
    this.taxoption,
    this.taxamount,
    this.taxgroupid,
    this.discount,
    this.rowSource,
  });

  factory CreateSalesInvoiceDetailModel.fromJson(Map<String, dynamic> json) =>
      CreateSalesInvoiceDetailModel(
        itemcode: json["Itemcode"],
        description: json["Description"],
        quantity: json["Quantity"],
        focQuantity: json["FocQuantity"],
        refProductId: json["RefProductID"],
        remarks: json["Remarks"],
        rowindex: json["Rowindex"],
        unitid: json["Unitid"],
        specificationid: json["Specificationid"],
        styleid: json["Styleid"],
        itemtype: json["Itemtype"],
        locationid: json["Locationid"],
        jobid: json["Jobid"],
        costcategoryid: json["Costcategoryid"],
        ordersdocid: json["Ordersdocid"],
        ordervoucherid: json["Ordervoucherid"],
        orderrowindex: json["Orderrowindex"],
        unitprice: json["Unitprice"],
        cost: json["Cost"],
        amount: json["Amount"],
        taxoption: json["Taxoption"],
        taxamount: json["Taxamount"],
        taxgroupid: json["Taxgroupid"],
        discount: json["Discount"],
        rowSource: json["RowSource"],
      );

  Map<String, dynamic> toJson() => {
        "Itemcode": itemcode,
        "Description": description,
        "Quantity": quantity,
        "FocQuantity": focQuantity,
        "RefProductID": refProductId,
        "Remarks": remarks,
        "Rowindex": rowindex,
        "Unitid": unitid,
        "Specificationid": specificationid,
        "Styleid": styleid,
        "Itemtype": itemtype,
        "Locationid": locationid,
        "Jobid": jobid,
        "Costcategoryid": costcategoryid,
        "Ordersdocid": ordersdocid,
        "Ordervoucherid": ordervoucherid,
        "Orderrowindex": orderrowindex,
        "Unitprice": unitprice,
        "Cost": cost,
        "Amount": amount,
        "Taxoption": taxoption,
        "Taxamount": taxamount,
        "Taxgroupid": taxgroupid,
        "Discount": discount,
        "RowSource": rowSource,
      };
}
