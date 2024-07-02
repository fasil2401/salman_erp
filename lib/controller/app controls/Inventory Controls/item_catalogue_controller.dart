import 'dart:convert';

import 'package:axolon_erp/model/Inventory%20Model/all_product_catalog_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:developer' as developer;
import '../../../model/Sales Model/get_customer_satatement_model.dart';
import '../../../services/Api Services/api_services.dart';
import '../../../utils/constants/snackbar.dart';
import '../../../utils/date_formatter.dart';
import '../../Api Controls/login_token_controller.dart';

class ItemCatalogueController extends GetxController {
  final loginController = Get.put(LoginTokenController());

  var isLoadingReport = false.obs;
  var isPrintingProgress = false.obs;
  var response = 0.obs;
  var reportList = [].obs;

  late ReportSource reportSource;

//---------old filter fields start -------------//

// var fromProduct = Products().obs;
// var toProduct = Products().obs;
// var catalogueIndex = 0.obs;

// selectFromProduct(Products product) {
//     this.fromProduct.value = product;
//     // customerId.value = this.customer.value.code ?? '';
//   }

// selectToProduct(Products product) {
//     this.toProduct.value = product;
//     // customerId.value = this.customer.value.code ?? '';
//   }

//---------old filter fields end -------------//

//---------products start -------------//
  TextEditingController productsControl = TextEditingController();
  TextEditingController productClassControl = TextEditingController();
  TextEditingController productCategoryControl = TextEditingController();
  TextEditingController productBrandControl = TextEditingController();
  TextEditingController productManufactureControl = TextEditingController();
  TextEditingController ProductOriginControl = TextEditingController();
  TextEditingController ProductStyleControl = TextEditingController();

  var isRangeProducts = false.obs;
  var isRangeProductClass = false.obs;
  var isRangeProductCategory = false.obs;
  var isRangeProductBrand = false.obs;
  var isRangeProductManufacture = false.obs;
  var isRangeProductOrigin = false.obs;
  var isRangeProductStyle = false.obs;

  var selectedProductList = [].obs;
  var selectedProductClassList = [].obs;
  var selectedProductCategoryList = [].obs;
  var selectedProductBrandList = [].obs;
  var selectedProductManufactureList = [].obs;
  var selectedProductOriginList = [].obs;
  var selectedProductStyleList = [].obs;

  var productAccordion = false.obs;

  showProductAccordian() {
    productAccordion.value = !productAccordion.value;
  }

  //---------products end -------------//

  //---------inactive toggles start -------------//
  var isinactiveProducts = false.obs;
  var iszeroQtyProducts = false.obs;

  toggleInactiveProducts() {
    isinactiveProducts.value = !isinactiveProducts.value;
  }

  toggleZeroQtyProducts() {
    iszeroQtyProducts.value = !iszeroQtyProducts.value;
  }

  //---------inactive toggles end -------------//

  getProductCatalogReport({required BuildContext context}) async {
    if (isLoadingReport.value == false) {
      isLoadingReport.value = true;
      await loginController.getToken();
      final String token = loginController.token.value;
      final data = jsonEncode({
        "token": token,
        "fromItem": CommonFilterControls.getJsonFromToFilter(
            true, isRangeProducts.value, true, selectedProductList),
        "toItem": CommonFilterControls.getJsonFromToFilter(
            false, isRangeProducts.value, true, selectedProductList),
        "fromClass": CommonFilterControls.getJsonFromToFilter(
            true, isRangeProductClass.value, false, selectedProductClassList),
        "toClass": CommonFilterControls.getJsonFromToFilter(
            false, isRangeProductClass.value, false, selectedProductClassList),
        "fromCategory": CommonFilterControls.getJsonFromToFilter(true,
            isRangeProductCategory.value, false, selectedProductCategoryList),
        "toCategory": CommonFilterControls.getJsonFromToFilter(false,
            isRangeProductCategory.value, false, selectedProductCategoryList),
        "fromBrand": CommonFilterControls.getJsonFromToFilter(
            true, isRangeProductBrand.value, false, selectedProductBrandList),
        "toBrand": CommonFilterControls.getJsonFromToFilter(
            false, isRangeProductBrand.value, false, selectedProductBrandList),
        "fromManufacturer": CommonFilterControls.getJsonFromToFilter(
            true,
            isRangeProductManufacture.value,
            false,
            selectedProductManufactureList),
        "toManufacturer": CommonFilterControls.getJsonFromToFilter(
            false,
            isRangeProductManufacture.value,
            false,
            selectedProductManufactureList),
        "fromStyle": CommonFilterControls.getJsonFromToFilter(
            true, isRangeProductStyle.value, false, selectedProductStyleList),
        "toStyle": CommonFilterControls.getJsonFromToFilter(
            false, isRangeProductStyle.value, false, selectedProductStyleList),
        "fromOrigin": CommonFilterControls.getJsonFromToFilter(
            true, isRangeProductOrigin.value, false, selectedProductOriginList),
        "toOrigin": CommonFilterControls.getJsonFromToFilter(false,
            isRangeProductOrigin.value, false, selectedProductOriginList),
        "ItemIDs": CommonFilterControls.getJsonListFilter(
            productsControl, isRangeProducts.value, selectedProductList, true),
        "ItemClassIDs": CommonFilterControls.getJsonListFilter(
            productClassControl,
            isRangeProductClass.value,
            selectedProductClassList,
            false),
        "ItemCategoryIDs": CommonFilterControls.getJsonListFilter(
            productCategoryControl,
            isRangeProductCategory.value,
            selectedProductCategoryList,
            false),
        "BrandIDs": CommonFilterControls.getJsonListFilter(productBrandControl,
            isRangeProductBrand.value, selectedProductBrandList, false),
        "ManufactureIDs": CommonFilterControls.getJsonListFilter(
            productManufactureControl,
            isRangeProductManufacture.value,
            selectedProductManufactureList,
            false),
        "OriginIDs": CommonFilterControls.getJsonListFilter(
            ProductOriginControl,
            isRangeProductOrigin.value,
            selectedProductOriginList,
            false),
        "StyleIDs": CommonFilterControls.getJsonListFilter(ProductStyleControl,
            isRangeProductStyle.value, selectedProductStyleList, false),
        "ShowInActive": isinactiveProducts.value,
        "ShowZeroQuantity": iszeroQtyProducts.value
      });

      dynamic result;
      try {
        var feedback = await ApiServices.fetchDataRawBodyInventory(
            // api:'GetProductCatalogReport?token=${token}&FromItem=${fromProduct.value.productId}&ToItem=${toProduct.value.productId}&ShowInActive=${isinactiveProducts}&ShowZeroQuantity=${iszeroQtyProducts}'
            api: 'GetProductCatalogReport',
            data: data);
        if (feedback != null) {
          result = AllProductCatalogModel.fromJson(feedback);
          print(result);
          response.value = result.res;
          reportList.value = result.model;
          reportSource = ReportSource(result.model);
        }
      } finally {
        isLoadingReport.value = false;
        if (response.value == 1 && reportList.value.isNotEmpty) {
          Navigator.pop(context);
          // developer.log(reportList.value[0].name.toString(),
          //   name: 'Customer Name');
        } else {
          SnackbarServices.errorSnackbar('No Data Found !!');
        }
      }
    }
  }

  getItemsPrint() {
    return ListView.builder(
      itemCount: reportList.length,
      itemBuilder: (context, index) {
        var product = reportList[index];
        return Row(
          children: [Text('Item Code : '), Text(product.productID)],
        );
      },
    );
  }
}

class ReportSource extends DataGridSource {
  ReportSource(List<ProductCatalogModel> analysis) {
    dataGridRows = analysis
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<dynamic>(
                  columnName: 'Product ID', value: dataGridRow.productID),
              DataGridCell<dynamic>(
                  columnName: 'Name',
                  value: dataGridRow.description == null
                      ? ''
                      : dataGridRow.description!.replaceAll('\n', ' ')),
              DataGridCell<dynamic>(
                  columnName: 'Class Name',
                  value: dataGridRow.className == null
                      ? ''
                      : dataGridRow.className!.replaceAll('\n', ' ')),
              DataGridCell<dynamic>(
                  columnName: 'Unit',
                  value: dataGridRow.unitID == null
                      ? ''
                      : dataGridRow.unitID!.replaceAll('\n', ' ')),
            ],
          ),
        )
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 20,
          width: 100,
          alignment: dataGridCell.columnName == 'Date'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child:
              //  dataGridCell.columnName == 'Profit'
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           RotatedBox(
              //             quarterTurns:
              //                 double.parse(dataGridCell.value) >= 0 ? 4 : 2,
              //             child: SvgPicture.asset(
              //               AppIcons.up_arrow,
              //               height: 15,
              //               width: 10,
              //               color: double.parse(dataGridCell.value) >= 0
              //                   ? AppColors.success
              //                   : AppColors.error,
              //             ),
              //           ),
              //           Text(
              //             dataGridCell.value.toString(),
              //             // overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       )
              //     :
              Text(
            dataGridCell.value.toString(),
            // overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
