import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/merchandise_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_invoice_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/sales_Invoice_item_scanning.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MerchandProductListScreen extends StatelessWidget {
  MerchandProductListScreen({super.key});

  final merchandisecontroller = Get.put(MerchandiseController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: merchandisecontroller.resetList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: Obx(() {
          if (merchandisecontroller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          } else {
            return Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      isCollapsed: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                        
                        },
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    onChanged: (value) =>
                        merchandisecontroller.searchProducts(value),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => merchandisecontroller.filterList.isEmpty
                        ? Center(
                            child: Text('No Data Found!'),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.separated(
                              itemCount:
                                  merchandisecontroller.filterList.length,
                              itemBuilder: (context, index) {
                                var product =
                                    merchandisecontroller.filterList[index];

                                return InkWell(
                                  onTap: () async {
                                    await merchandisecontroller
                                        .addOrUpdateProductToMerchandise(
                                            product,
                                            true,
                                            ProductDetailsModel(
                                                res: 1,
                                                model: [],
                                                unitmodel: [],
                                                productlocationmodel: [],
                                                msg: ''),
                                            1,
                                            context);
                                    Get.dialog(
                                        barrierDismissible: false,
                                        AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          scrollable: true,
                                          titlePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                          title: Text(product.description ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),
                                          content: SizedBox(
                                              width: double.maxFinite,
                                              child: SingleChildScrollView(
                                                  child: Obx(() {
                                                return merchandisecontroller
                                                        .isProductLoading.value
                                                    ? SalesShimmer
                                                        .popUpShimmer()
                                                    : Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: const [
                                                              Text(
                                                                'Quantity ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppColors
                                                                        .primary),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  'Stock',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: AppColors
                                                                          .primary),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        merchandisecontroller
                                                                            .decrementQuantity();
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor:
                                                                            AppColors.primary,
                                                                        radius:
                                                                            15,
                                                                        child: const Center(
                                                                            child:
                                                                                Icon(Icons.remove)),
                                                                      ),
                                                                    ),
                                                                    Obx(() {
                                                                      merchandisecontroller
                                                                          .quantityControl
                                                                          .value
                                                                          .selection = TextSelection.fromPosition(TextPosition(offset: merchandisecontroller.quantityControl.value.text.length));
                                                                      return Flexible(
                                                                        child: merchandisecontroller.edit.value
                                                                            ? TextField(
                                                                                autofocus: false,
                                                                                controller: merchandisecontroller.quantityControl.value,
                                                                                textAlign: TextAlign.center,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: const InputDecoration.collapsed(hintText: ''),
                                                                                onChanged: (value) {
                                                                                  merchandisecontroller.setQuantity(value);
                                                                                },
                                                                                onTap: () => merchandisecontroller.quantityControl.value.selectAll(),
                                                                              )
                                                                            : Obx(
                                                                                () => InkWell(
                                                                                  onTap: () {
                                                                                    merchandisecontroller.editQuantity();
                                                                                  },
                                                                                  child: Text(merchandisecontroller.quantity.value.toString()),
                                                                                ),
                                                                              ),
                                                                      );
                                                                    }),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        merchandisecontroller
                                                                            .incrementQuantity();
                                                                      },
                                                                      child:
                                                                          const CircleAvatar(
                                                                        backgroundColor:
                                                                            AppColors.primary,
                                                                        radius:
                                                                            15,
                                                                        child: Center(
                                                                            child:
                                                                                Icon(Icons.add)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Center(
                                                                  child: Text(
                                                                    InventoryCalculations
                                                                        .roundOffQuantity(
                                                                      quantity: merchandisecontroller
                                                                          .availableStock
                                                                          .value,
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: AppColors
                                                                            .primary),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      DropdownButtonFormField2(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isCollapsed:
                                                                          true,
                                                                      contentPadding:
                                                                          EdgeInsets.symmetric(
                                                                              vertical: 5),
                                                                      label:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          merchandisecontroller
                                                                              .unit
                                                                              .value,
                                                                          style: TextStyle(
                                                                              color: AppColors.primary,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .arrow_drop_down,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                    iconSize:
                                                                        20,
                                                                    // buttonHeight: 4.5.w,
                                                                    buttonPadding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            10),
                                                                    dropdownDecoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                    items: merchandisecontroller
                                                                        .unitList
                                                                        .map(
                                                                          (item) =>
                                                                              DropdownMenuItem(
                                                                            value:
                                                                                item,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
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
                                                                    onChanged:
                                                                        (value) {
                                                                      // developer.log(value.toString());
                                                                      Unitmodel
                                                                          selectedUnit =
                                                                          value
                                                                              as Unitmodel;
                                                                      // String unit = selectedUnit.code.toString();
                                                                      if (merchandisecontroller
                                                                              .availableStock
                                                                              .value !=
                                                                          0.0) {
                                                                        merchandisecontroller.availableStock.value = InventoryCalculations.getStockPerFactor(
                                                                            factorType:
                                                                                selectedUnit.factorType!,
                                                                            factor: double.parse(selectedUnit.factor!),
                                                                            stock: merchandisecontroller.singleProduct.value.model[0].quantity);
                                                                      } else if (merchandisecontroller
                                                                              .availableStock
                                                                              .value !=
                                                                          0.0) {
                                                                        merchandisecontroller.availableStock.value = InventoryCalculations.getStockPerFactor(
                                                                            factorType:
                                                                                selectedUnit.factorType!,
                                                                            factor: double.parse(selectedUnit.factor!),
                                                                            stock: merchandisecontroller.singleProduct.value.model[0].quantity);
                                                                      }
                                                                    },
                                                                    onSaved:
                                                                        (value) {},
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 9,
                                                                    right: 15),
                                                            child: Obx(
                                                              () =>
                                                                  CommonTextField
                                                                      .textfield(
                                                                suffixicon:
                                                                    true,
                                                                readonly: true,
                                                                keyboardtype:
                                                                    TextInputType
                                                                        .datetime,
                                                                controller: TextEditingController(
                                                                    text: merchandisecontroller.isexpirydate.value ==
                                                                            false
                                                                        ? ""
                                                                        : "${DateFormatter.dateFormat.format(merchandisecontroller.expirydate.value)}"),
                                                                label:
                                                                    "Expiry Date",
                                                                ontap:
                                                                    () async {
                                                                  DateTime date = await merchandisecontroller.selectExpiryDate(
                                                                      context,
                                                                      merchandisecontroller
                                                                          .expirydate
                                                                          .value);
                                                                  merchandisecontroller
                                                                      .expirydate
                                                                      .value = date;
                                                                },
                                                                icon: Icons
                                                                    .calendar_month_outlined,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                              }))),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors
                                                        .mutedBlueColor,
                                                  ),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColors.primary),
                                                  ),
                                                  onPressed: () {
                                                    merchandisecontroller
                                                        .quantity.value = 1.0;

                                                    Navigator.of(context).pop();
                                                    merchandisecontroller
                                                        .cancelAdd();
                                                  },
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                    ),
                                                    child: Text(
                                                      'Add',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      if (merchandisecontroller
                                                              .isProductLoading
                                                              .value ==
                                                          false) {
                                                        await merchandisecontroller
                                                            .addItem(context);
                                                        merchandisecontroller
                                                            .clearAdd();
                                                      } else {
                                                        SnackbarServices
                                                            .errorSnackbar(
                                                                'Quantity is not available');
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 22.w,
                                          child: AutoSizeText(
                                            product.productId,
                                            maxLines: 2,
                                            maxFontSize: 20,
                                            minFontSize: 14,
                                            style: TextStyle(
                                                color: AppColors.mutedColor),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: AutoSizeText(
                                            product.description,
                                            maxFontSize: 20,
                                            minFontSize: 14,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: AppColors.mutedColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 2,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  

  Container _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22.w,
              child: AutoSizeText(
                'Code',
                maxLines: 2,
                maxFontSize: 20,
                minFontSize: 14,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: AutoSizeText(
                'Name',
                maxFontSize: 20,
                minFontSize: 14,
                maxLines: 2,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension TextEditingControllerExt on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
