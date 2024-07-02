import 'dart:convert';

GetCustomerStatementModel getCustomerStatementModelFromJson(String str) => GetCustomerStatementModel.fromJson(json.decode(str));

String getCustomerStatementModelToJson(GetCustomerStatementModel data) => json.encode(data.toJson());

class GetCustomerStatementModel {
    GetCustomerStatementModel({
       required this.result,
       required this.headerModelobject,
       required this.detailModelobject,
    });

    int result;
    List<CustomerStatementHeaderModel> headerModelobject;
    List<CustomerStatementDetailModel> detailModelobject;

    factory GetCustomerStatementModel.fromJson(Map<String, dynamic> json) => GetCustomerStatementModel(
        result: json["result"],
        headerModelobject: List<CustomerStatementHeaderModel>.from(json["HeaderModelobject"].map((x) => CustomerStatementHeaderModel.fromJson(x))),
        detailModelobject: List<CustomerStatementDetailModel>.from(json["DetailModelobject"].map((x) => CustomerStatementDetailModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "HeaderModelobject": List<dynamic>.from(headerModelobject.map((x) => x.toJson())),
        "DetailModelobject": List<dynamic>.from(detailModelobject.map((x) => x.toJson())),
    };
}

class CustomerStatementDetailModel {
    CustomerStatementDetailModel({
        this.customerCode,
        this.sysDocType,
        this.docType,
        this.docId,
        this.docNo,
        this.date,
        this.arDueDate,
        this.poNumber,
        this.trCustomer,
        this.trCustomerId,
        this.childCode,
        this.childName,
        this.salesPersonId,
        this.salesPersonName,
        this.chq,
        this.chqDate,
        this.description,
        this.reference,
        this.currencyId,
        this.currencyRate,
        this.debitFc,
        this.creditFc,
        this.note,
        this.debit,
        this.credit,
        this.currencyNote,
        this.balance,
    });

    String? customerCode;
    int? sysDocType;
    String? docType;
    String? docId;
    String? docNo;
    DateTime? date;
    DateTime? arDueDate;
    String? poNumber;
    String? trCustomer;
    String? trCustomerId;
    dynamic childCode;
    dynamic childName;
    String? salesPersonId;
    String? salesPersonName;
    String? chq;
    DateTime? chqDate;
    String? description;
    String? reference;
    String? currencyId;
    dynamic currencyRate;
    dynamic debitFc;
    dynamic creditFc;
    String? note;
    dynamic debit;
    dynamic credit;
    dynamic currencyNote;
    dynamic balance;

    factory CustomerStatementDetailModel.fromJson(Map<String, dynamic> json) => CustomerStatementDetailModel(
        customerCode: json["Customer Code"],
        sysDocType: json["SysDocType"],
        docType: json["Doc Type"],
        docId: json["Doc ID"],
        docNo: json["Doc No"],
        date: DateTime.parse(json["Date"]),
        arDueDate: json["ARDueDate"] == null ? null : DateTime.parse(json["ARDueDate"]),
        poNumber: json["PO Number"] == null ? null : json["PO Number"],
        trCustomer: json["Tr_Customer"] == null ? null : json["Tr_Customer"],
        trCustomerId: json["Tr_Customer_ID"] == null ? null : json["Tr_Customer_ID"],
        childCode: json["ChildCode"],
        childName: json["ChildName"],
        salesPersonId: json["SalesPersonID"] == null ? null : json["SalesPersonID"],
        salesPersonName: json["SalesPersonName"] == null ? null : json["SalesPersonName"],
        chq: json["Chq#"] == null ? null : json["Chq#"],
        chqDate: json["Chq Date"] == null ? null : DateTime.parse(json["Chq Date"]),
        description: json["Description"] == null ? null : json["Description"],
        reference: json["Reference"],
        currencyId: json["CurrencyID"],
        currencyRate: json["CurrencyRate"],
        debitFc: json["DebitFC"] == null ? null : json["DebitFC"].toDouble(),
        creditFc: json["CreditFC"] == null ? null : json["CreditFC"],
        note: json["Note"] == null ? null : json["Note"],
        debit: json["Debit"] == null ? null : json["Debit"].toDouble(),
        credit: json["Credit"] == null ? null : json["Credit"].toDouble(),
        currencyNote: json["CurrencyNote"],
        balance: json["Balance"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Customer Code": customerCode,
        "SysDocType": sysDocType,
        "Doc Type": docType,
        "Doc ID": docId,
        "Doc No": docNo,
        "Date": date == null ? null : date!.toIso8601String(),
        "ARDueDate": arDueDate == null ? null : arDueDate!.toIso8601String(),
        "PO Number": poNumber == null ? null : poNumber,
        "Tr_Customer": trCustomer == null ? null : trCustomer,
        "Tr_Customer_ID": trCustomerId == null ? null : trCustomerId,
        "ChildCode": childCode,
        "ChildName": childName,
        "SalesPersonID": salesPersonId == null ? null : salesPersonId,
        "SalesPersonName": salesPersonName == null ? null : salesPersonName,
        "Chq#": chq == null ? null : chq,
        "Chq Date": chqDate == null ? null : chqDate!.toIso8601String(),
        "Description": description == null ? null : description,
        "Reference": reference,
        "CurrencyID": currencyId,
        "CurrencyRate": currencyRate,
        "DebitFC": debitFc == null ? null : debitFc,
        "CreditFC": creditFc == null ? null : creditFc,
        "Note": note == null ? null : note,
        "Debit": debit == null ? null : debit,
        "Credit": credit == null ? null : credit,
        "CurrencyNote": currencyNote,
        "Balance": balance,
    };
}


class CustomerStatementHeaderModel {
    CustomerStatementHeaderModel({
        this.customerCode,
        this.statementEmail,
        this.statementSendingMethod,
        this.termName,
        this.openingBalance,
        this.endingBalance,
        this.pdc,
        this.customerName,
        this.addressPrintFormat,
        this.email,
        this.phone1,
        this.shipToAddressId,
        this.currencyId,
        this.currencyName,
    });

    String? customerCode;
    String? statementEmail;
    int? statementSendingMethod;
    String? termName;
    dynamic openingBalance;
    dynamic endingBalance;
    dynamic pdc;
    String? customerName;
    String? addressPrintFormat;
    String? email;
    String? phone1;
    String? shipToAddressId;
    String? currencyId;
    String? currencyName;

    factory CustomerStatementHeaderModel.fromJson(Map<String, dynamic> json) => CustomerStatementHeaderModel(
        customerCode: json["Customer Code"],
        statementEmail: json["StatementEmail"],
        statementSendingMethod: json["StatementSendingMethod"],
        termName: json["TermName"],
        openingBalance: json["Opening Balance"],
        endingBalance: json["Ending Balance"].toDouble(),
        pdc: json["PDC"].toDouble(),
        customerName: json["Customer Name"],
        addressPrintFormat: json["AddressPrintFormat"],
        email: json["Email"],
        phone1: json["Phone1"],
        shipToAddressId: json["ShipToAddressID"],
        currencyId: json["CurrencyID"],
        currencyName: json["CurrencyName"],
    );

    Map<String, dynamic> toJson() => {
        "Customer Code": customerCode,
        "StatementEmail": statementEmail,
        "StatementSendingMethod": statementSendingMethod,
        "TermName": termName,
        "Opening Balance": openingBalance,
        "Ending Balance": endingBalance,
        "PDC": pdc,
        "Customer Name": customerName,
        "AddressPrintFormat": addressPrintFormat,
        "Email": email,
        "Phone1": phone1,
        "ShipToAddressID": shipToAddressId,
        "CurrencyID": currencyId,
        "CurrencyName": currencyName,
    };
}

