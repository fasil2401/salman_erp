import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';
import 'package:axolon_erp/model/get_Packing_List_Details_Model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_action_status_log_list_model.dart';
import 'package:axolon_erp/model/get_action_status_security_model.dart';
import 'package:axolon_erp/model/get_shipper_list_mode.dart';
import 'package:axolon_erp/utils/Theme/color_helper.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/container_tracker_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';

Widget timeline(
  BuildContext context,
) {
  final actionStatusLogController = Get.put(ContainerTrackerController());
  return Obx(() => actionStatusLogController.isActionListLoading.value
      ? popShimmer()
      : actionStatusLogController.actionStatusLog.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No Data",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: actionStatusLogController.actionStatusLog.length,
              itemBuilder: (context, index) {
                final item = actionStatusLogController.actionStatusLog[index];
                return TimelineTile(
                    alignment: TimelineAlign.start,
                    lineXY: 0.1,
                    isFirst: index == 0,
                    isLast: index ==
                        actionStatusLogController.actionStatusLog.length - 1,
                    beforeLineStyle:
                        LineStyle(color: Colors.grey, thickness: 1.5),
                    afterLineStyle:
                        LineStyle(color: Colors.grey, thickness: 1.5),
                    // indicatorStyle: IndicatorStyle(
                    // color: AppColors.primary,
                    // height: 10,
                    // width: 10,
                    // iconStyle: IconStyle(
                    //   fontSize: 5,
                    //   color: AppColors.mutedBlueColor,
                    //   iconData: Icons.circle,
                    // ),
                    // ),
                    indicatorStyle: IndicatorStyle(
                      indicatorXY: 0,
                      // drawGap: true,
                      color: AppColors.primary,
                      height: 15,
                      width: 15,
                      iconStyle: IconStyle(
                        fontSize: 10,
                        color: AppColors.mutedBlueColor,
                        iconData: Icons.circle,
                      ),
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.statusDate == null || item.statusDate == ''
                                    ? ""
                                    : DateFormatter.dayFormat.format(
                                        DateTime.parse(
                                            item.statusDate.toString())),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                item.statusDate == null || item.statusDate == ''
                                    ? ""
                                    : DateFormatter.dateFormatTime.format(
                                        DateTime.parse(
                                            item.statusDate.toString())),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppColors.mutedColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppColors.lightGrey),
                                  color: AppColors.lightGrey.withOpacity(0.4)),
                              // elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: item.hexColorCode == null ||
                                                item.hexColorCode == ''
                                            ? Colors.transparent
                                            : Color(int.parse(
                                                    '${item.hexColorCode!.split('#')[1]}',
                                                    radix: 16) +
                                                0xFF000000),
                                      ),
                                      child: Text(
                                        item.status ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: item.hexColorCode == null ||
                                                    item.hexColorCode == ''
                                                ? Colors.black
                                                : ColorHelper
                                                    .getContrastingTextColorFromHex(
                                                        item.hexColorCode!),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Updated By : ',
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Expanded(
                                            child: Text(
                                          item.updatedBy ?? '',
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Remarks : ',
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Expanded(
                                            child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: Text(
                                              item.remarks ?? '',
                                              // maxLines:
                                              //     item.readMore == true ? null : 3,
                                            )),
                                            // InkWell(
                                            //   onTap: () {
                                            //     approvalController
                                            //         .readMoreText(index);
                                            //   },
                                            //   child: Text(
                                            //     item.readMore!
                                            //         ? "Read less"
                                            //         : "Read more",
                                            //     style: TextStyle(
                                            //         color: AppColors.primary),
                                            //   ),
                                            // ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       'Date Updated : ',
                                    //       style: TextStyle(
                                    //           color: AppColors.mutedColor,
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //     Expanded(
                                    //       child: Text(
                                    //         item.dateUpdated == null ||
                                    //                 item.dateUpdated == ''
                                    //             ? ""
                                    //             : DateFormatter.dateFormatter
                                    //                 .format(DateTime.parse(item
                                    //                     .dateUpdated
                                    //                     .toString())),
                                    //         style: TextStyle(
                                    //             color: AppColors.mutedColor,
                                    //             fontWeight: FontWeight.w400),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       'Status Date : ',
                                    //       style: TextStyle(
                                    //           color: AppColors.mutedColor,
                                    //           fontWeight: FontWeight.w400),
                                    //     ),
                                    //     Expanded(
                                    //       child: Text(
                                    //         item.statusDate == null ||
                                    //                 item.statusDate == ''
                                    //             ? ""
                                    //             : DateFormatter.dateFormatter
                                    //                 .format(DateTime.parse(item
                                    //                     .statusDate
                                    //                     .toString())),
                                    //         style: TextStyle(
                                    //             color: AppColors.mutedColor,
                                    //             fontWeight: FontWeight.w400),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    // const SizedBox(
                                    //   height: 5,
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reference  : ${item.reference1 ?? ''}',
                                          style: TextStyle(
                                              color: AppColors.mutedColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Reference 2 : ${item.reference2 ?? ''}',
                                      style: TextStyle(
                                          color: AppColors.mutedColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ));
              },
            ));
}

Widget popShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 35,
          child: Card(),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 5,
      ),
    ),
  );
}

SizedBox buildPreviewLoader() {
  return SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 3,
    ),
  );
}

DateTime dateUpdateAlertDialog(
    BuildContext context,
    String txt,
    var orginalDate,
    ContainerTrackerController containerTrackerController,
    Function() ontapSave) {
  containerTrackerController.changedDate.value =
      orginalDate == null || orginalDate == '' ? DateTime.now() : orginalDate;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                'Update $txt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedColor,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.mutedColor,
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 15,
                ),
              ),
            )
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFieldLabel('Original Date'),
              buildExpansionTextFields(
                  controller: TextEditingController(
                      text: orginalDate == null || orginalDate == ''
                          ? ""
                          : "${DateFormatter.dateFormat.format(orginalDate)}"),
                  onTap: () {}),
              // CommonTextField.textfield(
              //     suffixicon: false,
              //     readonly: true,
              //     keyboardtype: TextInputType.datetime,
              //     label: "Original Date",
              //     controller: TextEditingController(
              //         text: orginalDate == null || orginalDate == ''
              //             ? ""
              //             : "${DateFormatter.dateFormat.format(orginalDate)}")),
              const SizedBox(
                height: 15,
              ),
              buildTextFieldLabel('Expected Date'),
              Obx(
                () => buildExpansionTextFields(
                    controller: TextEditingController(
                        text:
                            "${DateFormatter.dateFormat.format(containerTrackerController.changedDate.value)}"),
                    onTap: () async {
                      await containerTrackerController.selectPackageDate(
                        context,
                        containerTrackerController.changedDate.value,
                      );
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: ontapSave,
                    child: Text('Save',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              // Obx(() => CommonTextField.textfield(
              //     suffixicon: false,
              //     readonly: true,
              //     keyboardtype: TextInputType.datetime,
              //     label: "Expected Date",
              //     controller: TextEditingController(
              //         text:
              //             "${DateFormatter.dateFormat.format(containerTrackerController.changedDate.value)}"),
              //     icon: Icons.date_range,
              //     ontap: () async {
              //       await containerTrackerController.selectPackageDate(
              //         context,
              //         containerTrackerController.changedDate.value,
              //       );
              //     }))
            ],
          ),
        ),
      );
    },
  );
  return containerTrackerController.changedDate.value;
}

ClipRRect buildExpansionTextFields(
    {required TextEditingController controller,
    required Function() onTap,
    String? hint,
    bool? isReadOnly,
    bool? isSearch,
    bool? isClosing,
    bool? disableSuffix,
    FocusNode? focus,
    bool? isDropdown,
    bool? isTime,
    Function(String)? onChanged,
    Function()? onEditingComplete}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: TextField(
      controller: controller,
      style: TextStyle(
          fontSize: 12,
          color: isClosing != null ? AppColors.primary : AppColors.mutedColor),
      maxLines: 1,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      readOnly: isReadOnly ?? true,
      autofocus: false,
      decoration: InputDecoration(
        isCollapsed: true,
        isDense: true,
        filled: true,
        hintText: hint ?? '',
        // enabled: false,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2)),
        fillColor: AppColors.lightGrey.withOpacity(0.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: disableSuffix != null
              ? Container()
              : Icon(
                  isTime != null
                      ? Icons.schedule
                      : isDropdown != null
                          ? Icons.keyboard_arrow_down
                          : isClosing != null
                              ? Icons.cancel_rounded
                              : isSearch != null
                                  ? Icons.search
                                  : Icons.calendar_month_outlined,
                  color: isClosing != null
                      ? AppColors.primary
                      : AppColors.mutedColor,
                  size: 20,
                ),
        ),
        suffixIconConstraints: BoxConstraints.tightFor(height: 20, width: 30),
      ),
    ),
  );
}

updateShipper(
    BuildContext context,
    String shipperName,
    Function() ontapOfChangingShipper,
    ContainerTrackerController controller,
    Function() ontapOfSave) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Update Shipper',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.mutedColor,
                      size: 15,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => CommonTextField.textfield(
                suffixicon: true,
                readonly: true,
                keyboardtype: TextInputType.datetime,
                label: "Shipper",
                controller: controller.shipperName.value,
                icon: Icons.arrow_drop_down_outlined,
                ontap: ontapOfChangingShipper))
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: ontapOfSave,
                  child:
                      Text('Save', style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

showShipperList(
    {required BuildContext context,
    required PackingDetailModel item,
    required ContainerTrackerController controller}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: popupTitle(
          title: 'Update Shipper',
          onTap: () {
            controller.selectedShipperValue.value = ShipperModel();
            Navigator.pop(context);
          },
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildExpansionTextFields(
                  controller: TextEditingController(),
                  onTap: () {},
                  hint: 'Search',
                  isReadOnly: false,
                  onChanged: (value) {
                    controller.searchShipperLIst(value);
                  },
                  onEditingComplete: () async {
                    await controller.changeFocus(context);
                  },
                  isSearch: true),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => buildExpansionTextFields(
                    controller: TextEditingController(
                        text: controller.selectedShipperValue.value.name ??
                            controller.shipperName.value.text),
                    onTap: () {},
                    isClosing: true),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: Obx(
                  () => controller.isLoading.value
                      ? SalesShimmer.locationPopShimmer()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filterShipperList.length,
                          itemBuilder: (context, index) {
                            var shipper = controller.filterShipperList[index];
                            return InkWell(
                              onTap: <ShipperModel>() {
                                controller.selectedShipperValue.value = shipper;
                                // controller.shipperName.value.text =
                                //     shipper.name.toString();
                                // Navigator.pop(context);
                                controller.filterShipperList.value =
                                    controller.shipperList;
                                return shipper;
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    thickness: 0.4,
                                    color: AppColors.mutedColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      "${shipper.code} - ${shipper.name}",
                                      minFontSize: 8,
                                      maxFontSize: 14,
                                      style: const TextStyle(
                                        color: AppColors.mutedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    controller.updateShipper(
                        item.docId.toString(),
                        item.voucherId.toString(),
                        controller.selectedShipperValue.value.code.toString());
                    Navigator.pop(context);
                  },
                  child:
                      Text('Save', style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  return controller.selectedShipperValue.value;
}

Row popupTitle({required Function() onTap, required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedColor,
          ),
        ),
      ),
      InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.mutedColor,
          child: Icon(
            Icons.close,
            color: AppColors.white,
            size: 15,
          ),
        ),
      )
    ],
  );
}

showStatusList(
    {required BuildContext context,
    required List<ActionStatusSecuirityModel> list,
    required var controller}) async {
  // customerFilterList = this.customerList;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        insetPadding: EdgeInsets.all(10),
        title: popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Status'),
        // Center(
        //   child: Text(
        //     'Status',
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w500,
        //       color: AppColors.primary,
        //     ),
        //   ),
        // ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildExpansionTextFields(
              controller: TextEditingController(),
              onTap: () {},
              isSearch: true,
              hint: 'Search',
              isReadOnly: false,
              onChanged: (value) {
                controller.searchStatusLIst(value);
              },
              onEditingComplete: () async {
                await controller.changeFocus(context);
              },
            ),
            // TextField(
            //   decoration: InputDecoration(
            //       isCollapsed: true,
            //       hintText: 'Search',
            //       contentPadding: EdgeInsets.all(8)),
            //   onChanged: (value) {
            //     controller.searchStatusLIst(value);
            //   },
            //   onEditingComplete: () async {
            //     await controller.changeFocus(context);
            //   },
            // ),
            Flexible(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Obx(
                  () => controller.isLoading.value
                      ? SalesShimmer.locationPopShimmer()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filterActionStatusList.length,
                          itemBuilder: (context, index) {
                            var status =
                                controller.filterActionStatusList[index];
                            // ActionStatusComboModel actionStatus = controller
                            //         .getActionStatus(status.statusId ?? '') ??
                            //     ActionStatusComboModel();
                            return InkWell(
                              onTap: <ActionStatusSecuirityModel>() {
                                controller.selectedStatusValue.value = status;
                                // controller.getActionStatus(
                                //         status.statusId ?? '') ??
                                //     ActionStatusComboModel();
                                Navigator.pop(context);
                                // controller
                                //         .filterActionChangingStatusList.value =
                                //     controller.actionStatusChangingList;
                                // return status;
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    thickness: 0.4,
                                    color: AppColors.mutedColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 12,
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.lightGrey,
                                                width: 0.4),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: status.hexColorCode ==
                                                        null ||
                                                    status.hexColorCode == ''
                                                ? Colors.white
                                                : Color(int.parse(
                                                        '${status.hexColorCode!.split('#')[1]}',
                                                        radix: 16) +
                                                    0xFF000000),
                                          ),
                                        ),
                                        AutoSizeText(
                                          "${status.code}",
                                          minFontSize: 8,
                                          maxFontSize: 14,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(5.0),
        //         child: InkWell(
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //           child:
        //               Text('Close', style: TextStyle(color: AppColors.primary)),
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      );
    },
  );
  return controller.selectedStatusValue.value;
}

updateActionStatus(BuildContext context, Function() ontapOfStatus,
    var controller, Function() onTapOfSave) {
  FocusNode _remarksFocusNode = FocusNode();
  controller.changedDate.value = DateTime.now();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        insetPadding: const EdgeInsets.all(10),
        title: popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Update Status'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFieldLabel('SysDoc Id'),
                              buildExpansionTextFields(
                                  controller: controller.sysDocId.value,
                                  onTap: () {},
                                  disableSuffix: true),
                            ],
                          ),
                          //  CommonTextField.textfield(
                          //     suffixicon: false,
                          //     readonly: false,
                          //     keyboardtype: TextInputType.text,
                          //     label: "SysDoc ID",
                          //     controller: controller.sysDocId.value,
                          //     ontap: () {}),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFieldLabel('Voucher Id'),
                              buildExpansionTextFields(
                                  controller: controller.voucherId.value,
                                  onTap: () {},
                                  disableSuffix: true),
                            ],
                          ),
                          // CommonTextField.textfield(
                          //     suffixicon: false,
                          //     readonly: false,
                          //     keyboardtype: TextInputType.text,
                          //     label: "Voucher ID",
                          //     controller: controller.voucherId.value,
                          //     ontap: () {}),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFieldLabel('Status'),
                              buildExpansionTextFields(
                                controller: controller.statusCode.value,
                                onTap: ontapOfStatus,
                                isDropdown: true,
                              ),
                            ],
                          ),
                          //  CommonTextField.textfield(
                          //     suffixicon: true,
                          //     readonly: true,
                          //     keyboardtype: TextInputType.text,
                          //     label: "Status",
                          //     controller: controller.statusCode.value,
                          //     icon: Icons.arrow_drop_down_outlined,
                          //     ontap: ontapOfStatus),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildExpansionTextFields(
                              controller: controller.statusName.value,
                              onTap: () {},
                              disableSuffix: true),
                          //  CommonTextField.textfield(
                          //     suffixicon: false,
                          //     readonly: false,
                          //     keyboardtype: TextInputType.text,
                          //     label: "",
                          //     controller: controller.statusName.value,
                          //     ontap: () {}),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => buildTextFieldLabel(
                                    controller.statusRef1Name.value),
                              ),
                              buildExpansionTextFields(
                                  controller:
                                      controller.statusRef1Controller.value,
                                  onTap: () {},
                                  isReadOnly: false,
                                  // isDropdown: true,
                                  disableSuffix: true),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => buildTextFieldLabel(
                                    controller.statusRef2Name.value),
                              ),
                              buildExpansionTextFields(
                                  controller:
                                      controller.statusRef2Controller.value,
                                  onTap: () {},
                                  isReadOnly: false,
                                  // isDropdown: true,
                                  disableSuffix: true),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextFieldLabel('Actual Date'),
                              buildExpansionTextFields(
                                  controller: TextEditingController(
                                      text: controller.actualDate.value ==
                                                  null ||
                                              controller.actualDate.value == ''
                                          ? ""
                                          : "${DateFormatter.dateFormat.format(controller.actualDate.value)}"),
                                  onTap: () async {
                                    controller.changedDate.value =
                                        DateTime.now();
                                    await controller.selectPackageDate(
                                      context,
                                      controller.changedDate.value,
                                    );
                                    controller.actualDate.value =
                                        controller.changedDate.value;
                                  }),
                            ],
                          ),
                          // CommonTextField.textfield(
                          //     suffixicon: true,
                          //     readonly: true,
                          //     keyboardtype: TextInputType.text,
                          //     label: "Actual Date",
                          //     controller: TextEditingController(
                          //         text: controller.actualDate.value == null ||
                          //                 controller.actualDate.value == ''
                          //             ? ""
                          //             : "${DateFormatter.dateFormat.format(controller.actualDate.value)}"),
                          //     icon: Icons.calendar_month_outlined,
                          //     ontap: () async {
                          //       controller.changedDate.value = DateTime.now();
                          //       await controller.selectPackageDate(
                          //         context,
                          //         controller.changedDate.value,
                          //       );
                          //       controller.actualDate.value =
                          //           controller.changedDate.value;
                          //     }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildExpansionTextFields(
                            controller: TextEditingController(
                                text: controller.actualDate.value == null ||
                                        controller.actualDate.value == ''
                                    ? ""
                                    : "${DateFormatter.dateFormatTime.format(DateTime(controller.actualDate.value.year, controller.actualDate.value.month, controller.actualDate.value.day, controller.actualtime.value.hour, controller.actualtime.value.minute))}"),
                            onTap: () async {
                              final TimeOfDay? time =
                                  // await controller.selectPackageTime(
                                  //     context, controller.actualtime.value);

                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.dial,
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                    ),
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      ),
                                    ),
                                  );
                                },
                              );
                              log(controller.actualtime.value.toString());
                              controller.actualtime.value =
                                  time ?? controller.actualtime.value;
                            },
                            // disableSuffix: true,
                            isTime: true,
                          ),
                          // CommonTextField.textfield(
                          //     suffixicon: true,
                          //     readonly: true,
                          //     keyboardtype: TextInputType.text,
                          //     label: "",
                          //     controller: TextEditingController(
                          //         text: controller.actualDate.value == null ||
                          //                 controller.actualDate.value == ''
                          //             ? ""
                          //             : "${DateFormatter.dateFormatTime.format(DateTime(controller.actualDate.value.year, controller.actualDate.value.month, controller.actualDate.value.day, controller.actualtime.value.hour, controller.actualtime.value.minute))}"),
                          //     ontap: () async {
                          //       final TimeOfDay? time =
                          //           // await controller.selectPackageTime(
                          //           //     context, controller.actualtime.value);

                          //           await showTimePicker(
                          //         context: context,
                          //         initialTime: TimeOfDay.now(),
                          //         initialEntryMode: TimePickerEntryMode.dial,
                          //         builder:
                          //             (BuildContext context, Widget? child) {
                          //           return Theme(
                          //             data: Theme.of(context).copyWith(
                          //               materialTapTargetSize:
                          //                   MaterialTapTargetSize.padded,
                          //             ),
                          //             child: Directionality(
                          //               textDirection: TextDirection.ltr,
                          //               child: MediaQuery(
                          //                 data: MediaQuery.of(context).copyWith(
                          //                   alwaysUse24HourFormat: false,
                          //                 ),
                          //                 child: child!,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //       log(controller.actualtime.value.toString());
                          //       controller.actualtime.value =
                          //           time ?? controller.actualtime.value;
                          //     },
                          //     icon: Icons.timer_outlined),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFieldLabel('Ref Date'),
                    buildExpansionTextFields(
                      controller: TextEditingController(
                          text: controller.refDate.value == null ||
                                  controller.refDate.value == ''
                              ? ""
                              : "${DateFormatter.dateFormat.format(controller.refDate.value)}"),
                      onTap: () async {
                        controller.changedDate.value = DateTime.now();
                        await controller.selectPackageDate(
                          context,
                          controller.changedDate.value,
                        );
                        controller.refDate.value = controller.changedDate.value;
                      },
                    ),

                    // CommonTextField.textfield(
                    //     suffixicon: true,
                    //     readonly: true,
                    //     keyboardtype: TextInputType.text,
                    //     label: "Ref Date",
                    //     controller: TextEditingController(
                    //         text: controller.refDate.value == null ||
                    //                 controller.refDate.value == ''
                    //             ? ""
                    //             : "${DateFormatter.dateFormat.format(controller.refDate.value)}"),
                    //     ontap: () async {
                    //       controller.changedDate.value = DateTime.now();
                    //       await controller.selectPackageDate(
                    //         context,
                    //         controller.changedDate.value,
                    //       );
                    //       controller.refDate.value =
                    //           controller.changedDate.value;
                    //     },
                    //     icon: Icons.calendar_month_outlined),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextFieldLabel('Remarks'),
                    TextField(
                      style:
                          TextStyle(fontSize: 12, color: AppColors.mutedColor),
                      onChanged: (value) {},
                      controller: controller.remarks.value,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.lightGrey.withOpacity(0.6),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.mutedColor,
                            width: 0.1,
                          ),
                        ),
                        // labelText: "Remarks",
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                      ),
                      autofocus: false,
                      focusNode: _remarksFocusNode,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ],
                )),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: onTapOfSave,
                  child:
                      Text('Save', style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget buildTextFieldLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: AppColors.mutedColor,
        fontSize: 12,
      ),
    ),
  );
}
