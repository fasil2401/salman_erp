import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/overdue_controller.dart';
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

class OverDueScreen extends StatelessWidget {
  OverDueScreen({Key? key}) : super(key: key);

  var selectedValue;
  final overduecontroller = Get.put(OverDueController());
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
        title: const Text('Over Due'),
        actions: [
          IconButton(
            onPressed: () async {
              overduecontroller.getoverdueOpenList();
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => SysDocRow(
                        onTap: () async {
                          await overduecontroller.generateSysDocList();
                          if (!overduecontroller.isLoading.value) {
                            var sysDoc =
                                await salesScreenController.selectSysDoc(
                                    context: context,
                                    sysDocType: 270,
                                    list: overduecontroller.sysDocList);
                            if (sysDoc.code != null) {
                              overduecontroller.getVoucherNumber(
                                  sysDoc.code, sysDoc.name);
                            }
                          }
                        },
                        sysDocIdController: TextEditingController(
                          text: overduecontroller.sysDocName.value,
                        ),
                        sysDocSuffixLoading:
                            salesScreenController.isLoading.value,
                        voucherIdController: TextEditingController(
                          text: overduecontroller.voucherNumber.value,
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
                                overduecontroller.resetCustomerList();
                                overduecontroller.isSearching.value = false;
                                if (!overduecontroller
                                    .isCustomerLoading.value) {
                                  var customer =
                                      await homecontroller.selectCustomer(
                                    context: context,
                                  );
                                  if (customer.code != null) {
                                    overduecontroller.selectCustomer(customer);
                                  }
                                }
                              },
                              controller: TextEditingController(
                                text: overduecontroller.customerId.value == ''
                                    ? overduecontroller.isCustomerLoading.value
                                        ? 'Please wait..'
                                        : ' '
                                    : overduecontroller.customer.value.name,
                              ),
                              isLoading:
                                  overduecontroller.isCustomerLoading.value),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (overduecontroller.isCustomerLoading.value) {
                            SnackbarServices.errorSnackbar(
                                'CustomerId is empty');
                          } else {
                            overduecontroller.getCustomerSanpBalance();

                            CommonWidget.commonDialog(
                                context: context,
                                title: "Customer Balance",
                                content: customerBalancePopUp(context));
                          }
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
                                      "${DateFormatter.dateFormat.format(overduecontroller.overdueDate.value)}"),
                              label: "Date",
                              ontap: () async {
                                DateTime date =
                                    await overduecontroller.selectDateStartDate(
                                        context,
                                        overduecontroller.overdueDate.value);
                                overduecontroller.overdueDate.value = date;
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
                              controller: overduecontroller
                                  .overduereferenceController.value,
                              label: "Reference",
                              ontap: () async {},
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Obx(() => CommonTextField.textfield(
                  //       suffixicon: true,
                  //       readonly: true,
                  //       keyboardtype: TextInputType.datetime,
                  //       icon: Icons.arrow_drop_down,
                  //       controller: TextEditingController(
                  //         text: overduecontroller.customerId.value == ''
                  //             ? overduecontroller.isCustomerLoading.value
                  //                 ? 'Please wait..'
                  //                 : ' '
                  //             : overduecontroller.customer.value.name,
                  //       ),
                  //       label: "CustomerId",
                  //       ontap: () async {
                  //         overduecontroller.resetCustomerList();
                  //         overduecontroller.isSearching.value = false;
                  //         if (!overduecontroller.isCustomerLoading.value) {
                  //           var customer = await homecontroller.selectCustomer(
                  //             context: context,
                  //           );
                  //           if (customer.code != null) {
                  //             overduecontroller.selectCustomer(customer);
                  //           }
                  //         }
                  //       },
                  //     )),
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
                                value: overduecontroller.overdueinActive.value,
                                onChanged: (value) {
                                  overduecontroller.overdueinActive.value =
                                      !overduecontroller.overdueinActive.value;
                                },
                              )),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          "Hold",
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 13),
                        ),
                        Expanded(
                          child: Obx(() => Checkbox(
                                activeColor: AppColors.primary,
                                value: overduecontroller.overduehold.value,
                                onChanged: (value) {
                                  overduecontroller.overduehold.value =
                                      !overduecontroller.overduehold.value;
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => CommonTextField.textfield(
                              suffixicon: false,
                              readonly: false,
                              keyboardtype: TextInputType.datetime,
                              controller: overduecontroller
                                  .overdueamountController.value,
                              label: "Over Due Amount",
                              ontap: () async {},
                            )),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Expanded(
                      //   child: Obx(() => CommonTextField.textfield(
                      //         suffixicon: false,
                      //         readonly: false,
                      //         keyboardtype: TextInputType.datetime,
                      //         controller:
                      //             salesController.overduedaysController.value,
                      //         label: "Over Due Days",
                      //         ontap: () async {},
                      //       )),
                      // ),
                    ],
                  ),
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
                                      "${DateFormatter.dateFormat.format(overduecontroller.overduevalidFrom.value)}"),
                              label: "Valid From",
                              ontap: () async {
                                DateTime date =
                                    await overduecontroller.selectDateStartDate(
                                        context,
                                        overduecontroller
                                            .overduevalidFrom.value);
                                overduecontroller.overduevalidFrom.value = date;
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
                                    "${DateFormatter.dateFormat.format(overduecontroller.overduevalidTo.value)}"),
                            label: "Valid To",
                            ontap: () async {
                              DateTime date =
                                  await overduecontroller.selectDateStartDate(
                                      context,
                                      overduecontroller.overduevalidTo.value);
                              overduecontroller.overduevalidTo.value = date;
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
                        maxLines: 5,
                        keyboardtype: TextInputType.text,
                        controller:
                            overduecontroller.overdueremarksController.value,
                        label: "Remarks",
                        ontap: () async {},
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Obx(() => multilineTextfield(
                        suffixicon: false,
                        readonly: false,
                        keyboardtype: TextInputType.text,
                        maxLines: 5,
                        controller:
                            overduecontroller.overduenoteController.value,
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
                          Navigator.pop(context);
                        },
                        onTapOfSave: () async {
                          if (overduecontroller.isNewRecord.value = true) {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.overdue,
                                type: ScreenRightOptions.Add)) {
                              await overduecontroller.createOverDue();
                            }
                          } else {
                            if (homecontroller.isScreenRightAvailable(
                                screenId: SalesScreenId.overdue,
                                type: ScreenRightOptions.Edit)) {
                              await overduecontroller.createOverDue();
                            }
                          }
                        },
                        isSaving: overduecontroller.isSaving.value,
                        isSaveActive: overduecontroller.isNewRecord.value
                            ? overduecontroller.isAddEnabled.value
                            : overduecontroller.isEditEnabled.value))),
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
                () => overduecontroller.isCreditLimitOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : overduecontroller.creditlimitOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                overduecontroller.creditlimitOpenList.length,
                            itemBuilder: (context, index) {
                              var item =
                                  overduecontroller.creditlimitOpenList[index];
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
                                    await overduecontroller.getOverduebyid(
                                        item.docId ?? '', item.docNumber ?? '');
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
                      .dateRange[overduecontroller.dateIndex.value],
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
                    overduecontroller.selectDateRange(
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
                      .format(overduecontroller.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: overduecontroller.isFromDate.value,
                isDate: true,
                onTap: () {
                  overduecontroller.selectDate(context, true);
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
                        .format(overduecontroller.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: overduecontroller.isToDate.value,
                  isDate: true,
                  onTap: () {
                    overduecontroller.selectDate(context, false);
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
              overduecontroller.getOverdueOpenList();
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
    int? maxLines,
  }) {
    return SizedBox(
      child: TextField(
        enabled: !isDisabled,
        controller: controller,
        readOnly: readonly || isUpdate,
        onTap: ontap,
        maxLines: maxLines,
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
  }

  customerBalancePopUp(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Obx(() => overduecontroller.iscustomerLoading.value
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
                          overduecontroller.code.value,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          " - ${overduecontroller.name.value}",
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
                          text: overduecontroller.status.value,
                        ),
                        firstTextStyle: overduecontroller.status.value
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
                          text: overduecontroller.creditstatus.value,
                        ),
                        firstTextStyle: overduecontroller.creditstatus.value
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
                                        overduecontroller.balance.value))
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
                          text: InventoryCalculations.formatPrice(double.parse(
                              overduecontroller.creditlimit.value)),
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
                              double.parse(overduecontroller.insAmount.value)),
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
                              double.parse(overduecontroller.dueAmount.value)),
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
                              double.parse(overduecontroller.unsecPdc.value)),
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
                          text: overduecontroller.maxduedays.value,
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
                              double.parse(overduecontroller.pdc.value)),
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
                          text: InventoryCalculations.formatPrice(double.parse(
                              overduecontroller.uninvoicedd.value)),
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
                              double.parse(overduecontroller.net.value)),
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
                              double.parse(overduecontroller.available.value)),
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
                          text: overduecontroller.customerremarks.value,
                        ),
                        label: "Remarks",
                      ),
                    ),
                  ],
                ),
              ],
            )),
    );
  }
}
