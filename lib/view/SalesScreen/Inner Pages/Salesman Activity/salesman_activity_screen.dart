import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/sales_screen_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/salesman_activity_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/chatscreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';

class SalesmanActivityScreen extends StatefulWidget {
  const SalesmanActivityScreen({super.key});

  @override
  State<SalesmanActivityScreen> createState() => _SalesmanActivityScreenState();
}

class _SalesmanActivityScreenState extends State<SalesmanActivityScreen> {
  final salesmanactivityController = Get.put(SalesmanActivityController());
  final salesscreenController = Get.put(SalesController());
  final homeControl = Get.put(HomeController());
  var selectedSysdocValue;
  TextEditingController sysDocIdController = TextEditingController();
  TextEditingController voucherIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Salesman Activity"),
        actions: [
          Obx(() => homeControl.chatenabled.value == true
              ? IconButton(
                  onPressed: () {
                    Get.to(ConversationPage());
                  },
                  icon: Icon(Icons.chat_outlined))
              : Container(
                  height: 0,
                  width: 0,
                )),
          IconButton(
            onPressed: () {
              salesmanactivityController.getSalesmanActivityOpenList();
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
              () => salesmanactivityController.isSalesOrderByIdLoading.value
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 10, right: 10, left: 10),
                  //   child: Text(
                  //     'SysDoc Id:',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w400,
                  //       color: AppColors.primary,
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    child: SizedBox(
                      height: 9.w,
                      child: Obx(() => TextField(
                            controller: TextEditingController(
                              text: salesmanactivityController.sysDocName.value,
                            ).text.isEmpty
                                ? TextEditingController(text: ' ')
                                : TextEditingController(
                                    text: salesmanactivityController
                                        .sysDocName.value,
                                  ),
                            // enabled: false,
                            readOnly: true,
                            onTap: () async {
                              await salesmanactivityController
                                  .generateSysDocList();
                              if (!salesscreenController.isLoading.value) {
                                var sysDoc =
                                    await salesscreenController.selectSysDoc(
                                        context: context,
                                        sysDocType: 114,
                                        list: salesmanactivityController
                                            .sysDocList);
                                if (sysDoc.code != null) {
                                  salesmanactivityController.getVoucherNumber(
                                      sysDoc.code, sysDoc.name);

                                  salesmanactivityController
                                      .sysDocIdControl.text = sysDoc.name;
                                  salesmanactivityController
                                          .voucherControl.text =
                                      salesmanactivityController
                                          .voucherNumber.value;
                                }
                              }
                            },

                            style: TextStyle(
                                fontSize: 12, color: AppColors.mutedColor),
                            decoration: InputDecoration(
                                isCollapsed: true,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.mutedColor, width: 0.1),
                                ),
                                labelText: "SysDoc Id",
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary,
                                ),
                                suffixIconConstraints:
                                    BoxConstraints.loose(Size.infinite),
                                suffixIcon:
                                    salesscreenController.isLoading == true
                                        ? SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              color: AppColors.mutedColor,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.primary,
                                          )),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        height: 9.w,
                        child: Obx(
                          () => salesmanactivityController.textfield(
                              controller: TextEditingController(
                                text: salesmanactivityController
                                    .voucherNumber.value,
                              ),
                              readonly: true,
                              ontap: () {},
                              suffixicon: false,
                              keyboardtype: TextInputType.text,
                              label: "Voucher"),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 9.w,
                child: salesmanactivityController.textfield(
                  suffixicon: false,
                  ontap: () {},
                  controller: salesmanactivityController.activityNameControl,
                  label: "Activity Name",
                  readonly: false,
                  keyboardtype: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 110,
                      height: 9.w,
                      child: salesmanactivityController.textfield(
                        suffixicon: true,
                        label: "Activity Type",
                        controller:
                            salesmanactivityController.activityTypeControl,
                        ontap: () {
                          salesmanactivityController.isLoading.value = true;
                          homeControl.selectCRMList(
                              context: context,
                              text: "Activity Type",
                              oneditingcomplete: () async {
                                await salesmanactivityController
                                    .changeFocus(context);
                              },
                              controller: salesmanactivityController
                                  .activityTypeControl,
                              list: homeControl.activitytypelist);
                        },
                        readonly: true,
                        keyboardtype: TextInputType.text,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 9.w,
                      child: salesmanactivityController.textfield(
                        label: "Regarding",
                        controller: salesmanactivityController.regardingControl,
                        suffixicon: true,
                        ontap: () async {
                          await homeControl.selectCRMList(
                              context: context,
                              text: "Regarding",
                              oneditingcomplete: () async {
                                await salesmanactivityController
                                    .changeFocus(context);
                              },
                              controller:
                                  salesmanactivityController.regardingControl,
                              list: homeControl.regardinglist);
                        },
                        readonly: true,
                        keyboardtype: TextInputType.text,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 10.w,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 1.5.w),
                            label: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Related To",
                                style: TextStyle(
                                    color: AppColors.primary, fontSize: 12),
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
                          buttonPadding:
                              const EdgeInsets.only(left: 0, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: RelatedtypeOptions.values
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
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
                            RelatedtypeOptions selectedvalue =
                                value as RelatedtypeOptions;
                            salesmanactivityController.relatedTo.value =
                                selectedvalue;

                            salesmanactivityController
                                .isSelectedRelatedto.value = true;
                            salesmanactivityController
                                .relatedtoitemscontrol.value.text = " ";
                          },
                          onSaved: (value) {},
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
                        width: double.infinity,
                        child: salesmanactivityController.textfield(
                          controller: salesmanactivityController
                              .relatedtoitemscontrol.value,
                          ontap: () async {
                            // if (salesmanactivityController.relatedtolist[
                            //         salesmanactivityController
                            //             .relatedtoIndex.value] ==
                            //     "Lead") {
                            if (salesmanactivityController
                                    .isSelectedRelatedto.value ==
                                true) {
                              if (salesmanactivityController.relatedTo.value ==
                                  RelatedtypeOptions.Lead) {
                                await homeControl.selectCRMList(
                                    context: context,
                                    text: "Leads",
                                    oneditingcomplete: () async {
                                      await salesmanactivityController
                                          .changeFocus(context);
                                    },
                                    controller: salesmanactivityController
                                        .relatedtoitemscontrol.value,
                                    list: homeControl.leadList);
                              } else {
                                log("${homeControl.customerList.isEmpty}");
                                salesmanactivityController
                                    .relatedtoitemscontrol.value.text = " ";

                                await homeControl.selectCRMList(
                                    context: context,
                                    text: "Customers",
                                    oneditingcomplete: () async {
                                      await salesmanactivityController
                                          .changeFocus(context);
                                    },
                                    controller: salesmanactivityController
                                        .relatedtoitemscontrol.value,
                                    list: homeControl.customerList);
                              }
                            }
                          },
                          label: salesmanactivityController
                                      .isSelectedRelatedto.value ==
                                  true
                              ? salesmanactivityController.relatedTo.value ==
                                      RelatedtypeOptions.Lead
                                  ? "Lead"
                                  : "Customers"
                              : "",
                          suffixicon: true,
                          readonly: true,
                          keyboardtype: TextInputType.text,
                        ),
                      ),
                    ),
                    if (salesmanactivityController.isSelectedRelatedto.value ==
                        true)
                      if (salesmanactivityController.relatedTo.value ==
                          RelatedtypeOptions.Lead)
                        IconButton(
                            onPressed: () {
                              Get.toNamed(RouteManager.lead);
                              // Get.toNamed(RouteManager.leadList);
                            
                            },
                            icon: Icon(
                              Icons.add_box,
                              color: AppColors.primary,
                            ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 9.w,
                child: salesmanactivityController.textfield(
                  suffixicon: true,
                  controller: salesmanactivityController.contactControl,
                  label: "Contact",
                  ontap: () async {
                    await homeControl.selectCRMList(
                        context: context,
                        text: "Contact",
                        oneditingcomplete: () async {
                          await salesmanactivityController.changeFocus(context);
                        },
                        controller: salesmanactivityController.contactControl,
                        list: homeControl.contactlist);
                  },
                  readonly: true,
                  keyboardtype: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 9.w,
                child: salesmanactivityController.textfield(
                  controller: salesmanactivityController.activityByControl,
                  label: "Activity By",
                  suffixicon: true,
                  ontap: () {
                    homeControl.selectCRMList(
                        context: context,
                        text: "Activity By",
                        oneditingcomplete: () async {
                          await salesmanactivityController.changeFocus(context);
                        },
                        controller:
                            salesmanactivityController.activityByControl,
                        list: homeControl.activitybylist);
                  },
                  readonly: true,
                  keyboardtype: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              salesmanactivityController.multilinetextfield(
                controller: salesmanactivityController.noteControl,
                label: "Note",
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    homeControl.selectFile();
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        dashPattern: [10, 4],
                        strokeCap: StrokeCap.round,
                        color: AppColors.mutedColor,
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                              color: AppColors.mutedColor.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(10)),
                          child: homeControl.result.value ==
                                  FilePickerResult([])
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      color: AppColors.mutedColor,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Attach File',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 4),
                                      itemCount:
                                          homeControl.result.value.files.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              homeControl.filetypeIcon(index),
                                              Center(
                                                child: Text(
                                                  "${homeControl.result.value.files[index].name}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.mutedColor,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: height / 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    salesmanactivityController.clearData();
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mutedBlueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Obx(() => Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        salesmanactivityController.validateField();
                        if (salesmanactivityController.validateField() ==
                            true) {
                          salesmanactivityController.createActivity();
                        }
                      },
                      child:
                          salesmanactivityController.isLoadingSave.value == true
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : Text("Save"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                    ),
                  ),
                ))
          ],
        ),
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
                      .dateRange[salesmanactivityController.dateIndex.value],
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
                    salesmanactivityController.selectDateRange(
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
                      .format(salesmanactivityController.fromDate.value)
                      .toString(),
                ),
                label: 'From Date',
                enabled: salesmanactivityController.isFromDate.value,
                isDate: true,
                onTap: () {
                  salesmanactivityController.selectDate(context, true);
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
                        .format(salesmanactivityController.toDate.value)
                        .toString(),
                  ),
                  label: 'To Date',
                  enabled: salesmanactivityController.isToDate.value,
                  isDate: true,
                  onTap: () {
                    salesmanactivityController.selectDate(context, false);
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
              log("from date ${salesmanactivityController.fromDate.value} todate ${salesmanactivityController.toDate.value}");
              salesmanactivityController.getSalesmanActivityOpenList();
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
                () => salesmanactivityController.isOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : salesmanactivityController
                                .salesmanActivityOpenList.length ==
                            0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: salesmanactivityController
                                .salesmanActivityOpenList.length,
                            itemBuilder: (context, index) {
                              var item = salesmanactivityController
                                  .salesmanActivityOpenList[index];
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
                                    salesmanactivityController.getActivityByID(
                                        item.docId, item.number);
                                    // sysDocIdController.text =
                                    //     "${item.docId ?? " "}";
                                    // voucherIdController.text =
                                    //     "${item.number ?? " "}";
                                    // salesmanactivityController
                                    //     .activityNameControl
                                    //     .text = "${item.activityName ?? " "}";
                                    // salesmanactivityController
                                    //     .activityTypeControl
                                    //     .text = "${item.activityType ?? " "}";
                                    // log("${item.accountType}");
                                    // if (item.accountType == "Lead") {
                                    //   salesmanactivityController.relatedTo
                                    //       .value = RelatedtypeOptions.Lead;
                                    //   salesmanactivityController
                                    //       .relatedToControl.text = "Lead";
                                    //   salesmanactivityController
                                    //       .isSelectedRelatedto.value = true;
                                    // } else {
                                    //   RelatedtypeOptions selectedvalue =
                                    //       "Customers" as RelatedtypeOptions;
                                    //   salesmanactivityController
                                    //       .relatedTo.value = selectedvalue;

                                    //   salesmanactivityController
                                    //       .isSelectedRelatedto.value = true;
                                    //   salesmanactivityController
                                    //       .relatedtoitemscontrol
                                    //       .value
                                    //       .text = " ";
                                    // }
                                    // salesmanactivityController.contactControl
                                    //     .text = "${item.contact ?? " "}";
                                    // salesmanactivityController.activityByControl
                                    //     .text = "${item.performedBy ?? " "}";
                                    // salesmanactivityController
                                    //         .noteControl.text =
                                    //     "${item.note == "" ? " " : item.note ?? " "}";
                                    salesmanactivityController
                                        .isNewRecord.value = false;
                                    Navigator.pop(context);
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
                                          '${item.docId} - ${item.number}',
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
                                            'Activity Name : ${item.activityName}',
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
                                          'Account Type : ${item.accountType}',
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
                                          'Date : ${DateFormatter.dateFormat.format(item.date)}',
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
