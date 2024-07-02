import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/credit_limit_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_invoice_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';

import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';

import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/components/customerIdRow.dart';

import 'package:axolon_erp/view/SalesScreen/components/sysDocRow.dart';

import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreditLimtScreen extends StatelessWidget {
  CreditLimtScreen({Key? key}) : super(key: key);

  var selectedValue;
  final creditlimtController = Get.put(CreditLimitController());
  final homecontroller = Get.put(HomeController());
  final salesScreenController = Get.put(SalesController());
  var selectedSysdocValue;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(1, 66, 150, 1),
        title: const Text('Credit Limit'),
        actions: [
          IconButton(
            onPressed: () async {
              creditlimtController.getCreditLimitOpenList();
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
              // CommonWidget.commonDialog(
              //     context: context,
              //     title: "",
              //     content: _buildOpenListPopContent(width, context));
            },
            icon: SvgPicture.asset(
              AppIcons.openList,
              color: Colors.white,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => SysDocRow(
                        onTap: () async {
                          await creditlimtController
                              .generateCreditLimitSysDocList();
                          if (!creditlimtController.isLoading.value) {
                            var sysDoc =
                                await salesScreenController.selectSysDoc(
                                    context: context,
                                    sysDocType: 217,
                                    list: creditlimtController.sysDocList);
                            if (sysDoc.code != null) {
                              creditlimtController.getVoucherNumber(
                                  sysDoc.code, sysDoc.name);
                            }
                          }
                        },
                        sysDocIdController: TextEditingController(
                          text: creditlimtController.sysDocName.value,
                        ),
                        sysDocSuffixLoading:
                            salesScreenController.isLoading.value,
                        voucherIdController: TextEditingController(
                          text: creditlimtController.voucherNumber.value,
                        ),
                        voucherSuffixLoading: false),
                  ),
                  SizedBox(
                    height: 18,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => CustomerIdRow(
                              onTap: () async {
                                creditlimtController.resetCustomerList();
                                creditlimtController.isSearching.value = false;
                                if (!creditlimtController
                                    .isCustomerLoading.value) {
                                  var customer =
                                      await homecontroller.selectCustomer(
                                    context: context,
                                  );
                                  if (customer.code != null) {
                                    creditlimtController
                                        .selectCustomer(customer);
                                  }
                                }
                              },
                              controller: TextEditingController(
                                text: creditlimtController.customerId.value ==
                                        ''
                                    ? creditlimtController
                                            .isCustomerLoading.value
                                        ? 'Please wait..'
                                        : ' '
                                    : creditlimtController.customer.value.name,
                              ),
                              isLoading:
                                  creditlimtController.isCustomerLoading.value),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (creditlimtController.isCustomerLoading.value) {
                            SnackbarServices.errorSnackbar(
                                'CustomerId is empty');
                          } else {
                            creditlimtController.getCustomerSanpBalance();

                            CommonWidget.commonDialog(
                                context: context,
                                title: "Customer Balance",
                                content: customerBalancePopUp(context));
                          }
                          // creditlimtController.getCustomerSanpBalance();

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
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.datetime,
                              controller: TextEditingController(
                                  text:
                                      "${DateFormatter.dateFormat.format(creditlimtController.creditDate.value)}"),
                              label: "Date",
                              ontap: () async {
                                DateTime date = await creditlimtController
                                    .selectDateStartDate(context,
                                        creditlimtController.creditDate.value);
                                creditlimtController.creditDate.value = date;
                              },
                              icon: Icons.calendar_month_outlined))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: false,
                              keyboardtype: TextInputType.text,
                              controller: creditlimtController
                                  .referenceController.value,
                              label: "Reference",
                              ontap: () async {},
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Obx(() => CommonTextField.textfield(
                  //             suffixicon: true,
                  //             readonly: true,
                  //             keyboardtype: TextInputType.datetime,
                  //             icon: Icons.arrow_drop_down,
                  //             controller: TextEditingController(
                  //               text: creditlimtController.customerId.value == ''
                  //                   ? creditlimtController.isCustomerLoading.value
                  //                       ? 'Please wait..'
                  //                       : ' '
                  //                   : creditlimtController.customer.value.name,
                  //             ),
                  //             label: "CustomerId",
                  //             ontap: () async {
                  //               creditlimtController.resetCustomerList();
                  //               creditlimtController.isSearching.value = false;
                  //               if (!creditlimtController.isCustomerLoading.value) {
                  //                 var customer = await homecontroller.selectCustomer(
                  //                   context: context,
                  //                 );
                  //                 if (customer.code != null) {
                  //                   creditlimtController.selectCustomer(customer);
                  //                 }
                  //               }
                  //             },
                  //           )),
                  //     ),
                  //      const SizedBox(
                  //         width: 10,
                  //       ),
                  //       InkWell(
                  //         onTap: () async {
                  //           if (creditlimtController.isCustomerLoading.value) {
                  //             SnackbarServices.errorSnackbar(
                  //                 'CustomerId is empty');
                  //           } else {
                  //             creditlimtController.getCustomerSanpBalance();

                  //             CommonWidget.commonDialog(
                  //                 context: context,
                  //                 title: "Customer Balance",
                  //                 content: customerBalancePopUp(context));
                  //           }
                  //           // salesController.getCustomerSanpBalance();

                  //           // CommonWidget.commonDialog(
                  //           //     context: context,
                  //           //     title: "Customer Balance",
                  //           //     content: customerBalancePopUp(context));
                  //         },
                  //         child: Card(
                  //             color: AppColors.lightGrey,
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(8)),
                  //             child: const Padding(
                  //               padding: EdgeInsets.all(5),
                  //               child: Icon(
                  //                 Icons.attach_money,
                  //                 color: AppColors.primary,
                  //               ),
                  //             )),
                  //       ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Inactive",
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 13),
                        ),
                        Expanded(
                          child: Obx(() => Checkbox(
                                activeColor: AppColors.primary,
                                value: creditlimtController.inActive.value,
                                onChanged: (value) {
                                  creditlimtController.inActive.value =
                                      !creditlimtController.inActive.value;
                                },
                              )),
                        ),
                        Text(
                          "Hold",
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 13),
                        ),
                        Expanded(
                          child: Obx(() => Checkbox(
                                activeColor: AppColors.primary,
                                value: creditlimtController.hold.value,
                                onChanged: (value) {
                                  creditlimtController.hold.value =
                                      !creditlimtController.hold.value;
                                },
                              )),
                        ),
                        Text(
                          "Token",
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 13),
                        ),
                        Expanded(
                          child: Obx(() => Checkbox(
                                activeColor: AppColors.primary,
                                value: creditlimtController.isToken.value,
                                onChanged: (value) {
                                  creditlimtController.isToken.value =
                                      !creditlimtController.isToken.value;
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => CommonTextField.textfield(
                        suffixicon: false,
                        readonly: false,
                        keyboardtype: TextInputType.datetime,
                        controller: creditlimtController.amountController.value,
                        label: "Amount",
                        ontap: () async {},
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Obx(() => CommonTextField.textfield(
                              suffixicon: true,
                              readonly: true,
                              keyboardtype: TextInputType.datetime,
                              controller: TextEditingController(
                                  text:
                                      "${DateFormatter.dateFormat.format(creditlimtController.validFrom.value)}"),
                              label: "Valid From",
                              ontap: () async {
                                DateTime date = await creditlimtController
                                    .selectDateStartDate(context,
                                        creditlimtController.validFrom.value);
                                creditlimtController.validFrom.value = date;
                              },
                              icon: Icons.calendar_month_outlined))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                            suffixicon: true,
                            readonly: true,
                            keyboardtype: TextInputType.datetime,
                            controller: TextEditingController(
                                text:
                                    "${DateFormatter.dateFormat.format(creditlimtController.validTo.value)}"),
                            label: "Valid To",
                            ontap: () async {
                              DateTime date = await creditlimtController
                                  .selectDateStartDate(context,
                                      creditlimtController.validTo.value);
                              creditlimtController.validTo.value = date;
                            },
                            icon: Icons.calendar_month_outlined)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Obx(() => multilineTextfield(
                        suffixicon: false,
                        readonly: false,
                        keyboardtype: TextInputType.text,
                        maxlines: 5,
                        controller:
                            creditlimtController.remarksController.value,
                        label: "Remarks",
                        ontap: () async {},
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Obx(() => multilineTextfield(
                        suffixicon: false,
                        readonly: false,
                        maxlines: 5,
                        keyboardtype: TextInputType.text,
                        controller: creditlimtController.noteController.value,
                        label: "Note",
                        ontap: () async {},
                      )),
                ],
              ),
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
                          creditlimtController.clearCreditLimt();
                        },
                        onTapOfSave: () async {
                          if (creditlimtController.isNewRecord.value = true) {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.creditlimit,
                                type: ScreenRightOptions.Add)) {
                              await creditlimtController.createCreditLimit();
                            }
                          } else {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.creditlimit,
                                type: ScreenRightOptions.Edit)) {
                              await creditlimtController.createCreditLimit();
                            }
                          }
                          // if (creditlimtController.validation()) {
                          //   creditlimtController.createCreditLimit();
                          //   // salesController.clearCreditLimt();
                          // }
                        },
                        isSaving: creditlimtController.isCLSaving.value,
                        isSaveActive: creditlimtController.isNewRecord.value
                            ? creditlimtController.isAddEnabled.value
                            : creditlimtController.isEditEnabled.value))),
              ))
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
                () => creditlimtController.isCreditLimitOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : creditlimtController.creditlimitOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                creditlimtController.creditlimitOpenList.length,
                            itemBuilder: (context, index) {
                              var item = creditlimtController
                                  .creditlimitOpenList[index];
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
                                    await creditlimtController
                                        .getCreditLimitbyid(item.docId ?? '',
                                            item.docNumber ?? '');
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
                                          'Date : ${item.date ?? DateFormatter.dateFormat.format(item.date!)}',
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
                      .dateRange[creditlimtController.dateIndex.value],
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
                    creditlimtController.selectDateRange(
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
                      .format(creditlimtController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: creditlimtController.isFromDate.value,
                isDate: true,
                onTap: () {
                  creditlimtController.selectDate(context, true);
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
                        .format(creditlimtController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: creditlimtController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    creditlimtController.selectDate(context, false);
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
              creditlimtController.getCreditLimitOpenList();
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
    int? maxlines,
  }) {
    return SizedBox(
      child: TextField(
        enabled: !isDisabled,
        controller: controller,
        readOnly: readonly || isUpdate,
        onTap: ontap,
        keyboardType: keyboardtype,
        maxLines: maxlines,
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

  customerBalancePopUp(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Obx(() => creditlimtController.iscustomerLoading.value
              ? SalesShimmer.locationPopShimmer()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creditlimtController.code.value,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              " - ${creditlimtController.name.value}",
                              style: TextStyle(
                                color: AppColors.mutedColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
                              text: creditlimtController.status.value,
                            ),
                            firstTextStyle: creditlimtController.status.value
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
                              text: creditlimtController.creditstatus.value,
                            ),
                            firstTextStyle: creditlimtController
                                        .creditstatus.value
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
                                            creditlimtController.balance.value))
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
                                      creditlimtController.creditlimit.value)),
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
                                      creditlimtController.insAmount.value)),
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
                                      creditlimtController.dueAmount.value)),
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
                                  double.parse(
                                      creditlimtController.unsecPdc.value)),
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
                              text: creditlimtController.maxduedays.value,
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
                                  double.parse(creditlimtController.pdc.value)),
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
                                      creditlimtController.uninvoicedd.value)),
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
                                  double.parse(creditlimtController.net.value)),
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
                                      creditlimtController.available.value)),
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
                              text: creditlimtController.customerremarks.value,
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
}
