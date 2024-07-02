import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_order_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Inventory%20Model/get_all_products_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/services/pdf%20services/pdf_api.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/draggable_button.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_product_list_screen.dart';
import 'package:axolon_erp/view/SalesScreen/components/customerIdRow.dart';
import 'package:axolon_erp/view/SalesScreen/components/discount_bottom_sheet.dart';
import 'package:axolon_erp/view/SalesScreen/components/order_detail_accordion.dart';
import 'package:axolon_erp/view/SalesScreen/components/summary_card.dart';
import 'package:axolon_erp/view/SalesScreen/components/sysDocRow.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/dragging_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:open_filex/open_filex.dart';

class SalesOrderScreen extends StatefulWidget {
  SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final salesController = Get.put(SalesOrderController());
  final salesScreenController = Get.put(SalesController());
  final homecontroller = Get.put(HomeController());
  var selectedSysdocValue;
  TextEditingController _discountAmountController = TextEditingController();
  TextEditingController _discountPercentageController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  FocusNode _discountAmountFocusNode = FocusNode();
  FocusNode _discountPercentageFocusNode = FocusNode();
  FocusNode _remarksFocusNode = FocusNode();
  var selectedValue;

  List sysDocList = [];
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _discountAmountController.text = salesController.discount.value.toString();
    _discountPercentageController.text =
        salesController.discountPercentage.value.toString();
    _remarksController.text = salesController.remarks.value.toString();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

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
          title: const Text('Sales Order'),
          actions: [
            IconButton(
              onPressed: () {
                salesController.getSalesOrderOpenList();
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
                () => salesController.isSalesOrderByIdLoading.value
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Obx(
                      () => SysDocRow(
                        onTap: () async {
                          await salesController.generateSysDocList();
                          if (!salesScreenController.isLoading.value) {
                            var sysDoc =
                                await salesScreenController.selectSysDoc(
                                    context: context,
                                    sysDocType: 23,
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
                          onTap: () async {
                            if (salesController.isCustomerLoading.value) {
                              SnackbarServices.errorSnackbar(
                                  'CustomerId is empty');
                            } else {
                              salesController.getCustomerSanpBalance();

                              CommonWidget.commonDialog(
                                  context: context,
                                  title: "Customer Balance",
                                  content: customerBalancePopUp(context));
                            }
                            // salesController.getCustomerSanpBalance();

                            // CommonWidget.commonDialog(
                            //     context: context,
                            //     title: "Customer Balance",
                            //     content: customerBalancePopUp(context));
                          },
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
                      ],
                    ),
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
                          itemCount: salesController.salesOrderList.length,
                          itemBuilder: (context, index) {
                            var salesOrder =
                                salesController.salesOrderList[index].model[0];
                            return Slidable(
                              key: const Key('sales_order_list'),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                      backgroundColor: Colors.green[100]!,
                                      foregroundColor: Colors.green,
                                      icon: Icons.mode_edit_outlined,
                                      onPressed: (_) => salesController
                                          .addOrUpdateProductToSales(
                                              Products(),
                                              false,
                                              false,
                                              salesController
                                                  .salesOrderList[index],
                                              index,
                                              context)),
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
                                          salesController.removeItem(index)),
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
                                          salesController.salesOrderList[index]
                                              .model[0].productId,
                                        )),
                                    SizedBox(
                                        width: width * 0.4,
                                        child: AutoSizeText(
                                          salesController.salesOrderList[index]
                                              .model[0].description,
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
                                                  .salesOrderList[index]
                                                  .model[0]
                                                  .updatedQuantity,
                                            ),
                                            textAlign: TextAlign.center,
                                          )),
                                    ),
                                    SizedBox(
                                      width: width * 0.13,
                                      child: Obx(() => Text(
                                            InventoryCalculations.formatPrice(
                                                salesController
                                                    .salesOrderList[index]
                                                    .model[0]
                                                    .updatedPrice
                                                    .toDouble()),
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
                  Obx(
                    () => SummaryCard(
                        isSaveActive: salesController.isNewRecord.value
                            ? salesController.isAddEnabled.value
                            : salesController.isEditEnabled.value,
                        isVoidActive: salesController.isEditEnabled.value,
                        onTap: () {
                          _discountAmountController.text = salesController
                              .discount
                              .toStringAsFixed(2)
                              .toString();
                          _discountPercentageController.text =
                              InventoryCalculations.formatPrice(salesController
                                  .discountPercentage.value
                                  .toDouble());

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
                                    salesController.calculateDiscount(
                                        value, true);
                                    setState(() {
                                      _discountAmountController.text =
                                          InventoryCalculations.formatPrice(
                                              salesController.discount.value
                                                  .toDouble());
                                    });
                                  },
                                  onChangeAmount: (value) {
                                    salesController.calculateDiscount(
                                        value, false);
                                    setState(() {
                                      _discountPercentageController.text =
                                          InventoryCalculations.formatPrice(
                                              salesController
                                                  .discountPercentage.value
                                                  .toDouble());
                                    });
                                  },
                                  amountFocus: _discountAmountFocusNode,
                                  percentFocus: _discountPercentageFocusNode,
                                  amountController: _discountAmountController,
                                  percentController:
                                      _discountPercentageController));
                        },
                        onSave: () async {
                          if (salesController.isNewRecord.value == true) {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.salesOrder,
                                type: ScreenRightOptions.Add)) {
                              await salesController.createSalesOrder();
                              setState(() {
                                _remarksController.text =
                                    salesController.remarks.value;
                              });
                            }
                          } else {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.salesOrder,
                                type: ScreenRightOptions.Edit)) {
                              await salesController.createSalesOrder();
                              setState(() {
                                _remarksController.text =
                                    salesController.remarks.value;
                              });
                            }
                          }
                        },
                        onVoid: () async {
                          if (salesController.isNewRecord.value == true) {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.salesOrder,
                                type: ScreenRightOptions.Edit)) {
                              salesController.onVoided(context);
                            }
                          } else {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.salesOrder,
                                type: ScreenRightOptions.Edit)) {
                              salesController.onVoided(context);
                            }
                          }

                          // salesController.deleteOrder();
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
                        isVoidEnable: !salesController.isNewRecord.value,
                        isDeleting: salesController.isDeleting.value,
                        isLoading: salesController.isSaving.value,
                        subTotal: InventoryCalculations.formatPrice(
                            salesController.subTotal.value.toDouble()),
                        discount: InventoryCalculations.formatPrice(
                            salesController.discount.value.toDouble()),
                        tax: InventoryCalculations.formatPrice(
                            salesController.totalTax.value.toDouble()),
                        total: InventoryCalculations.formatPrice(
                            salesController.total.value.toDouble())),
                  )
                ],
              ),
            ),
            DragableButton(
              onTap: () {
                _remarksFocusNode.unfocus();
                Get.to(() => SalesProductListScreen());
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     salesController.getSalesOrderPrint('00032');
        //   },
        //   child: const Icon(Icons.print),
        // ),
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
                    : salesController.salesOrderOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                salesController.salesOrderOpenList.length,
                            itemBuilder: (context, index) {
                              var item =
                                  salesController.salesOrderOpenList[index];
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
                                        item.docId, item.docNumber);
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
                                          '${item.docId} - ${item.docNumber}',
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
                                            '${item.customerCode} - ${item.customerName}',
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
                                          'Amount : ${item.amount.toString()}/-',
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
                                          'Date : ${DateFormatter.dateFormat.format(item.orderDate)}',
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
              salesController.getSalesOrderOpenList();
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

  changeFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
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

  customerBalancePopUp(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Obx(() => salesController.iscustomerLoading.value
              ? SalesShimmer.locationPopShimmer()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            salesController.code.value,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " - ${salesController.name.value}",
                            style: TextStyle(
                              color: AppColors.mutedColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: multilineTextfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: salesController.status.value,
                            ),
                            firstTextStyle: salesController.status.value
                                        .trim()
                                        .toLowerCase() ==
                                    'active'
                                ? AppColors.success
                                : AppColors.error,
                            label: "Status",
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: multilineTextfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: salesController.creditstatus.value,
                            ),
                            firstTextStyle: salesController.creditstatus.value
                                        .trim()
                                        .toLowerCase() ==
                                    'available'
                                ? AppColors.success
                                : AppColors.error,
                            label: "CreditStatus",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                                text: InventoryCalculations.formatPrice(
                                        double.parse(
                                            salesController.balance.value))
                                    .toString()

                                //salesController.balance.value,
                                ),
                            label: "Balance",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(
                                      salesController.creditlimit.value)),
                            ),
                            label: "CreditLimit",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(
                                      salesController.insAmount.value)),
                            ),
                            label: "InsAmount",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(
                                      salesController.dueAmount.value)),
                            ),
                            label: "DueAmount",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(salesController.unsecPdc.value)),
                            ),
                            label: "UnSecPDC",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: salesController.maxduedays.value,
                            ),
                            label: "MaxDueDays",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(salesController.pdc.value)),
                            ),
                            label: "PDC",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(
                                      salesController.uninvoicedd.value)),
                            ),
                            label: "Uninvoiced",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(salesController.net.value)),
                            ),
                            label: "Net",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: InventoryCalculations.formatPrice(
                                  double.parse(
                                      salesController.available.value)),
                            ),
                            label: "Available",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                              text: salesController.customerremarks.value,
                            ),
                            label: "Remarks",
                          ),
                        ),
                      ],
                    ),
                  ],
                )
          //Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             salesController.code.value,
          //             style: TextStyle(
          //               color: AppColors.primary,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 16,
          //             ),
          //           ),
          //           Text(
          //             " - ${salesController.name.value}",
          //             style: TextStyle(
          //               color: AppColors.mutedColor,
          //               fontSize: 16,
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(height: 10),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           commonRow(
          //               firsthead: "Balance ",
          //               secondhead: "Credit Limit",
          //               firstValue: salesController.balance.value.toString(),
          //               secondValue:
          //                   salesController.creditlimit.value.toString(),
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "Ins.Amount",
          //               secondhead: "DueAmount",
          //               firstValue:
          //                   salesController.insAmount.value.toString(),
          //               secondValue:
          //                   salesController.dueAmount.value.toString(),
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "UnSecPDC",
          //               secondhead: "Max Due Days",
          //               firstValue: salesController.unsecPdc.value.toString(),
          //               secondValue:
          //                   salesController.maxduedays.value.toString(),
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "PDC ",
          //               secondhead: "Uninvoiced",
          //               firstValue: salesController.pdc.value.toString(),
          //               secondValue: salesController.uninvoicedd.value,
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "Net",
          //               secondhead: "Available",
          //               firstValue: salesController.net.value.toString(),
          //               secondValue:
          //                   salesController.available.value.toString(),
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "Status",
          //               secondhead: "Credit Status",
          //               firstValue: salesController.status.value.trim(),
          //               firstTextStyle: salesController.status.value
          //                           .trim()
          //                           .toLowerCase() ==
          //                       'active'
          //                   ? AppColors.success
          //                   : AppColors.error,
          //               secondValue: salesController.creditstatus.value,
          //               secondValueTextStyle: salesController
          //                           .creditstatus.value
          //                           .trim()
          //                           .toLowerCase() ==
          //                       'available'
          //                   ? AppColors.success
          //                   : AppColors.error,
          //               view: true),
          //           SizedBox(height: 10),
          //           commonRow(
          //               firsthead: "Remarks",
          //               secondhead: "",
          //               firstValue:
          //                   salesController.customerremarks.value.toString(),
          //               secondValue: "",
          //               view: false
          //               //   secondValueTextStyle: Colors.red,
          //               ),
          //         ],
          //       ),
          //     ],
          //   ),
          ),
    );
  }

  static commonRow({
    required String firsthead,
    String? firstValue,
    required String secondhead,
    String? secondValue,
    Color? secondValueTextStyle,
    Color? firstTextStyle,
    bool? view,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(firsthead,
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 13)),
            ],
          ),
        ),
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' : ',
                style: TextStyle(
                    color: AppColors.mutedColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 14)),
            Text(firstValue ?? '',
                style: TextStyle(
                    color: firstTextStyle ?? AppColors.mutedColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
          ],
        )),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(secondhead,
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 13)),
            ],
          ),
        ),
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: view == true,
              child: Text(' : ',
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 14)),
            ),
            Text(secondValue ?? '',
                style: TextStyle(
                    color: secondValueTextStyle ?? AppColors.mutedColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
          ],
        )),
      ],
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
        enabled: !isDisabled, // Set enabled based on the isDisabled parameter
        controller: controller,
        readOnly: readonly || isUpdate, // Set readOnly if isUpdate is true
        onTap: ontap,
        keyboardType: keyboardtype,
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
    ;
  }
}
