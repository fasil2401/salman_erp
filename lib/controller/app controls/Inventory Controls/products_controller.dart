import 'dart:convert';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/view/Inventory%20Screen/components/inventory_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class ProductsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  final loginController = Get.put(LoginTokenController());
  final homeController = Get.put(HomeController());
  var isLoading = false.obs;
  var isProductLoading = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var productList = [].obs;
  var filterList = [].obs;
  var singleProduct = SingleProduct().obs;
  var unitList = [].obs;
  var productLocationList = [].obs;
  var totalStock = 0.0.obs;
  var unitLabel = 'Unit'.obs;
  var unitId = ''.obs;
  var factor = 0.0.obs;
  var factorType = ''.obs;

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  resetList() {
    filterList.value = productList;
  }

  getTotalStock() {
    totalStock.value = 0.0;
    for (var stock in productLocationList) {
      totalStock.value += stock.quantity;
    }
  }

  setToDefault() {
    unitList.value = [];
    productLocationList.value = [];
    totalStock.value = 0.0;
    unitId.value = '';
    unitLabel.value = 'Unit';
    factor.value = 0.0;
    factorType.value = '';
  }

  scanInventory(String itemCode) {
    Get.back();
    var product = productList.firstWhere(
      (element) => element.upc == itemCode,
      orElse: () => productList.firstWhere(
          (element) => element.productId == itemCode,
          orElse: () => null),
    );
    if (product != null) {
      getProductDetails(product.productId);
      Get.back();
    } else {
      SnackbarServices.errorSnackbar('Product not found');
    }
  }

  changeUnit(String code) {
    unitId.value = code;
    unitLabel.value = 'Unit';
    factor.value = double.parse(
        unitList.firstWhere((element) => element.code == code).factor);
    factorType.value =
        unitList.firstWhere((element) => element.code == code).factorType;
    totalStock.value = InventoryCalculations.getStockPerFactor(
        factorType: factorType.value,
        factor: factor.value,
        stock: totalStock.value);
    developer.log('total stoc iss ::::: ${factorType.value}');
  }

  showDetailDialogue(BuildContext context) {
    Get.defaultDialog(
      title: '',
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      contentPadding: EdgeInsets.only(left: 15, right: 15),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InventoryComponents.detailRow('Stock Unit', unitId.value),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.16,
                        child: InventoryComponents.tableHeadText(
                            'Code', TextAlign.left, context)),
                    Expanded(
                        child: InventoryComponents.tableHeadText(
                            'Location', TextAlign.left, context)),
                    InventoryComponents.tableHeadText(
                        'Stock', TextAlign.right, context),
                  ]),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: productLocationList.length,
                    itemBuilder: (context, index) {
                      double quantity = InventoryCalculations.getStockPerFactor(
                          factorType: factorType.value,
                          factor: factor.value,
                          stock: productLocationList[index].quantity);

                      return Column(
                        children: [
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(1.0),
                              1: FlexColumnWidth(2.7),
                              2: FlexColumnWidth(1.0),
                            },
                            children: [
                              TableRow(children: [
                                InventoryComponents.tableText(
                                    productLocationList[index].locationId,
                                    TextAlign.left),
                                InventoryComponents.tableText(
                                    '', TextAlign.left),
                                InventoryComponents.tableText(
                                    InventoryCalculations.roundOffQuantity(
                                        quantity: quantity),
                                    TextAlign.right),
                              ]),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Stock :',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Flexible(
                    child: Text(
                      InventoryCalculations.roundOffQuantity(
                          quantity: totalStock.value),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: Text('Close', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }

  getAllProducts() async {
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

  getProductDetails(String productId) async {
    await setToDefault();
    isProductLoading.value = true;
    await loginController.getToken();
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
        result = ProductDetailsModel.fromJson(feedback);
        response.value = result.res;
        singleProduct.value = result.model[0];
        unitId.value = singleProduct.value.unitId ?? '';
        unitLabel.value = singleProduct.value.unitId ?? '';
        unitList.value = result.unitmodel;
        productLocationList.value = result.productlocationmodel;
        getTotalStock();
      }
    } finally {
      isProductLoading.value = false;
      if (response.value == 1) {
        developer.log(productLocationList.value.toString(),
            name:
                'Product Location List for ${singleProduct.value.description}');
      } else {}
    }
  }
}
