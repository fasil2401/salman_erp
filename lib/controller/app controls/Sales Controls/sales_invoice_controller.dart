import 'dart:convert';
import 'dart:math';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/open_sales_order_summary.model.dart';
import 'package:axolon_erp/model/Sales%20Model/ceate_sales_order_response.dart';
import 'package:axolon_erp/model/Sales%20Model/create_sales_invoice_detail_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_invoice_by_id_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_invoice_open_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_by_id_model.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/error_response_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/discount_calculations.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

class SalesInvoiceController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());

  DateTime date = DateTime.now();

  var isLoading = false.obs;

  var isCustomerLoading = false.obs;
  var isVoucherLoading = false.obs;
  var isLocationLoading = false.obs;
  var response = 0.obs;
  var responses = 0.obs;
  var message = ''.obs;
  var sysDocList = [].obs;
  var productList = [].obs;
  var customerList = [].obs;
  var filterList = [].obs;
  var salesInvoiceList = [].obs;
  var salesInvoiceOpenList = [].obs;
  var salesordersummaryOpenList = [].obs;
  var productLocationList = [].obs;

  var voucherNumber = ''.obs;
  var sysDocName = ' '.obs;
  var sysDocId = ''.obs;
  var orderVoucherNumber = ''.obs;
  var orderSysDocId = ''.obs;
  var dueDate = DateTime.now().obs;
  var transactionDate = DateTime.now().obs;
  var isNewRecord = true.obs;
  var customerFilterList = [].obs;
  var isSearching = false.obs;
  var customer = CustomerModel().obs;
  var customerId = ''.obs;
  var shippingAddress = ''.obs;
  var billingAddress = ''.obs;
  var remarks = ' '.obs;
  var locationId = ''.obs;
  var location = LocationSingleModel().obs;
  var salesFlow = 0.obs;

  var isFirstFocusOnRemarks = true.obs;
  var isSaving = false.obs;
  var isEditEnabled = false.obs;
  var isAddEnabled = false.obs;
  var isOpenListLoading = false.obs;
  var isSalesSummaryOpenListLoading = false.obs;
  var isSalesInvoiceByIdLoading = false.obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    customerId.value = this.customer.value.code ?? '';
  }

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.salesInvoice, type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.salesInvoice, type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
  }

  presetSysdoc() async {
    if (salesScreenController.isLoading.value == false) {
      await generateSysDocList();
      getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
    } else {
      await Future.delayed(Duration(seconds: 0));
      presetSysdoc();
    }
  }

  generateSysDocList() {
    sysDocList.clear();
    for (var element in salesScreenController.sysDocList) {
      if (element.sysDocType == SysdocType.SalesInvoice.value) {
        sysDocList.add(element);
      }
    }
  }

  resetList() {
    filterList.value = productList;
  }

  getRemarks(String value) {
    remarks.value = value;
  }

  // calculateTotal(double price) {
  //   subTotal.value = subTotal.value + price;
  // }

  // calculateTotalTax(double tax) {
  //   totalTax.value += tax;
  //   total.value = subTotal.value + totalTax.value - discount.value;
  // }

  // changeUnit(String value) {
  //   unit.value = value;
  // }

  clearData() {
    customerId.value = '';
    salesScreenController.subTotal.value = 0.0;
    salesScreenController.discount.value = 0.0;
    salesScreenController.totalTax.value = 0.0;
    salesScreenController.discountPercentage.value = 0.0;
    salesScreenController.total.value = 0.0;
    salesInvoiceList.clear();
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    remarks.value = ' ';
    isFirstFocusOnRemarks.value = true;
    generateSysDocList();
  }

  // scanSalesItems(String itemCode, BuildContext context) {
  //   Navigator.pop(context);
  //   var product = productList.firstWhere(
  //     (element) => element.upc == itemCode,
  //     orElse: () => productList.firstWhere(
  //         (element) => element.productId == itemCode,
  //         orElse: () => null),
  //   );
  //   if (product != null) {
  //     getProductDetails(product.productId);
  //     Navigator.pop(context);
  //   } else {
  //     SnackbarServices.errorSnackbar('Product not found');
  //   }
  // }
  scanSalesItems(String itemCode, BuildContext context) {
    // Navigator.pop(context);
    var product = productList.firstWhere(
      (element) => element.upc == itemCode,
      orElse: () => productList.firstWhere(
          (element) => element.productId == itemCode,
          orElse: () => null),
    );
    if (product != null) {
      // getProductDetails(product.productId, context);
      //Navigator.pop(context);
      salesScreenController.addOrUpdateProductToSales(
          product: product,
          isAdding: true,
          isScanning: true,
          single: ProductDetailsModel(
              res: 1,
              model: [],
              unitmodel: [],
              productlocationmodel: [],
              msg: ''),
          index: 1,
          context: context,
          list: salesInvoiceList,
          customerId: customerId.value);
    } else {
      Navigator.pop(context);
      SnackbarServices.errorSnackbar('Product not found');
    }
  }

  getAllProducts() async {
    await isEnanbled();
    await presetSysdoc();
    if (homeController.productList.isEmpty) {
      isLoading.value = true;
      await homeController.getAllProducts();
      productList.value = homeController.productList;
      filterList.value = homeController.productList;
      isLoading.value = false;
    } else {
      productList.value = homeController.productList;
      filterList.value = homeController.productList;
    }
    // isLoading.value = true;
    // await loginController.getToken();
    // final String token = loginController.token.value;
    // dynamic result;
    // try {
    //   var feedback = await ApiServices.fetchDataInventory(
    //       api: 'GetAllProductList?token=${token}');
    //   if (feedback != null) {
    //     result = GetAllProductsModel.fromJson(feedback);
    //     print(result);
    //     response.value = result.res;
    //     productList.value = result.products;
    //     filterList.value = result.products;
    //     isLoading.value = false;
    //   }
    // } finally {
    //   if (response.value == 1) {
    //     developer.log(productList.length.toString(), name: 'All Products');
    //   }
    // }
  }

  getAllCustomers() async {
    isCustomerLoading.value = true;
    isLoading.value = true;
    isLocationLoading.value = true;
    await isEnanbled();
    await presetSysdoc();
    await homeController.getCustomerList();
    await generateCustomerList();
    await getLocationList();
    await salesFlowget();

    isCustomerLoading.value = false;
    getAllProducts();
  }

  salesFlowget() {
    salesFlow.value = int.parse(
        homeController.getCompanyOption(CompanyOptions.LocalSalesFlow.value));
    update();
    developer.log("${salesFlow.value} companyPreference1");
  }

  generateCustomerList() async {
    customerList.clear();
    for (var element in homeController.customerList) {
      customerList.add(element);
    }
    customer.value = customerList[0];
    customerId.value = customer.value.code ?? '';
  }

  getVoucherNumber(String sysDocId, String name) async {
    isNewRecord.value = true;
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    isVoucherLoading.value = true;
    this.sysDocId.value = sysDocId;
    sysDocName.value = name;
    await loginController.getToken();
    final String token = loginController.token.value;
    String date = DateTime.now().toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetNextDocumentNo?token=${token}&sysDocID=${sysDocId}&dateTime=${date}');
      if (feedback != null) {
        result = VoucherNumberModel.fromJson(feedback);
        print(result);
        response.value = result.res;
        voucherNumber.value = result.model;
        isVoucherLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(voucherNumber.value.toString(), name: 'Voucher Number');
      }
    }
  }

  getLocationList() async {
    if (homeController.locationList.isEmpty) {
      await homeController.getLocationList();
    }
    location.value = homeController.locationList.first;
    locationId.value = location.value.code ?? '';
    isLocationLoading.value = false;
    update();
  }
  // getProductDetails(String productId) async {
  //   isProductLoading.value = true;
  //   await loginController.getToken();
  //   final String token = loginController.token.value;
  //   String data = jsonEncode({
  //     "token": token,
  //     "locationid": "",
  //     "productid": productId,
  //   });
  //   dynamic result;
  //   try {
  //     var feedback = await ApiServices.fetchDataRawBodyInventory(
  //         api: 'GetProductDetails', data: data);
  //     if (feedback != null) {
  //       result = ProductDetailsModel.fromJson(feedback);
  //       response.value = result.res;
  //       singleProduct.value = result;
  //       unit.value = singleProduct.value.model[0].unitId ?? 'Unit';
  //       unitList.value = result.unitmodel;
  //     }
  //   } finally {
  //     isProductLoading.value = false;
  //     if (response.value == 1) {
  //       developer.log(productLocationList.value.toString(),
  //           name:
  //               'Product Location List for ${singleProduct.value.model[0].description}');
  //     } else {}
  //   }
  // }

  selectTransactionDates(context, bool isTransaction) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isTransaction ? transactionDate.value = newDate : dueDate.value = newDate;
    }
    update();
  }

  resetCustomerList() {
    customerFilterList.value = customerList;
  }

  createSalesInvoice() async {
    bool permission = await salesScreenController.getCustomerCreditLimit(
        customerId: customerId.value,
        subtotal: salesScreenController.subTotal.value,
        transactionDate: transactionDate.value);
    bool confirmation = false;
    if (salesInvoiceList.isNotEmpty) {
      if (voucherNumber.value != '') {
        if (customerId.value != '') {
          if (permission == false) {
            isSaving.value = true;
            var list = [];
            var taxList = [];
            int index = 0;
            int orderrowindex = 0;
            int taxIndex = 0;
            double taxAmount = 0.0;
            for (ProductDetailsModel product in salesInvoiceList) {
              bool isBelow = await isBelowCost(
                  productId: product.model[0].productId ?? '',
                  unitId: product.model[0].updatedUnitId ?? '',
                  price: product.model[0].updatedPrice);
              // developer.log(isBelow.toString(), name: 'is Below');
              if (isBelow) {
                developer.log(isBelow.toString(), name: 'is Below');
                confirmation = await lessCostWarning(
                    '${product.model[0].productId} - ${product.model[0].description}');
                developer.log(confirmation.toString(), name: 'is Confirm');
                if (confirmation == false) {
                  break;
                }
              } else {
                confirmation = true;
              }
              list.add(
                CreateSalesInvoiceDetailModel(
                    itemcode: product.model[0].productId,
                    description: product.model[0].description,
                    quantity: product.model[0].updatedQuantity,
                    remarks: product.model[0].remarks,
                    rowindex: index,
                    unitid: product.model[0].updatedUnitId,
                    specificationid: '',
                    styleid: '',
                    itemtype: product.model[0].itemType ?? 0,
                    locationid: locationId.value,
                    jobid: '',
                    costcategoryid: '',
                    unitprice: product.model[0].updatedPrice,
                    cost: product.model[0].price1,
                    amount: product.model[0].updatedPrice *
                        product.model[0].updatedQuantity,
                    taxoption: product.model[0].taxOption,
                    taxamount: (product.model[0].taxAmount ?? 0.0) *
                        product.model[0].updatedQuantity,
                    taxgroupid: product.model[0].taxGroupId ?? '',
                    discount: 0,
                    focQuantity: 0,
                    orderrowindex: index,
                    ordersdocid: orderSysDocId.value,
                    ordervoucherid: orderVoucherNumber.value,
                    refProductId: '',
                    rowSource: 0),
              );
              if (product.taxList!.isNotEmpty) {
                developer.log(product.taxList.toString(),
                    name: 'item tax details 222222');
                for (TaxModel tax in product.taxList!) {
                  tax.orderIndex = index;
                  tax.token = '';
                  tax.sysDocId = sysDocId.value;
                  tax.voucherId = voucherNumber.value;
                  tax.rowIndex = taxIndex;
                  tax.taxItemName = '';
                  tax.accountId = '';
                  tax.currencyId = '';
                  tax.currencyRate = 1;
                  tax.taxLevel = 2;
                  tax.taxAmount =
                      tax.taxAmount * product.model[0].updatedQuantity;
                  taxList.add(tax);
                  taxIndex++;
                }
              }
              index++;

              //   if (product.taxList != null && product.taxList.isNotEmpty) {
              //     for (var tax in product.taxList) {
              // tax.orderIndex = index;
              // tax.token = '';
              // tax.sysDocId = sysDocId.value;
              // tax.voucherId = voucherNumber.value;
              // tax.rowIndex = taxIndex;
              // tax.taxItemName = '';
              // tax.accountId = '';
              // tax.currencyId = '';
              // tax.currencyRate = 1;
              // tax.taxLevel = 2;
              // tax.taxAmount =
              //     tax.taxAmount * product.model[0].updatedQuantity;
              // taxList.add(tax);
              // taxIndex++;
              //     }
              //   }

              //   index++;
              // }
              // taxList.insert(
              //     0,
              //     TaxModel(
              //       orderIndex: 0,
              //       token: '',
              //       sysDocId: sysDocId.value,
              //       voucherId: voucherNumber.value,
              //       rowIndex: -1,
              //       taxItemName: '',
              //       taxAmount: salesScreenController.totalTax.value,
              //       taxLevel: 2,
              //       taxGroupId: 'TAX01',
              //       accountId: '',
              //       currencyId: '',
              //       currencyRate: 1,
              //       calculationMethod: '1',
              //       taxRate: 5,
              //       taxItemId: 'VAT5',
              //     ));
            }
            Map<String, Map<String, dynamic>> groupedTaxDetails = {};
            developer.log("${taxList}   taxssssss");
            taxList.forEach((taxDetail) {
              if (!groupedTaxDetails.containsKey(taxDetail.taxItemId)) {
                groupedTaxDetails[taxDetail.taxItemId!] = {
                  // 'taxRateSum': 0.0,
                  'taxAmount': 0.0,
                };
              }
              // TaxModel item = salesInvoiceList.firstWhere(
              //     (element) => element.rowIndex == taxDetail.orderIndex,
              //     orElse: () => TaxModel());
              groupedTaxDetails[taxDetail.taxItemId]?['taxRate'] =
                  taxDetail.taxRate;
              groupedTaxDetails[taxDetail.taxItemId]?['taxAmount'] +=
                  (taxDetail.taxAmount);
            });
            developer.log("${groupedTaxDetails.values}");
            groupedTaxDetails.forEach((taxCode, values) {
              // print('Tax Code: $taxCode');
              // print('Total Tax Rate: ${values['taxRate']}');
              // print('Total Tax Amount: ${values['taxAmountSum']}');
              // print('---');
              // var taxAmountSum = values['taxAmountSum'];
              // if (header.isReturn == 1) {
              //   taxAmountSum = 0 - values['taxAmountSum'];
              // }
              taxList.insert(
                  0,
                  TaxModel(
                      calculationMethod: "1",
                      taxItemId: taxCode,
                      taxRate: values['taxRate'],
                      taxGroupId: customer.value.taxGroupId ?? "",
                      currencyId: "",
                      orderIndex: 0,
                      rowIndex: -1,
                      sysDocId: sysDocId.value,
                      taxAmount: double.parse(
                          InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                                  values['taxAmount'])
                              .toStringAsFixed(2)),
                      accountId: '',
                      currencyRate: 1,
                      taxLevel: 2,
                      taxItemName: '',
                      token: '',
                      voucherId: voucherNumber.value));
              taxAmount += double.parse(
                  InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                          values['taxAmount'])
                      .toStringAsFixed(2));
            });
            if (confirmation == false) {
              isSaving.value = false;
              return;
            }
            await loginController.getToken();
            if (loginController.token.value.isEmpty) {
              await loginController.getToken();
            }
            final String token = loginController.token.value;
            String data = jsonEncode({
              "token": token,
              "Isnewrecord": isNewRecord.value,
              "Sysdocid": sysDocId.value,
              "Voucherid": voucherNumber.value,
              "Companyid": "1",
              "Divisionid": "",
              "Customerid": customerId.value,
              "Transactiondate": transactionDate.value.toIso8601String(),
              "Salespersonid": "",
              "Salesflow": salesFlow.value,
              "Shippingaddress": shippingAddress.value,
              "Shiptoaddress": billingAddress.value,
              "Billingaddress": "",
              "Customeraddress": "",
              "Priceincludetax": false,
              "Status": 0,
              "Currencyid":
                  homeController.companyInfoInstance.value.baseCurrencyId ?? '',
              "Currencyrate": 1,
              "Currencyname": "",
              "Termid": "",
              "Shippingmethodid": "",
              "Reference": "",
              "Reference2": "",
              "Note": remarks.value,
              "POnumber": "",
              "Isvoid": false,
              "Discount": InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                  salesScreenController.discount.value),
              "Total": InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                  salesScreenController.total.value),
              "Taxamount": InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                  salesScreenController.totalTax.value),
              "Sourcedoctype": 0,
              "Jobid": "",
              "Costcategoryid": "",
              "Payeetaxgroupid": customer.value.taxGroupId ?? '',
              "Taxoption": customer.value.taxOption ?? '',
              "Roundoff": 0,
              "Ordertype": 0,
              "IsWeightInvoice": false,
              "ReportTo": "",
              "DriverID": "",
              "VehicleID": "",
              "Advanceamount": 0,
              "SalesInvoiceDetails": list,
              "TaxDetails": taxList,
              "SalesExpenseDetails": []
            });
            dynamic result;
            developer.log("${data}");
            try {
              var feedback = await ApiServices.fetchDataRawBody(
                  api: 'CreateSalesInvoice', data: data);
              if (feedback != null) {
                if (feedback["res"] == 0) {
                  message.value = feedback["msg"] ?? 'Failed Saving';
                  result = ErrorResponseModel.fromJson(feedback);
                  response.value = result.res;
                } else {
                  result = CreateSalesOrderResponseModel.fromJson(feedback);
                  response.value = result.res;
                }
              }
              isSaving.value = false;
            } finally {
              if (response.value == 1) {
                // getSalesOrderPrint(result.docNo);
                // getSalesOrderPdf(result.docNo);
                clearData();
                getVoucherNumber(sysDocId.value, sysDocName.value);
                SnackbarServices.successSnackbar(
                    'Successfully Saved as Doc No : ${result.docNo}');
                generateCustomerList();
              } else {
                SnackbarServices.errorSnackbar(result.err ?? message.value);
              }
            }
          }
        } else {
          SnackbarServices.errorSnackbar('Please select any Customer !');
        }
      } else {
        SnackbarServices.errorSnackbar('Pick Any Voucher !');
      }
    } else {
      SnackbarServices.errorSnackbar('Please add Products first !');
    }
  }

  Future<bool> isBelowCost(
      {required String productId,
      required String unitId,
      required double price}) async {
    isOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String currencyId =
        homeController.companyInfoInstance.value.baseCurrencyId ?? '';

    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'IsBelowCost?token=${token}&itemCode=${productId}&unitID=${unitId}&currencyID=${currencyId}&currencyRate=1&price=$price');
      if (feedback != null) {
        developer.log(feedback.toString(), name: 'is Less Cost');
      }
      return feedback != null ? feedback['result'] : false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> lessCostWarning(String product) async {
    developer.log(
        homeController.companyInfoInstance.value.pricelessCostAction.toString(),
        name: 'is Action');
    if (homeController.companyInfoInstance.value.pricelessCostAction == 1) {
      return true;
    } else if (homeController.companyInfoInstance.value.pricelessCostAction ==
        2) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              "The price of $product is less than the cost . Do you want to continue?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
      return result ?? false; // If null, default to false.
    } else if (homeController.companyInfoInstance.value.pricelessCostAction ==
        3) {
      SnackbarServices.errorSnackbar(
          'The price of $product should not fall below the cost');
      return false;
    } else {
      return false;
    }
    // Condition not met, user can continue.
  }

  getSalesInvoiceOpenList() async {
    isOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String sysDoc = sysDocId.value;
    final String fromDate = this.fromDate.value.toIso8601String();
    final String toDate = this.toDate.value.toIso8601String();
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesInvoiceOpenList?token=${token}&fromDate=${fromDate}&toDate=${toDate}&sysDocID=${sysDoc}');
      if (feedback != null) {
        result = SalesInvoiceOpenListModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        salesInvoiceOpenList.value = result.modelobject;
        isOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(salesInvoiceOpenList.length.toString(),
            name: 'All sales open list');
      }
    }
  }

  getOpenSalesOrdersSummaryList() async {
    isSalesSummaryOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    final String customerID = customerId.value;

    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCustomer(
          api: 'GetOpenSalesOrdersSummary?token=$token&customerID=$customerID');
      if (feedback != null) {
        result = GetOpenSalesOrdersSummaryModel.fromJson(feedback);
        print("reult:${result.res}");
        response.value = result.res;
        salesordersummaryOpenList.value = result.model;
        isSalesSummaryOpenListLoading.value = false;
        update();
      }
    } finally {
      isOpenListLoading.value = false;
      if (response.value == 1) {
        developer.log(salesordersummaryOpenList.length.toString(),
            name: ' open list');
      }
    }
  }

  getSalesInvoiceById(String sysDoc, String voucher) async {
    isSalesInvoiceByIdLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesInvoiceByid?token=${token}&sysDocID=${sysDoc}&voucherID=${voucher}');
      if (feedback != null) {
        result = SalesInvoiceByIdModel.fromJson(feedback);
        response.value = result.result;
      } else {
        isSalesInvoiceByIdLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        loadSalesInvoiceFromCloud(result);
      } else {
        isSalesInvoiceByIdLoading.value = false;
      }
    }
  }

  getSalesOrderById(String sysDoc, String voucher) async {
    isSalesSummaryOpenListLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesOrderByid?token=${token}&sysDocID=${sysDoc}&voucherID=${voucher}');
      if (feedback != null) {
         developer.log("${feedback.toString()} companyPreference1");

        result = SalesOrderByIdModel.fromJson(feedback);
        response.value = result.result;
      } else {
        isSalesSummaryOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        loadSalesOrderFromCloud(result);
      } else {
        isSalesSummaryOpenListLoading.value = false;
      }
    }
  }

  loadSalesOrderFromCloud(dynamic result) async {
    await clearData();
    isNewRecord.value = true;
    transactionDate.value = result.header[0].transactionDate;
    dueDate.value = result.header[0].dueDate;
    customerId.value = result.header[0].customerId;
    if (homeController.customerList.isEmpty) {
      await homeController.getCustomerList();
    }
    customer.value = homeController.customerList.firstWhere(
        (element) => element.code == customerId.value,
        orElse: (() => developer.log('eroorrrrrrr')));
    // voucherNumber.value = result.header[0].voucherId;

    // sysDocId.value = result.header[0].sysDocId;
    orderSysDocId.value = result.header[0].sysDocId;
    orderVoucherNumber.value = result.header[0].voucherId;
    shippingAddress.value=result.header[0].shippingAddressId;
    billingAddress.value=result.header[0].billingAddressId;
    // var selectedSysDoc =
    //     sysDocList.where((element) => element.code == sysDocId.value).first;
    // sysDocName.value = selectedSysDoc.name;

    salesScreenController.subTotal.value = result.header[0].total.toDouble();

    salesScreenController.total.value = result.header[0].total.toDouble();
  

    salesScreenController.discount.value = result.header[0].discount.toDouble();
    salesScreenController.totalTax.value = result.header[0].taxAmount != null
        ? result.header[0].taxAmount.toDouble()
        : 0.0;

    salesScreenController.calculateDiscount(
        salesScreenController.discount.value.toString(), false);
    remarks.value = result.detail[0].remarks;
    for (var product in result.detail) {
      List<TaxModel> taxList = [];
      double qty = product.unitQuantity == null ||
              product.unitQuantity == 0 ||
              product.unitQuantity == ""
          ? product.quantity.toDouble()
          : product.unitQuantity.toDouble();

      if (result.taxDetail.isNotEmpty) {
        for (var tax in result.taxDetail) {
          if (tax.orderIndex == product.rowIndex) {
            taxList.add(TaxModel(
              sysDocId: tax.sysDocId,
              voucherId: tax.voucherId,
              taxLevel: tax.taxLevel,
              taxGroupId: tax.taxGroupId,
              calculationMethod: tax.calculationMethod.toString(),
              taxItemName: tax.taxItemName,
              taxItemId: tax.taxItemId,
              taxRate: tax.taxRate.toDouble(),
              taxAmount: tax.taxAmount != null
                  ? (tax.taxAmount / qty).toDouble()
                  : 0.0,
              currencyId: tax.currencyId,
              currencyRate: tax.currencyRate.toDouble(),
              orderIndex: tax.orderIndex,
              rowIndex: tax.rowIndex,
              accountId: tax.accountId,
            ));
          }
        }
      }

      salesInvoiceList.add(
        ProductDetailsModel(
            res: 1,
            model: [
              SingleProduct(
                productId: product.productId,
                description: product.description1,
                taxGroupId: product.taxGroupId,
                taxOption: product.taxOption,
                updatedQuantity: product.unitQuantity == null ||
                        product.unitQuantity == 0 ||
                        product.unitQuantity == ""
                    ? product.quantity.toDouble()
                    : product.unitQuantity.toDouble(),
                updatedUnitId: product.unitId,
                updatedPrice: product.unitPrice.toDouble(),
                remarks: product.remarks,
                price1: product.unitPrice.toDouble(),
                locationId: product.locationId,
                taxAmount: product.taxAmount != null
                    ? (product.taxAmount / qty).toDouble()
                    : 0.0,
              )
            ],
            unitmodel: [],
            productlocationmodel: [],
            taxList: taxList,
            msg: ''),
      );
    }
    isSalesInvoiceByIdLoading.value = false;
  }

  loadSalesInvoiceFromCloud(dynamic result) async {
    await clearData();
    isNewRecord.value = false;
    transactionDate.value = result.header[0].transactionDate;
    dueDate.value = result.header[0].dueDate;
    customerId.value = result.header[0].customerId;
    if (homeController.customerList.isEmpty) {
      await homeController.getCustomerList();
    }
    customer.value = homeController.customerList.firstWhere(
        (element) => element.code == customerId.value,
        orElse: (() => developer.log('eroorrrrrrr')));
    voucherNumber.value = result.header[0].voucherId;

    sysDocId.value = result.header[0].sysDocId;

    var selectedSysDoc =
        sysDocList.where((element) => element.code == sysDocId.value).first;
    sysDocName.value = selectedSysDoc.name;

    salesScreenController.subTotal.value = result.header[0].total.toDouble();

    salesScreenController.total.value = result.header[0].total.toDouble();

    salesScreenController.discount.value = result.header[0].discount.toDouble();
    salesScreenController.totalTax.value = result.header[0].taxAmount != null
        ? result.header[0].taxAmount.toDouble()
        : 0.0;

    salesScreenController.calculateDiscount(
        salesScreenController.discount.value.toString(), false);
    remarks.value = result.detail[0].remarks;
    for (var product in result.detail) {
      List<TaxModel> taxList = [];
      double qty = product.unitQuantity == null ||
              product.unitQuantity == 0 ||
              product.unitQuantity == ""
          ? product.quantity.toDouble()
          : product.unitQuantity.toDouble();

      if (result.taxDetail.isNotEmpty) {
        for (var tax in result.taxDetail) {
          if (tax.orderIndex == product.rowIndex) {
            taxList.add(TaxModel(
              sysDocId: tax.sysDocId,
              voucherId: tax.voucherId,
              taxLevel: tax.taxLevel,
              taxGroupId: tax.taxGroupId,
              calculationMethod: tax.calculationMethod.toString(),
              taxItemName: tax.taxItemName,
              taxItemId: tax.taxItemId,
              taxRate: tax.taxRate.toDouble(),
              taxAmount: tax.taxAmount != null
                  ? (tax.taxAmount / qty).toDouble()
                  : 0.0,
              currencyId: tax.currencyId,
              currencyRate: tax.currencyRate.toDouble(),
              orderIndex: tax.orderIndex,
              rowIndex: tax.rowIndex,
              accountId: tax.accountId,
            ));
          }
        }
      }

      salesInvoiceList.add(
        ProductDetailsModel(
            res: 1,
            model: [
              SingleProduct(
                productId: product.productId,
                description: product.description1,
                taxGroupId: product.taxGroupId,
                taxOption: product.taxOption,
                updatedQuantity: product.unitQuantity == null ||
                        product.unitQuantity == 0 ||
                        product.unitQuantity == ""
                    ? product.quantity.toDouble()
                    : product.unitQuantity.toDouble(),
                updatedUnitId: product.unitId,
                updatedPrice: product.unitPrice.toDouble(),
                remarks: product.remarks,
                price1: product.unitPrice.toDouble(),
                locationId: product.locationId,
                taxAmount: product.taxAmount != null
                    ? (product.taxAmount / qty).toDouble()
                    : 0.0,
              )
            ],
            unitmodel: [],
            productlocationmodel: [],
            taxList: taxList,
            msg: ''),
      );
    }
    isSalesInvoiceByIdLoading.value = false;
  }

  selectDateRange(int value, int index) async {
    dateIndex.value = index;
    isEqualDate.value = false;
    isFromDate.value = false;
    isToDate.value = false;
    if (value == 16) {
      isFromDate.value = true;
      isToDate.value = true;
    } else if (value == 15) {
      isFromDate.value = true;
      isEqualDate.value = true;
    } else {
      DateTimeRange dateTime = await DateRangeSelector.getDateRange(value);
      fromDate.value = dateTime.start;
      toDate.value = dateTime.end;
    }
  }

  selectDate(context, bool isFrom) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      isFrom ? fromDate.value = newDate : toDate.value = newDate;
      if (isEqualDate.value) {
        toDate.value = fromDate.value;
      }
    }
    update();
  }
  // addOrUpdateProductToSales(Products product, bool isAdding,
  //     ProductDetailsModel single, int index, BuildContext context) async {
  //   final TextEditingController priceController = TextEditingController();
  //   isAdding
  //       ? quantity.value = 1
  //       : quantity.value = single.model[0].updatedQuantity;
  //   if (isAdding == false) {
  //     unit.value = single.model[0].updatedUnitId!;
  //     unitList.value = single.unitmodel;
  //     price.value = single.model[0].updatedPrice!;
  //     quantityControl.text = quantity.value.toString();
  //   }
  //   if (isAdding == true) {
  //     getProductDetails(product.productId!);
  //     // price.value = singleProduct.value.model[0].price1;
  //     quantityControl.text = quantity.value.toString();
  //   }
  //   isPriceEdited.value = false;

  //   Get.defaultDialog(
  //       barrierDismissible: false,
  //       titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //       title: product.description ?? '',
  //       titleStyle: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.black,
  //       ),
  //       content: Obx(() {
  //         if (isProductLoading.value == false) {
  //           priceController.text = isAdding
  //               ? singleProduct.value.model[0].price1.toString()
  //               : single.model[0].updatedPrice.toString();
  //         }
  //         return isProductLoading.value
  //             ? SalesShimmer.popUpShimmer()
  //             : Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: const [
  //                       Text(
  //                         'Quantity ',
  //                         style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w400,
  //                             color: AppColors.primary),
  //                       ),
  //                       Center(
  //                         child: Text(
  //                           'Stock',
  //                           style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w400,
  //                               color: AppColors.primary),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Flexible(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                           children: [
  //                             InkWell(
  //                               onTap: () {
  //                                 decrementQuantity();
  //                               },
  //                               child: CircleAvatar(
  //                                 backgroundColor: AppColors.primary,
  //                                 radius: 15,
  //                                 child:
  //                                     const Center(child: Icon(Icons.remove)),
  //                               ),
  //                             ),
  //                             Obx(() {
  //                               quantityControl.selection =
  //                                   TextSelection.fromPosition(TextPosition(
  //                                       offset: quantityControl.text.length));
  //                               return Flexible(
  //                                 child: edit.value
  //                                     ? TextField(
  //                                         autofocus: false,
  //                                         controller: quantityControl,
  //                                         textAlign: TextAlign.center,
  //                                         keyboardType: TextInputType.number,
  //                                         decoration:
  //                                             const InputDecoration.collapsed(
  //                                                 hintText: ''),
  //                                         onChanged: (value) {
  //                                           setQuantity(value);
  //                                         },
  //                                         onTap: () =>
  //                                             quantityControl.selectAll(),
  //                                       )
  //                                     : Obx(
  //                                         () => InkWell(
  //                                           onTap: () {
  //                                             editQuantity();
  //                                           },
  //                                           child:
  //                                               Text(quantity.value.toString()),
  //                                         ),
  //                                       ),
  //                               );
  //                             }),
  //                             InkWell(
  //                               onTap: () {
  //                                 incrementQuantity();
  //                               },
  //                               child: CircleAvatar(
  //                                 backgroundColor: AppColors.primary,
  //                                 radius: 15,
  //                                 child: const Center(child: Icon(Icons.add)),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Flexible(
  //                         child: Center(
  //                           child: Text(
  //                             InventoryCalculations.roundOffQuantity(
  //                               quantity: isAdding
  //                                   ? singleProduct.value.model[0].quantity ??
  //                                       0.0
  //                                   : single.model[0].quantity ?? 0.0,
  //                             ),
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w400,
  //                                 color: AppColors.primary),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 10),
  //                     child: Row(
  //                       children: [
  //                         Flexible(
  //                           child: DropdownButtonFormField2(
  //                             decoration: InputDecoration(
  //                               isCollapsed: true,
  //                               contentPadding:
  //                                   EdgeInsets.symmetric(vertical: 5),
  //                               label: Padding(
  //                                 padding: EdgeInsets.all(8.0),
  //                                 child: Text(
  //                                   unit.value,
  //                                   style: TextStyle(
  //                                       color: AppColors.primary, fontSize: 12),
  //                                 ),
  //                               ),
  //                               border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(10),
  //                               ),
  //                             ),
  //                             icon: Icon(
  //                               Icons.arrow_drop_down,
  //                               color: AppColors.primary,
  //                             ),
  //                             iconSize: 20,
  //                             // buttonHeight: 4.5.w,
  //                             buttonPadding:
  //                                 const EdgeInsets.only(left: 20, right: 10),
  //                             dropdownDecoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(15),
  //                             ),
  //                             items: unitList
  //                                 .map(
  //                                   (item) => DropdownMenuItem(
  //                                     value: item.code,
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           item.code,
  //                                           style: TextStyle(
  //                                             fontSize: 12,
  //                                             color: AppColors.primary,
  //                                             // fontWeight: FontWeight.w400,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 )
  //                                 .toList(),
  //                             onChanged: (value) {
  //                               var selectedUnit = value;
  //                               String unit = selectedUnit.toString();
  //                               changeUnit(unit);
  //                             },
  //                             onSaved: (value) {},
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Flexible(
  //                           child: TextField(
  //                             controller: priceController,
  //                             onChanged: (value) => changePrice(value),
  //                             onTap: () => priceController.selectAll(),
  //                             keyboardType: TextInputType.number,
  //                             style: const TextStyle(
  //                                 fontSize: 16, color: Colors.black),
  //                             decoration: InputDecoration(
  //                               border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 borderSide: const BorderSide(
  //                                     color: AppColors.mutedColor, width: 0.1),
  //                               ),
  //                               isCollapsed: true,
  //                               contentPadding: const EdgeInsets.symmetric(
  //                                   vertical: 10, horizontal: 15),
  //                               labelText: 'Price',
  //                               labelStyle: TextStyle(
  //                                   color: AppColors.primary, fontSize: 12),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               );
  //       }),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColors.mutedBlueColor,
  //               ),
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w400,
  //                     color: AppColors.primary),
  //               ),
  //               onPressed: () {
  //                 quantity.value = 1.0;
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.primary,
  //                 ),
  //                 child: Text(
  //                   isAdding ? 'Add' : 'Update',
  //                   style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w400,
  //                       color: Colors.white),
  //                 ),
  //                 onPressed: isAdding
  //                     ? () async {
  //                         double taxAmount = 0.0;
  //                         if (isProductLoading.value == false) {
  //                           var taxList = await TaxHelper.calculateTax(
  //                               taxGroupId: singleProduct
  //                                   .value.model[0].taxGroupId
  //                                   .toString(),
  //                               price: isPriceEdited.value
  //                                   ? price.value
  //                                   : singleProduct.value.model[0].price1,
  //                               isExclusive: true);
  //                           for (var tax in taxList) {
  //                             taxAmount += tax.taxAmount;
  //                           }

  //                           singleProduct.value.taxList = taxList;
  //                           singleProduct.value.model[0].taxAmount = taxAmount;
  //                           singleProduct.value.model[0].updatedQuantity =
  //                               quantity.value;
  //                           singleProduct.value.model[0].updatedUnitId =
  //                               unit.value;
  //                           singleProduct.value.model[0].updatedPrice =
  //                               isPriceEdited.value
  //                                   ? price.value
  //                                   : singleProduct.value.model[0].price1;
  //                           salesInvoiceList.add(singleProduct.value);

  //                           isPriceEdited.value
  //                               ? calculateTotal(
  //                                   price.value,
  //                                   singleProduct
  //                                       .value.model[0].updatedQuantity)
  //                               : calculateTotal(
  //                                   singleProduct.value.model[0].price1,
  //                                   singleProduct
  //                                       .value.model[0].updatedQuantity);
  //                           calculateTotalTax(taxAmount);

  //                           quantity.value = 1.0;
  //                           Navigator.pop(context);
  //                           Navigator.pop(context);
  //                           developer.log(salesInvoiceList.length.toString(),
  //                               name: 'salesInvoiceList.length');
  //                         } else {
  //                           SnackbarServices.errorSnackbar(
  //                               'Quantity is not available');
  //                         }
  //                       }
  //                     : () async {
  //                         double taxAmount = 0.0;
  //                         var taxList = await TaxHelper.calculateTax(
  //                             taxGroupId: single.model[0].taxGroupId.toString(),
  //                             price: price.value,
  //                             isExclusive: true);

  //                         for (var tax in taxList) {
  //                           taxAmount += tax.taxAmount;
  //                         }
  //                         subTotal.value = subTotal.value -
  //                             (single.model[0].updatedPrice *
  //                                 single.model[0].updatedQuantity);
  //                         total.value = total.value -
  //                             (single.model[0].updatedPrice *
  //                                 single.model[0].updatedQuantity);
  //                         single.taxList = taxList;
  //                         single.model[0].updatedQuantity = quantity.value;
  //                         single.model[0].updatedUnitId = unit.value;
  //                         single.model[0].updatedPrice = price.value;
  //                         single.model[0].taxAmount = taxAmount;
  //                         salesInvoiceList.insert(index, single);
  //                         salesInvoiceList.removeAt(index + 1);
  //                         totalTax.value =
  //                             totalTax.value - single.model[0].taxAmount;

  //                         calculateTotal(
  //                             price.value, single.model[0].updatedQuantity);
  //                         calculateTotalTax(taxAmount);

  //                         Navigator.pop(context);
  //                         developer.log(salesInvoiceList.length.toString(),
  //                             name: 'salesInvoiceList.length');
  //                         // refresh();
  //                       }),
  //           ],
  //         ),
  //       ]);
  // }
}
