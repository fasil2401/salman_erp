// To parse this JSON data, do
//
//     final getMercahndiseByIdModel = getMercahndiseByIdModelFromJson(jsonString);

import 'dart:convert';

GetMercahndiseByIdModel getMercahndiseByIdModelFromJson(String str) =>
    GetMercahndiseByIdModel.fromJson(json.decode(str));

String getMercahndiseByIdModelToJson(GetMercahndiseByIdModel data) =>
    json.encode(data.toJson());

class GetMercahndiseByIdModel {
  int? result;
  List<Header>? header;
  List<Detail>? detail;

  GetMercahndiseByIdModel({
    this.result,
    this.header,
    this.detail,
  });

  factory GetMercahndiseByIdModel.fromJson(Map<String, dynamic> json) =>
      GetMercahndiseByIdModel(
        result: json["result"],
        header: json["Header"] == null
            ? []
            : List<Header>.from(json["Header"]!.map((x) => Header.fromJson(x))),
        detail: json["Detail"] == null
            ? []
            : List<Detail>.from(json["Detail"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Header": header == null
            ? []
            : List<dynamic>.from(header!.map((x) => x.toJson())),
        "Detail": detail == null
            ? []
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class Detail {
  String? sysDocId;
  String? voucherId;
  String? productId;
  dynamic quantity;
  dynamic unitPrice;
  String? description;
  String? unitId;
  dynamic unitQuantity;
  dynamic unitFactor;
  dynamic factorType;
  String? locationId;
  dynamic sourceVoucherId;
  dynamic sourceSysDocId;
  dynamic sourceRowIndex;
  dynamic subunitPrice;
  dynamic rowIndex;
  dynamic rowSource;
  dynamic jobId;
  dynamic costCategoryId;
  dynamic refSlNo;
  dynamic refText1;
  dynamic refText2;
  dynamic refText3;
  dynamic refText4;
  dynamic refText5;
  dynamic refNum1;
  dynamic refNum2;
  dynamic refDate1;
  dynamic refDate2;
  String? remarks;
  dynamic taxPercentage;
  dynamic taxAmount;
  DateTime? expiryDate;
  String? itemCode;
  dynamic quantityReturned;
  dynamic quantityShipped;
  dynamic taxOption;
  dynamic taxGroupId;

  Detail({
    this.sysDocId,
    this.voucherId,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.description,
    this.unitId,
    this.unitQuantity,
    this.unitFactor,
    this.factorType,
    this.locationId,
    this.sourceVoucherId,
    this.sourceSysDocId,
    this.sourceRowIndex,
    this.subunitPrice,
    this.rowIndex,
    this.rowSource,
    this.jobId,
    this.costCategoryId,
    this.refSlNo,
    this.refText1,
    this.refText2,
    this.refText3,
    this.refText4,
    this.refText5,
    this.refNum1,
    this.refNum2,
    this.refDate1,
    this.refDate2,
    this.remarks,
    this.taxPercentage,
    this.taxAmount,
    this.expiryDate,
    this.itemCode,
    this.quantityReturned,
    this.quantityShipped,
    this.taxOption,
    this.taxGroupId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        productId: json["ProductID"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"],
        description: json["Description"],
        unitId: json["UnitID"],
        unitQuantity: json["UnitQuantity"],
        unitFactor: json["UnitFactor"],
        factorType: json["FactorType"],
        locationId: json["LocationID"],
        sourceVoucherId: json["SourceVoucherID"],
        sourceSysDocId: json["SourceSysDocID"],
        sourceRowIndex: json["SourceRowIndex"],
        subunitPrice: json["SubunitPrice"],
        rowIndex: json["RowIndex"],
        rowSource: json["RowSource"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        refSlNo: json["RefSlNo"],
        refText1: json["RefText1"],
        refText2: json["RefText2"],
        refText3: json["RefText3"],
        refText4: json["RefText4"],
        refText5: json["RefText5"],
        refNum1: json["RefNum1"],
        refNum2: json["RefNum2"],
        refDate1: json["RefDate1"],
        refDate2: json["RefDate2"],
        remarks: json["Remarks"],
        taxPercentage: json["TaxPercentage"],
        taxAmount: json["TaxAmount"],
        expiryDate: json["ExpiryDate"] == null
            ? null
            : DateTime.parse(json["ExpiryDate"]),
        itemCode: json["Item Code"],
        quantityReturned: json["QuantityReturned"],
        quantityShipped: json["QuantityShipped"],
        taxOption: json["TaxOption"],
        taxGroupId: json["TaxGroupID"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ProductID": productId,
        "Quantity": quantity,
        "UnitPrice": unitPrice,
        "Description": description,
        "UnitID": unitId,
        "UnitQuantity": unitQuantity,
        "UnitFactor": unitFactor,
        "FactorType": factorType,
        "LocationID": locationId,
        "SourceVoucherID": sourceVoucherId,
        "SourceSysDocID": sourceSysDocId,
        "SourceRowIndex": sourceRowIndex,
        "SubunitPrice": subunitPrice,
        "RowIndex": rowIndex,
        "RowSource": rowSource,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "RefSlNo": refSlNo,
        "RefText1": refText1,
        "RefText2": refText2,
        "RefText3": refText3,
        "RefText4": refText4,
        "RefText5": refText5,
        "RefNum1": refNum1,
        "RefNum2": refNum2,
        "RefDate1": refDate1,
        "RefDate2": refDate2,
        "Remarks": remarks,
        "TaxPercentage": taxPercentage,
        "TaxAmount": taxAmount,
        "ExpiryDate": expiryDate?.toIso8601String(),
        "Item Code": itemCode,
        "QuantityReturned": quantityReturned,
        "QuantityShipped": quantityShipped,
        "TaxOption": taxOption,
        "TaxGroupID": taxGroupId,
      };
}

class Header {
  String? sysDocId;
  String? voucherId;
  String? partyId;
  String? partyType;
  dynamic sysDocType;
  DateTime? transactionDate;
  String? salespersonId;
  dynamic salesFlow;
  dynamic requiredDate;
  dynamic isExport;
  dynamic shippingAddressId;
  dynamic customerAddress;
  dynamic billingAddressId;
  dynamic shipToAddress;
  dynamic status;
  String? currencyId;
  dynamic termId;
  dynamic shippingMethodId;
  String? reference;
  dynamic clUserId;
  dynamic port;
  String? reference2;
  dynamic reference3;
  String? note;
  dynamic isVoid;
  dynamic discount;
  dynamic total;
  dynamic roundoff;
  dynamic sourceDocType;
  String? driverId;
  String? vehicleId;
  String? containerNumber;
  dynamic containerSizeId;
  dynamic jobId;
  dynamic costCategoryId;
  String? locationId;
  dynamic currencyRate;
  String? address;
  String? phone;
  dynamic isCompleted;
  String? toLocationId;
  String? vehicleNo;
  dynamic transactionType;
  dynamic isInvoiced;
  dynamic isShipped;
  dynamic invoiceSysDocId;
  dynamic invoiceVoucherId;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? createdBy;
  String? updatedBy;

  Header({
    this.sysDocId,
    this.voucherId,
    this.partyId,
    this.partyType,
    this.sysDocType,
    this.transactionDate,
    this.salespersonId,
    this.salesFlow,
    this.requiredDate,
    this.isExport,
    this.shippingAddressId,
    this.customerAddress,
    this.billingAddressId,
    this.shipToAddress,
    this.status,
    this.currencyId,
    this.termId,
    this.shippingMethodId,
    this.reference,
    this.clUserId,
    this.port,
    this.reference2,
    this.reference3,
    this.note,
    this.isVoid,
    this.discount,
    this.total,
    this.roundoff,
    this.sourceDocType,
    this.driverId,
    this.vehicleId,
    this.containerNumber,
    this.containerSizeId,
    this.jobId,
    this.costCategoryId,
    this.locationId,
    this.currencyRate,
    this.address,
    this.phone,
    this.isCompleted,
    this.toLocationId,
    this.vehicleNo,
    this.transactionType,
    this.isInvoiced,
    this.isShipped,
    this.invoiceSysDocId,
    this.invoiceVoucherId,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        partyId: json["PartyID"],
        partyType: json["PartyType"],
        sysDocType: json["SysDocType"],
        transactionDate: json["TransactionDate"] == null
            ? null
            : DateTime.parse(json["TransactionDate"]),
        salespersonId: json["SalespersonID"],
        salesFlow: json["SalesFlow"],
        requiredDate: json["RequiredDate"],
        isExport: json["IsExport"],
        shippingAddressId: json["ShippingAddressID"],
        customerAddress: json["CustomerAddress"],
        billingAddressId: json["BillingAddressID"],
        shipToAddress: json["ShipToAddress"],
        status: json["Status"],
        currencyId: json["CurrencyID"],
        termId: json["TermID"],
        shippingMethodId: json["ShippingMethodID"],
        reference: json["Reference"],
        clUserId: json["CLUserID"],
        port: json["Port"],
        reference2: json["Reference2"],
        reference3: json["Reference3"],
        note: json["Note"],
        isVoid: json["IsVoid"],
        discount: json["Discount"],
        total: json["Total"],
        roundoff: json["Roundoff"],
        sourceDocType: json["SourceDocType"],
        driverId: json["DriverID"],
        vehicleId: json["VehicleID"],
        containerNumber: json["ContainerNumber"],
        containerSizeId: json["ContainerSizeID"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        locationId: json["LocationID"],
        currencyRate: json["CurrencyRate"],
        address: json["Address"],
        phone: json["Phone"],
        isCompleted: json["IsCompleted"],
        toLocationId: json["ToLocationID"],
        vehicleNo: json["VehicleNo"],
        transactionType: json["TransactionType"],
        isInvoiced: json["IsInvoiced"],
        isShipped: json["IsShipped"],
        invoiceSysDocId: json["InvoiceSysDocID"],
        invoiceVoucherId: json["InvoiceVoucherID"],
        dateCreated: json["DateCreated"] == null
            ? null
            : DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"] == null
            ? null
            : DateTime.parse(json["DateUpdated"]),
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "PartyID": partyId,
        "PartyType": partyType,
        "SysDocType": sysDocType,
        "TransactionDate": transactionDate?.toIso8601String(),
        "SalespersonID": salespersonId,
        "SalesFlow": salesFlow,
        "RequiredDate": requiredDate,
        "IsExport": isExport,
        "ShippingAddressID": shippingAddressId,
        "CustomerAddress": customerAddress,
        "BillingAddressID": billingAddressId,
        "ShipToAddress": shipToAddress,
        "Status": status,
        "CurrencyID": currencyId,
        "TermID": termId,
        "ShippingMethodID": shippingMethodId,
        "Reference": reference,
        "CLUserID": clUserId,
        "Port": port,
        "Reference2": reference2,
        "Reference3": reference3,
        "Note": note,
        "IsVoid": isVoid,
        "Discount": discount,
        "Total": total,
        "Roundoff": roundoff,
        "SourceDocType": sourceDocType,
        "DriverID": driverId,
        "VehicleID": vehicleId,
        "ContainerNumber": containerNumber,
        "ContainerSizeID": containerSizeId,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "LocationID": locationId,
        "CurrencyRate": currencyRate,
        "Address": address,
        "Phone": phone,
        "IsCompleted": isCompleted,
        "ToLocationID": toLocationId,
        "VehicleNo": vehicleNo,
        "TransactionType": transactionType,
        "IsInvoiced": isInvoiced,
        "IsShipped": isShipped,
        "InvoiceSysDocID": invoiceSysDocId,
        "InvoiceVoucherID": invoiceVoucherId,
        "DateCreated": dateCreated?.toIso8601String(),
        "DateUpdated": dateUpdated?.toIso8601String(),
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}
