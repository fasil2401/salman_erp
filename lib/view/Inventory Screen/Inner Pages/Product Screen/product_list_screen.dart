import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Inventory%20Controls/products_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Product%20Screen/inventory_scanning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  final productsController = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: productsController.resetList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: Obx(() {
          if (productsController.isLoading.value) {
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
                          Get.to(() => InventoryScanner());
                        },
                        child: Icon(
                          Icons.qr_code_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    onChanged: (value) =>
                        productsController.searchProducts(value),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => productsController.filterList.isEmpty
                        ? Center(
                            child: Text('No Data Found!'),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.separated(
                              itemCount: productsController.filterList.length,
                              itemBuilder: (context, index) {
                                var product =
                                    productsController.filterList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    productsController
                                        .getProductDetails(product.productId);
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
