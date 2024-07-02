import 'dart:developer';
import 'dart:io';

import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/merchandise_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/model/Inventory%20Model/product_details_model.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Merchandise%20Screen/merchand_product_list_screen.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MerchandiseItemPicker extends StatefulWidget {
  const MerchandiseItemPicker({super.key});

  @override
  State<MerchandiseItemPicker> createState() => _MerchandiseItemPickerState();
}

class _MerchandiseItemPickerState extends State<MerchandiseItemPicker> {
  FocusNode focus = FocusNode();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final merchandiseController = Get.put(MerchandiseController());

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _handleKeyboardEvent(RawKeyEvent event) {
    log("handling keyboard");
    if (event.runtimeType == RawKeyUpEvent) {
      // Process scanner input when a key is released
      final String scannedData = event.data.logicalKey.keyLabel;
      merchandiseController.merchandiseList.isNotEmpty
          ? merchandiseController.scanToAddIncreaseStockItem(
              scannedData, context)
          : merchandiseController.scanToAddStockItem(scannedData, context);

      // if (stockTakeController.selectedValue.value == 1) {
      //   controller!.resumeCamera();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Scanner'),
                Obx(() => Radio(
                      value: 2,
                      activeColor: AppColors.primary,
                      groupValue: merchandiseController.selectedValue.value,
                      onChanged: (value) {
                        merchandiseController.selectValue(value);
                        focus.requestFocus();
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text('Camera'),
                Obx(() => Radio(
                      value: 1,
                      activeColor: AppColors.primary,
                      groupValue: merchandiseController.selectedValue.value,
                      onChanged: (value) {
                        merchandiseController.selectValue(value);
                        focus.unfocus();
                      },
                    )),
              ],
            )
          ],
        ),
        Obx(() => SizedBox(
            height: merchandiseController.selectedValue == 2
                ? 0
                : MediaQuery.of(context).size.width * 0.8,
            child: merchandiseController.selectedValue == 2
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      backgroundBlendMode: BlendMode.clear,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_rounded,
                              size: 0,
                              color: AppColors.mutedColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Sacnning Mode')
                          ],
                        ),
                      ),
                    ),
                  )
                : _buildQrView(context))),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Obx(() => TextField(
                    onChanged: (p0) async {
                      merchandiseController.merchandiseList.isNotEmpty
                          ? merchandiseController.scanToAddIncreaseStockItem(
                              p0, context)
                          : await merchandiseController.scanToAddStockItem(
                              p0, context);
                    },
                    focusNode: focus,
                    controller: merchandiseController.itemCode.value,
                    readOnly: merchandiseController.selectedValue.value == 1
                        ? true
                        : false,
                    style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isCollapsed: true,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.mutedColor, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.mutedColor, width: 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.mutedColor, width: 0.1),
                      ),
                      labelText: 'Item Code',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                      suffixIconConstraints:
                          BoxConstraints.tightFor(height: 30, width: 30),
                    ),
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => MerchandProductListScreen());
                merchandiseController.getAllProducts();
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                  )),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Obx(() => CommonTextField.textfield(
            suffixicon: false,
            readonly: true,
            keyboardtype: TextInputType.text,
            controller: TextEditingController(
                text: "${merchandiseController.itemname.value.text}"),
            ontap: () async {},
            label: "Item Name")),
        SizedBox(
          height: 15,
        ),
        Obx(() => DropdownButtonFormField2(
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                // hintText: "Units",
                label: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    merchandiseController.unit.value.isNotEmpty
                        ? merchandiseController.unit.value
                        : "Units",
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
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
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: merchandiseController.unitList
                  .map(
                    (item) => DropdownMenuItem(
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
              onChanged: (value) {
                // developer.log(value.toString());
                Unitmodel selectedUnit = value as Unitmodel;
                // String unit = selectedUnit.code.toString();
                if (merchandiseController.availableStock.value != 0.0) {
                  merchandiseController.availableStock.value =
                      InventoryCalculations.getStockPerFactor(
                          factorType: selectedUnit.factorType!,
                          factor: double.parse(selectedUnit.factor!),
                          stock: merchandiseController
                              .singleProduct.value.model[0].quantity);
                } else if (merchandiseController.availableStock.value != 0.0) {
                  merchandiseController.availableStock.value =
                      InventoryCalculations.getStockPerFactor(
                          factorType: selectedUnit.factorType!,
                          factor: double.parse(selectedUnit.factor!),
                          stock: merchandiseController
                              .singleProduct.value.model[0].quantity);
                }
              },
              onSaved: (value) {},
            )),
        SizedBox(
          height: 20,
        ),
        Obx(
          () => CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.datetime,
            controller: TextEditingController(
                text: merchandiseController.isexpirydate.value == false
                    ? ""
                    : "${DateFormatter.dateFormat.format(merchandiseController.expirydate.value)}"),
            label: "Expiry Date",
            ontap: () async {
              DateTime date = await merchandiseController.selectExpiryDate(
                  context, merchandiseController.expirydate.value);
              merchandiseController.expirydate.value = date;
            },
            icon: Icons.calendar_month_outlined,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              'Quantity',
              style: TextStyle(color: AppColors.mutedColor, fontSize: 14),
            ),
            Center(
              child: Text(
                'Stock',
                style: TextStyle(color: AppColors.mutedColor, fontSize: 14),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      merchandiseController.decrementQuantity();
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 15,
                      child: const Center(child: Icon(Icons.remove)),
                    ),
                  ),
                  Obx(() {
                    merchandiseController.quantityControl.value.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: merchandiseController
                                .quantityControl.value.text.length));
                    return Flexible(
                      child: merchandiseController.edit.value
                          ? TextField(
                              autofocus: false,
                              controller:
                                  merchandiseController.quantityControl.value,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              onChanged: (value) {
                                merchandiseController.setQuantity(value);
                              },
                              // onTap: () => merchandiseController.quantityControl
                              //     .value
                              //     .selectAll(),
                            )
                          : Obx(
                              () => InkWell(
                                onTap: () {
                                  merchandiseController.editQuantity();
                                },
                                child: Text(merchandiseController.quantity.value
                                    .toString()),
                              ),
                            ),
                    );
                  }),
                  InkWell(
                    onTap: () {
                      merchandiseController.incrementQuantity();
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
                child: Obx(() => Text(
                      InventoryCalculations.roundOffQuantity(
                        quantity: merchandiseController.availableStock.value,
                      ),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary),
                    )),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mutedBlueColor,
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary),
                ),
                onPressed: () {
                  merchandiseController.cancelAll();
                  merchandiseController.quantity.value = 1.0;
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  onPressed: () async {
                    merchandiseController.itemCode.value.text.isEmpty
                        ? SnackbarServices.errorSnackbar(
                            'Please Add Products to Continue')
                        : await merchandiseController.addItem(context);
                    merchandiseController.cancelAll();

                    //  else {
                    //   SnackbarServices.errorSnackbar('Quantity is not available');
                    // }
                  }),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? MediaQuery.of(context).size.width * 0.8
        : MediaQuery.of(context).size.width * 0.8;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          overlayColor: Colors.white,
          borderColor: AppColors.primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      // log("${scanData.code} scandata");
      // log("${result!.code} result");

      controller.pauseCamera();
      merchandiseController.merchandiseList.isNotEmpty
          ? await merchandiseController.scanToAddIncreaseStockItem(
              result!.code!, context)
          : await merchandiseController.scanToAddStockItem(
              result!.code!, context);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    RawKeyboard.instance.removeListener(_handleKeyboardEvent);
    super.dispose();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}

extension TextEditingControllerExt on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
