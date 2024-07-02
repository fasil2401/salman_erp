import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/app controls/Inventory Controls/item_stock_controller.dart';
import '../../../components/accordian.dart';
import '../../../components/common_text_field.dart';

class ItemStockScreen extends StatefulWidget {
  const ItemStockScreen({super.key});

  @override
  State<ItemStockScreen> createState() => _ItemStockScreenState();
}

class _ItemStockScreenState extends State<ItemStockScreen> {
  final itemStockController = Get.put(ItemStockController());
  var selectedValue;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, buildFilter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Obx(() => CommonFilterControls.reportAppbar(
                baseString: itemStockController.baseString.value,
                name: "Product Stock"))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Obx(() => itemStockController.baseString.value.isEmpty
                  ? CommonFilterControls.buildEmptyPlaceholder()
                  : GetBuilder<ItemStockController>(builder: (controller) {
                      return CommonFilterControls.buildPdfView(
                          controller.bytes.value);
                    })),
            ),
          ],
        ),
        floatingActionButton: CommonFilterControls.buildFilterButton(context,
            filter: buildFilter(context)));
  }

  buildFilter(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
                child: Obx(() => CommonTextField.textfield(
                    suffixicon: true,
                    readonly: true,
                    keyboardtype: TextInputType.text,
                    label: 'As of Date',
                    ontap: () {
                      itemStockController.selectDate(context);
                    },
                    controller: TextEditingController(
                      text: DateFormatter.dateFormat
                          .format(itemStockController.reportDate.value)
                          .toString(),
                    ),
                    icon: Icons.calendar_month))),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Card(
                      child: Center(
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.mutedColor,
                    ),
                  ))),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildLocationFilter(
              context,
              onTapLocation: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.locationController.value, filterOptions: FilterComboOptions.Location, 
            selectedList: itemStockController.selectedLocationList, 
            isRange: itemStockController.isRangeLocation, isProduct: false);},
              locationController: itemStockController.locationController.value,
            )),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonFilterControls.buildProductFilter(context,
            isAccordionOpen: itemStockController.productAccordion.value,
            onToggle: (value) {
              itemStockController.showProductAccordian();
            },
            productController: itemStockController.productControl,
            classController: itemStockController.classControl,
            categoryController: itemStockController.categoryControl,
            brandController: itemStockController.brandControl,
            manufacturerController: itemStockController.manufacturerControl,
            originController: itemStockController.originControl,
            styleController: itemStockController.styleControl,

onTapProduct: (){ CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.productControl, filterOptions: FilterComboOptions.Item, 
            selectedList: itemStockController.selectedProductList, 
            isRange: itemStockController.isRangeProduct, isProduct: true);},

            onTapClass: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.classControl, filterOptions: FilterComboOptions.ItemClass, 
            selectedList: itemStockController.selectedclassList, 
            isRange: itemStockController.isRangeClass, isProduct: false);},

            onTapCategory: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.categoryControl, filterOptions: FilterComboOptions.ItemCategory, 
            selectedList: itemStockController.selectedCategoryList, 
            isRange: itemStockController.isRangeCategory, isProduct: false);},
            
            onTapBrand: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.brandControl, filterOptions: FilterComboOptions.ItemBrand, 
            selectedList: itemStockController.selectedBrandList, 
            isRange: itemStockController.isRangeBrand, isProduct: false);},
            
            onTapManufacturer: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.manufacturerControl, filterOptions: FilterComboOptions.ItemManufacture, 
            selectedList: itemStockController.selectedManufacturerList, 
            isRange: itemStockController.isRangeManufacturer, isProduct: false);},

            onTapOrigin: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.originControl, filterOptions: FilterComboOptions.ItemOrigin, 
            selectedList: itemStockController.selectedOriginList, 
            isRange: itemStockController.isRangeOrigin, isProduct: false);},
            
            onTapStyle: () { CommonFilterControls.OnTapCommon(homeController: homeController, context: context, 
            txtController: itemStockController.styleControl, filterOptions: FilterComboOptions.ItemStyle, 
            selectedList: itemStockController.selectedStyleList, 
            isRange: itemStockController.isRangeStyle, isProduct: false);}

            )),
        Obx(() => CommonFilterControls.buildToggleTile(
              toggleText: 'Show items with zero quantity',
              switchValue: itemStockController.iszeroQtyProducts.value,
              onToggled: (bool? value) {
                itemStockController.toggleZeroQtyProducts();
              },
            )),
        Obx(() => CommonFilterControls.buildToggleTile(
              toggleText: 'Show Inactive Products',
              switchValue: itemStockController.isinactiveProducts.value,
              onToggled: (bool? value) {
                itemStockController.toggleInactiveProducts();
              },
            )),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: itemStockController.isLoading.value,
                onTap: () async {
                  await itemStockController.getProductStockListReport(context);
                },
              ),
            )),
      ],
    );
  }
}
