import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_item_snaning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SalesProductListScreen extends StatelessWidget {
  SalesProductListScreen({super.key});

  final productsController = Get.put(SalesOrderController());

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
                         const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          Get.to(() =>const SalesOrderScanner());
                        },
                        child:const Icon(
                          Icons.qr_code_scanner_rounded,
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
                        ? const Center(
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
                                    productsController
                                        .addOrUpdateProductToSales(
                                            product,
                                            true,
                                            false,
                                            ProductDetailsModel(
                                                res: 1,
                                                model: [],
                                                unitmodel: [],
                                                productlocationmodel: [],
                                                msg: ''), 1,context);
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
                                            style:const TextStyle(
                                                color: AppColors.mutedColor),
                                          ),
                                        ),
                                       const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: AutoSizeText(
                                            product.description,
                                            maxFontSize: 20,
                                            minFontSize: 14,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: AppColors.mutedColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>const SizedBox(
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
