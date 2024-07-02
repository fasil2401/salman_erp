import 'dart:convert';

AllCustomerModel allCustomerModelFromJson(String str) =>
    AllCustomerModel.fromJson(json.decode(str));

String allCustomerModelToJson(AllCustomerModel data) =>
    json.encode(data.toJson());

class AllCustomerModel {
  AllCustomerModel({
    required this.result,
    required this.modelobject,
  });

  int result;
  List<CustomerModel> modelobject;

  factory AllCustomerModel.fromJson(Map<String, dynamic> json) =>
      AllCustomerModel(
        result: json["result"],
        modelobject: List<CustomerModel>.from(
            json["Modelobject"].map((x) => CustomerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Modelobject": List<dynamic>.from(modelobject.map((x) => x.toJson())),
      };
}

class CustomerModel {
  CustomerModel({
    this.code,
    this.name,
    this.searchColumn,
    this.currencyId,
    this.allowConsignment,
    this.isHold,
    this.priceLevelId,
    this.balance,
    this.parentCustomerId,
    this.paymentTermId,
    this.paymentMethodId,
    this.shippingMethodId,
    this.billToAddressId,
    this.shipToAddressId,
    this.salesPersonId,
    this.isWeightInvoice,
    this.customerClassId,
    this.taxOption,
    this.taxGroupId,
    this.childCustomers,
    this.isLpo,
    this.isPro,
    this.mobile,
  });

  String? code;
  String? name;
  String? searchColumn;
  String? currencyId;
  bool? allowConsignment;
  bool? isHold;
  dynamic priceLevelId;
  dynamic balance;
  dynamic parentCustomerId;
  dynamic paymentTermId;
  dynamic paymentMethodId;
  dynamic shippingMethodId;
  dynamic billToAddressId;
  dynamic shipToAddressId;
  String? salesPersonId;
  bool? isWeightInvoice;
  String? customerClassId;
  dynamic taxOption;
  dynamic taxGroupId;
  dynamic childCustomers;
  dynamic isLpo;
  dynamic isPro;
  String? mobile;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        code: json["Code"],
        name: json["Name"],
        searchColumn: json["SearchColumn"],
        currencyId: json["CurrencyID"],
        allowConsignment: json["AllowConsignment"],
        isHold: json["IsHold"],
        priceLevelId: json["PriceLevelID"],
        balance: json["Balance"],
        parentCustomerId: json["ParentCustomerID"],
        paymentTermId: json["PaymentTermID"],
        paymentMethodId: json["PaymentMethodID"],
        shippingMethodId: json["ShippingMethodID"],
        billToAddressId: json["BillToAddressID"],
        shipToAddressId: json["ShipToAddressID"],
        salesPersonId: json["SalesPersonID"],
        isWeightInvoice: json["IsWeightInvoice"],
        customerClassId: json["CustomerClassID"],
        taxOption: json["TaxOption"],
        taxGroupId: json["TaxGroupID"],
        childCustomers: json["ChildCustomers"],
        isLpo: json["IsLPO"],
        isPro: json["IsPRO"],
        mobile: json["Mobile"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Name": name,
        "SearchColumn": searchColumn,
        "CurrencyID": currencyId,
        "AllowConsignment": allowConsignment,
        "IsHold": isHold,
        "PriceLevelID": priceLevelId,
        "Balance": balance,
        "ParentCustomerID": parentCustomerId,
        "PaymentTermID": paymentTermId,
        "PaymentMethodID": paymentMethodId,
        "ShippingMethodID": shippingMethodId,
        "BillToAddressID": billToAddressId,
        "ShipToAddressID": shipToAddressId,
        "SalesPersonID": salesPersonId,
        "IsWeightInvoice": isWeightInvoice,
        "CustomerClassID": customerClassId,
        "TaxOption": taxOption,
        "TaxGroupID": taxGroupId,
        "ChildCustomers": childCustomers,
        "IsLPO": isLpo,
        "IsPRO": isPro,
        "Mobile": mobile,
      };
}
