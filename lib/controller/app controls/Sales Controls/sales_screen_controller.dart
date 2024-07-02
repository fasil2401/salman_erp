import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/filter_sys_doc_model.dart';
import 'package:axolon_erp/model/system_doc_list_model.dart';
import 'package:axolon_erp/model/user_by_id_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/discount_calculations.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

class SalesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // getUserById();
    // getSystemDocList();
  }

  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var response = 0.obs;
  var user = UserModel().obs;
  var sysDocList = [].obs;
  var sysDocFilterList = [].obs;
  var sysDoc = SysDocModel().obs;
  var userEntityLinks = <FilterSysDocModel>[].obs;
  var filteredEntitySysDocId = [].obs;

  // getUserById() async {
  //   isLoading.value = true;
  //   await loginController.getToken();
  //   if (loginController.token.value.isEmpty) {
  //     await loginController.getToken();
  //   }
  //   final String token = loginController.token.value;
  //   final String userId = await UserSimplePreferences.getUsername() ?? '';
  //   dynamic result;
  //   try {
  //     var feedback = await ApiServices.fetchData(
  //         api: 'GetUserByID?token=${token}&userid=${userId}');
  //     if (feedback != null) {
  //       isLoading.value = false;
  //       result = UserByIdModel.fromJson(feedback);
  //       print(result);

  //       response.value = result.res;
  //       user.value = result.model[0];
  //     }
  //     isLoading.value = false;
  //   } finally {
  //     if (response.value == 1) {
  //       isLoading.value = false;
  //       getSystemDocList();
  //     }
  //   }
  // }

  getSystemDocList() async {
    developer.log('Entering sysdoc');
    isLoading.value = true;
    // await loginController.getToken();
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetSystemDocumentByUserList?token=${token}');
      if (feedback != null) {
        result = SystemDoccumentListModel.fromJson(feedback);
        response.value = result.res;
        sysDocList.value = result.model;
        sysDocFilterList.value = sysDocList;
        isLoading.value = false;
      }
      isLoading.value = false;
      if (response.value == 1) {
        getFilterSysDoclist();
      }
    } finally {
      isLoading.value = false;
    }
  }

  getFilterSysDoclist() async {
    isLoading.value = true;
    userEntityLinks.clear();
    filteredEntitySysDocId.clear();
    // await loginController.getToken();
    final String token = loginController.token.value;
    // final String divisionId = homeController.user.value.defaultCompanyDivisionId ?? '';
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api: 'GetUserEntityLinks?token=$token&entityType=5');
      developer.log("${feedback} feeedback");
      if (feedback != null) {
        result = GetFilterSysDoclistModel.fromJson(feedback);
        userEntityLinks.value = result.modelobject;

        isLoading.value = false;
      }
      isLoading.value = false;
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
      }
    }
  }

  bool containsMatchingObject({required var element, required int type}) {
    // Check if any object in list1 has the parameter equal to the condition
    return userEntityLinks.any((obj2) {
      return obj2.sysDocId == element.code && obj2.sysDocType == type;
    });
  }

  searchSysDoc(String value, int type) {
    var list = sysDocList.where((element) => element.sysDocType == type);
    sysDocFilterList.value = list
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  filterSysDoc(int type, var lists) {
    var list = lists.where((element) => element.sysDocType == type).toList();
    sysDocFilterList.value = list;
    // sysDocTempList.value = sysDocFilterList;
  }

  selectSysDoc(
      {required BuildContext context,
      required int sysDocType,
      required var list}) async {
    if (sysDocList.isEmpty && isLoading.value == false) {
      getSystemDocList();
    }
    await filterSysDoc(sysDocType, list);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              'System Document',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  searchSysDoc(value, sysDocType);
                },
                onEditingComplete: () async {
                  await changeFocus(context);
                },
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => isLoading.value
                        ? SalesShimmer.locationPopShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: sysDocFilterList.length,
                            itemBuilder: (context, index) {
                              var sysDoc = sysDocFilterList[index];
                              return InkWell(
                                onTap: <SysDocModel>() async {
                                  this.sysDoc.value = sysDoc;
                                  Navigator.pop(context);
                                  // Future.delayed(Duration(milliseconds: 1), () {
                                  //   sysDocFilterList.value = sysDocList;
                                  // });
                                  return this.sysDoc.value;
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      "${sysDoc.code} - ${sysDoc.name}",
                                      minFontSize: 12,
                                      maxFontSize: 16,
                                      style: TextStyle(
                                        color: AppColors.mutedColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      this.sysDoc.value = SysDocModel();
                      // Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return sysDoc.value;
  }

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //////////////////////////-------------------------------------------
  var singleProduct = ProductDetailsModel(
          res: 1, model: [], unitmodel: [], productlocationmodel: [], msg: '')
      .obs;
  var quantity = 1.0.obs;
  var unit = ''.obs;
  var price = 0.0.obs;
  var isPriceEdited = false.obs;
  var unitList = [].obs;
  var availableStock = 0.0.obs;
  var minPrice = 0.0.obs;
  var edit = false.obs;
  var quantityControl = TextEditingController();
  var priceController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var isProductLoading = false.obs;
  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var discountPercentage = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;

  ///-------------------------------------------------
  decrementQuantity() {
    if (quantity.value > 1) {
      edit.value = false;
      quantity.value--;
    }
  }

  incrementQuantity() {
    edit.value = false;
    quantity.value++;
  }

  // editQuantity() {
  //   edit.value = !edit.value;
  // }
  editQuantity() {
    edit.value = !edit.value;
    quantityControl.text = quantity.value.toString();
  }

  setQuantity(String value) {
    value.isNotEmpty
        ? quantity.value = double.parse(value)
        : quantity.value = 1.0;
  }

  addOrUpdateProductToSales(
      {required Products product,
      required bool isAdding,
      required bool isScanning,
      required ProductDetailsModel single,
      required int index,
      required BuildContext context,
      var list,
      required String customerId}) async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == false) {
      SnackbarServices.errorSnackbar('No Internet Connection');
      return;
    }
    isPriceEdited.value = false;
    isAdding
        ? quantity.value = 1
        : quantity.value = single.model[0].updatedQuantity;
    if (isAdding == false) {
      unit.value = single.model[0].updatedUnitId!;
      unitList.value = single.unitmodel;
      price.value = single.model[0].updatedPrice!;
      quantityControl.text = quantity.value.toString();
      availableStock.value = single.model[0].selectedStock ?? 0.0;
    }
    if (isAdding == true) {
      getProductDetails(
          product.productId ?? '', context, isScanning, customerId);
      quantityControl.text = quantity.value.toString();
    }
    isPriceEdited.value = false;
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          scrollable: true,
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          title: Text(
            product.description ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(child: Obx(() {
                if (isProductLoading.value == false &&
                    isPriceEdited.value == false) {
                  priceController.value.text = isAdding
                      ? InventoryCalculations.formatPrice(
                          singleProduct.value.model[0].price1.toDouble())
                      : InventoryCalculations.formatPrice(
                          single.model[0].updatedPrice.toDouble());
                  remarksController.value.text =
                      isAdding ? '' : single.model[0].remarks ?? "";
                  developer.log(
                      'updating price controller${priceController.value.text}');
                  if (isAdding == false) {
                    var units = unitList.firstWhere(
                      (element) => element.code == unit.value,
                      orElse: () => null,
                    );
                    if (units != null) {
                      minPrice.value = InventoryCalculations.getStockPerFactor(
                          factorType: units.factorType,
                          factor: double.parse(units.factor!),
                          stock: singleProduct.value.model[0].minPrice);
                    }
                  } else {
                    minPrice.value = singleProduct.value.model[0].minPrice;
                  }
                }
                return isProductLoading.value
                    ? SalesShimmer.popUpShimmer()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text(
                                'Quantity ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary),
                              ),
                              Center(
                                child: Text(
                                  'Stock',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        decrementQuantity();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        radius: 15,
                                        child: const Center(
                                            child: Icon(Icons.remove)),
                                      ),
                                    ),
                                    Obx(() {
                                      quantityControl.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: quantityControl
                                                      .text.length));
                                      return Flexible(
                                        child: edit.value
                                            ? TextField(
                                                autofocus: false,
                                                controller: quantityControl,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration
                                                            .collapsed(
                                                        hintText: ''),
                                                onChanged: (value) {
                                                  setQuantity(value);
                                                },
                                                onTap: () =>
                                                    quantityControl.selectAll(),
                                              )
                                            : Obx(
                                                () => InkWell(
                                                  onTap: () {
                                                    editQuantity();
                                                  },
                                                  child: Text(quantity.value
                                                      .toString()),
                                                ),
                                              ),
                                      );
                                    }),
                                    InkWell(
                                      onTap: () {
                                        incrementQuantity();
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        radius: 15,
                                        child: Center(child: Icon(Icons.add)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    InventoryCalculations.roundOffQuantity(
                                      quantity: availableStock.value,
                                    ),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Flexible(
                                  child: DropdownButtonFormField2(
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          unit.value,
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 12),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.primary,
                                    ),
                                    iconSize: 20,
                                    // buttonHeight: 4.5.w,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    items: unitList
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.code,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.primary,
                                                    // fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      developer.log(value.toString());
                                      Unitmodel selectedUnit =
                                          value as Unitmodel;
                                      // String unit = selectedUnit.code.toString();
                                      if (isAdding &&
                                          availableStock.value != 0.0) {
                                        availableStock.value =
                                            InventoryCalculations
                                                .getStockPerFactor(
                                                    factorType: selectedUnit
                                                        .factorType!,
                                                    factor:
                                                        double
                                                            .parse(
                                                                selectedUnit
                                                                    .factor!),
                                                    stock: singleProduct.value
                                                        .model[0].quantity);
                                      } else if (availableStock.value != 0.0) {
                                        availableStock.value =
                                            InventoryCalculations
                                                .getStockPerFactor(
                                                    factorType:
                                                        selectedUnit
                                                            .factorType!,
                                                    factor: double.parse(
                                                        selectedUnit.factor!),
                                                    stock: single
                                                        .model[0].quantity);
                                      }
                                      if (isAdding) {
                                        changeUnit(
                                            value: selectedUnit,
                                            price: singleProduct
                                                .value.model[0].price1,
                                            minPrice: singleProduct
                                                .value.model[0].minPrice);
                                      } else {
                                        changeUnit(
                                            value: selectedUnit,
                                            price: single.model[0].price1,
                                            minPrice: single.model[0].minPrice);
                                      }
                                    },
                                    onSaved: (value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Obx(
                                    () => TextField(
                                      controller: priceController.value,
                                      onChanged: (value) => changePrice(value),
                                      onTap: () =>
                                          priceController.value.selectAll(),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: AppColors.mutedColor,
                                              width: 0.1),
                                        ),
                                        isCollapsed: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                        labelText: 'Price',
                                        labelStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: TextStyle(
                                fontSize: 12, color: AppColors.mutedColor),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColors.mutedColor, width: 0.1),
                              ),
                              labelText: "Remarks",
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                            autofocus: false,
                            maxLines: 5,
                            maxLength: 3000,
                            controller: remarksController.value,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          )
                        ],
                      );
              }))),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mutedBlueColor,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary),
                  ),
                  onPressed: () {
                    quantity.value = 1.0;
                    Navigator.of(context).pop();
                    if (isScanning) {
                      Navigator.pop(context);
                    }
                    // Get.back();
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      isAdding ? 'Add' : 'Update',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    onPressed: isAdding
                        ? () async {
                            double taxAmount = 0.0;
                            if (isProductLoading.value == false) {
                              bool minprice =
                                  await minPriceWarning(minPrice.value);
                              if (minprice == true) {
                                await addItem(context, taxAmount, list);
                              }
                            } else {
                              SnackbarServices.errorSnackbar(
                                  'Quantity is not available');
                            }
                          }
                        : () async {
                            bool minprice =
                                await minPriceWarning(minPrice.value);
                            if (minprice == true) {
                              updateItem(context, single, index, list);
                            }
                          }),
              ],
            ),
          ],
        ));
  }

  addItem(BuildContext context, taxAmount, var list) async {
    var taxList = await TaxHelper.calculateTax(
        taxGroupId: singleProduct.value.model[0].taxGroupId.toString(),
        price: isPriceEdited.value
            ? price.value
            : singleProduct.value.model[0].price1,
        isExclusive: true);
    for (var tax in taxList) {
      taxAmount += tax.taxAmount;
    }

    singleProduct.value.taxList = taxList;
    singleProduct.value.model[0].taxAmount = taxAmount;
    singleProduct.value.model[0].updatedQuantity = quantity.value;
    singleProduct.value.model[0].updatedUnitId = unit.value;
    singleProduct.value.model[0].updatedPrice =
        isPriceEdited.value ? price.value : singleProduct.value.model[0].price1;
    singleProduct.value.model[0].selectedStock = availableStock.value;
    singleProduct.value.model[0].remarks = remarksController.value.text;
    list.add(singleProduct.value);

    isPriceEdited.value
        ? calculateTotal(
            price.value, singleProduct.value.model[0].updatedQuantity)
        : calculateTotal(singleProduct.value.model[0].price1,
            singleProduct.value.model[0].updatedQuantity);
    calculateTotalTax(taxAmount, singleProduct.value.model[0].updatedQuantity);

    quantity.value = 1.0;
    Navigator.pop(context);
    Navigator.pop(context);
    developer.log(list.length.toString(), name: 'salesOrderList.length');
  }

  updateItem(BuildContext context, ProductDetailsModel single, int index,
      var list) async {
    double taxAmount = 0.0;
    var taxList = await TaxHelper.calculateTax(
        taxGroupId: single.model[0].taxGroupId.toString(),
        price: price.value,
        isExclusive: true);

    for (var tax in taxList) {
      taxAmount += tax.taxAmount;
    }
    subTotal.value = subTotal.value -
        (single.model[0].updatedPrice * single.model[0].updatedQuantity);
    total.value = total.value -
        (single.model[0].updatedPrice * single.model[0].updatedQuantity);
    totalTax.value = totalTax.value -
        (single.model[0].taxAmount * single.model[0].updatedQuantity);
    single.taxList = taxList;
    single.model[0].updatedQuantity = quantity.value;
    single.model[0].updatedUnitId = unit.value;
    single.model[0].updatedPrice = price.value;
    single.model[0].taxAmount = taxAmount;
    single.model[0].selectedStock = availableStock.value;
    single.model[0].remarks = remarksController.value.text;
    list.insert(index, single);
    list.removeAt(index + 1);

    calculateTotal(price.value, single.model[0].updatedQuantity);
    calculateTotalTax(taxAmount, single.model[0].updatedQuantity);

    Navigator.pop(context);
  }

  Future<bool> minPriceWarning(double minPrice) async {
    if (double.parse(priceController.value.text) < minPrice) {
      if (homeController.companyInfo.value == 1) {
        return true;
      } else if (homeController.companyInfo.value == 2) {
        final result = await Get.dialog<bool>(
          AlertDialog(
            title: Text('Confirmation'),
            content: Text(
                "The price is less than the minimum price (${minPrice.toStringAsFixed(2)}). Do you want to continue?"),
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
      } else if (homeController.companyInfo.value == 3) {
        SnackbarServices.errorSnackbar(
            'The price should not fall below the minimum of (${minPrice})');
        return false;
      }
    }
    return true; // Condition not met, user can continue.
  }

  changeUnit(
      {required Unitmodel value,
      required double price,
      required double minPrice}) async {
    unit.value = value.code!;
    if (price > 0) {
      isPriceEdited.value = true;
      this.price.value = InventoryCalculations.getStockPerFactor(
          factorType: value.factorType!,
          factor: double.parse(value.factor!),
          stock: price);
      this.minPrice.value = InventoryCalculations.getStockPerFactor(
          factorType: value.factorType!,
          factor: double.parse(value.factor!),
          stock: minPrice);

      update();
      priceController.value.text =
          InventoryCalculations.formatPrice(this.price.value).toString();
      developer.log(priceController.value.text, name: 'Price controller');
      developer.log("${this.minPrice.value} min");
      update();
    }
  }

  changePrice(String value) {
    isPriceEdited.value = true;
    value.isNotEmpty ? price.value = double.parse(value) : price.value = 0.0;
  }

  calculateTotal(double price, double quantity) {
    subTotal.value = subTotal.value + (price * quantity);
    total.value = subTotal.value - discount.value;
  }

  calculateTotalTax(double tax, double quantity) {
    developer.log(tax.toString(),
        name: 'SalesOrderController.calculateTotalTax');
    totalTax.value += (tax * quantity);
    total.value = subTotal.value + totalTax.value - discount.value;
  }

  calculateDiscount(String discountAmount, bool isPercentage) {
    double discount = discountAmount.length > 0 && discountAmount != ''
        ? double.parse(discountAmount)
        : 0.0;
    if (isPercentage) {
      // this.discount.value = (subTotal.value * discount) / 100;
      this.discount.value = DiscountHelper.calculateDiscount(
          discountAmount: discount,
          totalAmount: subTotal.value,
          isPercent: true);
      discountPercentage.value = discount;
    } else {
      this.discount.value = discount;
      // discountPercentage.value = (discount * 100) / subTotal.value;
      discountPercentage.value = DiscountHelper.calculateDiscount(
          discountAmount: discount,
          totalAmount: subTotal.value,
          isPercent: false);
    }
    total.value = subTotal.value + totalTax.value - this.discount.value;
  }

  removeItem(int index, var list) {
    subTotal.value = subTotal.value -
        (list[index].model[0].updatedPrice *
            list[index].model[0].updatedQuantity);

    totalTax.value = totalTax.value - list[index].model[0].taxAmount;
    total.value = subTotal.value - discount.value + totalTax.value;
    list.removeAt(index);
  }

  getProductDetails(String productId, BuildContext context, bool isScaning,
      String customerId) async {
    isProductLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    String data = jsonEncode({
      "token": token,
      "locationid": "",
      "productid": productId,
    });
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataRawBodyInventory(
          api: 'GetProductDetails', data: data);
      if (feedback != null) {
        developer.log("${feedback}");
        result = ProductDetailsModel.fromJson(feedback);
        response.value = result.res;
        singleProduct.value = result;
        if (singleProduct.value.model.isNotEmpty) {
          unit.value = singleProduct.value.model[0].unitId ?? 'Unit';
          unitList.value = result.unitmodel;
          unitList.insert(
              0,
              Unitmodel(
                  code: unit.value,
                  name: unit.value,
                  productId: productId,
                  factorType: 'M',
                  factor: '1',
                  isMainUnit: true));
          availableStock.value = singleProduct.value.model[0].quantity != null
              ? singleProduct.value.model[0].quantity.toDouble()
              : 0.0;
          if (homeController.isCompanyOptionAvailable(
              CompanyOptions.TakeLastSalesPrice.value)) {
            await getLastSalesTransactionByCustomer(
                singleProduct.value, customerId);
          }

          isProductLoading.value = false;
        } else {
          Navigator.pop(context);
          if (isScaning) {
            Navigator.pop(context);
          }
          await SnackbarServices.errorSnackbar('Couldnt find product details');
          // isProductLoading.value = false;
        }
      }
    } finally {
      if (response.value == 1) {
      } else {}
    }
  }

  getLastSalesTransactionByCustomer(
      ProductDetailsModel product, String customerId) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String customer = customerId;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetLastSalesTransactionByCustomer?token=${token}&customerID=${customer}&ProductID=${product.model[0].productId}&UnitID=${product.model[0].unitId}');
      if (feedback != null) {
        if (feedback['Modelobject'] != null && feedback['Modelobject'] > 0) {
          singleProduct.value.model[0].price1 =
              feedback['Modelobject'].toDouble();
        }

        update();
      }
    } finally {}
  }

  Future<bool> getCustomerCreditLimit(
      {required String customerId,
      required double subtotal,
      required DateTime transactionDate}) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final token = loginController.token.value;
    bool result = false;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              "GetCustomerCreditLimit?token=$token&customerID=${customerId}&amount=${subtotal}&checkOpenDN=true&transactionDate=${transactionDate.toIso8601String()}");
      developer.log("${feedback}");

      if (feedback != null && feedback['Modelobject'] != null) {
        if (feedback['Modelobject'] == true) {
          if (feedback['overCL'] == 2) {
            await Get.dialog(
              AlertDialog(
                title: Text('Confirmation'),
                content: Text(
                    "This transaction exceeds the customer's credit limit. Do you want to continue?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      SnackbarServices.warningSnackbar(
                          "Credit Limit reached !");
                      result = true;
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      result = false;
                      Get.back();
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
          } else if (feedback['overCL'] == 3) {
            SnackbarServices.warningSnackbar(
                "This transaction exceeds the customer's credit limit. You are not allowed to sell over the customer's credit limit.");
            return true;
          } else {
            return false;
          }
        }
      }
    } finally {
      // Any cleanup or error handling can go here
    }

    return result;
  }
}
