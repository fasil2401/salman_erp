import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Merchandise%20Model/create_merchandise_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Merchandise%20Model/get_merchandiselist_model.dart';
import 'package:axolon_erp/model/Sales%20Model/Merchandise%20Model/merchandise_byid_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/location_list_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Merchandise%20Screen/merchand_product_list_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

class MerchandiseController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () {
      presetSysdoc();
    });
  }

  final homeController = Get.put(HomeController());
  final loginController = Get.put(LoginTokenController());
  var isLoading = false.obs;
  var productList = [].obs;
  var singleproductList = <SingleProduct>[].obs;
  var customerList = [].obs;
  var filterList = [].obs;
  var isEditingQuantity = false.obs;
  var isLoadingProducts = false.obs;
  var isLoadingItems = false.obs;
  var quantity = 1.0.obs;
  var quantityControl = TextEditingController().obs;
  var stockCtrl = TextEditingController().obs;
  var descriptionControl = TextEditingController().obs;
  var customerControl = TextEditingController().obs;
  var isPriceEdited = false.obs;
  var unit = ''.obs;
  var price = 0.0.obs;
  var availableStock = 0.0.obs;
  var minPrice = 0.0.obs;
  var unitList = [].obs;
  var isProductLoading = false.obs;
  var isAdding = false.obs;
  var isVoucherLoading = false.obs;
  var addorUpdate = false.obs;
  var isLocationLoading = false.obs;
  var edit = false.obs;
  var response = 0.obs;
  var merchandiseList = [].obs;
  var sysDocList = [].obs;
  var productUnitList = [].obs;
  var singleProduct = ProductDetailsModel(
          res: 1, model: [], unitmodel: [], productlocationmodel: [], msg: '')
      .obs;
  var priceController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var itemCode = TextEditingController().obs;
  var itemname = TextEditingController().obs;
  var voucherNumber = ''.obs;
  var sysDocId = ''.obs;
  var sysDocName = ' '.obs;
  var location = LocationSingleModel().obs;
  var locationId = ''.obs;
  var selectedValue = 1.obs;

  var unitIdCtrl = TextEditingController().obs;
  var selectedUnit = Unitmodel().obs;
  var isSaving = false.obs;
  var transactionDate = DateTime.now().obs;
  var dueDate = DateTime.now().obs;
  var isNewRecord = true.obs;
  final salesScreenController = Get.put(SalesController());
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var isMerchandiseByIdLoading = false.obs;
  var isOpenListLoading = false.obs;
  var merchandiseOpenList = [].obs;
  var expirydate = DateTime.now().obs;
  var isexpirydate = false.obs;
  var isViewexpirydate = false.obs;
  var isCustomerLoading = false.obs;
  var customerId = ''.obs;
  var customer = CustomerModel().obs;

  var customerFilterList = [].obs;
  var isSearching = false.obs;
  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  DateTime date = DateTime.now();
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.merchandise, type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.merchandise, type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
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
  }

  getAllCustomers() async {
    isCustomerLoading.value = true;

    await homeController.getCustomerList();
    await generateCustomerList();

    isCustomerLoading.value = false;
  }

  generateCustomerList() async {
    customerList.clear();
    for (var element in homeController.customerList) {
      customerList.add(element);
    }
    customer.value = customerList[0];
    customerId.value = customer.value.code ?? '';
  }

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  Future<DateTime> selectExpiryDate(BuildContext context, DateTime date) async {
    isexpirydate.value = true;
    isViewexpirydate.value = true;
    DateTime? newDate = await CommonFilterControls.getCalender(context, date);
    if (newDate != null) {
      return newDate;
    }
    return DateTime.now();
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

  getMerchandiseOpenList() async {
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
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetItemTransactionOpenList?token=${token}&from=${fromDate}&to=${toDate}&showVoid=false');
      if (feedback != null) {
        result = GetMercahndiseOpenListModel.fromJson(feedback);
        // log(result);
        response.value = result.res;
        merchandiseOpenList.value = result.model;
        isOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        log(merchandiseList.length.toString(), name: 'All open list');
      }
    }
  }

  getMerchandiseByID(String sysdoc, String voucher) async {
    isLoading.value = true;
    update();
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataInventory(
          api:
              'GetItemTransactionByID?token=$token&sysDocID=${sysdoc}&voucherID=${voucher}');
      log(feedback.toString());
      if (feedback != null) {
        if (feedback["result"] == 1) {
          result = GetMercahndiseByIdModel.fromJson(feedback);
          sysDocId.value = sysdoc;
          voucherNumber.value = voucher;
          isNewRecord.value = false;

          Header header = result.header[0];
          descriptionControl.value.text = header.note.toString();
          locationId.value = header.locationId.toString();
          customerId.value = header.partyId.toString();
          if (homeController.customerList.isEmpty) {
            await homeController.getCustomerList();
          }
          customer.value = homeController.customerList.firstWhere(
              (element) => element.code == customerId.value,
              orElse: (() => log('eroorrrrrrr')));
          log("${location.value.code} location");
          log("${locationId.value} locationlocation");

          update();
          merchandiseList.clear();

          for (var product in result.detail) {
            merchandiseList.add(
              ProductDetailsModel(
                  res: 1,
                  model: [
                    SingleProduct(
                      productId: product.productId,
                      description: product.description,
                      updatedQuantity: product.unitQuantity == null ||
                              product.unitQuantity == 0 ||
                              product.unitQuantity == ""
                          ? product.quantity.toDouble()
                          : product.unitQuantity.toDouble(),
                      updatedUnitId: product.unitId,
                      locationId: product.locationId,
                      quantity: product.quantity ?? 0,
                      expiryDate: product.expiryDate,
                    ),
                  ],
                  unitmodel: [],
                  productlocationmodel: [],
                  taxList: [],
                  msg: ''),
            );
            log("${product.unitId}unitId");
            update();
          }

          isNewRecord.value = false;
          update();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  resetList() {
    filterList.value = productList;
  }

  editQuantity() {
    isEditingQuantity.value = !isEditingQuantity.value;
  }

  incrementQuantity() {
    isEditingQuantity.value = false;
    quantity.value++;
    update();
  }

  decrementQuantity() {
    isEditingQuantity.value = false;
    if (quantity > 1) {
      quantity.value--;
      update();
    }
  }

  setQuantity(String value) {
    quantity.value = double.parse(value);
  }

  resetQuantity() {
    quantity.value = 1;
    isEditingQuantity.value = false;
    update();
  }

  getProductDetails(
    String productId,
    BuildContext context,
  ) async {
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
        //log("${feedback}");
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

          isProductLoading.value = false;
          update();
        } else {
          Navigator.pop(context);

          await SnackbarServices.errorSnackbar('Couldnt find product details');
          // isProductLoading.value = false;
        }
      }
    } finally {
      if (response.value == 1) {
      } else {}
    }
  }

  addOrUpdateProductToMerchandise(Products product, bool isAdding,
      ProductDetailsModel single, int index, BuildContext context) async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == false) {
      SnackbarServices.errorSnackbar('No Internet Connection');
      return;
    }

    isAdding
        ? quantity.value = 1
        : quantity.value = single.model[0].updatedQuantity;
    if (isAdding == false) {
      availableStock.value = single.model[0].selectedStock ?? 0.0;
      unit.value = single.model[0].updatedUnitId!;
      unitList.value = single.unitmodel;
      quantityControl.value.text = quantity.value.toString();

      itemCode.value.text = product.productId ?? "";
      itemname.value.text = product.description ?? "";
      update();
    }

    if (isAdding == true) {
      getProductDetails(product.productId ?? '', context);
      update();

      quantityControl.value.text = quantity.value.toString();
    }
  }

  updateItem(
      BuildContext context, ProductDetailsModel single, int index) async {
    addorUpdate.value = true;
    single.model[0].updatedQuantity = quantity.value;
    single.model[0].updatedUnitId = unit.value;
    single.model[0].updatedPrice = price.value;

    single.model[0].selectedStock = availableStock.value;
    single.model[0].expiryDate = expirydate.value;
    merchandiseList.insert(index, single);
    merchandiseList.removeAt(index + 1);

    Navigator.pop(context);
  }

  addItem(
    BuildContext context,
  ) async {
    addorUpdate.value = false;
    singleProduct.value.model[0].updatedQuantity = quantity.value;
    singleProduct.value.model[0].updatedUnitId = unit.value;

    singleProduct.value.model[0].selectedStock = availableStock.value;
    singleProduct.value.model[0].expiryDate = expirydate.value;

    merchandiseList.add(
      singleProduct.value,
    );
    log("${merchandiseList.length.toString()}length");
    log("${merchandiseList.length.toString()}length");

    quantity.value = 1.0;
    Navigator.pop(context);
    // Navigator.pop(context);
  }

  clearAdd() {
    isexpirydate.value = false;
    expirydate.value = DateTime.now();
    unit.value = "";
    availableStock.value = 0.0;
    isNewRecord.value = true;
    update();
  }

  cancelAdd() {
    isexpirydate.value = false;
    expirydate.value = DateTime.now();
    update();
  }

  deleteItem(int index) {
    merchandiseList.removeAt(index);
    update();
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
    }
  }

  generateSysDocList() {
    sysDocList.clear();

    for (var element in salesScreenController.sysDocList) {
      if (element.sysDocType == SysdocType.ItemTransaction.value) {
        sysDocList.add(element);
      }
    }

    log('Length of sysDocList: ${sysDocList.length}');
    update();
  }

  getVoucherNumber(
    String sysDocId,
    String name,
  ) async {
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
        update();
      }
    } finally {
      if (response.value == 1) {
        log(voucherNumber.value.toString(), name: 'Voucher Number');
        update();
      }
      update();
    }
  }

  presetSysdoc() async {
    if (!salesScreenController.isLoading.value) {
      await await isEnanbled();
      await generateSysDocList();
      await getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
      log('Length of sysDocList: ${sysDocList.length}');
      await getAllCustomers();

      await getLocationList();
      await getAllProducts();
      update();
    } else {
      await Future.delayed(Duration(seconds: 0));

      await presetSysdoc();
    }
  }

  createMercahndiseItemTransfer() async {
    if (merchandiseList.isEmpty) {
      SnackbarServices.errorSnackbar('Please Add Products to Continue');
      return;
    }
    if (isLoading.value == true) {
      return;
    }
    isLoading.value = true;
    isSaving.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    List<ItemTransactionDetail> list = [];
    int rowIndex = 0;
    var detailRowindex = 0;
    for (var product in merchandiseList) {
      list.add(ItemTransactionDetail(
        itemcode: product.model[0].productId,
        description: product.model[0].description,
        quantity: product.model[0].updatedQuantity,
        remarks: "",
        unitid: product.model[0].updatedUnitId,
        locationId: locationId.value,
        rowindex: rowIndex,
        unitPrice: 0,
        quantityReturned: 0,
        quantityShipped: 0,
        unitQuantity: 0,
        unitFactor: 0,
        factorType: "",
        subunitPrice: 0,
        jobId: "",
        costCategoryId: "",
        sourceVoucherId: "",
        sourceSysDocId: "",
        sourceRowIndex: 0,
        rowSource: "",
        refSlNo: "",
        refText1: "",
        refText2: "",
        refText3: "",
        refText4: "",
        refText5: "",
        refNum1: 0,
        refNum2: 0,
        refDate1: "",
        refDate2: "",
        expiryDate: product.model[0].expiryDate,
      ));
      rowIndex++;
      detailRowindex++;
    }
    final data = jsonEncode({
      "token": "${token}",
      "Sysdocid": sysDocId.value,
      "SysDocType": 0,
      "Voucherid": voucherNumber.value,
      "PartyType": "C",
      "PartyID": customerId.value,
      "LocationID": locationId.value,
      "Salespersonid": "",
      "Currencyid": "",
      "TransactionDate": transactionDate.value.toIso8601String(),
      "Reference1": "",
      "Reference2": "",
      "Reference3": "",
      "Note": descriptionControl.value.text,
      "Isvoid": true,
      "Discount": 0,
      "Total": 0,
      "Roundoff": 0,
      "Address": "",
      "Phone": "",
      "IsCompleted": 0,
      "DriverID": "",
      "VehicleID": "",
      "ToLocationID": locationId.value ?? "",
      "ContainerNo": "",
      "Isnewrecord": isNewRecord.value,
      "VehicleNo": "",
      "TransactionType": TransactionType.Merchandiser.value.toInt(),
      "ItemTransactionDetails": list
    });
    try {
      log(data.toString());
      var feedback = await ApiServices.fetchDataRawBodyInventory(
          api: 'CreateItemTransaction', data: data);
      if (feedback != null) {
        if (feedback['res'] == 1) {
          SnackbarServices.successSnackbar(
              'Saved Successfully ${feedback['docNo']}');
          getVoucherNumber(sysDocId.value, sysDocName.value);
          clearAll();
        } else {
          SnackbarServices.errorSnackbar(feedback['msg'] ?? feedback['err']);
        }
        isLoading.value = false;
      }
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      isSaving.value = false;
    }
  }

  scanToAddIncreaseStockItem(String itemCode, BuildContext context) async {
    if (productList.isEmpty) {
      await getAllProducts();
    }

    var product = productList.firstWhere(
      (element) => element.upc == itemCode,
      orElse: () => productList.firstWhere(
          (element) => element.productId == itemCode,
          orElse: () => null),
    );
    if (product != null) {
      getProductDetails(product.productId, context);
      addOrUpdateProductToMerchandise(
        product,
        true,
        ProductDetailsModel(
          res: 1,
          model: [],
          unitmodel: [],
          productlocationmodel: [],
          msg: '',
        ),
        1,
        context,
      );
      update();

      this.itemCode.value.text = product.productId;
      itemname.value.text = product.description;
    } else {
      SnackbarServices.errorSnackbar('Item not found');
    }
  }

  scanToAddStockItem(String itemCode, BuildContext context) async {
    if (productList.isEmpty) {
      await getAllProducts();
    }

    var product = productList.firstWhere(
      (element) => element.upc == itemCode,
      orElse: () => productList.firstWhere(
          (element) => element.productId == itemCode,
          orElse: () => null),
    );
    log("${product.productId} proiddddd");
    log("${product}pListtt");
    log("${itemCode} itemCode");
    if (product != null) {
      log("${product.productId.toString()} product id");
      log("${product.description.toString()} product description");
      getProductDetails(product.productId, context);
      addOrUpdateProductToMerchandise(
        product,
        true,
        ProductDetailsModel(
          res: 1,
          model: [],
          unitmodel: [],
          productlocationmodel: [],
          msg: '',
        ),
        1,
        context,
      );
      update();

      this.itemCode.value.text = product.productId;
      this.itemname.value.text = product.description;
    } else {
      SnackbarServices.errorSnackbar('Item not found');
    }
  }

  selectValue(var value) {
    selectedValue.value = value;
    UserSimplePreferences.setIsCameraDisabled(value as int);
  }

  clearAll() {
    merchandiseList.clear();
    descriptionControl.value.clear();
    transactionDate.value = DateTime.now();
    expirydate.value = DateTime.now();
    dueDate.value = DateTime.now();
    generateSysDocList();
    update();
  }

  cancelAll() {
    itemCode.value.clear();
    availableStock.value = 0.0;
    itemname.value.clear();
    unit.value = "";
    isexpirydate.value = false;
    update();
  }

  resetCustomerList() {
    customerFilterList.value = customerList;
  }

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    log(this.customer.value.taxGroupId.toString(),
        name: 'SalesOrderController.selectCustomer');
    customerId.value = this.customer.value.code ?? '';
  }
}
