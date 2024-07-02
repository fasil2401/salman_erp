import 'dart:convert';

SalesOrderByIdModel salesOrderByIdModelFromJson(String str) =>
    SalesOrderByIdModel.fromJson(json.decode(str));

String salesOrderByIdModelToJson(SalesOrderByIdModel data) =>
    json.encode(data.toJson());

class SalesOrderByIdModel {
  SalesOrderByIdModel({
    required this.result,
    required this.header,
    required this.detail,
    required this.taxDetail,
  });

  int result;
  List<Header> header;
  List<Detail> detail;
  List<TaxDetail> taxDetail;

  factory SalesOrderByIdModel.fromJson(Map<String, dynamic> json) =>
      SalesOrderByIdModel(
        result: json["result"],
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
        detail:
            List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
        taxDetail: List<TaxDetail>.from(
            json["TaxDetail"].map((x) => TaxDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Header": List<dynamic>.from(header.map((x) => x.toJson())),
        "Detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "TaxDetail": List<dynamic>.from(taxDetail.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.sysDocId,
    this.voucherId,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.description,
    this.remarks,
    this.locationId,
    this.unitId,
    this.unitQuantity,
    this.unitFactor,
    this.factorType,
    this.subunitPrice,
    this.itemType,
    this.rowIndex,
    this.jobId,
    this.costCategoryId,
    this.sourceVoucherId,
    this.sourceSysDocId,
    this.sourceRowIndex,
    this.sourceDocType,
    this.taxOption,
    this.taxGroupId,
    this.taxPercentage,
    this.taxAmount,
    this.cost,
    this.discount,
    this.specificationId,
    this.styleId,
    this.equipmentId,
    this.isNonEdit,
    this.externalSource,
    this.externalId,
    this.refSlNo,
    this.refText1,
    this.refText2,
    this.refNum1,
    this.refNum2,
    this.refDate1,
    this.refDate2,
    this.quantityShipped,
    this.refText3,
    this.refText4,
    this.refText5,
    this.description1,
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.matrixParentId,
    this.isTrackSerial,
    this.isTrackLot,
    this.taxGroupId1,
    this.pkSysDocId,
    this.pkVoucherId,
    this.shipped,
    this.discount1,
    this.fixedTaxAmount,
  });

  String? sysDocId;
  String? voucherId;
  String? productId;
  dynamic quantity;
  dynamic unitPrice;
  String? description;
  String? remarks;
  dynamic locationId;
  String? unitId;
  dynamic unitQuantity;
  dynamic unitFactor;
  dynamic factorType;
  dynamic subunitPrice;
  int? itemType;
  int? rowIndex;
  dynamic jobId;
  dynamic costCategoryId;
  dynamic sourceVoucherId;
  dynamic sourceSysDocId;
  int? sourceRowIndex;
  dynamic sourceDocType;
  dynamic taxOption;
  dynamic taxGroupId;
  dynamic taxPercentage;
  dynamic taxAmount;
  dynamic cost;
  dynamic discount;
  dynamic specificationId;
  dynamic styleId;
  dynamic equipmentId;
  bool? isNonEdit;
  dynamic externalSource;
  dynamic externalId;
  dynamic refSlNo;
  dynamic refText1;
  dynamic refText2;
  dynamic refNum1;
  dynamic refNum2;
  dynamic refDate1;
  dynamic refDate2;
  dynamic quantityShipped;
  dynamic refText3;
  dynamic refText4;
  dynamic refText5;
  String? description1;
  dynamic attribute1;
  dynamic attribute2;
  dynamic attribute3;
  dynamic matrixParentId;
  bool? isTrackSerial;
  bool? isTrackLot;
  String? taxGroupId1;
  dynamic pkSysDocId;
  dynamic pkVoucherId;
  dynamic shipped;
  dynamic discount1;
  dynamic fixedTaxAmount;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        productId: json["ProductID"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"].toDouble(),
        description: json["Description"],
        remarks: json["Remarks"],
        locationId: json["LocationID"],
        unitId: json["UnitID"],
        unitQuantity: json["UnitQuantity"],
        unitFactor: json["UnitFactor"],
        factorType: json["FactorType"],
        subunitPrice: json["SubunitPrice"],
        itemType: json["ItemType"],
        rowIndex: json["RowIndex"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        sourceVoucherId: json["SourceVoucherID"],
        sourceSysDocId: json["SourceSysDocID"],
        sourceRowIndex: json["SourceRowIndex"],
        sourceDocType: json["SourceDocType"],
        taxOption: json["TaxOption"],
        taxGroupId: json["TaxGroupID"],
        taxPercentage: json["TaxPercentage"],
        taxAmount: json["TaxAmount"],
        cost: json["Cost"],
        discount: json["Discount"],
        specificationId: json["SpecificationID"],
        styleId: json["StyleID"],
        equipmentId: json["EquipmentID"],
        isNonEdit: json["IsNonEdit"],
        externalSource: json["ExternalSource"],
        externalId: json["ExternalID"],
        refSlNo: json["RefSlNo"],
        refText1: json["RefText1"],
        refText2: json["RefText2"],
        refNum1: json["RefNum1"],
        refNum2: json["RefNum2"],
        refDate1: json["RefDate1"],
        refDate2: json["RefDate2"],
        quantityShipped: json["QuantityShipped"],
        refText3: json["RefText3"],
        refText4: json["RefText4"],
        refText5: json["RefText5"],
        description1: json["Description1"],
        attribute1: json["Attribute1"],
        attribute2: json["Attribute2"],
        attribute3: json["Attribute3"],
        matrixParentId: json["MatrixParentID"],
        isTrackSerial: json["IsTrackSerial"],
        isTrackLot: json["IsTrackLot"],
        taxGroupId1: json["TaxGroupID1"],
        pkSysDocId: json["PKSysDocID"],
        pkVoucherId: json["PKVoucherID"],
        shipped: json["Shipped"],
        discount1: json["Discount1"],
        fixedTaxAmount: json["FixedTaxAmount"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ProductID": productId,
        "Quantity": quantity,
        "UnitPrice": unitPrice,
        "Description": description,
        "Remarks": remarks,
        "LocationID": locationId,
        "UnitID": unitId,
        "UnitQuantity": unitQuantity,
        "UnitFactor": unitFactor,
        "FactorType": factorType,
        "SubunitPrice": subunitPrice,
        "ItemType": itemType,
        "RowIndex": rowIndex,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "SourceVoucherID": sourceVoucherId,
        "SourceSysDocID": sourceSysDocId,
        "SourceRowIndex": sourceRowIndex,
        "SourceDocType": sourceDocType,
        "TaxOption": taxOption,
        "TaxGroupID": taxGroupId,
        "TaxPercentage": taxPercentage,
        "TaxAmount": taxAmount,
        "Cost": cost,
        "Discount": discount,
        "SpecificationID": specificationId,
        "StyleID": styleId,
        "EquipmentID": equipmentId,
        "IsNonEdit": isNonEdit,
        "ExternalSource": externalSource,
        "ExternalID": externalId,
        "RefSlNo": refSlNo,
        "RefText1": refText1,
        "RefText2": refText2,
        "RefNum1": refNum1,
        "RefNum2": refNum2,
        "RefDate1": refDate1,
        "RefDate2": refDate2,
        "QuantityShipped": quantityShipped,
        "RefText3": refText3,
        "RefText4": refText4,
        "RefText5": refText5,
        "Description1": description1,
        "Attribute1": attribute1,
        "Attribute2": attribute2,
        "Attribute3": attribute3,
        "MatrixParentID": matrixParentId,
        "IsTrackSerial": isTrackSerial,
        "IsTrackLot": isTrackLot,
        "TaxGroupID1": taxGroupId1,
        "PKSysDocID": pkSysDocId,
        "PKVoucherID": pkVoucherId,
        "Shipped": shipped,
        "Discount1": discount1,
        "FixedTaxAmount": fixedTaxAmount,
      };
}

class Header {
  Header({
    this.sysDocId,
    this.voucherId,
    this.companyId,
    this.divisionId,
    this.customerId,
    this.transactionDate,
    this.salespersonId,
    this.salesFlow,
    this.isExport,
    this.requiredDate,
    this.dueDate,
    this.expDeliveryDate,
    this.shippingAddressId,
    this.billingAddressId,
    this.shipToAddress,
    this.customerAddress,
    this.priceIncludeTax,
    this.status,
    this.currencyId,
    this.currencyRate,
    this.currencyName,
    this.termId,
    this.shippingMethodId,
    this.reference,
    this.reference2,
    this.note,
    this.poNumber,
    this.isVoid,
    this.discount,
    this.total,
    this.taxAmount,
    this.sourceDocType,
    this.jobId,
    this.costCategoryId,
    this.payeeTaxGroupId,
    this.taxOption,
    this.roundOff,
    this.allowSoEdit,
    this.externalSource,
    this.externalId,
    this.orderType,
    this.approvalStatus,
    this.verificationStatus,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  String? sysDocId;
  String? voucherId;
  String? companyId;
  String? divisionId;
  String? customerId;
  DateTime? transactionDate;
  String? salespersonId;
  int? salesFlow;
  dynamic isExport;
  dynamic requiredDate;
  DateTime? dueDate;
  DateTime? expDeliveryDate;
  String? shippingAddressId;
  String? billingAddressId;
  String? shipToAddress;
  String? customerAddress;
  bool? priceIncludeTax;
  int? status;
  String? currencyId;
  dynamic currencyRate;
  dynamic currencyName;
  String? termId;
  String? shippingMethodId;
  String? reference;
  String? reference2;
  String? note;
  String? poNumber;
  dynamic isVoid;
  dynamic discount;
  dynamic total;
  dynamic taxAmount;
  int? sourceDocType;
  String? jobId;
  String? costCategoryId;
  String? payeeTaxGroupId;
  dynamic taxOption;
  dynamic roundOff;
  bool? allowSoEdit;
  dynamic externalSource;
  dynamic externalId;
  dynamic orderType;
  int? approvalStatus;
  dynamic verificationStatus;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        companyId: json["CompanyID"],
        divisionId: json["DivisionID"],
        customerId: json["CustomerID"],
        transactionDate: json["TransactionDate"] == null ? null : DateTime.parse(json["TransactionDate"]),
        salespersonId: json["SalespersonID"],
        salesFlow: json["SalesFlow"],
        isExport: json["IsExport"],
        requiredDate: json["RequiredDate"],
        dueDate: json["DueDate"] == null ? null : DateTime.parse(json["DueDate"]),
        expDeliveryDate:json["ExpDeliveryDate"] == null ? null : DateTime.parse(json["ExpDeliveryDate"]),
        shippingAddressId: json["ShippingAddressID"],
        billingAddressId: json["BillingAddressID"],
        shipToAddress: json["ShipToAddress"],
        customerAddress: json["CustomerAddress"],
        priceIncludeTax: json["PriceIncludeTax"],
        status: json["Status"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        currencyName: json["CurrencyName"],
        termId: json["TermID"],
        shippingMethodId: json["ShippingMethodID"],
        reference: json["Reference"],
        reference2: json["Reference2"],
        note: json["Note"],
        poNumber: json["PONumber"],
        isVoid: json["IsVoid"],
        discount: json["Discount"],
        total: json["Total"].toDouble(),
        taxAmount: json["TaxAmount"],
        sourceDocType: json["SourceDocType"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        payeeTaxGroupId: json["PayeeTaxGroupID"],
        taxOption: json["TaxOption"],
        roundOff: json["RoundOff"],
        allowSoEdit: json["AllowSOEdit"],
        externalSource: json["ExternalSource"],
        externalId: json["ExternalID"],
        orderType: json["OrderType"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: json["DateCreated"] == null ? null : DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "CompanyID": companyId,
        "DivisionID": divisionId,
        "CustomerID": customerId,
        "TransactionDate":
            transactionDate == null ? null : transactionDate!.toIso8601String(),
        "SalespersonID": salespersonId,
        "SalesFlow": salesFlow,
        "IsExport": isExport,
        "RequiredDate": requiredDate,
        "DueDate": dueDate == null ? null : dueDate!.toIso8601String(),
        "ExpDeliveryDate":
            expDeliveryDate == null ? null : expDeliveryDate!.toIso8601String(),
        "ShippingAddressID": shippingAddressId,
        "BillingAddressID": billingAddressId,
        "ShipToAddress": shipToAddress,
        "CustomerAddress": customerAddress,
        "PriceIncludeTax": priceIncludeTax,
        "Status": status,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "CurrencyName": currencyName,
        "TermID": termId,
        "ShippingMethodID": shippingMethodId,
        "Reference": reference,
        "Reference2": reference2,
        "Note": note,
        "PONumber": poNumber,
        "IsVoid": isVoid,
        "Discount": discount,
        "Total": total,
        "TaxAmount": taxAmount,
        "SourceDocType": sourceDocType,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "PayeeTaxGroupID": payeeTaxGroupId,
        "TaxOption": taxOption,
        "RoundOff": roundOff,
        "AllowSOEdit": allowSoEdit,
        "ExternalSource": externalSource,
        "ExternalID": externalId,
        "OrderType": orderType,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated":
            dateCreated == null ? null : dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}

class TaxDetail {
  TaxDetail({
    this.sysDocId,
    this.voucherId,
    this.taxLevel,
    this.taxGroupId,
    this.calculationMethod,
    this.taxItemName,
    this.taxItemId,
    this.taxRate,
    this.taxAmount,
    this.currencyId,
    this.currencyRate,
    this.orderIndex,
    this.rowIndex,
    this.accountId,
  });

  String? sysDocId;
  String? voucherId;
  dynamic taxLevel;
  String? taxGroupId;
  String? calculationMethod;
  String? taxItemName;
  String? taxItemId;
  dynamic taxRate;
  dynamic taxAmount;
  String? currencyId;
  dynamic currencyRate;
  dynamic orderIndex;
  dynamic rowIndex;
  String? accountId;

  factory TaxDetail.fromJson(Map<String, dynamic> json) => TaxDetail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        taxLevel: json["TaxLevel"],
        taxGroupId: json["TaxGroupID"],
        calculationMethod: json["CalculationMethod"],
        taxItemName: json["TaxItemName"],
        taxItemId: json["TaxItemID"],
        taxRate: json["TaxRate"],
        taxAmount: json["TaxAmount"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        orderIndex: json["OrderIndex"],
        rowIndex: json["RowIndex"],
        accountId: json["AccountID"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "TaxLevel": taxLevel,
        "TaxGroupID": taxGroupId,
        "CalculationMethod": calculationMethod,
        "TaxItemName": taxItemName,
        "TaxItemID": taxItemId,
        "TaxRate": taxRate,
        "TaxAmount": taxAmount,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "OrderIndex": orderIndex,
        "RowIndex": rowIndex,
        "AccountID": accountId,
      };
}
