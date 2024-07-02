import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Sales%20Model/Salesman%20Activity%20models/contacts_list_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/Inventory Model/get_product_open_list_model.dart';

class ItemListController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProductList();
  }

  final loginController = Get.put(LoginTokenController());
  var categoryFilterController = TextEditingController().obs;
  var originFilterController = TextEditingController().obs;
  var brandFilterController = TextEditingController().obs;
  var typeFilterController = TextEditingController().obs;
  var styleFilterController = TextEditingController().obs;
  var classFilterController = TextEditingController().obs;
  var locationFilterController = TextEditingController(text: '').obs;
  var filterSearchList = [].obs;
  var searchController = TextEditingController().obs;
  final homeController = Get.put(HomeController());
  var isProductLoading = false.obs;
  String categoryFilterId = 'category';
  String originFilterId = 'origin';
  String brandFilterId = 'brand';
  String typeFilterId = 'type';
  String styleFilterId = 'style';
  String classFilterId = 'class';
  String locationFilterId = 'location';

  var originFilter = [].obs;
  var categoryFilter = [].obs;
  var brandFilter = [].obs;
  var typeFilter = [].obs;
  var styleFilter = [].obs;
  var classFilter = [].obs;
  var locationFilter = [].obs;

  var productList = [].obs;
  var filterList = [].obs;
  var colorList = <Detail>[].obs;
  var filterSearchProductList = [].obs;
  var isinactiveProducts = false.obs;
  var iszeroQtyProducts = false.obs;
  var toggleChanged = false.obs;

  toggleInactiveProducts() {
    isinactiveProducts.value = !isinactiveProducts.value;
    toggleChanged.value = true;
    update();
  }

  bool isChangedValues() {
    return locationFilterController.value.text.isNotEmpty ||
        toggleChanged.value == true;
  }

  toggleZeroQtyProducts() {
    iszeroQtyProducts.value = !iszeroQtyProducts.value;
    toggleChanged.value = true;
    update();
  }

  getProductList() async {
    isProductLoading.value = true;
    productList.clear();
    filterSearchProductList.clear();
    filterList.clear();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetProductOpenList?token=$token&inActive=${isinactiveProducts.value}&showZeroBalance=${iszeroQtyProducts.value}${locationFilterController.value.text.isNotEmpty ? '&locationID=${locationFilterController.value.text}' : ''}');
      //  log("${feedback}");
      if (feedback != null) {
        result = GetProductOpenListModel.fromJson(feedback);
        productList.value = result.model;
        filterSearchProductList.value = result.model;
        filterList.value = productList;
        colorList.value = result.details;
        await filterItemList();
        isProductLoading.value = false;
      }
    } finally {
      isProductLoading.value = false;
      log(productList.length.toString(), name: 'All Products');
    }
  }

  int getColor(String itemId) {
    return colorList
            .firstWhere(
              (element) => element.entityId == itemId,
              orElse: () => Detail(color: null),
            )
            .color ??
        0;
  }

  searchProducts(String value) {
    filterSearchProductList.value = filterList
        .where((element) =>
            (element.itemCode != null &&
                element.itemCode!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.description != null &&
                element.description!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.category != null &&
                element.category!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.origin != null &&
                element.origin!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.brand != null &&
                element.brand!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.type != null &&
                element.type!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.style != null &&
                element.style!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.modelClass != null &&
                element.modelClass!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.onhand != null &&
                element.onhand!
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.unit != null &&
                element.unit!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.totalWeight != null && element.totalWeight!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.age != null && element.age!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.manufacturer != null && element.manufacturer!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.size != null && element.size!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.vendorRef != null && element.vendorRef!.toString().toLowerCase().contains(value.toLowerCase())) ||
            (element.weight != null && element.weight!.toString().toLowerCase().contains(value.toLowerCase())))
        .toList();
  }

  searchFilter({required String filterId, required String value}) {
    if (filterId == categoryFilterId) {
      filterSearchList.value = categoryFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    } else if (filterId == originFilterId) {
      filterSearchList.value = originFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    } else if (filterId == brandFilterId) {
      filterSearchList.value = brandFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    } else if (filterId == typeFilterId) {
      filterSearchList.value = typeFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    } else if (filterId == styleFilterId) {
      filterSearchList.value = styleFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    } else if (filterId == classFilterId) {
      filterSearchList.value = classFilter
          .where((element) =>
              (element.code
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              (element.name.toLowerCase().contains(value.toLowerCase())))
          .toList();
      update();
    }
  }

  selectFilterValue({required String filterId, required String value}) {
    if (filterId == categoryFilterId) {
      categoryFilterController.value.text = value;
      update();
    } else if (filterId == originFilterId) {
      originFilterController.value.text = value;
      update();
    }
    if (filterId == brandFilterId) {
      brandFilterController.value.text = value;
      update();
    }
    if (filterId == typeFilterId) {
      typeFilterController.value.text = value;
      update();
    }
    if (filterId == styleFilterId) {
      styleFilterController.value.text = value;
      update();
    }
    if (filterId == classFilterId) {
      classFilterController.value.text = value;
      update();
    }
    if (filterId == locationFilterId) {
      locationFilterController.value.text = value;
      update();
    }
  }

  getList(String val) async {
    switch (val) {
      case 'category':
        categoryFilter.clear();
        if (homeController.productCategoryList.isEmpty) {
          await homeController.getProductCategoryList();
          categoryFilter.value = homeController.productCategoryList;
        } else {
          categoryFilter.value = homeController.productCategoryList;
        }
        break;
      case 'origin':
        originFilter.clear();
        if (homeController.countryList.isEmpty) {
          await homeController.getCountryList();
          originFilter.value = homeController.countryList;
        } else {
          originFilter.value = homeController.countryList;
        }
        break;
      case 'brand':
        brandFilter.clear();
        if (homeController.productBrandList.isEmpty) {
          await homeController.getProductBrandList();
          brandFilter.value = homeController.productBrandList;
        } else {
          brandFilter.value = homeController.productBrandList;
        }
        break;
      case 'style':
        styleFilter.clear();
        if (homeController.productStyleList.isEmpty) {
          await homeController.getProductStyleList();
          styleFilter.value = homeController.productStyleList;
        } else {
          styleFilter.value = homeController.productStyleList;
        }
        break;

      case 'location':
        locationFilter.clear();
        if (homeController.productLocationList.isEmpty) {
          await homeController.getProductLocationList();
          locationFilter.value = homeController.productLocationList;
        } else {
          locationFilter.value = homeController.productLocationList;
        }
        break;

      case 'class':
        classFilter.clear();
        if (homeController.productClassList.isEmpty) {
          await homeController.getProductClassList();
          classFilter.value = homeController.productClassList;
        } else {
          classFilter.value = homeController.productClassList;
        }
        break;
      case 'type':
        typeFilter.clear();
        typeFilter.value = ItemTypes.values
            .map(
                (item) => ContactsModel(code: "${item.value}", name: item.name))
            .toList();
        break;
      default:
        {
          debugPrint('nothing');
          return;
        }
    }
    update();
  }

  filterItemList() {
    filterList.value = productList.where((element) {
      bool categoryFilter = element.category.toString().toLowerCase().contains(
              categoryFilterController.value.text
                  .toLowerCase()
                  .split(' - ')[0]) ||
          element.category.toString().toLowerCase().contains(
              categoryFilterController.value.text
                  .toLowerCase()
                  .split(' - ')[1]) ||
          categoryFilterController.value.text.isEmpty;

      bool originFilter = element.origin.toString().toLowerCase().contains(
              originFilterController.value.text
                  .toLowerCase()
                  .split(' - ')[0]) ||
          element.origin.toString().toLowerCase().contains(
              originFilterController.value.text
                  .toLowerCase()
                  .split(' - ')[1]) ||
          originFilterController.value.text.isEmpty;

      bool brandFilter = element.brand.toString().toLowerCase().contains(
              brandFilterController.value.text.toLowerCase().split(' - ')[0]) ||
          element.brand.toString().toLowerCase().contains(
              brandFilterController.value.text.toLowerCase().split(' - ')[1]) ||
          brandFilterController.value.text.isEmpty;

      bool typeFilter = element.type.toString().toLowerCase().contains(
              typeFilterController.value.text.toLowerCase().split(' - ')[0]) ||
          element.type.toString().toLowerCase().contains(
              typeFilterController.value.text.toLowerCase().split(' - ')[1]) ||
          typeFilterController.value.text.isEmpty;

      bool styleFilter = element.style.toString().toLowerCase().contains(
              styleFilterController.value.text.toLowerCase().split(' - ')[0]) ||
          element.style.toString().toLowerCase().contains(
              styleFilterController.value.text.toLowerCase().split(' - ')[1]) ||
          styleFilterController.value.text.isEmpty;

      bool classFilter = element.modelClass.toString().toLowerCase().contains(
              classFilterController.value.text.toLowerCase().split(' - ')[0]) ||
          element.modelClass.toString().toLowerCase().contains(
              classFilterController.value.text.toLowerCase().split(' - ')[1]) ||
          classFilterController.value.text.isEmpty;

      // bool locationFilter = element.modelClass.toString().toLowerCase().contains(
      //     locationFilterController.value.text.toLowerCase().split(' - ')[0]) ||
      //     element.modelClass.toString().toLowerCase().contains(
      //         locationFilterController.value.text.toLowerCase().split(' - ')[1]) ||
      //     locationFilterController.value.text.isEmpty;

      return categoryFilter &&
          originFilter &&
          brandFilter &&
          typeFilter &&
          styleFilter &&
          classFilter;
    }).toList();
    filterSearchProductList.value = filterList;
    update();
  }

  toggleChanges() {
    toggleChanged.value = false;
    update();
  }

  clearFilter() {
    isinactiveProducts.value = false;
    iszeroQtyProducts.value = false;
    categoryFilterController.value.clear();
    originFilterController.value.clear();
    brandFilterController.value.clear();
    typeFilterController.value.clear();
    styleFilterController.value.clear();
    classFilterController.value.clear();
    locationFilterController.value.clear();
    filterItemList();
    toggleChanges();
    update();
  }

  clearSearch() {
    if (searchController.value.text.isNotEmpty) {
      searchController.value.clear();
      searchProducts('');
    }

    update();
  }

  // getColor(String itemCode) {
  //   try {
  //     return colorList
  //         .firstWhere((element) => element.entityId == itemCode)
  //         .color;
  //   } catch (e) {
  //     // Handle the case when no matching element is found, e.g., return a default color.
  //     return ''; // You can choose your default color here.
  //   }
  // }
}
