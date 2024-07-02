import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Inventory%20Screen/components/product_detail_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class InventoryShimmer {
  List<String> unitList = [];

  static Widget loadShimmer(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              height: 6.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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
            controller: TextEditingController(text: 'Product Classification'),
            callback: () async {},
            label: 'Class',
          ),
          const SizedBox(
            height: 10,
          ),
          ItemDetailsField(
            controller: TextEditingController(text: 'Product Name'),
            callback: () async {},
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
                      contentPadding: EdgeInsets.symmetric(vertical: 1.5.w),
                      label: const Padding(
                          padding: EdgeInsets.all(8.0), child: Text('Unit')),
                      // contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                    ),
                    iconSize: 20,
                    buttonHeight: 4.5.w,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: InventoryShimmer()
                        .unitList
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    // fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {},
                    onSaved: (value) {
                      // selectedValue = value;
                    },
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
                    onTap: () {},
                    maxLines: 1,
                    controller: TextEditingController(text: '0.0'),
                    readOnly: true,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.mutedColor, width: 0.1),
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
                            controller: TextEditingController(text: '0.0'),
                            callback: () {},
                            label: 'Price 1',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ItemDetailsField(
                            controller: TextEditingController(text: '0.0'),
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
                            controller: TextEditingController(text: '0.0'),
                            callback: () {},
                            label: 'Minimum Price',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ItemDetailsField(
                            controller: TextEditingController(text: '0.0'),
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
                      controller: TextEditingController(text: '0.0'),
                      callback: () {},
                      label: 'Size',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: width * 0.3,
                  width: width * 0.43,
                  decoration: BoxDecoration(
                    // color: AppColors.mutedColor,
                    image: DecorationImage(
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
                  controller: TextEditingController(text: 'Origin'),
                  callback: () {},
                  label: 'Origin',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: ItemDetailsField(
                  controller: TextEditingController(text: 'Brand'),
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
                  controller: TextEditingController(text: 'Manufacturer'),
                  callback: () {},
                  label: 'Manufacturer',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: ItemDetailsField(
                  controller: TextEditingController(text: 'Style'),
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
                  controller: TextEditingController(text: 'Reorder Level'),
                  callback: () {},
                  label: 'Reorder Level',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: ItemDetailsField(
                  controller: TextEditingController(text: 'Bin'),
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
              onPressed: () {},
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
      ),
    );
  }
}
