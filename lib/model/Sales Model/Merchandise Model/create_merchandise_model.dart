// To parse this JSON data, do
//
//     final createMercahndiseModel = createMercahndiseModelFromJson(jsonString);

import 'dart:convert';

CreateMercahndiseModel createMercahndiseModelFromJson(String str) =>
    CreateMercahndiseModel.fromJson(json.decode(str));

String createMercahndiseModelToJson(CreateMercahndiseModel data) =>
    json.encode(data.toJson());

class CreateMercahndiseModel {
  String? token;
  String? sysdocid;
  dynamic sysDocType;
  String? voucherid;
  String? partyType;
  String? partyId;
  String? locationId;
  String? salespersonid;
  String? currencyid;
  DateTime? transactionDate;
  String? reference1;
  String? reference2;
  String? reference3;
  String? note;
  bool? isvoid;
  dynamic discount;
  dynamic total;
  dynamic roundoff;
  String? address;
  String? phone;
  dynamic isCompleted;
  String? driverId;
  String? vehicleId;
  String? toLocationId;
  String? containerNo;
  bool? isnewrecord;
  String? vehicleNo;
  dynamic transactionType;
  List<ItemTransactionDetail>? itemTransactionDetails;

  CreateMercahndiseModel({
    this.token,
    this.sysdocid,
    this.sysDocType,
    this.voucherid,
    this.partyType,
    this.partyId,
    this.locationId,
    this.salespersonid,
    this.currencyid,
    this.transactionDate,
    this.reference1,
    this.reference2,
    this.reference3,
    this.note,
    this.isvoid,
    this.discount,
    this.total,
    this.roundoff,
    this.address,
    this.phone,
    this.isCompleted,
    this.driverId,
    this.vehicleId,
    this.toLocationId,
    this.containerNo,
    this.isnewrecord,
    this.vehicleNo,
    this.transactionType,
    this.itemTransactionDetails,
  });

  factory CreateMercahndiseModel.fromJson(Map<String, dynamic> json) =>
      CreateMercahndiseModel(
        token: json["token"],
        sysdocid: json["Sysdocid"],
        sysDocType: json["SysDocType"],
        voucherid: json["Voucherid"],
        partyType: json["PartyType"],
        partyId: json["PartyID"],
        locationId: json["LocationID"],
        salespersonid: json["Salespersonid"],
        currencyid: json["Currencyid"],
        transactionDate: json["TransactionDate"],
        reference1: json["Reference1"],
        reference2: json["Reference2"],
        reference3: json["Reference3"],
        note: json["Note"],
        isvoid: json["Isvoid"],
        discount: json["Discount"],
        total: json["Total"],
        roundoff: json["Roundoff"],
        address: json["Address"],
        phone: json["Phone"],
        isCompleted: json["IsCompleted"],
        driverId: json["DriverID"],
        vehicleId: json["VehicleID"],
        toLocationId: json["ToLocationID"],
        containerNo: json["ContainerNo"],
        isnewrecord: json["Isnewrecord"],
        vehicleNo: json["VehicleNo"],
        transactionType: json["TransactionType"],
        itemTransactionDetails: json["ItemTransactionDetails"] == null
            ? []
            : List<ItemTransactionDetail>.from(json["ItemTransactionDetails"]!
                .map((x) => ItemTransactionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "Sysdocid": sysdocid,
        "SysDocType": sysDocType,
        "Voucherid": voucherid,
        "PartyType": partyType,
        "PartyID": partyId,
        "LocationID": locationId,
        "Salespersonid": salespersonid,
        "Currencyid": currencyid,
        "TransactionDate": transactionDate?.toIso8601String(),
        "Reference1": reference1,
        "Reference2": reference2,
        "Reference3": reference3,
        "Note": note,
        "Isvoid": isvoid,
        "Discount": discount,
        "Total": total,
        "Roundoff": roundoff,
        "Address": address,
        "Phone": phone,
        "IsCompleted": isCompleted,
        "DriverID": driverId,
        "VehicleID": vehicleId,
        "ToLocationID": toLocationId,
        "ContainerNo": containerNo,
        "Isnewrecord": isnewrecord,
        "VehicleNo": vehicleNo,
        "TransactionType": transactionType,
        "ItemTransactionDetails": itemTransactionDetails == null
            ? []
            : List<dynamic>.from(
                itemTransactionDetails!.map((x) => x.toJson())),
      };
}

class ItemTransactionDetail {
  String? itemcode;
  String? description;
  dynamic quantity;
  dynamic rowindex;
  String? unitid;
  dynamic unitPrice;
  dynamic quantityReturned;
  dynamic quantityShipped;
  dynamic unitQuantity;
  dynamic unitFactor;
  String? factorType;
  dynamic subunitPrice;
  String? jobId;
  String? costCategoryId;
  String? locationId;
  String? sourceVoucherId;
  String? sourceSysDocId;
  dynamic sourceRowIndex;
  String? rowSource;
  String? refSlNo;
  String? refText1;
  String? refText2;
  String? refText3;
  String? refText4;
  String? refText5;
  dynamic refNum1;
  dynamic refNum2;
  String? refDate1;
  String? refDate2;
  String? remarks;
  DateTime? expiryDate;

  ItemTransactionDetail({
    this.itemcode,
    this.description,
    this.quantity,
    this.rowindex,
    this.unitid,
    this.unitPrice,
    this.quantityReturned,
    this.quantityShipped,
    this.unitQuantity,
    this.unitFactor,
    this.factorType,
    this.subunitPrice,
    this.jobId,
    this.costCategoryId,
    this.locationId,
    this.sourceVoucherId,
    this.sourceSysDocId,
    this.sourceRowIndex,
    this.rowSource,
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
    this.expiryDate,
  });

  factory ItemTransactionDetail.fromJson(Map<String, dynamic> json) =>
      ItemTransactionDetail(
        itemcode: json["Itemcode"],
        description: json["Description"],
        quantity: json["Quantity"],
        rowindex: json["Rowindex"],
        unitid: json["Unitid"],
        unitPrice: json["UnitPrice"],
        quantityReturned: json["QuantityReturned"],
        quantityShipped: json["QuantityShipped"],
        unitQuantity: json["UnitQuantity"],
        unitFactor: json["UnitFactor"],
        factorType: json["FactorType"],
        subunitPrice: json["SubunitPrice"],
        jobId: json["JobID"],
        costCategoryId: json["CostCategoryID"],
        locationId: json["LocationID"],
        sourceVoucherId: json["SourceVoucherID"],
        sourceSysDocId: json["SourceSysDocID"],
        sourceRowIndex: json["SourceRowIndex"],
        rowSource: json["RowSource"],
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
        expiryDate: json["ExpiryDate"] == null
            ? null
            : DateTime.parse(json["ExpiryDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Itemcode": itemcode,
        "Description": description,
        "Quantity": quantity,
        "Rowindex": rowindex,
        "Unitid": unitid,
        "UnitPrice": unitPrice,
        "QuantityReturned": quantityReturned,
        "QuantityShipped": quantityShipped,
        "UnitQuantity": unitQuantity,
        "UnitFactor": unitFactor,
        "FactorType": factorType,
        "SubunitPrice": subunitPrice,
        "JobID": jobId,
        "CostCategoryID": costCategoryId,
        "LocationID": locationId,
        "SourceVoucherID": sourceVoucherId,
        "SourceSysDocID": sourceSysDocId,
        "SourceRowIndex": sourceRowIndex,
        "RowSource": rowSource,
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
        "ExpiryDate": expiryDate?.toIso8601String(),
      };
}
