import 'dart:convert';

CreateSalesOrderDetailModel createSalesOrderDetailModelFromJson(String str) => CreateSalesOrderDetailModel.fromJson(json.decode(str));

String createSalesOrderDetailModelToJson(CreateSalesOrderDetailModel data) => json.encode(data.toJson());

class CreateSalesOrderDetailModel {
    CreateSalesOrderDetailModel({
        this.itemcode,
        this.description,
        this.quantity,
        this.remarks,
        this.rowindex,
        this.unitid,
        this.specificationid,
        this.styleid,
        this.equipmentid,
        this.itemtype,
        this.locationid,
        this.jobid,
        this.costcategoryid,
        this.sourcesysdocid,
        this.sourcevoucherid,
        this.sourcerowindex,
        this.unitprice,
        this.cost,
        this.amount,
        this.taxoption,
        this.taxamount,
        this.taxgroupid,
    });

    String? itemcode;
    String? description;
    dynamic quantity;
    String? remarks;
    dynamic rowindex;
    String? unitid;
    String? specificationid;
    String? styleid;
    String? equipmentid;
    dynamic itemtype;
    String? locationid;
    String? jobid;
    String? costcategoryid;
    String? sourcesysdocid;
    String? sourcevoucherid;
    String? sourcerowindex;
    dynamic unitprice;
    dynamic cost;
    dynamic amount;
    dynamic taxoption;
    dynamic taxamount;
    String? taxgroupid;

    factory CreateSalesOrderDetailModel.fromJson(Map<String, dynamic> json) => CreateSalesOrderDetailModel(
        itemcode: json["Itemcode"],
        description: json["Description"],
        quantity: json["Quantity"],
        remarks: json["Remarks"],
        rowindex: json["Rowindex"],
        unitid: json["Unitid"],
        specificationid: json["Specificationid"],
        styleid: json["Styleid"],
        equipmentid: json["Equipmentid"],
        itemtype: json["Itemtype"],
        locationid: json["Locationid"],
        jobid: json["Jobid"],
        costcategoryid: json["Costcategoryid"],
        sourcesysdocid: json["Sourcesysdocid"],
        sourcevoucherid: json["Sourcevoucherid"],
        sourcerowindex: json["Sourcerowindex"],
        unitprice: json["Unitprice"],
        cost: json["Cost"],
        amount: json["Amount"],
        taxoption: json["Taxoption"],
        taxamount: json["Taxamount"],
        taxgroupid: json["Taxgroupid"],
    );

    Map<String, dynamic> toJson() => {
        "Itemcode": itemcode,
        "Description": description,
        "Quantity": quantity,
        "Remarks": remarks,
        "Rowindex": rowindex,
        "Unitid": unitid,
        "Specificationid": specificationid,
        "Styleid": styleid,
        "Equipmentid": equipmentid,
        "Itemtype": itemtype,
        "Locationid": locationid,
        "Jobid": jobid,
        "Costcategoryid": costcategoryid,
        "Sourcesysdocid": sourcesysdocid,
        "Sourcevoucherid": sourcevoucherid,
        "Sourcerowindex": sourcerowindex,
        "Unitprice": unitprice,
        "Cost": cost,
        "Amount": amount,
        "Taxoption": taxoption,
        "Taxamount": taxamount,
        "Taxgroupid": taxgroupid,
    };
}
