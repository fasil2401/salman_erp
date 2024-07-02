import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_invoice_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/draggable_button.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/credit_limit_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/over_due_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/sales_invoice_product_list_screen.dart';
import 'package:axolon_erp/view/SalesScreen/components/customerIdRow.dart';
import 'package:axolon_erp/view/SalesScreen/components/discount_bottom_sheet.dart';
import 'package:axolon_erp/view/SalesScreen/components/order_detail_accordion.dart';
import 'package:axolon_erp/view/SalesScreen/components/summary_card.dart';
import 'package:axolon_erp/view/SalesScreen/components/sysDocRow.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/dragging_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SalesInvoiceScreen extends StatefulWidget {
  SalesInvoiceScreen({super.key});

  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
  final homecontroller = Get.put(HomeController());
  final salesController = Get.put(SalesInvoiceController());
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _discountAmountController = TextEditingController();
  TextEditingController _discountPercentageController = TextEditingController();
  FocusNode _discountAmountFocusNode = FocusNode();
  FocusNode _discountPercentageFocusNode = FocusNode();
  final salesScreenController = Get.put(SalesController());

  var selectedSysdocValue;

  var selectedValue;

  List sysDocList = [];
  FocusNode _remarksFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        _remarksFocusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sales Invoice'),
          actions: <Widget>[
            PopupMenuButton<int>(
              // onSelected: (item) => handleClickOnAppBar(item),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(0),
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  padding: const EdgeInsets.all(0),
                  height: 30,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      salesController.getSalesInvoiceOpenList();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                          style: TextStyle(
                                              color: AppColors.primary)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Open From Open List'),
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  padding: const EdgeInsets.all(0),
                  height: 30,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      salesController.getOpenSalesOrdersSummaryList();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            title: _buildSalesSummaryOpenListHeader(context),
                            content: _buildSalesSummaryOpenListPopContent(
                                width, context),
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
                                          style: TextStyle(
                                              color: AppColors.primary)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Open From Sales Order'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Obx(
                      () => SysDocRow(
                        onTap: () async {
                          await salesController.generateSysDocList();
                          if (!salesController.isLoading.value) {
                            var sysDoc =
                                await salesScreenController.selectSysDoc(
                                    context: context,
                                    sysDocType: 26,
                                    list: salesController.sysDocList);
                            if (sysDoc.code != null) {
                              salesController.getVoucherNumber(
                                  sysDoc.code, sysDoc.name);
                            }
                          }
                        },
                        sysDocIdController: TextEditingController(
                          text: salesController.sysDocName.value,
                        ),
                        sysDocSuffixLoading:
                            salesScreenController.isLoading.value,
                        voucherIdController: TextEditingController(
                          text: salesController.voucherNumber.value,
                        ),
                        voucherSuffixLoading:
                            salesController.isVoucherLoading.value,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Flexible(
                  //         child: DropdownButtonFormField2(
                  //           isDense: true,
                  //           value: selectedSysdocValue,
                  //           decoration: InputDecoration(
                  //             isCollapsed: true,
                  //             contentPadding:
                  //                 const EdgeInsets.symmetric(vertical: 5),
                  //             label: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 'SysDocId',
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   color: AppColors.primary,
                  //                   fontWeight: FontWeight.w400,
                  //                   fontFamily: 'Rubik',
                  //                 ),
                  //               ),
                  //             ),
                  //             // contentPadding: EdgeInsets.zero,
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //           ),
                  //           isExpanded: true,
                  //           icon: Icon(
                  //             Icons.arrow_drop_down,
                  //             color: AppColors.primary,
                  //           ),
                  //           buttonPadding:
                  //               const EdgeInsets.only(left: 20, right: 10),
                  //           dropdownDecoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //           ),
                  //           items: salesController.sysDocList
                  //               .map(
                  //                 (item) => DropdownMenuItem(
                  //                   value: item,
                  //                   child: Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         "${item.code} - ",
                  //                         style: TextStyle(
                  //                           fontSize: 14,
                  //                           color: AppColors.primary,
                  //                           fontWeight: FontWeight.w400,
                  //                           fontFamily: 'Rubik',
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         width: width * 0.3,
                  //                         child: AutoSizeText(
                  //                           item.name,
                  //                           minFontSize: 10,
                  //                           maxLines: 2,
                  //                           overflow: TextOverflow.ellipsis,
                  //                           style: TextStyle(
                  //                             color: AppColors.primary,
                  //                             fontWeight: FontWeight.w400,
                  //                             fontFamily: 'Rubik',
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               )
                  //               .toList(),
                  //           onChanged: (value) {
                  // selectedSysdocValue = value;
                  // salesController
                  //     .getVoucherNumber(selectedSysdocValue.code);
                  //           },
                  //           onSaved: (value) {
                  //             // selectedValue = value;
                  //           },
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 5),
                  //         child: SizedBox(
                  //           width: width * 0.3,
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               SizedBox(
                  //                 child: Text(
                  //                   'Voucher :',
                  //                   style: TextStyle(
                  //                     fontSize: 14,
                  //                     color: AppColors.primary,
                  //                     fontWeight: FontWeight.w500,
                  //                     // fontFamily: 'Rubik',
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 child: Obx(() => Text(
                  //                       salesController.voucherNumber.value,
                  //                       style: TextStyle(
                  //                         fontSize: 14,
                  //                         color: AppColors.primary,
                  //                         fontWeight: FontWeight.w400,
                  //                         // fontFamily: 'Rubik',
                  //                       ),
                  //                     )),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => CustomerIdRow(
                                onTap: () async {
                                  salesController.resetCustomerList();
                                  salesController.isSearching.value = false;
                                  if (!salesController
                                      .isCustomerLoading.value) {
                                    var customer =
                                        await homecontroller.selectCustomer(
                                      context: context,
                                    );
                                    if (customer.code != null) {
                                      salesController.selectCustomer(customer);
                                    }
                                  }
                                },
                                controller: TextEditingController(
                                  text: salesController.customerId.value == ''
                                      ? salesController.isCustomerLoading.value
                                          ? 'Please wait..'
                                          : ' '
                                      : salesController.customer.value.name,
                                ),
                                isLoading:
                                    salesController.isCustomerLoading.value),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {},
                          child: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 0,
                                padding: const EdgeInsets.all(0),
                                height: 30,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.to(() => CreditLimtScreen());
                                    // CommonWidget.commonDialog(
                                    //     context: context,
                                    //     title: "Credit Limit Voucher",
                                    //     content:
                                    //         customerCreditLimitPopUp(context));
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Credit Limit Voucher',
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                padding: const EdgeInsets.all(0),
                                height: 30,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.to(() => OverDueScreen());
                                    // CommonWidget.commonDialog(
                                    //     context: context,
                                    //     title: "Overdue Control",
                                    //     content: overduePopUp(context));
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Overdue Control',
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            child: Card(
                                color: AppColors.lightGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: AppColors.primary,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: Text(
                            'Location:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(() => TextField(
                              controller: TextEditingController(
                                text: salesController.locationId.value == ''
                                    ? salesController.isLocationLoading.value
                                        ? 'Please wait..'
                                        : ' '
                                    : salesController.location.value.name,
                              ),
                              readOnly: true,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                isDense: true,
                                border: InputBorder.none,
                                suffix: Transform.translate(
                                  offset: Offset(0, 8),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        salesController.isLocationLoading.value
                                            ? CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.mutedColor,
                                              )
                                            : Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                salesController.location.value =
                                    await homecontroller.selectLocatio(
                                        context: context,
                                        locationList:
                                            homecontroller.locationList);
                                salesController.locationId.value =
                                    salesController.location.value.code ?? '';
                              })),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 0, horizontal: 10),
                  //         child: Text(
                  //           'Customer Id:',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: AppColors.primary,
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Obx(() => DropdownButtonHideUnderline(
                  //               child: DropdownButton2(
                  //                 isExpanded: true,
                  //                 isDense: true,
                  //                 hint: Text(
                  //                   salesController.isCustomerLoading.value
                  //                       ? 'Please wait...'
                  //                       : 'Customer Id',
                  //                   style: TextStyle(
                  //                     fontSize: 14,
                  //                     color: Theme.of(context).hintColor,
                  //                   ),
                  //                   overflow: TextOverflow.ellipsis,
                  //                 ),
                  //                 items: salesController.customerList
                  //                     .map((item) => DropdownMenuItem(
                  //                           value: item,
                  //                           child: AutoSizeText(
                  //                             item.name,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             style: const TextStyle(
                  //                               fontSize: 14,
                  //                               color: Colors.black54,
                  //                             ),
                  //                           ),
                  //                         ))
                  //                     .toList(),
                  //                 value: selectedValue,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     selectedValue = value;
                  //                   });
                  //                 },
                  //                 dropdownDecoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(14),
                  //                   color: Colors.white,
                  //                 ),
                  //                 buttonHeight: 20,
                  //                 buttonWidth: 140,
                  //                 itemHeight: 40,
                  //               ),
                  //             )),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => OrderAccordion(
                      onToggleCollapsed: (status) {
                        _remarksController.text = salesController.remarks.value;
                      },
                      onTapTransactionDate: () {
                        salesController.selectTransactionDates(context, true);
                      },
                      onTapDueDate: () {
                        salesController.selectTransactionDates(context, false);
                      },
                      onTapRemarks: salesController.isFirstFocusOnRemarks.value
                          ? () {
                              if (salesController.isFirstFocusOnRemarks.value) {
                                _remarksController.selectAll();
                              }
                              salesController.isFirstFocusOnRemarks.value =
                                  false;
                            }
                          : () {},
                      transactionDateController: TextEditingController(
                        text: DateFormatter.dateFormat
                            .format(salesController.transactionDate.value)
                            .toString(),
                      ),
                      dueDateController: TextEditingController(
                        text: DateFormatter.dateFormat
                            .format(salesController.dueDate.value)
                            .toString(),
                      ),
                      remarksController: _remarksController,
                      onChangeRemarks: (value) {
                        salesController.getRemarks(value);
                      },
                      remarkFocus: _remarksFocusNode,
                    ),
                  ),
                  tableHeader(context),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: salesController.salesInvoiceList.length,
                          itemBuilder: (context, index) {
                            var salesOrder = salesController
                                .salesInvoiceList[index].model[0];
                            return Slidable(
                              key: const Key('sales_order_list'),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.green[100]!,
                                    foregroundColor: Colors.green,
                                    icon: Icons.mode_edit_outlined,
                                    onPressed: (_) => salesScreenController
                                        .addOrUpdateProductToSales(
                                            product: Products(),
                                            isAdding: false,
                                            isScanning: false,
                                            single: salesController
                                                .salesInvoiceList[index],
                                            index: index,
                                            context: context,
                                            list: salesController
                                                .salesInvoiceList,
                                            customerId: salesController
                                                .customerId.value),
                                  ),
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
                                          salesScreenController.removeItem(
                                              index,
                                              salesController
                                                  .salesInvoiceList)),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: width * 0.15,
                                        child: Text(
                                          salesController
                                              .salesInvoiceList[index]
                                              .model[0]
                                              .productId,
                                        )),
                                    SizedBox(
                                        width: width * 0.4,
                                        child: AutoSizeText(
                                          salesController
                                              .salesInvoiceList[index]
                                              .model[0]
                                              .description,
                                          maxFontSize: 16,
                                          minFontSize: 12,
                                          textAlign: TextAlign.start,
                                        )),
                                    SizedBox(
                                      width: width * 0.13,
                                      child: Obx(() => Text(
                                            InventoryCalculations
                                                .roundOffQuantity(
                                              quantity: salesController
                                                  .salesInvoiceList[index]
                                                  .model[0]
                                                  .updatedQuantity,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                    SizedBox(
                                      width: width * 0.13,
                                      child: Obx(() => Text(
                                            salesController
                                                .salesInvoiceList[index]
                                                .model[0]
                                                .updatedPrice
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.mutedBlueColor,
                  ),
                  Obx(() {
                    var subtotal = salesController.salesInvoiceList
                        .fold<double>(
                            0,
                            (previousValue, element) =>
                                (previousValue ?? 0) +
                                ((element.model[0].updatedPrice) *
                                    (element.model[0].updatedQuantity ?? 0)));
                    var tax = salesController.salesInvoiceList.fold<double>(
                        0,
                        (previousValue, element) =>
                            (previousValue ?? 0) + element.model[0].taxAmount);
                    var total = tax + subtotal;
                    return SummaryCard(
                      isSaveActive: true,
                      isVoidActive: false,
                      onTap: () {
                        _discountAmountController.text = salesScreenController
                            .discount
                            .toStringAsFixed(2)
                            .toString();
                        _discountPercentageController.text =
                            salesScreenController.discountPercentage
                                .toStringAsFixed(2)
                                .toString();
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (context) => DiscountSheet(
                                onTapPercent: () {
                                  _discountPercentageController.selectAll();
                                  _discountPercentageFocusNode.requestFocus();
                                },
                                onTapAmount: () {
                                  _discountAmountController.selectAll();
                                  _discountAmountFocusNode.requestFocus();
                                },
                                onChangePercent: (value) {
                                  salesScreenController.calculateDiscount(
                                      value, true);
                                  setState(() {
                                    _discountAmountController.text =
                                        salesScreenController.discount.value
                                            .toStringAsFixed(2);
                                  });
                                },
                                onChangeAmount: (value) {
                                  salesScreenController.calculateDiscount(
                                      value, false);
                                  setState(() {
                                    _discountPercentageController.text =
                                        salesScreenController
                                            .discountPercentage.value
                                            .toStringAsFixed(2);
                                  });
                                },
                                amountFocus: _discountAmountFocusNode,
                                percentFocus: _discountPercentageFocusNode,
                                amountController: _discountAmountController,
                                percentController:
                                    _discountPercentageController));
                      },
                      onVoid: () {},
                      onSave: () async {
                        if (salesController.isNewRecord.value == true) {
                          if (homecontroller.isScreenRightAvailable(
                              screenId: SalesScreenId.salesInvoice,
                              type: ScreenRightOptions.Add)) {
                            await salesController.createSalesInvoice();
                            setState(() {
                              _remarksController.text =
                                  salesController.remarks.value;
                            });
                          }
                        } else {
                          if (homecontroller.isScreenRightAvailable(
                              screenId: SalesScreenId.salesInvoice,
                              type: ScreenRightOptions.Edit)) {
                            await salesController.createSalesInvoice();
                            setState(() {
                              _remarksController.text =
                                  salesController.remarks.value;
                            });
                          }
                        }
                      },
                      onClear: () async {
                        // salesController.salesOrderList.clear();
                        // salesController.subTotal.value = 0.00;
                        await salesController.clearData();
                        salesController.isNewRecord.value = true;
                        setState(() {
                          _remarksController.text =
                              salesController.remarks.value;
                        });
                      },
                      isVoidEnable: false,
                      isDeleting: false,
                      isLoading: salesController.isSaving.value,
                      subTotal: subtotal.toStringAsFixed(2),
                      discount: salesScreenController.discount.value
                          .toStringAsFixed(2),
                      tax: tax.toStringAsFixed(2),
                      total: total.toStringAsFixed(2),
                    );
                  })
                  // Card(
                  //   color: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   elevation: 4,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Expanded(
                  //                 child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               children: [
                  //                 _buildDetailTextHead('Sub Total'),
                  //                 const SizedBox(
                  //                   height: 8,
                  //                 ),
                  //                 _buildDetailTextHead('Discount'),
                  //                 const SizedBox(
                  //                   height: 8,
                  //                 ),
                  //                 _buildDetailTextHead('Tax'),
                  //                 const SizedBox(
                  //                   height: 8,
                  //                 ),
                  //                 _buildDetailTextHead('Total'),
                  //               ],
                  //             )),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.end,
                  //                 // mainAxisAlignment: MainAxisAlignment.start,
                  //                 children: [
                  //                   Obx(() => _buildDetailTextContent(
                  //                       salesController.subTotal.value
                  //                           .toString())),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Obx(() => _buildDetailTextContent(
                  //                       salesController.discount.value
                  //                           .toStringAsFixed(2))),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Obx(() => _buildDetailTextContent(
                  //                       salesController.totalTax.value
                  //                           .toStringAsFixed(2))),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Obx(() => _buildDetailTextContent(
                  //                       salesController.total.value
                  //                           .toStringAsFixed(2))),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Divider(
                  //           thickness: 1,
                  //           color: AppColors.lightGrey,
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 salesController.salesInvoiceList.clear();
                  //                 salesController.subTotal.value = 0.00;
                  //               },
                  //               style: ElevatedButton.styleFrom(
                  //                 backgroundColor: AppColors.mutedBlueColor,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 25),
                  //                 child: Text(
                  //                   'Clear',
                  //                   style: TextStyle(
                  //                     color: AppColors.primary,
                  //                     fontSize: 14,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 print('save');
                  //               },
                  //               style: ElevatedButton.styleFrom(
                  //                 backgroundColor: AppColors.primary,
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //               ),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 25),
                  //                 child: Text(
                  //                   'Save',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 14,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            DragableButton(
              onTap: () {
                _remarksFocusNode.unfocus();
                Get.to(() => SalesInvoiceProductListScreen());
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            // DraggableCard(
            //   child: InkWell(
            //     onTap: () {
            //       Get.to(() => SalesInvoiceProductListScreen());
            //     },
            //     child: AnimatedContainer(
            //       duration: const Duration(milliseconds: 300),
            //       curve: Curves.fastLinearToSlowEaseIn,
            //       height: 50,
            //       width: 50,
            //       decoration: const BoxDecoration(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(10),
            //         ),
            //       ),
            //       child: CircleAvatar(
            //         backgroundColor: AppColors.primary,
            //         child: Center(
            //           child: Icon(Icons.add, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Text _buildDetailTextContent(String text) {
    return Text(
      ' $text',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.primary,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Row _buildDetailTextHead(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                'Quantity',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Price',
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

  Column _buildSalesSummaryOpenListHeader(BuildContext context) {
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
                      .dateRange[salesController.dateIndex.value],
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
                    salesController.selectDateRange(
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
                      .format(salesController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: salesController.isFromDate.value,
                isDate: true,
                onTap: () {
                  salesController.selectDate(context, true);
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
                        .format(salesController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: salesController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    salesController.selectDate(context, false);
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
              salesController.getOpenSalesOrdersSummaryList();
              // Navigator.pop(context);
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
                      .dateRange[salesController.dateIndex.value],
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
                    salesController.selectDateRange(
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
                      .format(salesController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: salesController.isFromDate.value,
                isDate: true,
                onTap: () {
                  salesController.selectDate(context, true);
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
                        .format(salesController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: salesController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    salesController.selectDate(context, false);
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
              salesController.getSalesInvoiceOpenList();
              // Navigator.pop(context);
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

  static Widget multilineTextfield({
    Function()? ontap,
    String? label,
    TextEditingController? controller,
    IconData? icon,
    bool suffixicon = true,
    bool readonly = false,
    TextInputType keyboardtype = TextInputType.text,
    bool isUpdate = false, // New parameter to control label color
    bool isDisabled = false,
    Color? firstTextStyle,
  }) {
    return SizedBox(
      child: TextField(
        enabled: !isDisabled,
        controller: controller,
        readOnly: readonly || isUpdate,
        onTap: ontap,
        keyboardType: keyboardtype,
        maxLines: 5,
        style: TextStyle(
          fontSize: 12,
          color: firstTextStyle ?? AppColors.mutedColor,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.mutedColor, width: 0.1),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: isUpdate ? Colors.grey : AppColors.primary,
          ),
          suffixIcon: suffixicon
              ? Icon(
                  icon != null ? icon : Icons.more_vert,
                  color: isUpdate ? AppColors.mutedColor : AppColors.primary,
                  size: 15,
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          suffixIconConstraints: BoxConstraints.tightFor(height: 30, width: 30),
        ),
      ),
    );
  }

  SizedBox _buildSalesSummaryOpenListPopContent(
      double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => salesController.isSalesSummaryOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : salesController.salesordersummaryOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: salesController
                                .salesordersummaryOpenList.length,
                            itemBuilder: (context, index) {
                              var item = salesController
                                  .salesordersummaryOpenList[index];
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
                                    await salesController.getSalesOrderById(
                                        item.docId ?? '', item.number ?? '');
                                    await Future.delayed(
                                        const Duration(milliseconds: 0));
                                    setState(() {
                                      _remarksController.text =
                                          salesController.remarks.value;
                                    });
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
                                          '${item.docId ?? ''}-${item.number ?? ''}',
                                          minFontSize: 12,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: width * 0.6,
                                          child: AutoSizeText(
                                            '${item.customer ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Job : ${item.jobName ?? ""}',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Date : ${item.date ?? DateFormatter.dateFormat.format(item.invoiceDate!)}',
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
                () => salesController.isOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : salesController.salesInvoiceOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                salesController.salesInvoiceOpenList.length,
                            itemBuilder: (context, index) {
                              var item =
                                  salesController.salesInvoiceOpenList[index];
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
                                    await salesController.getSalesInvoiceById(
                                        item.docId ?? '', item.docNumber ?? '');
                                    await Future.delayed(
                                        const Duration(milliseconds: 0));
                                    setState(() {
                                      _remarksController.text =
                                          salesController.remarks.value;
                                    });
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
                                          '${item.docId ?? ''} - ${item.docNumber ?? ''}',
                                          minFontSize: 12,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: width * 0.6,
                                          child: AutoSizeText(
                                            '${item.customerCode ?? ''} - ${item.customerName ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Amount : ${item.amount ?? 0}/-',
                                          minFontSize: 10,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Date : ${item.invoiceDate ?? DateFormatter.dateFormat.format(item.invoiceDate!)}',
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
}
