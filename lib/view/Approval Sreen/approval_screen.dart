import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Approval%20Controller/approval_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Approvals%20Model/showApprovalDetailsModel.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/Approval%20Sreen/components.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ApprovalScreen extends StatefulWidget {
  ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final approvalController = Get.put(ApprovalController());

  final homeController = Get.put(HomeController());

  final GlobalKey<AnimatedListState> _approvalListkey = GlobalKey();
  FocusNode _remarksFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   approvalController.getApprovalCategories();
    // });
    return WillPopScope(
      onWillPop: () async {
        await homeController.removeFromBottomList();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approvals'),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: SizedBox(
                    height: 25,
                    child: SvgPicture.asset(
                      AppIcons.file,
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: () {
                    // Get.to(ConnectionScreen());
                  },
                ),
                Positioned(
                    left: 20,
                    top: 6,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(2),
                      child: Obx(() => AutoSizeText(
                            '${approvalController.totalCount.value}',
                            maxFontSize: 10,
                            minFontSize: 7,
                            style: TextStyle(color: AppColors.white),
                          )),
                    ))
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LimitedBox(
                maxHeight: 45,
                child: Obx(
                  () => approvalController.isCategoryLoading.value
                      ? _buildCategoryShimmer()
                      : GetBuilder<ApprovalController>(builder: (controller) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              var category = controller.categories[index];
                              return Obx(
                                () => Stack(
                                  children: [
                                    Card(
                                      elevation: 5,
                                      color: index ==
                                              controller
                                                  .selectedCategoryIndex.value
                                          ? AppColors.primary
                                          : AppColors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: InkWell(
                                        onTap: () {
                                          controller.getApprovalList(
                                              category.approvalId, index);
                                        },
                                        child: Container(
                                          // color: AppColors.primary,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                AppIcons.approval_badge,
                                                height: 20,
                                                width: 20,
                                                color: index ==
                                                        controller
                                                            .selectedCategoryIndex
                                                            .value
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                category.approvalName
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: index ==
                                                          controller
                                                              .selectedCategoryIndex
                                                              .value
                                                      ? FontWeight.w500
                                                      : FontWeight.w400,
                                                  color: index ==
                                                          controller
                                                              .selectedCategoryIndex
                                                              .value
                                                      ? AppColors.white
                                                      : AppColors.mutedColor,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.error,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        padding: EdgeInsets.all(3),
                                        child: Center(
                                          child: AutoSizeText(
                                            '${category.taskCount}',
                                            maxFontSize: 10,
                                            minFontSize: 7,
                                            style: TextStyle(
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                          );
                        }),
                ),
              ),
            ),
            Divider(
              height: 2,
              color: AppColors.mutedColor.withOpacity(0.5),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(() => approvalController.isListLoading.value
                    ? _buildMainCardShimmer()
                    : approvalController.approvalList.isEmpty
                        ? Center(child: Text('No Data'))
                        : AnimatedList(
                            physics: BouncingScrollPhysics(),
                            key: _approvalListkey,
                            initialItemCount:
                                approvalController.approvalList.length,
                            itemBuilder: (((context, index, animation) {
                              var approval =
                                  approvalController.approvalList[index];
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  key: UniqueKey(),
                                  sizeFactor: animation,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 3,
                                      child:
                                          _buildTile(context, approval, index)),
                                ),
                              );
                            })),
                          )),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: AppBottomBar(),
      ),
    );
  }

  void removeItem(int index, BuildContext context, approval) {
    AnimatedList.of(context).removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: _buildTile(context, approval, index)),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 600));
  }

  Row _buildDetailRow(String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          '$label - ',
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          maxFontSize: 16,
          minFontSize: 8,
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        Expanded(
          child: AutoSizeText(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            maxFontSize: 16,
            minFontSize: 8,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Shimmer _buildCategoryShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.primary,
      enabled: true,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              color: index == 1 ? AppColors.primary : AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                // color: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.approval_badge,
                      height: 20,
                      width: 20,
                      color: index == 1 ? AppColors.white : AppColors.primary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'PurchaseInvoiceAprooval',
                      style: TextStyle(
                        fontWeight:
                            index == 1 ? FontWeight.w500 : FontWeight.w400,
                        color:
                            index == 1 ? AppColors.white : AppColors.mutedColor,
                      ),
                    ),
                  ],
                )),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
          itemCount: 10),
    );
  }

  Shimmer _buildMainCardShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.mutedBlueColor,
      enabled: true,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        '# DID-0012574',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 20,
                        minFontSize: 8,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      AutoSizeText(
                        '01-03-2022 4:00 AM',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 16,
                        minFontSize: 8,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.mutedColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Party : ',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 16,
                        minFontSize: 8,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      AutoSizeText(
                        'Aabeda Aboobaker',
                        maxFontSize: 20,
                        minFontSize: 8,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'Amount : 1254228.26 AED',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 16,
                        minFontSize: 8,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.mutedColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SvgPicture.asset(
                              AppIcons.preview,
                              color: AppColors.primary,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Description : ',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 16,
                        minFontSize: 8,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: AutoSizeText(
                            'industry. Lorem Ipsum has been the industrys Lorem Ipsum has been the industrys Lorem Ipsum has been the industrys Lorem Ipsum has been the industrys',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            maxFontSize: 16,
                            minFontSize: 8,
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildDetailRow('Created By',
                                'Username on 01-03-2022 11:30 AM'),
                            SizedBox(
                              height: 5,
                            ),
                            _buildDetailRow(
                                'Edited By', 'Username on 01-03-2022 11:30 AM'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppIcons.check,
                          color: AppColors.darkGreen,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppIcons.cancel,
                          color: AppColors.darkRed,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10,
          );
        },
      ),
    );
  }

  Widget _buildTile(BuildContext context, approval, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: approval.voucherId != null
                    ? AutoSizeText(
                        '${approval.sysDocId ?? ''} - # ${approval.voucherId ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 20,
                        minFontSize: 8,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    : Container(),
              ),
              approval.date != null
                  ? AutoSizeText(
                      approval.date != null
                          ? DateFormatter.dateFormatter.format(approval.date)
                          : '',
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 16,
                      minFontSize: 8,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedColor,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          approval.party != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Party : ',
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 16,
                      minFontSize: 8,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                      // width: MediaQuery.of(context).size.width * 0.75,
                      child: AutoSizeText(
                        approval.party ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 14,
                        minFontSize: 12,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: 8,
          ),
          approval.amount != null
              ? AutoSizeText(
                  'Amount : ${approval.amount != null ? InventoryCalculations.formatPrice(approval.amount.toDouble()) : '0.00'}',
                  overflow: TextOverflow.ellipsis,
                  maxFontSize: 16,
                  minFontSize: 8,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedColor,
                  ),
                )
              : Container(),
          SizedBox(
            height: 8,
          ),
          approval.note != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Description : ',
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 16,
                      minFontSize: 8,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: AutoSizeText(
                          approval.note ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          maxFontSize: 16,
                          minFontSize: 8,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: approval.note != null ? 10 : 0,
          ),
          approval.dateCreated != null
              ? _buildDetailRow('Created By',
                  '${approval.createdBy ?? ''} on ${DateFormatter.dateFormatter.format(approval.dateCreated)}')
              : Container(),
          SizedBox(
            height: 5,
          ),
          approval.dateUpdated != null
              ? _buildDetailRow('Edited By',
                  '${approval.updatedBy ?? ''} on ${DateFormatter.dateFormatter.format(approval.dateUpdated)}')
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  bool isDetailsAvailble =
                      await approvalController.getTaskDetails(
                    index: index,
                    objectType: approval.objectType,
                    objectID: approval.objectId,
                    voucherId: approval.voucherId,
                    sysDocId: approval.sysDocId,
                  );
                  if (isDetailsAvailble) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          title: popupTitle(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              title: 'Approval History'),
                          content: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: timelineApprovaalHistory(
                                  context: context,
                                  list:
                                      approvalController.activeTaskDetails.value
                                  // approvalHistory:
                                  //     approvalController.taskDetails,
                                  // readmore: approvalController.readMore.value,
                                  // onTapOfReadMore:
                                  //     approvalController.readMoreText()
                                  )
                             
                              ),
                        );
                      },
                    );
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Obx(() => approvalController
                                .isTaskDetailsLoading.value &&
                            approvalController.selectedApprovalIndex.value ==
                                index
                        ? _buildPreviewLoader()
                        : SvgPicture.asset(
                            AppIcons.history,
                            color: AppColors.primary,
                            width: 20,
                            height: 20,
                          )),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  approvalController.previewApproval(context,
                      index: index,
                      sysDoc: approval.sysDocId ?? '',
                      voucher: approval.voucherId ?? '',
                      objectId: approval.objectId);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Obx(() => approvalController
                                .isPreviewLoading.value &&
                            approvalController.selectedApprovalIndex.value ==
                                index
                        ? _buildPreviewLoader()
                        : SvgPicture.asset(
                            AppIcons.preview,
                            color: AppColors.primary,
                            width: 20,
                            height: 20,
                          )),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  if (approvalController.dontshow == false) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 25, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.mutedColor),
                              onChanged: (value) {
                                if (approvalController
                                    .remarkscontrol.value.text.isEmpty) {
                                  approvalController.remarkscontrol.value.text =
                                      "";
                                }
                              },
                              decoration: InputDecoration(
                                isCollapsed: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.mutedColor,
                                    width: 0.1,
                                  ),
                                ),
                                labelText: "Remarks",
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary,
                                ),
                              ),
                              autofocus: false,
                              onTap: () {
                                approvalController.remarkscontrol.value
                                    .selectAll();
                              },
                              focusNode: _remarksFocusNode,
                              maxLines: 6,
                              controller:
                                  approvalController.remarkscontrol.value,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () =>
                                  approvalController.dontShowthisAgain(),
                              splashColor: AppColors.lightGrey,
                              splashFactory: InkRipple.splashFactory,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: AppColors.mutedColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Obx(() => Icon(
                                            Icons.check,
                                            size: 10,
                                            color: approvalController
                                                    .dontshow.value
                                                ? AppColors.primary
                                                : Colors.transparent,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Don't show this again",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      // bool isApproved =
                                      //     await approvalController.approveTask(
                                      //   index: index,
                                      //   objectType: approval.objectType,
                                      //   objectID: approval.objectId,
                                      //   taskID: approval.taskId,
                                      // );
                                      // isApproved
                                      //     ? removeItem(index, context, approval)
                                      //     : SnackbarServices.errorSnackbar(
                                      //         'Cannot Approve this');
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.mutedColor),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await approvalController
                                          .AddApproveRemarks(
                                              taskID: approval.taskId,
                                              index: index);
                                      bool isApproved =
                                          await approvalController.approveTask(
                                        index: index,
                                        objectType: approval.objectType,
                                        objectID: approval.objectId,
                                        taskID: approval.taskId,
                                      );
                                      isApproved
                                          ? removeItem(index, context, approval)
                                          : SnackbarServices.errorSnackbar(
                                              approvalController.message.value);
                                    },
                                    child: Text(
                                      "Save",
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    bool isApproved = await approvalController.approveTask(
                      index: index,
                      objectType: approval.objectType,
                      objectID: approval.objectId,
                      taskID: approval.taskId,
                    );
                    isApproved
                        ? removeItem(index, context, approval)
                        : SnackbarServices.errorSnackbar(
                            approvalController.message.value);
                  }
                },
                child: Obx(() => approvalController.isApproving.value &&
                        index == approvalController.selectedApprovalIndex.value
                    ? _buildLoader(true)
                    : SvgPicture.asset(
                        AppIcons.check,
                        color: AppColors.darkGreen,
                        width: 30,
                        height: 30,
                      )),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () async {
                  if (approvalController.dontshow == false) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 25, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.mutedColor),
                              onChanged: (value) {
                                if (approvalController
                                    .remarkscontrol.value.text.isEmpty) {
                                  approvalController.remarkscontrol.value.text =
                                      "";
                                }
                              },
                              decoration: InputDecoration(
                                isCollapsed: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.mutedColor, width: 0.1),
                                ),
                                labelText: "Remarks",
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary,
                                ),
                              ),
                              autofocus: false,
                              onTap: () {
                                approvalController.remarkscontrol.value
                                    .selectAll();
                              },
                              focusNode: _remarksFocusNode,
                              maxLines: 6,
                              controller:
                                  approvalController.remarkscontrol.value,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () =>
                                  approvalController.dontShowthisAgain(),
                              splashColor: AppColors.lightGrey,
                              splashFactory: InkRipple.splashFactory,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: AppColors.mutedColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Obx(() => Icon(
                                            Icons.check,
                                            size: 10,
                                            color: approvalController
                                                    .dontshow.value
                                                ? AppColors.primary
                                                : Colors.transparent,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Don't show this again",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      // bool isRejected =
                                      //     await approvalController.rejectTask(
                                      //   index: index,
                                      //   objectType: approval.objectType,
                                      //   objectID: approval.objectId,
                                      //   taskID: approval.taskId,
                                      // );
                                      // isRejected
                                      //     ? removeItem(index, context, approval)
                                      //     : SnackbarServices.errorSnackbar(
                                      //         'Cannot Approve this');
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.mutedColor),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await approvalController
                                          .AddApproveRemarks(
                                              taskID: approval.taskId,
                                              index: index);
                                      bool isRejected =
                                          await approvalController.rejectTask(
                                        index: index,
                                        objectType: approval.objectType,
                                        objectID: approval.objectId,
                                        taskID: approval.taskId,
                                      );
                                      isRejected
                                          ? removeItem(index, context, approval)
                                          : SnackbarServices.errorSnackbar(
                                              approvalController.message.value);
                                    },
                                    child: Text(
                                      "Save",
                                      style:
                                          TextStyle(color: AppColors.primary),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    bool isRejected = await approvalController.rejectTask(
                      index: index,
                      objectType: approval.objectType,
                      objectID: approval.objectId,
                      taskID: approval.taskId,
                    );
                    isRejected
                        ? removeItem(index, context, approval)
                        : SnackbarServices.errorSnackbar(
                            approvalController.message.value);
                  }
                },
                child: Obx(() => approvalController.isRejecting.value &&
                        index == approvalController.selectedApprovalIndex.value
                    ? _buildLoader(false)
                    : SvgPicture.asset(
                        AppIcons.cancel,
                        color: AppColors.darkRed,
                        width: 30,
                        height: 30,
                      )),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox _buildLoader(isApprove) {
    return SizedBox(
      width: 26,
      height: 26,
      child: CircularProgressIndicator(
        color: isApprove ? AppColors.darkGreen : AppColors.darkRed,
        strokeWidth: 3,
      ),
    );
  }

  approvalHistoryCard(TaskDetailsModel item) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.userName == null || item.userName == ""
                ? item.assigneeId ?? ""
                : item.userName ?? '',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "${item.taskId ?? ""}",
            style: TextStyle(
                color: AppColors.mutedColor, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remarks : ',
                style: TextStyle(
                    color: AppColors.mutedColor, fontWeight: FontWeight.w400),
              ),
              Expanded(child: Text(item.remarks ?? ''))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ApprovalStatus : ',
                style: TextStyle(
                    color: AppColors.mutedColor, fontWeight: FontWeight.w400),
              ),
              Expanded(
                child: Text(
                  item.status == ApprovalTypeStatus.Approved.value
                      ? ApprovalTypeStatus.Approved.name
                      : item.status == ApprovalTypeStatus.Pending.value
                          ? ApprovalTypeStatus.Pending.name
                          : item.status == ApprovalTypeStatus.Rejected.value
                              ? ApprovalTypeStatus.Rejected.name
                              : ApprovalTypeStatus.Waiting.name,
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildPreviewLoader() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
