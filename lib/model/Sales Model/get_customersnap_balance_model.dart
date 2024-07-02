// To parse this JSON data, do
//
//     final getCustomerSnapBalanceModel = getCustomerSnapBalanceModelFromJson(jsonString);

import 'dart:convert';

GetCustomerSnapBalanceModel getCustomerSnapBalanceModelFromJson(String str) => GetCustomerSnapBalanceModel.fromJson(json.decode(str));

String getCustomerSnapBalanceModelToJson(GetCustomerSnapBalanceModel data) => json.encode(data.toJson());

class GetCustomerSnapBalanceModel {
    int? result;
    List<CustomerSnapBalanceModel>? modelobject;

    GetCustomerSnapBalanceModel({
        this.result,
        this.modelobject,
    });

    factory GetCustomerSnapBalanceModel.fromJson(Map<String, dynamic> json) => GetCustomerSnapBalanceModel(
        result: json["result"],
        modelobject: json["Modelobject"] == null ? [] : List<CustomerSnapBalanceModel>.from(json["Modelobject"]!.map((x) => CustomerSnapBalanceModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": modelobject == null ? [] : List<dynamic>.from(modelobject!.map((x) => x.toJson())),
    };
}

class CustomerSnapBalanceModel {
    String? customerId;
    String? customerName;
    dynamic creditAmount;
    bool? isInactive;
    bool? isHold;
    dynamic clValidity;
    dynamic creditLimitType;
    dynamic parentCustomerId;
    bool? limitPdcUnsecured;
    dynamic pdcUnsecuredLimitAmount;
    dynamic insApprovedAmount;
    dynamic openDnAmount;
    dynamic tempCl;
    dynamic tempTokenCl;
    dynamic balance;
    dynamic pdcAmount;
    bool? acceptCheckPayment;
    bool? acceptPdc;
    dynamic currencyId;
    dynamic securityCheque;
    dynamic note;
    dynamic unrestrictedPdc;
    dynamic insuranceAmount;
    dynamic balanceAmount;
    dynamic unInvoiced;
    dynamic dueDays;
    String? status;
    String? customerStatus;
    dynamic limit;
    String? creditStatus;
    dynamic netBalance;
    dynamic dueAmount;
    dynamic remarks;

    CustomerSnapBalanceModel({
        this.customerId,
        this.customerName,
        this.creditAmount,
        this.isInactive,
        this.isHold,
        this.clValidity,
        this.creditLimitType,
        this.parentCustomerId,
        this.limitPdcUnsecured,
        this.pdcUnsecuredLimitAmount,
        this.insApprovedAmount,
        this.openDnAmount,
        this.tempCl,
        this.tempTokenCl,
        this.balance,
        this.pdcAmount,
        this.acceptCheckPayment,
        this.acceptPdc,
        this.currencyId,
        this.securityCheque,
        this.note,
        this.unrestrictedPdc,
        this.insuranceAmount,
        this.balanceAmount,
        this.unInvoiced,
        this.dueDays,
        this.status,
        this.customerStatus,
        this.limit,
        this.creditStatus,
        this.netBalance,
        this.dueAmount,
        this.remarks,
    });

    factory CustomerSnapBalanceModel.fromJson(Map<String, dynamic> json) => CustomerSnapBalanceModel(
        customerId: json["CustomerID"],
        customerName: json["CustomerName"],
        creditAmount: json["CreditAmount"],
        isInactive: json["IsInactive"],
        isHold: json["IsHold"],
        clValidity: json["CLValidity"],
        creditLimitType: json["CreditLimitType"],
        parentCustomerId: json["ParentCustomerID"],
        limitPdcUnsecured: json["LimitPDCUnsecured"],
        pdcUnsecuredLimitAmount: json["PDCUnsecuredLimitAmount"],
        insApprovedAmount: json["InsApprovedAmount"],
        openDnAmount: json["OpenDNAmount"],
        tempCl: json["TempCL"],
        tempTokenCl: json["TempTokenCL"],
        balance: json["Balance"],
        pdcAmount: json["PDCAmount"],
        acceptCheckPayment: json["AcceptCheckPayment"],
        acceptPdc: json["AcceptPDC"],
        currencyId: json["CurrencyID"],
        securityCheque: json["SecurityCheque"],
        note: json["Note"],
        unrestrictedPdc: json["UnrestrictedPDC"],
        insuranceAmount: json["InsuranceAmount"],
        balanceAmount: json["BalanceAmount"],
        unInvoiced: json["UnInvoiced"],
        dueDays: json["DueDays"],
        status: json["Status"],
        customerStatus: json["CustomerStatus"],
        limit: json["Limit"],
        creditStatus: json["CreditStatus"],
        netBalance: json["NetBalance"],
        dueAmount: json["DueAmount"],
        remarks: json["Remarks"],
    );

    Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "CustomerName": customerName,
        "CreditAmount": creditAmount,
        "IsInactive": isInactive,
        "IsHold": isHold,
        "CLValidity": clValidity,
        "CreditLimitType": creditLimitType,
        "ParentCustomerID": parentCustomerId,
        "LimitPDCUnsecured": limitPdcUnsecured,
        "PDCUnsecuredLimitAmount": pdcUnsecuredLimitAmount,
        "InsApprovedAmount": insApprovedAmount,
        "OpenDNAmount": openDnAmount,
        "TempCL": tempCl,
        "TempTokenCL": tempTokenCl,
        "Balance": balance,
        "PDCAmount": pdcAmount,
        "AcceptCheckPayment": acceptCheckPayment,
        "AcceptPDC": acceptPdc,
        "CurrencyID": currencyId,
        "SecurityCheque": securityCheque,
        "Note": note,
        "UnrestrictedPDC": unrestrictedPdc,
        "InsuranceAmount": insuranceAmount,
        "BalanceAmount": balanceAmount,
        "UnInvoiced": unInvoiced,
        "DueDays": dueDays,
        "Status": status,
        "CustomerStatus": customerStatus,
        "Limit": limit,
        "CreditStatus": creditStatus,
        "NetBalance": netBalance,
        "DueAmount": dueAmount,
        "Remarks": remarks,
    };
}
