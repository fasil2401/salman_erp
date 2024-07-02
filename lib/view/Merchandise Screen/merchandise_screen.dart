import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/merchandise_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/Merchandise%20Screen/add-merchandise_item_screen.dart';
import 'package:axolon_erp/view/Merchandise%20Screen/merchand_product_list_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/components/customerIdRow.dart';
import 'package:axolon_erp/view/SalesScreen/components/sysDocRow.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/dragging_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MerchandiseScreen extends StatelessWidget {
  MerchandiseScreen({super.key});

  final merchandisecontroller = Get.put(MerchandiseController());
  final homecontroller = Get.put(HomeController());
  final salesScreenController = Get.put(SalesController());
  var selectedSysdocValue;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Merchandise"),
        actions: [
          IconButton(
            onPressed: () {
              merchandisecontroller.getMerchandiseOpenList();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    title: _buildOpenListHeader(context),
                    content: _buildOpenListPopContent(width, context),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close',
                                  style: TextStyle(color: AppColors.primary)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Obx(
              () => merchandisecontroller.isMerchandiseByIdLoading.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        strokeWidth: 2,
                      ),
                    )
                  : SvgPicture.asset(
                      AppIcons.openList,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 10,
                // ),
                Obx(
                  () => SysDocRow(
                    onTap: () async {
                      await merchandisecontroller.generateSysDocList();
                      if (!merchandisecontroller.isLoading.value) {
                        var sysDoc = await salesScreenController.selectSysDoc(
                            context: context,
                            sysDocType: 26,
                            list: merchandisecontroller.sysDocList);
                        if (sysDoc.code != null) {
                          merchandisecontroller.getVoucherNumber(
                              sysDoc.code, sysDoc.name);
                        }
                      }
                    },
                    sysDocIdController: TextEditingController(
                      text: merchandisecontroller.sysDocName.value,
                    ),
                    sysDocSuffixLoading: salesScreenController.isLoading.value,
                    voucherIdController: TextEditingController(
                      text: merchandisecontroller.voucherNumber.value,
                    ),
                    voucherSuffixLoading:
                        merchandisecontroller.isVoucherLoading.value,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => CustomerIdRow(
                              onTap: () async {
                                merchandisecontroller.resetCustomerList();
                                merchandisecontroller.isSearching.value = false;
                                if (!merchandisecontroller
                                    .isCustomerLoading.value) {
                                  var customer =
                                      await homecontroller.selectCustomer(
                                    context: context,
                                  );
                                  if (customer.code != null) {
                                    merchandisecontroller
                                        .selectCustomer(customer);
                                  }
                                }
                              },
                              controller: TextEditingController(
                                text: merchandisecontroller.customerId.value ==
                                        ''
                                    ? merchandisecontroller
                                            .isCustomerLoading.value
                                        ? 'Please wait..'
                                        : ' '
                                    : merchandisecontroller.customer.value.name,
                              ),
                              isLoading: merchandisecontroller
                                  .isCustomerLoading.value),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Obx(() => CommonTextField.textfield(
                    suffixicon: false,
                    readonly: false,
                    keyboardtype: TextInputType.text,
                    controller: merchandisecontroller.descriptionControl.value,
                    ontap: () async {},
                    label: "Description")),

                SizedBox(
                  height: 18,
                ),
                Obx(() => CommonTextField.textfield(
                      suffixicon: true,
                      readonly: true,
                      keyboardtype: TextInputType.text,
                      controller: TextEditingController(
                        text: merchandisecontroller.locationId.value == ''
                            ? merchandisecontroller.isLocationLoading.value
                                ? 'Please wait..'
                                : ' '
                            : "${merchandisecontroller.location.value.name}",
                      ),
                      icon: Icons.arrow_drop_down_circle_outlined,
                      ontap: () async {
                        merchandisecontroller.location.value =
                            await homecontroller.selectLocatio(
                                context: context,
                                locationList: homecontroller.locationList);
                        merchandisecontroller.locationId.value =
                            merchandisecontroller.location.value.code ?? '';
                      },
                      label: "Location",
                    )),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.black,
                ),

                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => Text(
                            '${merchandisecontroller.merchandiseList.length} Results',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.mutedColor,
                            ),
                          )),
                    ),
                  ],
                ),

                Expanded(
                  flex: 1,
                  child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: merchandisecontroller.merchandiseList.length,
                        itemBuilder: (context, index) {
                          var merchandise = merchandisecontroller
                              .merchandiseList[index].model[0];
                          return Slidable(
                            key: const Key('merchandise_list'),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.green[100]!,
                                    foregroundColor: Colors.green,
                                    icon: Icons.mode_edit_outlined,
                                    onPressed: (_) {
                                      merchandisecontroller
                                          .addOrUpdateProductToMerchandise(
                                              Products(),
                                              false,
                                              merchandisecontroller
                                                  .merchandiseList[index],
                                              index,
                                              context);
                                      merchandisecontroller.expirydate.value =
                                          merchandisecontroller
                                              .merchandiseList[index]
                                              .model[0]
                                              .expiryDate;

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
                                                    horizontal: 12,
                                                    vertical: 12),
                                            title: Text(
                                                merchandise.description ?? '',
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
                                                          .isProductLoading
                                                          .value
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
                                                                          child:
                                                                              const Center(child: Icon(Icons.remove)),
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
                                                                                  // onTap: () => merchandisecontroller.quantityControl.value.selectAll(),
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
                                                                          child:
                                                                              Center(child: Icon(Icons.add)),
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
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              AppColors.primary),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
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
                                                                            EdgeInsets.symmetric(vertical: 5),
                                                                        label:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text(
                                                                            merchandisecontroller.unit.value,
                                                                            style:
                                                                                TextStyle(color: AppColors.primary, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      icon:
                                                                          Icon(
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
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      items: merchandisecontroller
                                                                          .unitList
                                                                          .map(
                                                                            (item) =>
                                                                                DropdownMenuItem(
                                                                              value: item,
                                                                              child: Row(
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
                                                                        if (merchandisecontroller.availableStock.value !=
                                                                            0.0) {
                                                                          merchandisecontroller.availableStock.value = InventoryCalculations.getStockPerFactor(
                                                                              factorType: selectedUnit.factorType!,
                                                                              factor: double.parse(selectedUnit.factor!),
                                                                              stock: merchandisecontroller.singleProduct.value.model[0].quantity);
                                                                        } else if (merchandisecontroller.availableStock.value !=
                                                                            0.0) {
                                                                          merchandisecontroller.availableStock.value = InventoryCalculations.getStockPerFactor(
                                                                              factorType: selectedUnit.factorType!,
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
                                                                      right:
                                                                          15),
                                                              child: Obx(
                                                                () => CommonTextField
                                                                    .textfield(
                                                                  suffixicon:
                                                                      true,
                                                                  readonly:
                                                                      true,
                                                                  keyboardtype:
                                                                      TextInputType
                                                                          .datetime,
                                                                  controller:
                                                                      TextEditingController(
                                                                    text:
                                                                        "${DateFormatter.dateFormat.format(merchandisecontroller.expirydate.value)}"
                                                                        "",
                                                                  ),
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .mutedBlueColor,
                                                    ),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .primary),
                                                    ),
                                                    onPressed: () {
                                                      merchandisecontroller
                                                          .quantity.value = 1.0;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                      ),
                                                      child: Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        if (merchandisecontroller
                                                                .isProductLoading
                                                                .value ==
                                                            false) {
                                                          await merchandisecontroller
                                                              .updateItem(
                                                                  context,
                                                                  merchandisecontroller
                                                                          .merchandiseList[
                                                                      index],
                                                                  index);
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
                                    }),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.red[100]!,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                    onPressed: (_) =>
                                        merchandisecontroller.deleteItem(
                                          index,
                                        )),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            merchandisecontroller
                                                .merchandiseList[index]
                                                .model[0]
                                                .productId,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${DateFormatter.dateFormat.format(merchandisecontroller.merchandiseList[index].model[0].expiryDate) == DateFormatter.dateFormat.format(DateTime.now()) ? "" : "ExpDate :${DateFormatter.dateFormat.format(merchandisecontroller.merchandiseList[index].model[0].expiryDate)}"}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.mutedColor),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${merchandisecontroller.merchandiseList[index].model[0].description}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.mutedColor),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      CommonWidget.commonRow(
                                          isBlue: false,
                                          firstValue: merchandisecontroller
                                                  .merchandiseList[index]
                                                  .model[0]
                                                  .updatedUnitId ??
                                              "",
                                          secondValue: "",
                                          firsthead: "Unit:",
                                          secondhead: "",
                                          isValueAvailable: true),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CommonWidget.commonRow(
                                        isBlue: false,
                                        firstValue: InventoryCalculations
                                            .roundOffQuantity(
                                          quantity: merchandisecontroller
                                              .merchandiseList[index]
                                              .model[0]
                                              .updatedQuantity,
                                        ),
                                        secondValue: "",
                                        firsthead: "Quantity :",
                                        secondhead: "",
                                        isValueAvailable: true,
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => CommonWidget.saveAndCancelButton(
                        onPressOfCancel: () {
                          merchandisecontroller.clearAll();
                          Navigator.pop(context);
                        },
                        onTapOfSave: () async {
                          if(merchandisecontroller.isNewRecord.value==true){
                            if(homecontroller.isScreenRightAvailable(
                              screenId: SalesScreenId.merchandise, type: ScreenRightOptions.Add)){
                                await merchandisecontroller.createMercahndiseItemTransfer();
                              }
                          }
                          //merchandisecontroller.createMercahndiseItemTransfer();
                          else{
                            if(homecontroller.isScreenRightAvailable(
                              screenId: SalesScreenId.merchandise, type: ScreenRightOptions.Edit)){
                                await merchandisecontroller.createMercahndiseItemTransfer();
                              }
                          }
                        },
                        isSaving: merchandisecontroller.isSaving.value,
                        isSaveActive:
                            merchandisecontroller.isNewRecord.value
                            ?merchandisecontroller.isAddEnabled.value
                            :merchandisecontroller.isEditEnabled.value,
                            ))),
              )),
          DragableButton(
            key: const Key('merchandise'),
            onTap: () {
              CommonWidget.commonDialog(
                  context: context,
                  title: "",
                  content: MerchandiseItemPicker());
            },
            icon: const Icon(
              Icons.qr_code_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildOpenListPopContent(double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => merchandisecontroller.isOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : merchandisecontroller.merchandiseOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: merchandisecontroller
                                .merchandiseOpenList.length,
                            itemBuilder: (context, index) {
                              var item = merchandisecontroller
                                  .merchandiseOpenList[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: InkWell(
                                  splashColor:
                                      AppColors.mutedColor.withOpacity(0.2),
                                  splashFactory: InkRipple.splashFactory,
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await merchandisecontroller
                                        .getMerchandiseByID(
                                            item.docId, item.docNumber);
                                    await Future.delayed(
                                        const Duration(milliseconds: 0));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          '${item.docId} - ${item.docNumber}',
                                          minFontSize: 12,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AutoSizeText(
                                          'Quantity : ${item.quantity.toString()}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AutoSizeText(
                                          'Date : ${item.transactionDate != null ? DateFormatter.dateFormat.format(item.transactionDate) : ""}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildOpenListHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Obx(
                () => DropdownButtonFormField2(
                  isDense: true,
                  value: DateRangeSelector
                      .dateRange[merchandisecontroller.dateIndex.value],
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Dates',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Rubik',
                        ),
                      ),
                    ),
                    // contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                  ),
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  items: DateRangeSelector.dateRange
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedSysdocValue = value;
                    merchandisecontroller.selectDateRange(
                        selectedSysdocValue.value,
                        DateRangeSelector.dateRange
                            .indexOf(selectedSysdocValue));
                  },
                  onSaved: (value) {},
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
                child: Obx(
              () => _buildDateTextFeild(
                controller: TextEditingController(
                  text: DateFormatter.dateFormat
                      .format(merchandisecontroller.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: merchandisecontroller.isFromDate.value,
                isDate: true,
                onTap: () {
                  merchandisecontroller.selectDate(context, true);
                },
              ),
            )),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Obx(
                () => _buildDateTextFeild(
                  controller: TextEditingController(
                    text: DateFormatter.dateFormat
                        .format(merchandisecontroller.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: merchandisecontroller.isToDate.value,
                  isDate: true,
                  onTap: () {
                    merchandisecontroller.selectDate(context, false);
                  },
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              merchandisecontroller.getMerchandiseOpenList();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rubik',
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField _buildDateTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }

  Container tableHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 30),
              child: Text(
                'Code',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Name',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Unit',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Qty',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'ExpDate',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  commonContent(
      {required BuildContext context,
      var list,
      required bool search,
      required TextEditingController textController,
      Widget? expansionTextField}) {
    // accept Widget as optional parameter
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: search == true,
            child: expansionTextField ?? SizedBox(),
          ),
          SizedBox(
            height: 5,
          ),
          GetBuilder<MerchandiseController>(
              builder: (controller) => controller.isLoading.value
                  ? SalesShimmer.locationPopShimmer()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = list[index];
                        return InkWell(
                          onTap: () {
                            // controller.getTaskGroup();
                            textController.text = "${item.code} - ${item.name}";
                            //mytaskController.clearSearch();

                            Navigator.pop(
                              context,
                            ); // Return selected item
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${item.code} - ${item.name}",
                                    style: TextStyle(
                                        color: AppColors.mutedColor,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: list.length)),
        ],
      ),
    );
  }
}
