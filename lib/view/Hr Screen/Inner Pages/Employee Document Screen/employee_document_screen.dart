import 'dart:convert';
import 'dart:typed_data';

import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/employee_document_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Employee%20Document%20Screen/add_employee_document_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/shimmer_provider.dart';
import 'package:axolon_erp/view/components/show_attachment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EmployeeDocumentScreen extends StatelessWidget {
  EmployeeDocumentScreen({super.key});
  final employeeDocumentController = Get.put(EmployeeDocumentController());
  var selectedValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Document"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              GetBuilder<EmployeeDocumentController>(
                  builder: (controller) => controller.isLoading.value
                      ? popShimmer()
                      : controller.employeeDocumentList.isEmpty
                          ? const Text("No Data")
                          : ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 8,
                                  ),
                              key: Key("employee_document_list"),
                              itemCount: controller.employeeDocumentList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item =
                                    controller.employeeDocumentList[index];

                                return Card(
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
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            CommonWidget.commonRow(
                                                isBlue: true,
                                                firsthead:
                                                    "${item.docId ?? ''}",
                                                secondhead:
                                                    "${item.documentNumber ?? ''}",
                                                isValueAvailable: false),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CommonWidget.commonRow(
                                                isBlue: false,
                                                firstValue:
                                                    " ${DateFormatter.dateFormat.format(item.issueDate ?? DateTime.now())}",
                                                secondValue: "",
                                                firsthead: "Issue Date :",
                                                secondhead: "",
                                                isValueAvailable: true),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CommonWidget.commonRow(
                                                isBlue: false,
                                                firsthead: "Document Type :",
                                                firstValue:
                                                    " ${item.documentTypeId ?? ''}",
                                                secondhead: "Expiry Date:",
                                                secondValue:
                                                    " ${DateFormatter.dateFormat.format(item.expiryDate ?? DateTime.now())}",
                                                isValueAvailable: true),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Remarks :",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .mutedColor)),
                                                        Flexible(
                                                          child: Text(
                                                              item.remarks ??
                                                                  '',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .mutedColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize:
                                                                      13)),
                                                        )
                                                      ]),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controller.getAttachment(
                                                        "${item.docId}");
                                                    // Uint8List? bytes = controller
                                                    //         .attachmentList.isNotEmpty
                                                    //     ? const Base64Codec().decode(controller
                                                    //             .attachmentList[0].fileData ??
                                                    //         '')
                                                    //     : null;

                                                    CommonWidget.commonDialog(
                                                        context: context,
                                                        title: "${item.docId}",
                                                        content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Obx(
                                                                () => controller
                                                                        .isAttachmentListLoading
                                                                        .value
                                                                    ? ShimmerProvider
                                                                        .gridShimmer()
                                                                    : controller
                                                                            .attachmentList
                                                                            .isEmpty
                                                                        ? Center(
                                                                            child:
                                                                                Text("No Attachments!"),
                                                                          )
                                                                        : controller.attachmentList[0].entityDocName!.substring(controller.attachmentList[0].entityDocName!.length - 3) ==
                                                                                "pdf"
                                                                            ? LimitedBox(
                                                                                maxHeight: 0.5 * size.height,
                                                                                child: CommonFilterControls.buildPdfView(Base64Codec().decode(controller.attachmentList[0].fileData ?? '')))
                                                                            : Image.memory(
                                                                                Base64Codec().decode(controller.attachmentList[0].fileData ?? ''),
                                                                                scale: 1,
                                                                                fit: BoxFit.fill,
                                                                                width: size.width,
                                                                              ),
                                                              )
                                                            ]));
                                                  },
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: SvgPicture.asset(
                                                      AppIcons.attachment,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              }))
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       // employeeDocumentController.getDocId();
      //       // employeeDocumentController.clearData();
      //       // employeeDocumentController.isNewRecord.value = true;
      //       Get.to(() => AddEmployeeDocumentScreen())?.then((value) =>
      //           employeeDocumentController.getEmployeeDocumentList());
      //     },
      //     child: Icon(Icons.add),
      //     backgroundColor: AppColors.primary),
    );
  }
}
