import 'dart:convert';
import 'dart:typed_data';
import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/model/Sales%20Model/ceate_sales_order_response.dart';
import 'package:axolon_erp/model/Sales%20Model/create_sales_order_detail_model.dart';
import 'package:axolon_erp/model/Sales%20Model/get_customersnap_balance_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_by_id_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_open_list_model.dart';
import 'package:axolon_erp/model/Sales%20Model/sales_order_print_model.dart';
import 'package:axolon_erp/model/Tax%20Model/tax_model.dart';
import 'package:axolon_erp/model/all_customer_model.dart';
import 'package:axolon_erp/model/error_response_model.dart';
import 'package:axolon_erp/model/voucher_number_model.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/services/pdf%20services/pdf_api.dart';
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
import 'package:getwidget/getwidget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer' as developer;

import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sizer/sizer.dart';

class SalesOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  final loginController = Get.put(LoginTokenController());
  final salesScreenController = Get.put(SalesController());
  final homeController = Get.put(HomeController());
  var quantityControl = TextEditingController();
  var priceController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  DateTime date = DateTime.now();
  var edit = false.obs;
  var isLoading = false.obs;
  var isProductLoading = false.obs;
  var isCustomerLoading = false.obs;
  var isVoucherLoading = false.obs;
  var isOpenListLoading = false.obs;
  var iscustomerLoading = false.obs;
  var isSalesOrderByIdLoading = false.obs;
  var isSearching = false.obs;
  var isSaving = false.obs;
  var response = 0.obs;
  var message = ''.obs;
  var sysDocList = [].obs;
  var productList = [].obs;
  var customerList = [].obs;
  var customerFilterList = [].obs;
  var filterList = [].obs;
  var salesOrderList = [].obs;
  var salesOrderOpenList = [].obs;
  var singleProduct = ProductDetailsModel(
          res: 1, model: [], unitmodel: [], productlocationmodel: [], msg: '')
      .obs;
  var unitList = [].obs;
  var productLocationList = [].obs;
  var subTotal = 0.0.obs;
  var discount = 0.0.obs;
  var discountPercentage = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;
  var quantity = 1.0.obs;
  var unit = ''.obs;
  var price = 0.0.obs;
  var isPriceEdited = false.obs;
  var voucherNumber = ''.obs;
  var sysDocId = ''.obs;
  var sysDocName = ' '.obs;
  var code = ' '.obs;
  var name = ' '.obs;
  var status = ' '.obs;
  var creditstatus = ' '.obs;
  var balance = ' '.obs;
  var creditlimit = ' '.obs;
  var insAmount = ' '.obs;
  var dueAmount = ' '.obs;
  var unsecPdc = ' '.obs;
  var maxduedays = ' '.obs;
  var pdc = ' '.obs;
  var uninvoicedd = ' '.obs;
  var net = ' '.obs;
  var credit = ''.obs;
  var available = ' '.obs;

  RxDouble invoice = 0.0.obs;
  RxDouble receipt = 0.0.obs;
  RxDouble returnTotal = 0.0.obs;
  var customerremarks = ' '.obs;
  var customerId = ''.obs;
  var customer = CustomerModel().obs;
  var fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var transactionDate = DateTime.now().obs;
  var dueDate = DateTime.now().obs;
  var dateIndex = 0.obs;
  var isEqualDate = false.obs;
  var isFromDate = false.obs;
  var isToDate = false.obs;
  var isNewRecord = true.obs;
  var isBottomVisible = true.obs;
  var remarks = ' '.obs;
  var isFirstFocusOnRemarks = true.obs;
  var isDeleting = false.obs;
  var isAddEnabled = false.obs;
  var isEditEnabled = false.obs;
  var availableStock = 0.0.obs;
  var minPrice = 0.0.obs;
  var selectedmodel = CustomerSnapBalanceModel().obs;

  isEnanbled() async {
    bool isAdd = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.salesOrder, type: ScreenRightOptions.Add);
    bool isEdit = await homeController.isScreenRightAvailable(
        screenId: SalesScreenId.salesOrder, type: ScreenRightOptions.Edit);
    if (isAdd) {
      isAddEnabled.value = true;
    }
    if (isEdit) {
      isEditEnabled.value = true;
    }
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

  getRemarks(String value) {
    remarks.value = value;
  }

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

  presetSysdoc() async {
    if (salesScreenController.isLoading.value == false) {
      await generateSysDocList();
      getVoucherNumber(sysDocList[0].code, sysDocList[0].name);
    } else {
      await Future.delayed(Duration(seconds: 0));
      presetSysdoc();
    }
  }

  editQuantity() {
    edit.value = !edit.value;
    quantityControl.text = quantity.value.toString();
  }

  setQuantity(String value) {
    value.isNotEmpty
        ? quantity.value = double.parse(value)
        : quantity.value = 1.0;
  }

  searchProducts(String value) {
    filterList.value = productList
        .where((element) =>
            element.description.toLowerCase().contains(value.toLowerCase()) ||
            element.productId.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  searchCustomers(String value) {
    customerFilterList.value = customerList
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  generateSysDocList() async {
    sysDocList.clear();
    var list = [];
    if (salesScreenController.userEntityLinks.isNotEmpty &&
        homeController.user.value.isAdmin == false) {
      list = salesScreenController.sysDocList
          .where((element) => salesScreenController.containsMatchingObject(
              element: element, type: 23))
          .toList();
    } else {
      list = salesScreenController.sysDocFilterList
          .where((element) => element.sysDocType == 23)
          .toList();
    }
    sysDocList.value = list;
    // sysDocList.value = salesScreenController.filteredEntitySysDocId;
    update();
  }

  generateCustomerList() async {
    customerList.clear();
    for (var element in homeController.customerList) {
      customerList.add(element);
    }
    customer.value = customerList[0];
    customerId.value = customer.value.code ?? '';
  }

  resetList() {
    filterList.value = productList;
  }

  resetCustomerList() {
    customerFilterList.value = customerList;
  }

  selectCustomer(CustomerModel customer) {
    this.customer.value = customer;
    developer.log(this.customer.value.taxGroupId.toString(),
        name: 'SalesOrderController.selectCustomer');
    customerId.value = this.customer.value.code ?? '';
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
      addOrUpdateProductToSales(
          product,
          true,
          true,
          ProductDetailsModel(
              res: 1,
              model: [],
              unitmodel: [],
              productlocationmodel: [],
              msg: ''),
          1,
          context);
    } else {
      Navigator.pop(context);
      SnackbarServices.errorSnackbar('Product not found');
    }
  }

  getCustomerId(String customerId) {
    this.customerId.value = customerId;
  }

  getAllProducts() async {
    // isLoading.value = true;
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
    // await loginController.getToken();
    // if (loginController.token.value.isEmpty) {
    //   await loginController.getToken();
    // }
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
    await isEnanbled();
    await presetSysdoc();
    await homeController.getCustomerList();
    await generateCustomerList();

    isCustomerLoading.value = false;
    getAllProducts();

    // await generateSysDocList();
    // isCustomerLoading.value = true;
    // await loginController.getToken();
    // final String token = loginController.token.value;
    // dynamic result;
    // try {
    //   var feedback =
    //       await ApiServices.fetchData(api: 'GetCustomerList?token=${token}');
    //   if (feedback != null) {
    //     result = AllCustomerModel.fromJson(feedback);
    //     print(result);
    //     response.value = result.result;
    //     customerList.value = result.modelobject;
    //     customerFilterList.value = result.modelobject;
    //     isCustomerLoading.value = false;
    //   }
    // } finally {
    //   if (response.value == 1) {
    //     getAllProducts();
    //     developer.log(customerList.length.toString(), name: 'All Customers');
    //   }
    // }
  }

  getProductDetails(
      String productId, BuildContext context, bool isScaning) async {
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
            await getLastSalesTransactionByCustomer(singleProduct.value);
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

  getSalesOrderOpenList() async {
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
              'GetSalesOrderOpenList?token=${token}&fromDate=${fromDate}&toDate=${toDate}&sysDocID=${sysDoc}');
      if (feedback != null) {
        result = SalesOrderOpenListModel.fromJson(feedback);
        print(result);
        response.value = result.result;
        salesOrderOpenList.value = result.modelobject;
        isOpenListLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        developer.log(salesOrderOpenList.length.toString(),
            name: 'All sales open list');
      }
    }
  }

  getSalesOrderById(String sysDoc, String voucher) async {
    isSalesOrderByIdLoading.value = true;
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
        result = SalesOrderByIdModel.fromJson(feedback);
        response.value = result.result;
      } else {
        isSalesOrderByIdLoading.value = false;
      }
    } finally {
      if (response.value == 1) {
        loadSalesOrderFromCloud(result);
      } else {
        isSalesOrderByIdLoading.value = false;
      }
    }
  }

  loadSalesOrderFromCloud(dynamic result) async {
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

    subTotal.value = result.header[0].total.toDouble();

    total.value = result.header[0].total.toDouble();

    discount.value = result.header[0].discount.toDouble();
    totalTax.value = result.header[0].taxAmount != null
        ? result.header[0].taxAmount.toDouble()
        : 0.0;

    calculateDiscount(discount.value.toString(), false);
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

      salesOrderList.add(
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
    isSalesOrderByIdLoading.value = false;
  }

  Future<bool> onVoided(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Text('Do you want to Void the Order?'),
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            actions: <Widget>[
              InkWell(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Cancel',
                        style: TextStyle(
                          color: AppColors.mutedColor,
                        )),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    voidOrder();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Void',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                  )),
            ],
          ),
        ) ??
        false;
  }

  voidOrder() async {
    isDeleting.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    try {
      final feedback = await ApiServices.fetchData(
          api:
              'VoidSalesOrder?token=${token}&SysDocID=${sysDocId.value}&VoucherID=${voucherNumber.value}&isVoid=true');
      if (feedback != null) {
        response.value = feedback["res"];
      }
    } finally {
      isDeleting.value = false;
      if (response.value == 1) {
        clearData();
        getVoucherNumber(sysDocId.value, sysDocName.value);
        SnackbarServices.successSnackbar('Successfully Voided the Order');
      }
    }
  }

  getCustomerSanpBalance() async {
    iscustomerLoading.value = true;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;

    dynamic result;
    try {
      var feedback = await ApiServices.fetchDataCustomer(
          api:
              'GetCustomerSnapBalanceData?token=${token}&CustomerID=${customerId.value}');
      if (feedback != null) {
        result = GetCustomerSnapBalanceModel.fromJson(feedback);
        print(result);
        response.value = result.result;

        selectedmodel.value = result.modelobject![0];
        code.value = selectedmodel.value.customerId ?? "";
        name.value = selectedmodel.value.customerName ?? "";
        balance.value = selectedmodel.value.balance.toString();
        creditlimit.value = selectedmodel.value.creditAmount?.toString() ?? "";
        insAmount.value = selectedmodel.value.insuranceAmount?.toString() ?? "";
        unsecPdc.value =
            selectedmodel.value.pdcUnsecuredLimitAmount?.toString() ?? "0";
        pdc.value = selectedmodel.value.pdcAmount?.toString() ?? "";

        net.value = selectedmodel.value.netBalance?.toString() ?? "0";

        credit.value = selectedmodel.value.creditAmount?.toString() ?? "";
        dueAmount.value = selectedmodel.value.dueAmount?.toString() ?? "0";
        maxduedays.value = selectedmodel.value.dueDays?.toString() ?? "0";
        uninvoicedd.value = selectedmodel.value.unInvoiced?.toString() ?? "0";
        available.value = selectedmodel.value.balanceAmount?.toString() ?? "0";

        status.value = selectedmodel.value.customerStatus.toString() ?? "";
        creditstatus.value = selectedmodel.value.creditStatus.toString();
        customerremarks.value = selectedmodel.value.remarks ?? "";

        //  customerremarks.value = selectedmodel.value.re.toString() ?? "";
        update();
      }
    } finally {
      iscustomerLoading.value = false;
      if (response.value == 1) {}
    }
  }

  clearData() {
    customerId.value = '';
    subTotal.value = 0.0;
    discount.value = 0.0;
    totalTax.value = 0.0;
    discountPercentage.value = 0.0;
    total.value = 0.0;
    salesOrderList.clear();
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    remarks.value = ' ';
    isFirstFocusOnRemarks.value = true;
    isNewRecord.value = true;
    generateSysDocList();
  }

  createSalesOrder() async {
    bool permission = await getCustomerCreditLimit();
    bool confirmation = false;
    if (salesOrderList.isNotEmpty) {
      if (voucherNumber.value != '') {
        if (customerId.value != '') {
          if (permission == false) {
            isSaving.value = true;
            var list = [];
            var taxList = [];
            int index = 0;
            int taxIndex = 0;
            for (var product in salesOrderList) {
              bool isBelow = await isBelowCost(
                  productId: product.model[0].productId ?? '',
                  unitId: product.model[0].updatedUnitId,
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
                CreateSalesOrderDetailModel(
                  itemcode: product.model[0].productId,
                  description: product.model[0].description,
                  quantity: product.model[0].updatedQuantity,
                  remarks: product.model[0].remarks,
                  rowindex: index,
                  unitid: product.model[0].updatedUnitId,
                  specificationid: '',
                  styleid: '',
                  equipmentid: '',
                  itemtype: 0,
                  locationid: '',
                  jobid: '',
                  costcategoryid: '',
                  sourcesysdocid: '',
                  sourcevoucherid: '',
                  sourcerowindex: '',
                  unitprice: product.model[0].updatedPrice,
                  cost: product.model[0].price1,
                  amount: product.model[0].updatedPrice *
                      product.model[0].updatedQuantity,
                  taxoption: product.model[0].taxOption,
                  taxamount: (product.model[0].taxAmount ?? 0.0) *
                      product.model[0].updatedQuantity,
                  taxgroupid: product.model[0].taxGroupId ?? '',
                ),
              );

              if (product.taxList != null && product.taxList.isNotEmpty) {
                for (var tax in product.taxList) {
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
            }
            taxList.insert(
                0,
                TaxModel(
                  orderIndex: 0,
                  token: '',
                  sysDocId: sysDocId.value,
                  voucherId: voucherNumber.value,
                  rowIndex: -1,
                  taxItemName: '',
                  taxAmount: totalTax.value,
                  taxLevel: 2,
                  taxGroupId: customer.value.taxGroupId ?? '',
                  accountId: '',
                  currencyId: '',
                  currencyRate: 1,
                  calculationMethod: '1',
                  taxRate: 5,
                  taxItemId: '',
                ));
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
              "Sysdocid": sysDocId.value,
              "Voucherid": voucherNumber.value,
              "Companyid": "",
              "Divisionid": "",
              "Customerid": customerId.value,
              "Transactiondate": transactionDate.value.toIso8601String(),
              "Salespersonid": homeController.salesPersonId.value,
              "Salesflow": 0,
              "Isexport": true,
              "Requireddate": DateTime.now().toIso8601String(),
              "Duedate": dueDate.value.toIso8601String(),
              "ETD": null,
              "Shippingaddress": "",
              "Shiptoaddress": "",
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
              "Discount": discount.value,
              "Total": subTotal.value,
              "Taxamount": totalTax.value,
              "Sourcedoctype": 0,
              "Jobid": "",
              "Costcategoryid": "",
              "Payeetaxgroupid": customer.value.taxGroupId ?? '',
              "Taxoption": 0,
              "Roundoff": 0,
              "Ordertype": 0,
              "Isnewrecord": isNewRecord.value,
              "SalesOrderDetails": list,
              "TaxDetails": taxList
            });
            dynamic result;
            try {
              var feedback = await ApiServices.fetchDataRawBody(
                  api: 'CreateSalesOrder', data: data);
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
                getSalesOrderPdf(result.docNo);
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

  Future<bool> getCustomerCreditLimit() async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final token = loginController.token.value;
    bool result = false;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              "GetCustomerCreditLimit?token=$token&customerID=${customerId.value}&amount=${subTotal.value}&checkOpenDN=true&transactionDate=${transactionDate.value.toIso8601String()}");
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

  getSalesOrderPrint(String voucherId) async {
    // await loginController.getToken();
    final String token = loginController.token.value;
    final String sysDoc = sysDocId.value;
    dynamic result;
    try {
      var feedback = await ApiServices.fetchData(
          api:
              'GetSalesOrderToPrint?token=${token}&sysDocID=${sysDoc}&voucherID=${voucherId}');
      if (feedback != null) {
        developer.log(feedback.toString());
        result = SalesOrderPrintModel.fromJson(feedback);

        response.value = result.result;
      }
    } finally {
      if (response.value == 1) {
        final file = await PdfApi.generatePdf(result);
        await OpenFilex.open(file.path);
        isSaving.value = false;
        // developer.log('Printing Success', name: '${result.docNo ?? ''}');
      }
    }
  }

  getSalesOrderPdf(
    String voucher,
  ) async {
    final String token = loginController.token.value;
    final String sysDoc = sysDocId.value;
    var data =
        jsonEncode({"FileName": "SalesOrder", "SysDocType": 23, "FileType": 1});
    var result;
    developer.log("${data} ${sysDoc} ${voucher} ${token} approve");
    try {
      var feedback = await ApiServices.fetchDataRawBodyReport(
          api:
              'GetApprovalPreview?token=${token}&SysDocID=${sysDoc}&VoucherID=${voucher}',
          data: data);
      if (feedback != null) {
        if (feedback['Modelobject'] != null &&
            feedback['Modelobject'].isNotEmpty) {
          Uint8List bytes = await base64.decode(feedback['Modelobject']);
          printUint8ListPdf(bytes);
          return bytes;
        } else {
          if (feedback['result'] != null && feedback['result'] == 0) {
            SnackbarServices.errorSnackbar(feedback['msg'].toString());
          }
        }
      }
    } finally {}
  }

  Future<void> printUint8ListPdf(Uint8List pdfBytes) async {
    // Uint8List pdfBytes = Uint8List.fromList([...]); // Replace `[...]` with your actual PDF bytes

    try {
      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
    } catch (e) {
      print('Printing error: $e');
    }
  }

  getVoucherNumber(String sysDocId, String name) async {
    isNewRecord.value = true;
    transactionDate.value = DateTime.now();
    dueDate.value = DateTime.now();
    isVoucherLoading.value = true;
    this.sysDocId.value = sysDocId;
    sysDocName.value = name;
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
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
      if (response.value == 1) {}
    }
  }

  removeItem(int index) {
    subTotal.value = subTotal.value -
        (salesOrderList[index].model[0].updatedPrice *
            salesOrderList[index].model[0].updatedQuantity);

    totalTax.value = totalTax.value - salesOrderList[index].model[0].taxAmount;
    total.value = subTotal.value - discount.value + totalTax.value;
    salesOrderList.removeAt(index);
  }

  addOrUpdateProductToSales(Products product, bool isAdding, bool isScanning,
      ProductDetailsModel single, int index, BuildContext context) async {
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
      getProductDetails(product.productId ?? '', context, isScanning);
      // price.value = singleProduct.value.model[0].price1;
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
          title: Text(product.description ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
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
                                await addItem(context, taxAmount);
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
                              updateItem(context, single, index);
                            }
                          }),
              ],
            ),
          ],
        ));
  }

  addItem(BuildContext context, taxAmount) async {
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
    salesOrderList.add(singleProduct.value);

    isPriceEdited.value
        ? calculateTotal(
            price.value, singleProduct.value.model[0].updatedQuantity)
        : calculateTotal(singleProduct.value.model[0].price1,
            singleProduct.value.model[0].updatedQuantity);
    calculateTotalTax(taxAmount, singleProduct.value.model[0].updatedQuantity);

    quantity.value = 1.0;
    Navigator.pop(context);
    Navigator.pop(context);
    developer.log(salesOrderList.length.toString(),
        name: 'salesOrderList.length');
  }

  // Widget dia(BuildContext context, bool isAdding, single, isScanning, index) {
  //   return ;
  // }

  updateItem(
      BuildContext context, ProductDetailsModel single, int index) async {
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
    salesOrderList.insert(index, single);
    salesOrderList.removeAt(index + 1);

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

  getLastSalesTransactionByCustomer(ProductDetailsModel product) async {
    await loginController.getToken();
    if (loginController.token.value.isEmpty) {
      await loginController.getToken();
    }
    final String token = loginController.token.value;
    final String customer = customerId.value;
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
}
