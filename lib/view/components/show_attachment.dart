import 'dart:convert';
import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/salesman_activity_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/shimmer_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ShowAttachment {
  static showAttachments(
      BuildContext context, String sysDocId, String voucher) {
    final controller = Get.put(HomeController());
    Size size = MediaQuery.of(context).size;
    controller.result.value = FilePickerResult([]);
    controller.getAttachmentList(sysDoc: sysDocId, voucher: voucher);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: popupTitle(
            title: 'Attachments',
            onTap: () => Navigator.pop(context),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "$sysDocId  -  ",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${voucher}",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // Expanded(
              //     child: Column(
              //   children: [],
              // )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  // controller.selectFile();
                  showModalBottomSheet(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              18,
                            ),
                            topRight: Radius.circular(
                              18,
                            ))),
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.mutedColor,
                              ),
                              title: Text("Camera"),
                              onTap: () {
                                controller.takePicture();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.photo_library_outlined,
                                color: AppColors.mutedColor,
                              ),
                              title: Text("Files"),
                              onTap: () async {
                                // qualityController.selectFile();
                                controller.selectFile();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(8),
                  dashPattern: [8, 4],
                  strokeCap: StrokeCap.round,
                  color: AppColors.mutedColor,
                  child: Container(
                    width: size.width,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 1.571,
                          child: const Icon(
                            Icons.attach_file,
                            color: AppColors.mutedColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Attach File',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mutedColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Flexible(
                child: SizedBox(
                  width: size.width,
                  child: GetBuilder<HomeController>(
                    builder: (_) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.result.value.files.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  controller.filetypeIcon(index),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        '${controller.result.value.files[index].name}',
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _.result.value.files.removeAt(index);
                                      _.update();
                                    },
                                    child: SvgPicture.asset(
                                      AppIcons.delete,
                                      height: 20,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                                color: AppColors.mutedColor,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                child: Obx(
                  () => SizedBox(
                    width: size.width,
                    height: controller.isAttachmentListLoading.value == false &&
                            controller.attachmentList.isEmpty
                        ? 0
                        : null,
                    child: controller.isAttachmentListLoading.value
                        ? ShimmerProvider.gridShimmer()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.attachmentList.length,
                            itemBuilder: (context, index) {
                              var item = controller.attachmentList[index];
                              Uint8List bytes = const Base64Codec()
                                  .decode(item.fileData ?? '');
                              return InkWell(
                                onTap: () {
                                  if (item.entityDocName!.substring(
                                          item.entityDocName!.length - 3) ==
                                      "pdf") {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          insetPadding: EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          title: Text(
                                            item.entityDocName ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          content: LimitedBox(
                                              maxHeight: 0.5 * size.height,
                                              child: SizedBox(
                                                width: 0.75 * size.width,
                                                child: CommonFilterControls
                                                    .buildPdfView(bytes),
                                              )),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primary)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    ShowAttachment.previewImage(context,
                                        image: bytes, name: item.entityDocName);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: MemoryImage(bytes),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                              ),
                                              child: Text(
                                                item.entityDocName ?? '',
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: AppColors.mutedColor,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                    // GridView.builder(
                    //     shrinkWrap: true,
                    //     gridDelegate:
                    //         SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 4,
                    //     ),
                    //     itemCount: controller.attachmentList.length,
                    //     itemBuilder: (BuildContext ctx, index) {
                    //       var item = controller.attachmentList[index];
                    //       Uint8List bytes = const Base64Codec()
                    //           .decode(item.fileData ?? '');
                    //       return InkWell(
                    //         onTap: () {
                    //           ShowAttachment.previewImage(context,
                    //               image: bytes, name: item.entityDocName);
                    //         },
                    //         child: Container(
                    //           // height: 100,
                    //           // width: 100,
                    //           alignment: Alignment.center,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(15)),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Column(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.center,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.center,
                    //               children: [
                    //                 // controller.filetypeIcon(index),
                    //                 Expanded(
                    //                   child: Card(
                    //                     child: Container(
                    //                       decoration: BoxDecoration(
                    //                         image: DecorationImage(
                    //                           image: MemoryImage(bytes),
                    //                           fit: BoxFit.cover,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Center(
                    //                   child: Text(
                    //                     item.entityDocName ?? '',
                    //                     maxLines: 1,
                    //                     style: TextStyle(
                    //                         color: AppColors.mutedColor,
                    //                         fontSize: 8,
                    //                         overflow:
                    //                             TextOverflow.ellipsis),
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // Obx(
              //   () => GestureDetector(
              //     onTap: () async {
              //       controller.selectFile();
              //       log("${controller.result.value}");
              //     },
              //     child: Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              //         child: DottedBorder(
              //           borderType: BorderType.RRect,
              //           radius: Radius.circular(10),
              //           dashPattern: [10, 4],
              //           strokeCap: StrokeCap.round,
              //           color: AppColors.mutedColor,
              //           child: Container(
              //             width: size.width * 3,
              //             height: size.height / 5,
              //             decoration: BoxDecoration(
              //                 color: AppColors.mutedColor.withOpacity(0.07),
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: controller.result.value == FilePickerResult([])
              //                 ? Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Icon(
              //                         Icons.folder_open,
              //                         color: AppColors.mutedColor,
              //                         size: 40,
              //                       ),
              //                       SizedBox(
              //                         height: 15,
              //                       ),
              //                       Text(
              //                         'Attach File',
              //                         style: TextStyle(
              //                             fontSize: 15,
              //                             color: Colors.grey.shade400),
              //                       ),
              //                     ],
              //                   )
              //                 : Center(
              //                     child: GridView.builder(
              //                         shrinkWrap: true,
              //                         gridDelegate:
              //                             SliverGridDelegateWithFixedCrossAxisCount(
              //                           crossAxisCount: 3,
              //                           // crossAxisSpacing: 8,
              //                           // mainAxisSpacing: 4),
              //                         ),
              //                         itemCount:
              //                             controller.result.value.files.length,
              //                         itemBuilder: (BuildContext ctx, index) {
              //                           return Container(
              //                             // height: 100,
              //                             // width: 100,
              //                             alignment: Alignment.center,
              //                             decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(15)),
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: Column(
              //                                 crossAxisAlignment:
              //                                     CrossAxisAlignment.center,
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.center,
              //                                 children: [
              //                                   controller.filetypeIcon(index),
              //                                   Center(
              //                                     child: Text(
              //                                       "${controller.result.value.files[index].name}",
              //                                       maxLines: 1,
              //                                       style: TextStyle(
              //                                           color: AppColors
              //                                               .mutedColor,
              //                                           overflow: TextOverflow
              //                                               .ellipsis),
              //                                     ),
              //                                   )
              //                                 ],
              //                               ),
              //                             ),
              //                           );
              //                         }),
              //                   ),
              //           ),
              //         )),
              //   ),
              // ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      // this.customer.value = CustomerModel();
                      // Navigator.pop(context);
                      controller.addAttachment(sysDocId, voucher,EntityType.Transactions);
                      Navigator.pop(context);
                    },
                    child: Text('Save',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static previewImage(BuildContext context,
      {required Uint8List image, String? name}) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text(
              name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
            content: LimitedBox(
                maxHeight: 0.5 * size.height,
                child: Image.memory(
                  image,
                  scale: 1,
                  fit: BoxFit.contain,
                  width: 0.7 * size.width,
                )),
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
                      child: Text('Cancel',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
