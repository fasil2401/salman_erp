import 'dart:convert';

import 'package:axolon_erp/controller/app%20controls/Inventory%20Controls/products_controller.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Load%20Shimmer/inventory_shimmer.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Product%20Screen/product_list_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/components/product_detail_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProductDetails extends StatelessWidget {
  ProductDetails({Key? key}) : super(key: key);

  List<String> unitList = [];
  final productsController = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            Uint8List bytes = Base64Codec().decode(
                productsController.singleProduct.value.productimage ?? '');
            return productsController.isProductLoading.value
                ? InventoryShimmer.loadShimmer(width)
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => ProductListScreen());
                        },
                        child: SizedBox(
                          height: 6.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productsController
                                        .singleProduct.value.productId ??
                                    'Product Id',
                              ),
                              Icon(
                                Icons.qr_code_rounded,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      const SizedBox(
                        height: 15,
                      ),
                      ItemDetailsField(
                        controller: TextEditingController(
                            text: productsController
                                    .singleProduct.value.modelClass ??
                                ' '),
                        callback: () async {},
                        label: 'Class',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ItemDetailsField(
                        controller: TextEditingController(
                            text: productsController
                                    .singleProduct.value.category ??
                                ' '),
                        callback: () async {},
                        label: 'Category',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ItemDetailsField(
                        controller: TextEditingController(
                            text: productsController
                                        .singleProduct.value.description !=
                                    null
                                ? productsController
                                    .singleProduct.value.description!
                                    .replaceAll("\n", " ")
                                : ' '),
                        callback: () async {
                          Get.to(() => ProductListScreen());
                        },
                        label: 'Item Name',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 10.w,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 1.5.w),
                                  label: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      productsController.unitLabel.value,
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
                                buttonPadding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                items: productsController.unitList
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item.code,
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
                                  var selectedUnit = value;
                                  String unit = selectedUnit.toString();
                                  productsController.changeUnit(unit);
                                },
                                onSaved: (value) {},
                              ),
                            ),

                            // ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 9.w,
                              child: TextField(
                                // controller: na meController,
                                onTap: () {
                                  productsController
                                      .showDetailDialogue(context);
                                },
                                maxLines: 1,
                                controller: TextEditingController(
                                    text:
                                        InventoryCalculations.roundOffQuantity(
                                            quantity: productsController
                                                .totalStock.value)),
                                readOnly: true,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3.w),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.mutedColor,
                                        width: 0.1),
                                  ),
                                  labelText: 'Stock',
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                  suffixIcon: Icon(Icons.info_outline_rounded,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: ItemDetailsField(
                                        controller: TextEditingController(
                                            text: productsController
                                                        .singleProduct
                                                        .value
                                                        .price1 !=
                                                    null
                                                ? productsController
                                                    .singleProduct.value.price1
                                                    .toString()
                                                : '0.0'),
                                        callback: () {},
                                        label: 'Price 1',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: ItemDetailsField(
                                        controller: TextEditingController(
                                            text: productsController
                                                        .singleProduct
                                                        .value
                                                        .price2 !=
                                                    null
                                                ? productsController
                                                    .singleProduct.value.price2
                                                    .toString()
                                                : '0.0'),
                                        callback: () {},
                                        label: 'Price 2',
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: ItemDetailsField(
                                        controller: TextEditingController(
                                            text: productsController
                                                        .singleProduct
                                                        .value
                                                        .minPrice !=
                                                    null
                                                ? productsController
                                                    .singleProduct
                                                    .value
                                                    .minPrice
                                                    .toString()
                                                : '0.0'),
                                        callback: () {},
                                        label: 'Minimum Price',
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: ItemDetailsField(
                                        controller: TextEditingController(
                                            text: productsController
                                                        .singleProduct
                                                        .value
                                                        .specialPrice !=
                                                    null
                                                ? productsController
                                                    .singleProduct
                                                    .value
                                                    .specialPrice
                                                    .toString()
                                                : '0.0'),
                                        callback: () {},
                                        label: 'Special Price',
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ItemDetailsField(
                                  controller: TextEditingController(
                                      text: productsController
                                              .singleProduct.value.size ??
                                          '0.0'),
                                  callback: () {},
                                  label: 'Size',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (productsController
                                        .singleProduct.value.productimage !=
                                    '') {
                                  Get.defaultDialog(
                                    title: productsController
                                        .singleProduct.value.description!,
                                    titleStyle: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    titlePadding: EdgeInsets.all(10),
                                    content: LimitedBox(
                                      maxHeight: 0.5 * height,
                                      child: Image.memory(
                                        bytes,
                                        scale: 1,
                                        fit: BoxFit.contain,
                                        width: 0.7 * width,
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                }
                              },
                              child: Container(
                                height: width * 0.3,
                                width: width * 0.43,
                                decoration: BoxDecoration(
                                  // color: AppColors.mutedColor,
                                  image: productsController.singleProduct.value
                                                  .productimage !=
                                              null &&
                                          productsController.singleProduct.value
                                                  .productimage !=
                                              ''
                                      ? DecorationImage(
                                          image: MemoryImage(bytes, scale: 1),
                                          fit: BoxFit.contain,
                                        )
                                      : DecorationImage(
                                          image: AssetImage(Images.placeholder),
                                          fit: BoxFit.cover,
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.mutedColor,
                                    width: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController
                                          .singleProduct.value.origin ??
                                      ' '),
                              callback: () {},
                              label: 'Origin',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController
                                          .singleProduct.value.brand ??
                                      ' '),
                              callback: () {},
                              label: 'Brand',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController
                                          .singleProduct.value.manufacturer ??
                                      ' '),
                              callback: () {},
                              label: 'Manufacturer',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController
                                          .singleProduct.value.style ??
                                      ' '),
                              callback: () {},
                              label: 'Style',
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController.singleProduct.value
                                              .reorderLevel !=
                                          null
                                      ? productsController
                                          .singleProduct.value.reorderLevel
                                          .toString()
                                      : ' '),
                              callback: () {},
                              label: 'Reorder Level',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: ItemDetailsField(
                              controller: TextEditingController(
                                  text: productsController
                                          .singleProduct.value.rackBin ??
                                      ' '),
                              callback: () {},
                              label: 'Bin',
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Close',
                          ),
                        ),
                      )
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
