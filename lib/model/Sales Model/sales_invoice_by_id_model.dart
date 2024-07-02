// To parse this JSON data, do
//
//     final salesInvoiceByIdModel = salesInvoiceByIdModelFromJson(jsonString?);

import 'dart:convert';

SalesInvoiceByIdModel salesInvoiceByIdModelFromJson(String str) =>
    SalesInvoiceByIdModel.fromJson(json.decode(str));

String salesInvoiceByIdModelToJson(SalesInvoiceByIdModel data) =>
    json.encode(data.toJson());

class SalesInvoiceByIdModel {
  int? result;
  List<Header>? header;
  List<Detail>? detail;
  List<TaxDetail>? taxDetail;
  List<dynamic>? salesExpenseDetail;

  SalesInvoiceByIdModel({
    this.result,
    this.header,
    this.detail,
    this.taxDetail,
    this.salesExpenseDetail,
  });

  factory SalesInvoiceByIdModel.fromJson(Map<String?, dynamic> json) =>
      SalesInvoiceByIdModel(
        result: json["result"],
        header:
            List<Header>.from(json["Header"].map((x) => Header.fromJson(x))),
        detail:
            List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
        taxDetail: List<TaxDetail>.from(
            json["TaxDetail"].map((x) => TaxDetail.fromJson(x))),
        salesExpenseDetail:
            List<dynamic>.from(json["SalesExpenseDetail"].map((x) => x)),
      );

  Map<String?, dynamic> toJson() => {
        "result": result,
        "Header": List<dynamic>.from(header?.map((x) => x.toJson()) ?? []),
        "Detail": List<dynamic>.from(detail?.map((x) => x.toJson()) ?? []),
        "TaxDetail":
            List<dynamic>.from(taxDetail?.map((x) => x.toJson()) ?? []),
        "SalesExpenseDetail":
            List<dynamic>.from(salesExpenseDetail?.map((x) => x) ?? []),
      };
}

class Detail {
  String? sysDocId;
  String? voucherId;
  String? productId;
  dynamic quantity;
  dynamic focQuantity;
  dynamic unitPrice;
  dynamic amount;
  dynamic amountFc;
  dynamic unitPriceFc;
  String? description;
  String? remarks;
  String? unitId;
  dynamic unitQuantity;
  dynamic unitFactor;
  int? taxOption;
  String? taxGroupId;
  dynamic taxPercentage;
  dynamic taxAmount;
  dynamic weightQuantity;
  dynamic weightPrice;
  dynamic factorType;
  String? locationId;
  dynamic consignmentNo;
  dynamic subunitPrice;
  dynamic discount;
  int? rowIndex;
  String? orderVoucherId;
  String? orderSysDocId;
  dynamic dNoteVoucherId;
  dynamic dNoteSysDocId;
  int? orderRowIndex;
  int? itemType;
  dynamic isDnRow;
  dynamic isRecost;
  int? rowSource;
  String? jobId;
  dynamic cost;
  String? costCategoryId;
  String? specificationId;
  String? styleId;
  dynamic listVoucherId;
  dynamic listSysDocId;
  dynamic listRowIndex;
  dynamic refSlNo;
  dynamic refText1;
  dynamic refText2;
  dynamic refNum1;
  dynamic refNum2;
  dynamic refDate1;
  dynamic refDate2;
  dynamic rewardPoints;
  String? refProductId;
  dynamic quantityReturned;
  dynamic cogs;
  dynamic quantityShipped;
  int? itRowId;
  dynamic refText3;
  dynamic refText4;
  dynamic refText5;
  String? description1;
  String? attribute1;
  String? attribute2;
  String? attribute3;
  dynamic matrixParentId;
  int? taxOption1;
  bool? isTrackLot;
  bool? isTrackSerial;
  String? brand;
  dynamic lotNumber;
  dynamic consignNumber;
  dynamic fixedTaxAmount;

  Detail({
    this.sysDocId,
    this.voucherId,
    this.productId,
    this.quantity,
    this.focQuantity,
    this.unitPrice,
    this.amount,
    this.amountFc,
    this.unitPriceFc,
    this.description,
    this.remarks,
    this.unitId,
    this.unitQuantity,
    this.unitFactor,
    this.taxOption,
    this.taxGroupId,
    this.taxPercentage,
    this.taxAmount,
    this.weightQuantity,
    this.weightPrice,
    this.factorType,
    this.locationId,
    this.consignmentNo,
    this.subunitPrice,
    this.discount,
    this.rowIndex,
    this.orderVoucherId,
    this.orderSysDocId,
    this.dNoteVoucherId,
    this.dNoteSysDocId,
    this.orderRowIndex,
    this.itemType,
    this.isDnRow,
    this.isRecost,
    this.rowSource,
    this.jobId,
    this.cost,
    this.costCategoryId,
    this.specificationId,
    this.styleId,
    this.listVoucherId,
    this.listSysDocId,
    this.listRowIndex,
    this.refSlNo,
    this.refText1,
    this.refText2,
    this.refNum1,
    this.refNum2,
    this.refDate1,
    this.refDate2,
    this.rewardPoints,
    this.refProductId,
    this.quantityReturned,
    this.cogs,
    this.quantityShipped,
    this.itRowId,
    this.refText3,
    this.refText4,
    this.refText5,
    this.description1,
    this.attribute1,
    this.attribute2,
    this.attribute3,
    this.matrixParentId,
    this.taxOption1,
    this.isTrackLot,
    this.isTrackSerial,
    this.brand,
    this.lotNumber,
    this.consignNumber,
    this.fixedTaxAmount,
  });

  factory Detail.fromJson(Map<String?, dynamic> json) => Detail(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        productId: json["ProductID"],
        quantity: json["Quantity"],
        focQuantity: json["FOCQuantity"],
        unitPrice: json["UnitPrice"],
        amount: json["Amount"],
        amountFc: json["AmountFC"],
        unitPriceFc: json["UnitPriceFC"],
        description: json["Description"],
        remarks: json["Remarks"],
        unitId: json["UnitID"],
        unitQuantity: json["UnitQuantity"],
        unitFactor: json["UnitFactor"],
        taxOption: json["TaxOption"],
        taxGroupId: json["TaxGroupID"],
        taxPercentage: json["TaxPercentage"],
        taxAmount: json["TaxAmount"],
        weightQuantity: json["WeightQuantity"],
        weightPrice: json["WeightPrice"],
        factorType: json["FactorType"],
        locationId: json["LocationID"],
        consignmentNo: json["ConsignmentNo"],
        subunitPrice: json["SubunitPrice"],
        discount: json["Discount"],
        rowIndex: json["RowIndex"],
        orderVoucherId: json["OrderVoucherID"],
        orderSysDocId: json["OrderSysDocID"],
        dNoteVoucherId: json["DNoteVoucherID"],
        dNoteSysDocId: json["DNoteSysDocID"],
        orderRowIndex: json["OrderRowIndex"],
        itemType: json["ItemType"],
        isDnRow: json["IsDNRow"],
        isRecost: json["IsRecost"],
        rowSource: json["RowSource"],
        jobId: json["JobID"],
        cost: json["Cost"],
        costCategoryId: json["CostCategoryID"],
        specificationId: json["SpecificationID"],
        styleId: json["StyleID"],
        listVoucherId: json["ListVoucherID"],
        listSysDocId: json["ListSysDocID"],
        listRowIndex: json["ListRowIndex"],
        refSlNo: json["RefSlNo"],
        refText1: json["RefText1"],
        refText2: json["RefText2"],
        refNum1: json["RefNum1"],
        refNum2: json["RefNum2"],
        refDate1: json["RefDate1"],
        refDate2: json["RefDate2"],
        rewardPoints: json["RewardPoints"],
        refProductId: json["RefProductID"],
        quantityReturned: json["QuantityReturned"],
        cogs: json["COGS"],
        quantityShipped: json["QuantityShipped"],
        itRowId: json["ITRowID"],
        refText3: json["RefText3"],
        refText4: json["RefText4"],
        refText5: json["RefText5"],
        description1: json["Description1"],
        attribute1: json["Attribute1"],
        attribute2: json["Attribute2"],
        attribute3: json["Attribute3"],
        matrixParentId: json["MatrixParentID"],
        taxOption1: json["TaxOption1"],
        isTrackLot: json["IsTrackLot"],
        isTrackSerial: json["IsTrackSerial"],
        brand: json["Brand"],
        lotNumber: json["LotNumber"],
        consignNumber: json["ConsignNumber"],
        fixedTaxAmount: json["FixedTaxAmount"],
      );

  Map<String?, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "ProductID": productId,
        "Quantity": quantity,
        "FOCQuantity": focQuantity,
        "UnitPrice": unitPrice,
        "Amount": amount,
        "AmountFC": amountFc,
        "UnitPriceFC": unitPriceFc,
        "Description": description,
        "Remarks": remarks,
        "UnitID": unitId,
        "UnitQuantity": unitQuantity,
        "UnitFactor": unitFactor,
        "TaxOption": taxOption,
        "TaxGroupID": taxGroupId,
        "TaxPercentage": taxPercentage,
        "TaxAmount": taxAmount,
        "WeightQuantity": weightQuantity,
        "WeightPrice": weightPrice,
        "FactorType": factorType,
        "LocationID": locationId,
        "ConsignmentNo": consignmentNo,
        "SubunitPrice": subunitPrice,
        "Discount": discount,
        "RowIndex": rowIndex,
        "OrderVoucherID": orderVoucherId,
        "OrderSysDocID": orderSysDocId,
        "DNoteVoucherID": dNoteVoucherId,
        "DNoteSysDocID": dNoteSysDocId,
        "OrderRowIndex": orderRowIndex,
        "ItemType": itemType,
        "IsDNRow": isDnRow,
        "IsRecost": isRecost,
        "RowSource": rowSource,
        "JobID": jobId,
        "Cost": cost,
        "CostCategoryID": costCategoryId,
        "SpecificationID": specificationId,
        "StyleID": styleId,
        "ListVoucherID": listVoucherId,
        "ListSysDocID": listSysDocId,
        "ListRowIndex": listRowIndex,
        "RefSlNo": refSlNo,
        "RefText1": refText1,
        "RefText2": refText2,
        "RefNum1": refNum1,
        "RefNum2": refNum2,
        "RefDate1": refDate1,
        "RefDate2": refDate2,
        "RewardPoints": rewardPoints,
        "RefProductID": refProductId,
        "QuantityReturned": quantityReturned,
        "COGS": cogs,
        "QuantityShipped": quantityShipped,
        "ITRowID": itRowId,
        "RefText3": refText3,
        "RefText4": refText4,
        "RefText5": refText5,
        "Description1": description1,
        "Attribute1": attribute1,
        "Attribute2": attribute2,
        "Attribute3": attribute3,
        "MatrixParentID": matrixParentId,
        "TaxOption1": taxOption1,
        "IsTrackLot": isTrackLot,
        "IsTrackSerial": isTrackSerial,
        "Brand": brand,
        "LotNumber": lotNumber,
        "ConsignNumber": consignNumber,
        "FixedTaxAmount": fixedTaxAmount,
      };
}

class Header {
  String? sysDocId;
  String? voucherId;
  String? companyId;
  String? divisionId;
  String? customerId;
  DateTime? transactionDate;
  DateTime? dueDate;
  String? salespersonId;
  String? reportTo;
  dynamic salesFlow;
  dynamic requiredDate;
  bool? priceIncludeTax;
  dynamic shippingAddressId;
  dynamic billingAddressId;
  String? customerAddress;
  String? shipToAddress;
  dynamic payeeTaxGroupId;
  dynamic taxOption;
  dynamic isExport;
  dynamic status;
  String? currencyId;
  dynamic currencyRate;
  dynamic termId;
  String? shippingMethodId;
  String? reference;
  String? reference2;
  String? note;
  dynamic paymentMethodType;
  dynamic expAmount;
  dynamic expPercent;
  dynamic expCode;
  dynamic registerId;
  String? poNumber;
  dynamic isVoid;
  bool? isWeightInvoice;
  dynamic clUserId;
  dynamic discount;
  dynamic discountFc;
  dynamic taxAmount;
  dynamic taxAmountFc;
  dynamic roundOff;
  dynamic total;
  dynamic totalFc;
  bool? isCash;
  int? sourceDocType;
  dynamic jobId;
  String? costCategoryId;
  dynamic tempKey;
  dynamic currentUser;
  dynamic autoKeyId;
  String? driverId;
  String? vehicleId;
  dynamic incoTermId;
  dynamic advanceAmount;
  dynamic totalCogs;
  bool? isDelivered;
  dynamic requireUpdate;
  dynamic printCount;
  int? approvalStatus;
  dynamic verificationStatus;
  DateTime? dateCreated;
  dynamic dateUpdated;
  String? createdBy;
  dynamic updatedBy;

  Header({
    this.sysDocId,
    this.voucherId,
    this.companyId,
    this.divisionId,
    this.customerId,
    this.transactionDate,
    this.dueDate,
    this.salespersonId,
    this.reportTo,
    this.salesFlow,
    this.requiredDate,
    this.priceIncludeTax,
    this.shippingAddressId,
    this.billingAddressId,
    this.customerAddress,
    this.shipToAddress,
    this.payeeTaxGroupId,
    this.taxOption,
    this.isExport,
    this.status,
    this.currencyId,
    this.currencyRate,
    this.termId,
    this.shippingMethodId,
    this.reference,
    this.reference2,
    this.note,
    this.paymentMethodType,
    this.expAmount,
    this.expPercent,
    this.expCode,
    this.registerId,
    this.poNumber,
    this.isVoid,
    this.isWeightInvoice,
    this.clUserId,
    this.discount,
    this.discountFc,
    this.taxAmount,
    this.taxAmountFc,
    this.roundOff,
    this.total,
    this.totalFc,
    this.isCash,
    this.sourceDocType,
    this.jobId,
    this.costCategoryId,
    this.tempKey,
    this.currentUser,
    this.autoKeyId,
    this.driverId,
    this.vehicleId,
    this.incoTermId,
    this.advanceAmount,
    this.totalCogs,
    this.isDelivered,
    this.requireUpdate,
    this.printCount,
    this.approvalStatus,
    this.verificationStatus,
    this.dateCreated,
    this.dateUpdated,
    this.createdBy,
    this.updatedBy,
  });

  factory Header.fromJson(Map<String?, dynamic> json) => Header(
        sysDocId: json["SysDocID"],
        voucherId: json["VoucherID"],
        companyId: json["CompanyID"],
        divisionId: json["DivisionID"],
        customerId: json["CustomerID"],
        transactionDate: DateTime.parse(json["TransactionDate"]),
        dueDate: DateTime.parse(json["DueDate"]),
        salespersonId: json["SalespersonID"],
        reportTo: json["ReportTo"],
        salesFlow: json["SalesFlow"],
        requiredDate: json["RequiredDate"],
        priceIncludeTax: json["PriceIncludeTax"],
        shippingAddressId: json["ShippingAddressID"],
        billingAddressId: json["BillingAddressID"],
        customerAddress: json["CustomerAddress"],
        shipToAddress: json["ShipToAddress"],
        payeeTaxGroupId: json["PayeeTaxGroupID"],
        taxOption: json["TaxOption"],
        isExport: json["IsExport"],
        status: json["Status"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        termId: json["TermID"],
        shippingMethodId: json["ShippingMethodID"],
        reference: json["Reference"],
        reference2: json["Reference2"],
        note: json["Note"],
        paymentMethodType: json["PaymentMethodType"],
        expAmount: json["ExpAmount"],
        expPercent: json["ExpPercent"],
        expCode: json["ExpCode"],
        registerId: json["RegisterID"],
        poNumber: json["PONumber"],
        isVoid: json["IsVoid"],
        isWeightInvoice: json["IsWeightInvoice"],
        clUserId: json["CLUserID"],
        discount: json["Discount"],
        discountFc: json["DiscountFC"],
        taxAmount: json["TaxAmount"],
        taxAmountFc: json["TaxAmountFC"],
        roundOff: json["RoundOff"],
        total: json["Total"],
        totalFc: json["TotalFC"],
        isCash: json["IsCash"],
        sourceDocType: json["SourceDocType"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        tempKey: json["TempKey"],
        currentUser: json["CurrentUser"],
        autoKeyId: json["AutoKeyID"],
        driverId: json["DriverID"],
        vehicleId: json["VehicleID"],
        incoTermId: json["INCOTermID"],
        advanceAmount: json["AdvanceAmount"],
        totalCogs: json["TotalCOGS"],
        isDelivered: json["IsDelivered"],
        requireUpdate: json["RequireUpdate"],
        printCount: json["PrintCount"],
        approvalStatus: json["ApprovalStatus"],
        verificationStatus: json["VerificationStatus"],
        dateCreated: DateTime.parse(json["DateCreated"]),
        dateUpdated: json["DateUpdated"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
      );

  Map<String?, dynamic> toJson() => {
        "SysDocID": sysDocId,
        "VoucherID": voucherId,
        "CompanyID": companyId,
        "DivisionID": divisionId,
        "CustomerID": customerId,
        "TransactionDate": transactionDate!.toIso8601String(),
        "DueDate": dueDate!.toIso8601String(),
        "SalespersonID": salespersonId,
        "ReportTo": reportTo,
        "SalesFlow": salesFlow,
        "RequiredDate": requiredDate,
        "PriceIncludeTax": priceIncludeTax,
        "ShippingAddressID": shippingAddressId,
        "BillingAddressID": billingAddressId,
        "CustomerAddress": customerAddress,
        "ShipToAddress": shipToAddress,
        "PayeeTaxGroupID": payeeTaxGroupId,
        "TaxOption": taxOption,
        "IsExport": isExport,
        "Status": status,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "TermID": termId,
        "ShippingMethodID": shippingMethodId,
        "Reference": reference,
        "Reference2": reference2,
        "Note": note,
        "PaymentMethodType": paymentMethodType,
        "ExpAmount": expAmount,
        "ExpPercent": expPercent,
        "ExpCode": expCode,
        "RegisterID": registerId,
        "PONumber": poNumber,
        "IsVoid": isVoid,
        "IsWeightInvoice": isWeightInvoice,
        "CLUserID": clUserId,
        "Discount": discount,
        "DiscountFC": discountFc,
        "TaxAmount": taxAmount,
        "TaxAmountFC": taxAmountFc,
        "RoundOff": roundOff,
        "Total": total,
        "TotalFC": totalFc,
        "IsCash": isCash,
        "SourceDocType": sourceDocType,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "TempKey": tempKey,
        "CurrentUser": currentUser,
        "AutoKeyID": autoKeyId,
        "DriverID": driverId,
        "VehicleID": vehicleId,
        "INCOTermID": incoTermId,
        "AdvanceAmount": advanceAmount,
        "TotalCOGS": totalCogs,
        "IsDelivered": isDelivered,
        "RequireUpdate": requireUpdate,
        "PrintCount": printCount,
        "ApprovalStatus": approvalStatus,
        "VerificationStatus": verificationStatus,
        "DateCreated": dateCreated!.toIso8601String(),
        "DateUpdated": dateUpdated,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
      };
}

class TaxDetail {
  String? sysDocId;
  String? voucherId;
  int? taxLevel;
  String? taxGroupId;
  String? calculationMethod;
  dynamic taxItemName;
  String? taxItemId;
  dynamic taxRate;
  dynamic taxAmount;
  String? currencyId;
  dynamic currencyRate;
  int? orderIndex;
  int? rowIndex;
  dynamic accountId;
  dynamic adjustAmount;

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
    this.adjustAmount,
  });

  factory TaxDetail.fromJson(Map<String?, dynamic> json) => TaxDetail(
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
        adjustAmount: json["AdjustAmount"],
      );

  Map<String?, dynamic> toJson() => {
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
        "AdjustAmount": adjustAmount,
      };
}
