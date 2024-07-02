import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/reimbursment_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/model/Reimbursement%20Request%20Model/get_addition_code_list.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Reinbursement%20Request/add_update_popup.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Reinbursement%20Request/additional_code_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:axolon_erp/view/components/dragging_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class ReimbursmentRequestApplyScreen extends StatelessWidget {
  ReimbursmentRequestApplyScreen({super.key});

  final reimbursementController = Get.put(ReimbursementController());
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Reimbursement Request Apply"),
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Obx(() => CommonTextField.textfield(
                            suffixicon: true,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                                text:
                                    "${reimbursementController.selectedDocId.value.code ?? ''} - ${reimbursementController.selectedDocId.value.name ?? ''}"),
                            icon: Icons.arrow_drop_down_circle_outlined,
                            ontap: () async {
                              await CommonWidget.commonDialog(
                                context: context,
                                title: "Doc ID",
                                content: docIdContent(context),
                              );
                            },
                            label: "Doc ID"))),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Obx(() => CommonTextField.textfield(
                            suffixicon: false,
                            readonly: true,
                            keyboardtype: TextInputType.text,
                            controller: TextEditingController(
                                text:
                                    "${reimbursementController.voucherNumber.value}"),
                            ontap: () {},
                            label: "Doc Number"))),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Obx(() => CommonTextField.textfield(
                    suffixicon: true,
                    readonly: true,
                    keyboardtype: TextInputType.datetime,
                    controller: TextEditingController(
                        text:
                            "${DateFormatter.dateFormat.format(reimbursementController.date.value)}"),
                    label: "Date",
                    ontap: () async {
                      DateTime date =
                          await reimbursementController.selectDatesForApplying(
                              context, reimbursementController.date.value);
                      reimbursementController.date.value = date;
                    },
                    icon: Icons.calendar_month_outlined)),
                SizedBox(
                  height: 15,
                ),
                CommonTextField.textfield(
                    suffixicon: false,
                    readonly: false,
                    keyboardtype: TextInputType.text,
                    controller: reimbursementController.remarksController.value,
                    label: "Remarks"),

                // SizedBox(
                //   height: 5,
                // ),
                // tableHeader(context),
                Divider(
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: GetBuilder<ReimbursementController>(
                      builder: (controller) => ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount:
                                controller.reimbursmentListCreated.length,
                            itemBuilder: (context, index) {
                              var reimbursment =
                                  controller.reimbursmentListCreated[index];
                              return Slidable(
                                key: const Key('sales_order_list'),
                                startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                        backgroundColor: Colors.green[100]!,
                                        foregroundColor: Colors.green,
                                        icon: Icons.mode_edit_outlined,
                                        onPressed: (_) {
                                          controller
                                                  .amountController.value.text =
                                              "${reimbursment.amount ?? 0.0}";
                                          controller.descontroller.value.text =
                                              "${reimbursment.des}";
                                          CommonWidget.commonDialog(
                                              context: context,
                                              title:
                                                  "${reimbursment.reimburseItemId}",
                                              content: AddUpdatePopUp(
                                                item: AdditionalCodeModel(
                                                    benefitCode: reimbursment
                                                            .reimburseItemId ??
                                                        '',
                                                    benefitName: reimbursment
                                                            .reimburseItemName ??
                                                        ''),
                                                isUpdate: true,
                                                index: index,
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
                                            controller.removeItem(index)),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          // CommonWidget.commonRow(
                                          //     isBlue: false,
                                          //     firstValue:
                                          //         " ${reimbursment.reimburseItemId}",
                                          //     secondValue:
                                          //         " ${reimbursment.reimburseItemName}",
                                          //     firsthead: "code :",
                                          //     secondhead: "Name :",
                                          //     isValueAvailable: true),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${reimbursment.reimburseItemId ?? ''}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.primary),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              AutoSizeText(
                                                "${DateFormatter.dateFormat.format(DateTime.parse(reimbursment.refDate!))}",
                                                maxFontSize: 16,
                                                minFontSize: 10,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          CommonWidget.commonRow(
                                              isBlue: false,
                                              firstValue:
                                                  " ${reimbursment.reimburseItemName}",
                                              secondValue: "",
                                              firsthead: "Name:",
                                              secondhead: "",
                                              isValueAvailable: true),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CommonWidget.commonRow(
                                            isBlue: false,
                                            firstValue: " ${reimbursment.des}",
                                            secondValue: "",
                                            firsthead: "Description :",
                                            secondhead: "",
                                            isValueAvailable: true,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CommonWidget.commonRow(
                                            isBlue: false,
                                            firstValue:
                                                " ${InventoryCalculations.formatPrice(reimbursment.amount ?? 0.0)}",
                                            secondValue: "",
                                            firsthead: "Total :",
                                            secondhead: "",
                                            isValueAvailable: true,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  // child:
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     SizedBox(
                                  //         width: width * 0.15,
                                  //         child: Text(
                                  //           reimbursment.reimburseItemId ?? '',
                                  //         )),
                                  //     SizedBox(
                                  //         width: width * 0.4,
                                  //         child: AutoSizeText(
                                  //           reimbursment.reimburseItemName ??
                                  //               '',
                                  //           maxFontSize: 16,
                                  //           minFontSize: 12,
                                  //           textAlign: TextAlign.start,
                                  //         )),
                                  //     SizedBox(
                                  //       width: width * 0.19,
                                  //       child: Text(
                                  //         "${DateFormatter.dateFormat.format(DateTime.parse(reimbursment.refDate!))}",
                                  //         textAlign: TextAlign.center,
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: width * 0.13,
                                  //       child: Text(
                                  //         InventoryCalculations.formatPrice(
                                  //             reimbursment.amount ?? 0.0),
                                  //         textAlign: TextAlign.center,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                ),
                              );
                            },
                          )),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
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
                            )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(() => Text(
                                        ' ${reimbursementController.total.value}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.lightGrey,
                        ),
                        Obx(() => CommonWidget.saveAndCancelButton(
                              onPressOfCancel: () {
                                reimbursementController.clearData();
                                Navigator.pop(context);
                              },
                              onTapOfSave: () async {
                                if (reimbursementController.isNewRecord.value ==
                                    true) {
                                  if (homeController.isScreenRightAvailable(
                                      screenId: HrScreenId
                                          .employeeReimbursementRequest,
                                      type: ScreenRightOptions.Add)) {
                                    await reimbursementController
                                        .createReimbursmentRequest();
                                  }
                                } else {
                                  if (homeController.isScreenRightAvailable(
                                      screenId: HrScreenId
                                          .employeeReimbursementRequest,
                                      type: ScreenRightOptions.Edit)) {
                                    await reimbursementController
                                        .createReimbursmentRequest();
                                  }
                                }
                              },
                              isSaving: reimbursementController.isSaving.value,
                              isSaveActive: reimbursementController
                                      .isNewRecord.value
                                  ? reimbursementController.isAddEnabled.value
                                  : reimbursementController.isEditEnabled.value,
                            ))
                      ],
                    ),
                  ),
                ),
              ])),
          DragableButton(
            onTap: () {
              reimbursementController.getAdditionCodeList();
              Get.to(() => AdditionalCodeScreen());
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  docIdContent(BuildContext context) {
    return GetBuilder<ReimbursementController>(
        builder: (controller) => controller.isLoading.value
            ? SalesShimmer.locationPopShimmer()
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = controller.docIdList[index];
                  return InkWell(
                    onTap: () {
                      controller.selectedDocId.value = item;
                      controller.getVoucherNumber(
                          controller.selectedDocId.value.code ?? '');
                      Navigator.pop(
                        context,
                      ); // Return selected item
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${item.code} - ${item.name}",
                            style: TextStyle(
                                color: AppColors.mutedColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: controller.docIdList.length));
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
                'Ref Date',
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
                'Amount',
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
}
