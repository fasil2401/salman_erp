import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/Inventory%20Controls/inventory_item_list_controller.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/filter_dilog_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'filter_dialog.dart';

class InventoryItemListScreen extends StatelessWidget {
  InventoryItemListScreen({super.key});
  final itemListController = Get.put(ItemListController());
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => buildExpansionTextFields(
                          controller: itemListController.searchController.value,
                          onTap: () {},
                          isReadOnly: false,
                          onChanged: (value) {},
                          focus: _focusNode,
                          disableSuffix: true,
                          hint: 'Search',
                          isSearch: true),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      itemListController.searchProducts(itemListController
                          .searchController.value.text
                          .trim());
                    },
                    child: Card(
                        color: AppColors.lightGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.search,
                            color: AppColors.mutedColor,
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      itemListController.toggleChanges();
                      itemListController.clearSearch();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                    top: 15,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    interactive: true,
                                    child: SingleChildScrollView(
                                        child:
                                            _buildFilterBottomsheet(context))),
                              ));
                    },
                    child: Card(
                        color: AppColors.lightGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SvgPicture.asset(
                            AppIcons.filter,
                            width: 22,
                            height: 22,
                            color: AppColors.mutedColor,
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      '${itemListController.filterSearchProductList.length} Results',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() => itemListController.isProductLoading.value
                  ? popShimmer()
                  : itemListController.filterList.isEmpty
                      ? const Text("No Data")
                      : GetBuilder<ItemListController>(builder: (_) {
                          return ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 8,
                            ),
                            shrinkWrap: true,
                            // key: key,//
                            itemCount: _.filterSearchProductList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var item = _.filterSearchProductList[index];
                              int color = _.getColor(item.itemCode);
                              String hexColorCode =
                                  color.toRadixString(16).toUpperCase();
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadowColor: Colors.black,
                                elevation: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: hexColorCode == '0' ||
                                                hexColorCode == ''
                                            ? Colors.white
                                            : Color(int.parse('${hexColorCode}',
                                                    radix: 16) +
                                                0xFF000000), // Color of the bottom border
                                        offset: const Offset(
                                            0, 3), // Position of the shadow
                                        blurRadius: 0, // Spread of the shadow
                                      ),
                                    ],
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: IgnorePointer(
                                      ignoring: false,
                                      child: ExpansionTile(
                                        // initiallyExpanded: isExpanded,

                                        tilePadding: EdgeInsets.zero,
                                        // trailing: const SizedBox(
                                        //   width: 0,
                                        // ),
                                        textColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            Null;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 0, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${item.itemCode ?? ''} :',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .primary),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${item.description ?? ''}",
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .primary),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.category ?? ''}",
                                                          title: 'Category'),
                                                    ),
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.origin ?? ''}",
                                                          title: 'Origin'),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.brand ?? ''}",
                                                          title: 'Brand'),
                                                    ),
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.type ?? ''}",
                                                          title: 'Type'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.style ?? ''}",
                                                          title: 'Style'),
                                                    ),
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.modelClass ?? ''}",
                                                          title: 'Class'),
                                                    ),
                                                  ],
                                                ),
                                                _buildTileText(
                                                    text:
                                                        "${item.modelClass ?? ''}",
                                                    title: 'Location'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.onhand ?? ''}",
                                                          title: 'OnHand'),
                                                    ),
                                                    Expanded(
                                                      child: _buildTileText(
                                                          text:
                                                              "${item.unit ?? ''}",
                                                          title: 'Unit'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 0, 12, 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Divider(
                                                      thickness: 1.5,
                                                      color:
                                                          AppColors.lightGrey,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Total Weight : ${item.totalWeight ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Age : ${item.age ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Manufacturer : ${item.manufacturer ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Reorder Level : ${item.reorderLevel ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Size : ${item.size ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "VendorRef : ${item.vendorRef ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Weight : ${item.weight ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Attribute 3 : ${item.attribute3 ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Alias : ${item.alias ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Price 1 : ${item.unitPrice1 ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Price 2 : ${item.unitPrice2 ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Price 3 : ${item.unitPrice3 ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Value : ${item.value ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Avg Cost : ${item.avgCost ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "UPC : ${item.upc ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                        Text(
                                                          "Last Sale : ${item.lastSale ?? ''}",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .mutedColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              // );
                            },
                          );
                        }))
            ],
          ),
        ),
      ),
    );
  }

  Column _buildFilterBottomsheet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Filter'),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Category'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller:
                          itemListController.categoryFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.categoryFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.categoryFilterId,
                            filterList: itemListController.categoryFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Origin'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller:
                          itemListController.originFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.originFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.originFilterId,
                            filterList: itemListController.originFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Brand'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller:
                          itemListController.brandFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.brandFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.brandFilterId,
                            filterList: itemListController.brandFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Type'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller: itemListController.typeFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.locationFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.locationFilterId,
                            filterList: itemListController.locationFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Style'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller:
                          itemListController.styleFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.styleFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.styleFilterId,
                            filterList: itemListController.styleFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Class'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller:
                          itemListController.classFilterController.value,
                      onTap: () {
                        itemListController
                            .getList(itemListController.classFilterId);
                        _buildFilterDialog(context,
                            filterId: itemListController.classFilterId,
                            filterList: itemListController.classFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextFieldLabel('Location'),
            Obx(
              () => buildExpansionTextFields(
                controller: itemListController.locationFilterController.value,
                onTap: () {
                  itemListController
                      .getList(itemListController.locationFilterId);
                  _buildFilterDialog(context,
                      filterId: itemListController.locationFilterId,
                      filterList: itemListController.locationFilter);
                },
                isDropdown: true,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: const Text(
                'Show items with zero quantity',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedColor,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: Obx(() => CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: itemListController.iszeroQtyProducts.value,
                    onChanged: (value) {
                      itemListController.toggleZeroQtyProducts();
                    },
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: const Text(
                'Show Inactive Products',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedColor,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: Obx(() => CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: itemListController.isinactiveProducts.value,
                    onChanged: (value) {
                      itemListController.toggleInactiveProducts();
                    },
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: AppColors.mutedBlueColor,
                ),
                onPressed: () {
                  itemListController.clearFilter();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    if (itemListController.isChangedValues()) {
                      await itemListController.getProductList();
                    }
                    itemListController.filterItemList();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply')),
            ),
          ],
        )
      ],
    );
  }

  Future<dynamic> _buildFilterDialog(BuildContext context,
      {required String filterId, required List<dynamic> filterList}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            title: popupTitle(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Select $filterId'),
            content: FilterDiailog(filterId: filterId, filterList: filterList),
          );
        });
  }

  ClipRRect _buildExpansionTextFields(
      {required TextEditingController controller, required Function() onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: AppColors.mutedColor),
        maxLines: 1,
        onTap: onTap,
        readOnly: true,
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          filled: true,
          // enabled: false,
          fillColor: AppColors.lightGrey.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffix: SvgPicture.asset(
            AppIcons.edit,
            color: AppColors.mutedColor,
            height: 15,
            width: 15,
          ),
        ),
      ),
    );
  }

  Row _buildTileText({required String title, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title : ",
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        Expanded(
          child: Text(text,
              textAlign: TextAlign.start,
              // maxLines: 2,
              style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        ),
      ],
    );
  }
}
