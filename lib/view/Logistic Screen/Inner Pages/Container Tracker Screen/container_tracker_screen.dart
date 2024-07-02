import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Approval%20Controller/approval_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';
import 'package:axolon_erp/model/get_Packing_List_Details_Model.dart';
import 'package:axolon_erp/model/get_action_status_combo_list_model.dart';
import 'package:axolon_erp/model/get_action_status_log_list_model.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Theme/color_helper.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/filter_dilog_content.dart';
import 'package:axolon_erp/view/Logistic%20Screen/logistics_screen.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/show_attachment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ContainerTrackerScreen extends StatefulWidget {
  ContainerTrackerScreen({super.key});

  @override
  State<ContainerTrackerScreen> createState() => _ContainerTrackerScreenState();
}

class _ContainerTrackerScreenState extends State<ContainerTrackerScreen> {
  bool isExpanded = false; // Variable to track the state of the ExpansionTile

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded; // Toggle the state
    });
  }

  GlobalKey<FormState>? listKey = GlobalKey<FormState>();

  final containerTrackerController = Get.put(ContainerTrackerController());

  final approvalController = Get.put(ApprovalController());

  var selectedValue;

  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bottomSpace = 16;
    return GestureDetector(
      onTap: () {
        // Unfocus the text field when tapping outside of it
        // FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Container Tracker'),
            actions: [
              IconButton(
                onPressed: () {
                  if (containerTrackerController.isPackingListLoading.value) {
                    return;
                  }
                  containerTrackerController.getPackingListDetails();
                },
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  Obx(() => CommonFilterControls.buildDateRageDropdown(
                        context,
                        isClosing: false,
                        dropValue: DateRangeSelector.dateRange[
                            containerTrackerController.dateIndex.value],
                        onChanged: (value) async {
                          selectedValue = value;
                          await containerTrackerController.selectDateRange(
                              selectedValue.value,
                              DateRangeSelector.dateRange
                                  .indexOf(selectedValue));
                          containerTrackerController.getPackingListDetails();
                        },
                        fromController: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(containerTrackerController.fromDate.value)
                              .toString(),
                        ),
                        toController: TextEditingController(
                          text: DateFormatter.dateFormat
                              .format(containerTrackerController.toDate.value)
                              .toString(),
                        ),
                        onTapFrom: () {
                          containerTrackerController.selectDate(context, true);
                        },
                        onTapTo: () {
                          containerTrackerController.selectDate(context, false);
                        },
                        isFromEnable:
                            containerTrackerController.isFromDate.value,
                        isToEnable: containerTrackerController.isToDate.value,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  // GFAccordion(
                  //     margin: EdgeInsets.zero,
                  //     title: 'Filter',
                  //     contentBackgroundColor: Colors.transparent,
                  //     titleBorderRadius: BorderRadius.circular(5),
                  //     expandedTitleBackgroundColor:
                  //         AppColors.lightGrey.withOpacity(0.5),
                  //     collapsedTitleBackgroundColor:
                  //         AppColors.lightGrey.withOpacity(0.5),
                  //     collapsedIcon: const Icon(Icons.keyboard_arrow_down,
                  //         color: AppColors.mutedColor),
                  //     expandedIcon: const Icon(
                  //       Icons.keyboard_arrow_up,
                  //       color: AppColors.mutedColor,
                  //     ),
                  //     textStyle: const TextStyle(
                  //       color: AppColors.mutedColor,
                  //     ),
                  //     contentPadding: EdgeInsets.zero,
                  //     contentChild: _buildFilterBottomsheet(context)),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => buildExpansionTextFields(
                              controller: containerTrackerController
                                  .searchController.value,
                              onTap: () {},
                              isReadOnly: false,
                              onChanged: (value) {},
                              focus: _focusNode,
                              disableSuffix: true,
                              hint: 'Search',
                              isSearch: true),
                        ),
                        // child: CommonTextField.textfield(
                        //   suffixicon: false,
                        //   readonly: false,
                        //   focus: _focusNode,
                        //   keyboardtype: TextInputType.text,
                        //   onchanged: (value) {
                        //     containerTrackerController
                        //         .searchPackingLIst(value);
                        //   },
                        //   label: "Search",
                        //   // controller: TextEditingController(),
                        // ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          containerTrackerController.searchPackingLIst(
                              containerTrackerController
                                  .searchController.value.text
                                  .trim());
                        },
                        child: Card(
                            color: AppColors.lightGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.search,
                                color: AppColors.mutedColor,
                              ),
                            )),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     // FocusScope.of(context).unfocus();
                      //     // containerTrackerController.searchPackingLIst(
                      //     //     containerTrackerController
                      //     //         .searchController.value.text
                      //     //         .trim());
                      //     toggleExpansion();
                      //     listKey!.currentState?.reset();
                      //   },
                      //   child: Card(
                      //       color: AppColors.lightGrey,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(8)),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(5),
                      //         child: Icon(
                      //           Icons.expand_circle_down_outlined,
                      //           color: AppColors.mutedColor,
                      //         ),
                      //       )),
                      // ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          // containerTrackerController.getPackingListDetails();
                          containerTrackerController.clearSearch();
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        left: 18,
                                        right: 18,
                                        top: 15,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Scrollbar(
                                        thumbVisibility: true,
                                        interactive: true,
                                        child: SingleChildScrollView(
                                            child: _buildFilterBottomsheet(
                                                context))),
                                  ));
                        },
                        child: Card(
                            color: AppColors.lightGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SvgPicture.asset(
                                AppIcons.filter,
                                width: 22,
                                height: 22,
                                color: AppColors.mutedColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            '${containerTrackerController.filterSearchPackingList.length} Results',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.mutedColor,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Show Closed',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.mutedColor,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: Obx(() => CupertinoSwitch(
                              activeColor: AppColors.primary,
                              value: containerTrackerController
                                  .showClosedToggle.value,
                              onChanged: (value) {
                                containerTrackerController.toggleClosed();
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => containerTrackerController.isPackingListLoading.value
                        ? popShimmer()
                        : containerTrackerController.packingList.isEmpty
                            ? const Text("No Data")
                            : ListView.separated(
                                shrinkWrap: true,
                                key: listKey,
                                itemCount: containerTrackerController
                                    .filterSearchPackingList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var item = containerTrackerController
                                      .filterSearchPackingList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Unfocus the text field when tapping outside of it
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      shadowColor: Colors.black,
                                      elevation: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: item.hexColorCode ==
                                                          null ||
                                                      item.hexColorCode == ''
                                                  ? Colors.white
                                                  : Color(int.parse(
                                                          '${item.hexColorCode!.split('#')[1]}',
                                                          radix: 16) +
                                                      0xFF000000), // Color of the bottom border
                                              offset: const Offset(0,
                                                  3), // Position of the shadow
                                              blurRadius:
                                                  0, // Spread of the shadow
                                            ),
                                          ],
                                        ),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: IgnorePointer(
                                            ignoring: false,
                                            child: ExpansionTile(
                                              // initiallyExpanded: isExpanded,

                                              tilePadding: EdgeInsets.zero,
                                              // trailing: const SizedBox(
                                              //   width: 0,
                                              // ),
                                              textColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: InkWell(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Null;
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 0, 0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${item.docId ?? ''} ',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .primary),
                                                              ),
                                                              Text(
                                                                ": ${item.voucherId ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .primary),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  containerTrackerController
                                                                      .sysDocId
                                                                      .value
                                                                      .text = item
                                                                          .docId ??
                                                                      '';
                                                                  containerTrackerController
                                                                      .voucherId
                                                                      .value
                                                                      .text = item
                                                                          .voucherId ??
                                                                      '';
                                                                  containerTrackerController
                                                                      .statusCode
                                                                      .value
                                                                      .text = item
                                                                          .actionstatuslog ??
                                                                      '';
                                                                  containerTrackerController
                                                                      .statusName
                                                                      .value
                                                                      .text = containerTrackerController
                                                                          .getActionStatusCombo(item.actionstatuslog ??
                                                                              '')
                                                                          .name ??
                                                                      '';
                                                                  containerTrackerController
                                                                      .statusRef1Name
                                                                      .value = containerTrackerController.getActionStatusCombo(item.actionstatuslog ?? '').ref1Name ==
                                                                              null ||
                                                                          containerTrackerController.getActionStatusCombo(item.actionstatuslog ?? '').ref1Name ==
                                                                              ''
                                                                      ? 'Ref 1'
                                                                      : containerTrackerController
                                                                          .getActionStatusCombo(item.actionstatuslog ??
                                                                              '')
                                                                          .ref1Name!;
                                                                  containerTrackerController
                                                                      .statusRef2Name
                                                                      .value = containerTrackerController.getActionStatusCombo(item.actionstatuslog ?? '').ref2Name ==
                                                                              null ||
                                                                          containerTrackerController.getActionStatusCombo(item.actionstatuslog ?? '').ref2Name ==
                                                                              ''
                                                                      ? 'Ref 2'
                                                                      : containerTrackerController
                                                                          .getActionStatusCombo(item.actionstatuslog ??
                                                                              '')
                                                                          .ref2Name!;
                                                                  containerTrackerController
                                                                          .actualDate
                                                                          .value =
                                                                      DateTime
                                                                          .now();
                                                                  containerTrackerController
                                                                          .refDate
                                                                          .value =
                                                                      DateTime
                                                                          .now();
                                                                  updateActionStatus(
                                                                    context,
                                                                    () async {
                                                                      await containerTrackerController
                                                                          .getActionStatusComboList();

                                                                      await showStatusList(
                                                                          context:
                                                                              context,
                                                                          list: containerTrackerController
                                                                              .actionStatusChangingList
                                                                              .value,
                                                                          controller:
                                                                              containerTrackerController);

                                                                      containerTrackerController.statusCode.value.text = containerTrackerController
                                                                          .selectedStatusValue
                                                                          .value
                                                                          .code
                                                                          .toString();
                                                                      containerTrackerController.statusName.value.text = containerTrackerController
                                                                          .selectedStatusValue
                                                                          .value
                                                                          .name
                                                                          .toString();
                                                                      containerTrackerController
                                                                          .statusRef1Name
                                                                          .value = containerTrackerController.selectedStatusValue.value.ref1Name == null ||
                                                                              containerTrackerController.selectedStatusValue.value.ref1Name ==
                                                                                  ''
                                                                          ? 'Ref 1'
                                                                          : containerTrackerController
                                                                              .selectedStatusValue
                                                                              .value
                                                                              .ref1Name!;
                                                                      containerTrackerController
                                                                          .statusRef2Name
                                                                          .value = containerTrackerController.selectedStatusValue.value.ref2Name == null ||
                                                                              containerTrackerController.selectedStatusValue.value.ref2Name ==
                                                                                  ''
                                                                          ? 'Ref 2'
                                                                          : containerTrackerController
                                                                              .selectedStatusValue
                                                                              .value
                                                                              .ref2Name!;
                                                                    },
                                                                    containerTrackerController,
                                                                    () async {
                                                                      await containerTrackerController.createActionLogStatus(
                                                                          index,
                                                                          item);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: item.hexColorCode ==
                                                                                null ||
                                                                            item.hexColorCode ==
                                                                                ''
                                                                        ? Colors
                                                                            .transparent
                                                                        : Color(int.parse('${item.hexColorCode!.split('#')[1]}',
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                  ),
                                                                  child: Text(
                                                                    item.actionstatuslog ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: item.hexColorCode == null || item.hexColorCode == ''
                                                                            ? Colors
                                                                                .black
                                                                            : ColorHelper.getContrastingTextColorFromHex(item
                                                                                .hexColorCode!),
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                                //  AutoSizeText(
                                                                //     "  ${item.actionstatuslog ?? ''}",
                                                                //     // product.deliveryDate,
                                                                //     maxFontSize:
                                                                //         10,
                                                                //     minFontSize:
                                                                //         8,
                                                                //     style:
                                                                //         TextStyle(
                                                                //       color: item.hexColorCode == null ||
                                                                //               item.hexColorCode ==
                                                                //                   ''
                                                                //           ? Colors
                                                                //               .white
                                                                //           : Color(int.parse('${item.hexColorCode!.split('#')[1]}', radix: 16) +
                                                                //               0xFF000000),
                                                                //     )),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            item.transactionDate ==
                                                                        null ||
                                                                    item.transactionDate ==
                                                                        ''
                                                                ? ""
                                                                : "${DateFormatter.dateFormat.format(item.transactionDate!)}",
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                color: AppColors
                                                                    .mutedColor),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      _buildTileText(
                                                          text:
                                                              item.vendorName ??
                                                                  '',
                                                          title: 'Vendor'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      _buildTileText(
                                                          text: item.port ?? '',
                                                          title: 'Port'),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          if (item.containerNumber !=
                                                                  null &&
                                                              item.containerNumber !=
                                                                  '') {
                                                            containerTrackerController
                                                                .launchInBrowser(
                                                                    item);
                                                          } else {
                                                            SnackbarServices
                                                                .errorSnackbar(
                                                                    "No Container Number");
                                                          }
                                                        },
                                                        child: _buildTileText(
                                                            text:
                                                                item.containerNumber ??
                                                                    '',
                                                            title:
                                                                'Container No.'),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      _buildTileText(
                                                          text:
                                                              item.itemCategory ??
                                                                  '',
                                                          title:
                                                              'ItemCategory'),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                _buildExpansionTextFields(
                                                                    controller:
                                                                        TextEditingController(
                                                                      text:
                                                                          "ETA : ${item.eta == null || item.eta == '' ? "" : DateFormatter.dateFormat.format(DateTime.parse(item.eta))}",
                                                                    ),
                                                                    onTap:
                                                                        () async {
                                                                      var date =
                                                                          await dateUpdateAlertDialog(
                                                                        context,
                                                                        "ETA",
                                                                        item.eta ==
                                                                                null
                                                                            ? ''
                                                                            : DateTime.parse(item.eta),
                                                                        containerTrackerController,
                                                                        () async {
                                                                          await containerTrackerController.updateDate(
                                                                              item.docId.toString(),
                                                                              item.voucherId.toString(),
                                                                              "ETADate");
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    }),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              // InkWell(
                                                              //   onTap: () {
                                                              //     FocusScope.of(
                                                              //             context)
                                                              //         .unfocus();
                                                              //     if (item.containerNumber !=
                                                              //             null &&
                                                              //         item.containerNumber !=
                                                              //             '') {
                                                              //       containerTrackerController.launchInBrowser(
                                                              //           item.containerNumber ??
                                                              //               "");
                                                              //     } else {
                                                              //       SnackbarServices
                                                              //           .errorSnackbar(
                                                              //               "No Container Number");
                                                              //     }
                                                              //   },
                                                              //   child:
                                                              //       SvgPicture
                                                              //           .asset(
                                                              //     AppIcons
                                                              //         .track,
                                                              //     color: AppColors
                                                              //         .mutedColor,
                                                              //     height: 20,
                                                              //     width: 20,
                                                              //   ),
                                                              // ),
                                                              // SizedBox(
                                                              //   width: 14,
                                                              // ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    ShowAttachment
                                                                        .showAttachments(
                                                                      context,
                                                                      item.docId
                                                                          .toString(),
                                                                      item.voucherId
                                                                          .toString(),
                                                                    );
                                                                  },
                                                                  child: containerTrackerController
                                                                              .isAttachmentListLoading
                                                                              .value &&
                                                                          containerTrackerController.isAttachmentListLoading.value ==
                                                                              index
                                                                      ? buildPreviewLoader()
                                                                      : Icon(
                                                                          Icons
                                                                              .photo_library_outlined,
                                                                          color:
                                                                              AppColors.mutedColor,
                                                                          size:
                                                                              20,
                                                                        )),
                                                              SizedBox(
                                                                width: 14,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  approvalController
                                                                      .previewApproval(
                                                                    context,
                                                                    index:
                                                                        index,
                                                                    sysDoc: item
                                                                        .docId
                                                                        .toString(),
                                                                    voucher: item
                                                                        .voucherId
                                                                        .toString(),
                                                                    objectId: SysdocType
                                                                        .PackingList
                                                                        .value,
                                                                  );
                                                                },
                                                                child: Obx(
                                                                  () => approvalController
                                                                              .isPreviewLoading
                                                                              .value &&
                                                                          approvalController.selectedApprovalIndex.value ==
                                                                              index
                                                                      ? buildPreviewLoader()
                                                                      : SvgPicture
                                                                          .asset(
                                                                          AppIcons
                                                                              .details,
                                                                          color:
                                                                              AppColors.mutedColor,
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                        ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 14,
                                                              ),
                                                              InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    containerTrackerController
                                                                        .getActionStatusLogList(
                                                                            index);
                                                                    showTimelineAlertDialog(
                                                                      context,
                                                                    );
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                      AppIcons
                                                                          .log,
                                                                      color: AppColors
                                                                          .mutedColor,
                                                                      height:
                                                                          20,
                                                                      width:
                                                                          20))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 0, 12, 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Divider(
                                                            thickness: 1.5,
                                                            color: AppColors
                                                                .lightGrey,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Bol No. : ${item.bolNumber ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: AppColors
                                                                        .mutedColor),
                                                              ),
                                                              Text(
                                                                "L Port : ${item.loadingPort ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: AppColors
                                                                        .mutedColor),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),

                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Ref 1 : ${item.reference1 ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: AppColors
                                                                        .mutedColor),
                                                              ),
                                                              Text(
                                                                "Ref 2 : ${item.reference2 ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: AppColors
                                                                        .mutedColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "ATD : ${item.atd == null || item.atd == '' ? "" : DateFormatter.dateFormat.format(DateTime.parse(item.atd))}",
                                                          //       textAlign:
                                                          //           TextAlign.start,
                                                          //       style: TextStyle(
                                                          //         fontSize: 13,
                                                          //       ),
                                                          //     ),
                                                          //     InkWell(
                                                          //       onTap: () async {
                                                          //         dateUpdateAlertDialog(
                                                          //           context,
                                                          //           "ATD",
                                                          //           item.atd == null
                                                          //               ? ''
                                                          //               : DateTime
                                                          //                   .parse(item
                                                          //                       .atd),
                                                          //           containerTrackerController,
                                                          //           () async {
                                                          //             await containerTrackerController.updateDate(
                                                          //                 item.docId
                                                          //                     .toString(),
                                                          //                 item.voucherId
                                                          //                     .toString(),
                                                          //                 "ATDDate");
                                                          //             Navigator.pop(
                                                          //                 context);
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //       child: Icon(
                                                          //         Icons.edit,
                                                          //         size: 18,
                                                          //         color: AppColors
                                                          //             .primary,
                                                          //       ),
                                                          //     )
                                                          //   ],
                                                          // ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    _buildExpansionTextFields(
                                                                        controller:
                                                                            TextEditingController(
                                                                          text:
                                                                              "ATD : ${item.atd == null || item.atd == '' ? "" : DateFormatter.dateFormat.format(DateTime.parse(item.atd))}",
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          dateUpdateAlertDialog(
                                                                            context,
                                                                            "ATD",
                                                                            item.atd == null
                                                                                ? ''
                                                                                : DateTime.parse(item.atd),
                                                                            containerTrackerController,
                                                                            () async {
                                                                              await containerTrackerController.updateDate(item.docId.toString(), item.voucherId.toString(), "ATDDate");
                                                                              Navigator.pop(context);
                                                                            },
                                                                          );
                                                                        }),
                                                              ),
                                                              // const SizedBox(
                                                              //   width: 8,
                                                              // ),
                                                              // Expanded(
                                                              //   child:

                                                              // ),
                                                            ],
                                                          ),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "ETA : ${item.eta == null || item.eta == '' ? "" : DateFormatter.dateFormat.format(DateTime.parse(item.eta))}",
                                                          //       textAlign:
                                                          //           TextAlign.start,
                                                          //       style: TextStyle(
                                                          //         fontSize: 13,
                                                          //       ),
                                                          //     ),
                                                          //     InkWell(
                                                          //       onTap: () async {
                                                          //         var date =
                                                          //             await dateUpdateAlertDialog(
                                                          //           context,
                                                          //           "ETA",
                                                          //           item.eta == null
                                                          //               ? ''
                                                          //               : DateTime
                                                          //                   .parse(item
                                                          //                       .eta),
                                                          //           containerTrackerController,
                                                          //           () async {
                                                          //             await containerTrackerController.updateDate(
                                                          //                 item.docId
                                                          //                     .toString(),
                                                          //                 item.voucherId
                                                          //                     .toString(),
                                                          //                 "ETADate");
                                                          //             Navigator.pop(
                                                          //                 context);
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //       child: Icon(
                                                          //         Icons.edit,
                                                          //         size: 18,
                                                          //         color: AppColors
                                                          //             .primary,
                                                          //       ),
                                                          //     )
                                                          //   ],
                                                          // ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          _buildExpansionTextFields(
                                                              controller:
                                                                  TextEditingController(
                                                                text:
                                                                    "Free Time Expiry : ${item.freeTimeExpiry == null || item.freeTimeExpiry == '' ? "" : DateFormatter.dateFormat.format(item.freeTimeExpiry ?? DateTime.now())}",
                                                              ),
                                                              onTap: () {
                                                                dateUpdateAlertDialog(
                                                                  context,
                                                                  "Free Time Expiry",
                                                                  item.freeTimeExpiry ==
                                                                          null
                                                                      ? ''
                                                                      : item
                                                                          .freeTimeExpiry,
                                                                  containerTrackerController,
                                                                  () async {
                                                                    await containerTrackerController.updateDate(
                                                                        item.docId
                                                                            .toString(),
                                                                        item.voucherId
                                                                            .toString(),
                                                                        "FreeTimeExpiryDate");
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                );
                                                              }),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "Free Time Expiry : ${item.freeTimeExpiry == null || item.freeTimeExpiry == '' ? "" : DateFormatter.dateFormat.format(item.freeTimeExpiry ?? DateTime.now())}",
                                                          //       textAlign:
                                                          //           TextAlign.start,
                                                          //       style: TextStyle(
                                                          //         fontSize: 13,
                                                          //       ),
                                                          //     ),
                                                          //     InkWell(
                                                          //       onTap: () {
                                                          //         dateUpdateAlertDialog(
                                                          //           context,
                                                          //           "Free Time Expiry",
                                                          //           item.freeTimeExpiry ==
                                                          //                   null
                                                          //               ? ''
                                                          //               : item
                                                          //                   .freeTimeExpiry,
                                                          //           containerTrackerController,
                                                          //           () async {
                                                          //             await containerTrackerController.updateDate(
                                                          //                 item.docId
                                                          //                     .toString(),
                                                          //                 item.voucherId
                                                          //                     .toString(),
                                                          //                 "FreeTimeExpiryDate");
                                                          //             Navigator.pop(
                                                          //                 context);
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //       child: Icon(
                                                          //         Icons.edit,
                                                          //         size: 18,
                                                          //         color: AppColors
                                                          //             .primary,
                                                          //       ),
                                                          //     )
                                                          //   ],
                                                          // ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          _buildExpansionTextFields(
                                                              controller:
                                                                  TextEditingController(
                                                                text:
                                                                    "Shipper Name : ${item.shipperName ?? ''}",
                                                              ),
                                                              onTap: () async {
                                                                containerTrackerController
                                                                    .shipperName
                                                                    .value
                                                                    .text = item
                                                                        .shipperName ??
                                                                    '';
                                                                containerTrackerController
                                                                    .getShipperList();

                                                                await showShipperList(
                                                                  context:
                                                                      context,
                                                                  item: item,
                                                                  controller:
                                                                      containerTrackerController,
                                                                );
                                                                containerTrackerController
                                                                    .shipperName
                                                                    .value
                                                                    .text = containerTrackerController
                                                                        .selectedShipperValue
                                                                        .value
                                                                        .name ??
                                                                    '';
                                                                log("}");
                                                                // updateShipper(
                                                                //   context,
                                                                //   item.shipperName ??
                                                                //       '',
                                                                //   () async {
                                                                //     // containerTrackerController
                                                                //     //     .getShipperList();

                                                                //     // await showShipperList(
                                                                //     //   context:
                                                                //     //       context,
                                                                //     //   controller:
                                                                //     //       containerTrackerController,
                                                                //     // );
                                                                //     // containerTrackerController
                                                                //     //     .shipperName
                                                                //     //     .value
                                                                //     //     .text = containerTrackerController
                                                                //     //         .selectedShipperValue
                                                                //     //         .value
                                                                //     //         .name ??
                                                                //     //     '';
                                                                //   },
                                                                //   containerTrackerController,
                                                                //   () {
                                                                //     // containerTrackerController.updateShipper(
                                                                //     //     item.docId
                                                                //     //         .toString(),
                                                                //     //     item.voucherId
                                                                //     //         .toString(),
                                                                //     //     containerTrackerController
                                                                //     //         .selectedShipperValue
                                                                //     //         .value
                                                                //     //         .code
                                                                //     //         .toString());
                                                                //     // Navigator.pop(
                                                                //     //     context);
                                                                //   },
                                                                // );
                                                              }),
                                                          // Row(
                                                          //   mainAxisAlignment:
                                                          //       MainAxisAlignment
                                                          //           .spaceBetween,
                                                          //   children: [
                                                          //     Text(
                                                          //       "Shipper Name : ${item.shipperName ?? ''}",
                                                          //       textAlign:
                                                          //           TextAlign.start,
                                                          //       style: TextStyle(
                                                          //         fontSize: 13,
                                                          //       ),
                                                          //     ),
                                                          //     InkWell(
                                                          //       onTap: () {
                                                          //         containerTrackerController
                                                          //                 .shipperName
                                                          //                 .value
                                                          //                 .text =
                                                          //             item.shipperName ??
                                                          //                 '';
                                                          //         log("}");
                                                          //         updateShipper(
                                                          //           context,
                                                          //           item.shipperName ??
                                                          //               '',
                                                          //           () async {
                                                          //             containerTrackerController
                                                          //                 .getShipperList();

                                                          //             await showShipperList(
                                                          //               context:
                                                          //                   context,
                                                          //               controller:
                                                          //                   containerTrackerController,
                                                          //             );
                                                          //             containerTrackerController
                                                          //                 .shipperName
                                                          //                 .value
                                                          //                 .text = containerTrackerController
                                                          //                     .selectedShipperValue
                                                          //                     .value
                                                          //                     .name ??
                                                          //                 '';
                                                          //           },
                                                          //           containerTrackerController,
                                                          //           () {
                                                          //             containerTrackerController.updateShipper(
                                                          //                 item.docId
                                                          //                     .toString(),
                                                          //                 item.voucherId
                                                          //                     .toString(),
                                                          //                 containerTrackerController
                                                          //                     .selectedShipperValue
                                                          //                     .value
                                                          //                     .code
                                                          //                     .toString());
                                                          //             Navigator.pop(
                                                          //                 context);
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //       child: Icon(
                                                          //         Icons.edit,
                                                          //         size: 18,
                                                          //         color: AppColors
                                                          //             .primary,
                                                          //       ),
                                                          //     )
                                                          //   ],
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 8,
                                ),
                              ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Row _buildTileText({required String title, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title : ",
            textAlign: TextAlign.start,
            maxLines: 1,
            style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        Expanded(
          child: Text(text,
              textAlign: TextAlign.start,
              // maxLines: 2,
              style: TextStyle(fontSize: 13, color: AppColors.mutedColor)),
        ),
      ],
    );
  }

  Column _buildFilterBottomsheet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        popupTitle(
            onTap: () {
              Navigator.pop(context);
            },
            title: 'Filter'),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Status'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller: containerTrackerController
                          .statusFilterController.value,
                      onTap: () {
                        _buildFilterDialog(context,
                            filterId: containerTrackerController.statusFilterId,
                            filterList:
                                containerTrackerController.statusFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Vendor'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller: containerTrackerController
                          .vendorFilterController.value,
                      onTap: () {
                        _buildFilterDialog(context,
                            filterId: containerTrackerController.vendorFilterId,
                            filterList:
                                containerTrackerController.vendorFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Port'),
                  buildExpansionTextFields(
                    controller:
                        containerTrackerController.portFilterController.value,
                    onTap: () {
                      containerTrackerController.portFilterController.value
                          .selectAll();
                    },
                    // isDropdown: true,
                    isReadOnly: false,
                    disableSuffix: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextFieldLabel('Container No'),
                  buildExpansionTextFields(
                    controller: containerTrackerController
                        .containerNoFilterController.value,
                    onTap: () {
                      containerTrackerController
                          .containerNoFilterController.value
                          .selectAll();
                    },
                    // isDropdown: true,
                    isReadOnly: false,
                    disableSuffix: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: AppColors.mutedBlueColor,
                ),
                onPressed: () {
                  containerTrackerController.clearFilter();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    containerTrackerController.filterPackingSearchList();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply')),
            ),
          ],
        )
      ],
    );
  }

  Future<dynamic> _buildFilterDialog(BuildContext context,
      {required String filterId, required List<dynamic> filterList}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            title: popupTitle(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Select $filterId'),
            content:
                FilterDialogContent(filterId: filterId, filterList: filterList),
          );
        });
  }

  ClipRRect _buildExpansionTextFields(
      {required TextEditingController controller, required Function() onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12, color: AppColors.mutedColor),
        maxLines: 1,
        onTap: onTap,
        readOnly: true,
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          filled: true,
          // enabled: false,
          fillColor: AppColors.lightGrey.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffix: SvgPicture.asset(
            AppIcons.edit,
            color: AppColors.mutedColor,
            height: 15,
            width: 15,
          ),
        ),
      ),
    );
  }
}
