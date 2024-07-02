import 'dart:convert';

SalesOrderPrintModel salesOrderPrintModelFromJson(String str) =>
    SalesOrderPrintModel.fromJson(json.decode(str));

String salesOrderPrintModelToJson(SalesOrderPrintModel data) =>
    json.encode(data.toJson());

class SalesOrderPrintModel {
  SalesOrderPrintModel({
    this.result,
    this.header,
    this.detail,
  });

  int? result;
  List<Header>? header;
  List<Detail>? detail;

  factory SalesOrderPrintModel.fromJson(Map<String, dynamic> json) =>
      SalesOrderPrintModel(
        result: json["result"],
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
        detail:
            List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Header": List<dynamic>.from(header!.map((x) => x.toJson())),
        "Detail": List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.sysDocId,
    this.voucherId,
    this.productId,
    this.description,
    this.quantity,
    this.taxAmount,
    this.taxGroupId,
    this.taxGroupName,
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.matrixParentId,
    this.photo,
    this.description2,
    this.remarks,
    this.unitPrice,
    this.equipmentId,
    this.equipment,
    this.total,
    this.unitId,
    this.jobId,
    this.jobName,
    this.costCategoryName,
    this.discount,
    this.brandName,
    this.specificationId,
    this.specificationName,
    this.origin,
    this.style,
    this.refSlNo,
    this.refText1,
    this.refText2,
    this.refNum1,
    this.refNum2,
    this.refDate1,
    this.refDate2,
    this.classId,
    this.className,
    this.categoryId,
    this.categoryName,
    this.manufacturerId,
    this.manufacturerName,
    this.upc,
    this.unitName,
    this.rowIndex,
    this.hsCode,
  });

  String? sysDocId;
  String? voucherId;
  String? productId;
  String? description;
  dynamic quantity;
  dynamic taxAmount;
  String? taxGroupId;
  String? taxGroupName;
  String? attribute1;
  String? attribute2;
  String? attribute3;
  dynamic matrixParentId;
  String? photo;
  String? description2;
  String? remarks;
  dynamic unitPrice;
  String? equipmentId;
  dynamic equipment;
  dynamic total;
  String? unitId;
  dynamic jobId;
  dynamic jobName;
  dynamic costCategoryName;
  dynamic discount;
  String? brandName;
  String? specificationId;
  dynamic specificationName;
  String? origin;
  dynamic style;
  dynamic refSlNo;
  dynamic refText1;
  dynamic refText2;
  dynamic refNum1;
  dynamic refNum2;
  dynamic refDate1;
  dynamic refDate2;
  String? classId;
  String? className;
  String? categoryId;
  String? categoryName;
  dynamic manufacturerId;
  dynamic manufacturerName;
  String? upc;
  String? unitName;
  dynamic rowIndex;
  String? hsCode;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        productId: json["ProductID"],
        description: json["Description"],
        quantity: json["Quantity"],
        taxAmount: json["TaxAmount"],
        taxGroupId: json["TaxGroupID"],
        taxGroupName: json["TaxGroupName"],
        attribute1: json["Attribute1"],
        attribute2: json["Attribute2"],
        attribute3: json["Attribute3"],
        matrixParentId: json["MatrixParentID"],
        photo: json["Photo"],
        description2: json["Description2"],
        remarks: json["Remarks"],
        unitPrice: json["UnitPrice"].toDouble(),
        equipmentId: json["EquipmentID"],
        equipment: json["Equipment"],
        total: json["Total"],
        unitId: json["UnitID"],
        jobId: json["JobID"],
        jobName: json["JobName"],
        costCategoryName: json["CostCategoryName"],
        discount: json["Discount"],
        brandName: json["BrandName"],
        specificationId: json["SpecificationID"],
        specificationName: json["SpecificationName"],
        origin: json["Origin"],
        style: json["Style"],
        refSlNo: json["RefSlNo"],
        refText1: json["RefText1"],
        refText2: json["RefText2"],
        refNum1: json["RefNum1"],
        refNum2: json["RefNum2"],
        refDate1: json["RefDate1"],
        refDate2: json["RefDate2"],
        classId: json["ClassID"],
        className: json["ClassName"],
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        manufacturerId: json["ManufacturerID"],
        manufacturerName: json["ManufacturerName"],
        upc: json["UPC"],
        unitName: json["UnitName"],
        rowIndex: json["RowIndex"],
        hsCode: json["HSCode"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ProductID": productId,
        "Description": description,
        "Quantity": quantity,
        "TaxAmount": taxAmount,
        "TaxGroupID": taxGroupId,
        "TaxGroupName": taxGroupName,
        "Attribute1": attribute1,
        "Attribute2": attribute2,
        "Attribute3": attribute3,
        "MatrixParentID": matrixParentId,
        "Photo": photo,
        "Description2": description2,
        "Remarks": remarks,
        "UnitPrice": unitPrice,
        "EquipmentID": equipmentId,
        "Equipment": equipment,
        "Total": total,
        "UnitID": unitId,
        "JobID": jobId,
        "JobName": jobName,
        "CostCategoryName": costCategoryName,
        "Discount": discount,
        "BrandName": brandName,
        "SpecificationID": specificationId,
        "SpecificationName": specificationName,
        "Origin": origin,
        "Style": style,
        "RefSlNo": refSlNo,
        "RefText1": refText1,
        "RefText2": refText2,
        "RefNum1": refNum1,
        "RefNum2": refNum2,
        "RefDate1": refDate1,
        "RefDate2": refDate2,
        "ClassID": classId,
        "ClassName": className,
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "ManufacturerID": manufacturerId,
        "ManufacturerName": manufacturerName,
        "UPC": upc,
        "UnitName": unitName,
        "RowIndex": rowIndex,
        "HSCode": hsCode,
      };
}

class Header {
  Header({
    this.sysDocId,
    this.voucherId,
    this.customerId,
    this.customerName,
    this.cTaxIdNo,
    this.customerAddress,
    this.transactionDate,
    this.contactName,
    this.approvalStatus,
    this.approvedBy,
    this.salesPersonId,
    this.fullName,
    this.spMob,
    this.spDes,
    this.requiredDate,
    this.shippingAddress,
    this.shippingMethodName,
    this.currencyId,
    this.currencyRate,
    this.createdBy,
    this.updatedBy,
    this.termId,
    this.termName,
    this.isVoid,
    this.reference,
    this.discount,
    this.grandTotal,
    this.tax,
    this.roundOff,
    this.total,
    this.poNumber,
    this.note,
    this.jobName,
    this.costCategoryName,
    this.phone1,
    this.fax,
    this.shipToAddress,
    this.quoteRemarks1,
    this.quoteRemarks2,
    this.payeeTaxGroupId,
    this.taxGroupName,
    this.shortName,
    this.createdBy1,
    this.jobNote,
    this.jobId,
    this.foreignName,
    this.expDeliveryDate,
    this.dueDate,
    this.totalInWords,
    this.totalInWordsAltLang,
  });

  String? sysDocId;
  String? voucherId;
  String? customerId;
  String? customerName;
  String? cTaxIdNo;
  String? customerAddress;
  DateTime? transactionDate;
  String? contactName;
  String? approvalStatus;
  dynamic approvedBy;
  String? salesPersonId;
  String? fullName;
  String? spMob;
  String? spDes;
  dynamic requiredDate;
  String? shippingAddress;
  String? shippingMethodName;
  String? currencyId;
  dynamic currencyRate;
  String? createdBy;
  dynamic updatedBy;
  String? termId;
  String? termName;
  dynamic isVoid;
  String? reference;
  dynamic discount;
  dynamic grandTotal;
  dynamic tax;
  dynamic roundOff;
  dynamic total;
  String? poNumber;
  String? note;
  dynamic jobName;
  dynamic costCategoryName;
  String? phone1;
  String? fax;
  String? shipToAddress;
  dynamic quoteRemarks1;
  dynamic quoteRemarks2;
  dynamic payeeTaxGroupId;
  dynamic taxGroupName;
  String? shortName;
  String? createdBy1;
  dynamic jobNote;
  dynamic jobId;
  String? foreignName;
  dynamic expDeliveryDate;
  DateTime? dueDate;
  String? totalInWords;
  String? totalInWordsAltLang;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        customerId: json["CustomerID"],
        customerName: json["CustomerName"],
        cTaxIdNo: json["CTaxIDNo"],
        customerAddress: json["CustomerAddress"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
        contactName: json["ContactName"],
        approvalStatus: json["APPROVAL STATUS"],
        approvedBy: json["Approved By"],
        salesPersonId: json["SalesPersonID"],
        fullName: json["FullName"],
        spMob: json["SP Mob"],
        spDes: json["SP Des"],
        requiredDate: json["RequiredDate"],
        shippingAddress: json["ShippingAddress"],
        shippingMethodName: json["ShippingMethodName"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        termId: json["TermID"],
        termName: json["TermName"],
        isVoid: json["IsVoid"],
        reference: json["Reference"],
        discount: json["Discount"],
        grandTotal: json["GrandTotal"],
        tax: json["Tax"],
        roundOff: json["RoundOff"],
        total: json["Total"],
        poNumber: json["PONumber"],
        note: json["Note"],
        jobName: json["JobName"],
        costCategoryName: json["CostCategoryName"],
        phone1: json["Phone1"],
        fax: json["Fax"],
        shipToAddress: json["ShipToAddress"],
        quoteRemarks1: json["QuoteRemarks1"],
        quoteRemarks2: json["QuoteRemarks2"],
        payeeTaxGroupId: json["PayeeTaxGroupID"],
        taxGroupName: json["TaxGroupName"],
        shortName: json["ShortName"],
        createdBy1: json["CreatedBy1"],
        jobNote: json["Job Note"],
        jobId: json["JobID"],
        foreignName: json["ForeignName"],
        expDeliveryDate: json["ExpDeliveryDate"],
        dueDate: DateTime.parse(json["DueDate"]),
        totalInWords: json["TotalInWords"],
        totalInWordsAltLang: json["TotalInWordsALTLang"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "CTaxIDNo": cTaxIdNo,
        "CustomerAddress": customerAddress,
        "TransactionDate":
            transactionDate == null ? null : transactionDate!.toIso8601String(),
        "ContactName": contactName,
        "APPROVAL STATUS": approvalStatus,
        "Approved By": approvedBy,
        "SalesPersonID": salesPersonId,
        "FullName": fullName,
        "SP Mob": spMob,
        "SP Des": spDes,
        "RequiredDate": requiredDate,
        "ShippingAddress": shippingAddress,
        "ShippingMethodName": shippingMethodName,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "TermID": termId,
        "TermName": termName,
        "IsVoid": isVoid,
        "Reference": reference,
        "Discount": discount,
        "GrandTotal": grandTotal,
        "Tax": tax,
        "RoundOff": roundOff,
        "Total": total,
        "PONumber": poNumber,
        "Note": note,
        "JobName": jobName,
        "CostCategoryName": costCategoryName,
        "Phone1": phone1,
        "Fax": fax,
        "ShipToAddress": shipToAddress,
        "QuoteRemarks1": quoteRemarks1,
        "QuoteRemarks2": quoteRemarks2,
        "PayeeTaxGroupID": payeeTaxGroupId,
        "TaxGroupName": taxGroupName,
        "ShortName": shortName,
        "CreatedBy1": createdBy1,
        "Job Note": jobNote,
        "JobID": jobId,
        "ForeignName": foreignName,
        "ExpDeliveryDate": expDeliveryDate,
        "DueDate": dueDate == null ? null : dueDate!.toIso8601String(),
        "TotalInWords": totalInWords,
        "TotalInWordsALTLang": totalInWordsAltLang,
      };
}
