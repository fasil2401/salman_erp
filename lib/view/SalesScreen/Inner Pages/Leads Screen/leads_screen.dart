import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/lead_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/salesman_activity_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/services/enums.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Leads%20Screen/components/map_dialog.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/chatscreen.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final homecontroller = Get.put(HomeController());
  // final salesmanactivityController = Get.put(SalesmanActivityController());
  final leadsController = Get.put(LeadController());
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Leads"),
          actions: [
            Obx(() => homeController.chatenabled.value == true
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
                leadsController.searchControl.clear();
                leadsController.getLeadOpenList();
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
                () => leadsController.isLeadsIdLoading.value
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        leadsController.disabledTextfield(
                            "Lead Code", leadsController.leadcodecontrol),
                        SizedBox(
                          height: 20,
                        ),
                        CommonTextField.textfield(
                            keyboardtype: TextInputType.text,
                            ontap: () {},
                            controller: leadsController.leadnamecontrol,
                            label: "Lead Name",
                            readonly: false,
                            suffixicon: false)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'General',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: AppColors.mutedColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          // SizedBox(
                          //   height: 10,
                          // ),
                          CommonTextField.textfield(
                              controller: leadsController.statuscontrol,
                              label: "Status",
                              ontap: () {
                                homecontroller.selectCRMList(
                                  text: "Status",
                                  list: homecontroller.statusList,
                                  oneditingcomplete: () async {
                                    await leadsController.changeFocus(context);
                                  },
                                  controller: leadsController.statuscontrol,
                                  context: context,
                                );
                              },
                              keyboardtype: TextInputType.text,
                              readonly: true,
                              suffixicon: true,
                              icon: Icons.arrow_drop_down),
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextField.textfield(
                              keyboardtype: TextInputType.text,
                              readonly: true,
                              suffixicon: true,
                              controller: leadsController.stagecontrol,
                              label: "Stage",
                              ontap: () {
                                homecontroller.selectCRMList(
                                    text: "Stage",
                                    list: homecontroller.stageList,
                                    oneditingcomplete: () async {
                                      await leadsController
                                          .changeFocus(context);
                                    },
                                    controller: leadsController.stagecontrol,
                                    context: context);
                              },
                              icon: Icons.arrow_drop_down),
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextField.textfield(
                              keyboardtype: TextInputType.text,
                              readonly: true,
                              suffixicon: true,
                              controller: leadsController.sourcecontrol,
                              label: "Source",
                              ontap: () {
                                homecontroller.selectCRMList(
                                    text: "Source",
                                    list: homecontroller.sourceList,
                                    oneditingcomplete: () async {
                                      await leadsController
                                          .changeFocus(context);
                                    },
                                    controller: leadsController.sourcecontrol,
                                    context: context);
                              },
                              icon: Icons.arrow_drop_down),
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextField.textfield(
                              controller: leadsController.reasoncontrol,
                              label: "Reason",
                              ontap: () {
                                log("${homecontroller.regardinglist}");
                                leadsController.isLoading.value = false;
                                homecontroller.selectCRMList(
                                    text: "Reasons",
                                    list: homecontroller.reasonList,
                                    oneditingcomplete: () async {
                                      await leadsController
                                          .changeFocus(context);
                                    },
                                    controller: leadsController.reasoncontrol,
                                    context: context);
                              },
                              keyboardtype: TextInputType.text,
                              readonly: true,
                              suffixicon: true,
                              icon: Icons.arrow_drop_down),
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextField.textfield(
                              keyboardtype: TextInputType.text,
                              controller: leadsController.companynamecontrol,
                              label: "Company Name",
                              ontap: () {},
                              readonly: false,
                              suffixicon: false),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: CommonTextField.textfield(
                                suffixicon: false,
                                readonly: true,
                                keyboardtype: TextInputType.text,
                                label: 'Next Follow Up',
                                ontap: () {},
                                controller: leadsController.nextFollowUpControl,
                              )),
                              Visibility(
                                visible:
                                    leadsController.isNewRecord.value == false
                                        ? true
                                        : false,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        leadsController.followUp(context);
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.add_box_outlined,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Center(
                                        child: Icon(
                                          Icons.list_alt_sharp,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Details',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: AppColors.mutedColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          // SizedBox(
                          //     child: CommonTextField
                          //         .multilinetextfield(
                          //             controller:
                          //                 leadsController.addresscontrol,
                          //             label: "Address")),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          textfield(
                            suffixicon: SizedBox(),
                            controller: leadsController.contactPerson,
                            label: "Contact Person",
                            keyboardtype: TextInputType.text,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          textfield(
                              label: "Mobile",
                              suffixicon: leadsController.isNewRecord == false
                                  ? SizedBox(
                                      width: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              leadsController.whatsAppLaunch(
                                                  leadsController
                                                      .mobilecontrol.text);
                                            },
                                            child: SvgPicture.asset(
                                              AppIcons.whatsapp,
                                              color: AppColors.primary,
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              leadsController.phoneCallLaunch(
                                                  leadsController
                                                      .mobilecontrol.text);
                                            },
                                            child: SvgPicture.asset(
                                              AppIcons.phone,
                                              height: 20,
                                              width: 20,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              keyboardtype: TextInputType.phone,
                              controller: leadsController.mobilecontrol),
                          SizedBox(
                            height: 20,
                          ),
                          textfield(
                            suffixicon: leadsController.isNewRecord == false
                                ? SizedBox(
                                    width: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            leadsController.emailLaunch(
                                                leadsController
                                                    .emailcontrol.text);
                                          },
                                          child: SvgPicture.asset(
                                            AppIcons.mail,
                                            color: AppColors.primary,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            controller: leadsController.emailcontrol,
                            label: "Email",
                            keyboardtype: TextInputType.emailAddress,
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          textfield(
                            suffixicon: leadsController.isNewRecord.value ==
                                    false
                                ? SizedBox(
                                    width: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            leadsController.launchInBrowser(
                                                leadsController
                                                    .websitecontrol.value.text);
                                          },
                                          child: SvgPicture.asset(
                                            AppIcons.www,
                                            color: AppColors.primary,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                            controller: leadsController.websitecontrol,
                            label: "Website",
                            keyboardtype: TextInputType.text,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextField.textfield(
                                    keyboardtype: TextInputType.text,
                                    readonly: true,
                                    suffixicon: true,
                                    controller: leadsController.countrycontrol,
                                    label: "Country",
                                    ontap: () async {
                                      await homecontroller.selectCRMList(
                                          text: "Country",
                                          list: homecontroller.countryList,
                                          oneditingcomplete: () async {
                                            await leadsController
                                                .changeFocus(context);
                                          },
                                          controller:
                                              leadsController.countrycontrol,
                                          context: context);
                                      homecontroller.areaCountryList.clear();
                                    },
                                    icon: Icons.arrow_drop_down),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: CommonTextField.textfield(
                                    keyboardtype: TextInputType.text,
                                    readonly: true,
                                    suffixicon: true,
                                    controller: leadsController.areacontrol,
                                    label: "Area",
                                    ontap: () {
                                      homecontroller
                                          .countryCode.value = leadsController
                                              .countrycontrol.text
                                              .contains('-')
                                          ? leadsController.countrycontrol.text
                                              .split(' - ')[0]
                                          : leadsController.countrycontrol.text;
                                      if (leadsController
                                          .countrycontrol.text.isEmpty) {
                                        SnackbarServices.errorSnackbar(
                                            "Select Country");
                                      } else {
                                        homecontroller.selectCRMList(
                                            text: "Area",
                                            list:
                                                homecontroller.areaCountryList,
                                            oneditingcomplete: () async {
                                              await leadsController
                                                  .changeFocus(context);
                                            },
                                            controller:
                                                leadsController.areacontrol,
                                            context: context);
                                      }
                                    },
                                    icon: Icons.arrow_drop_down),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Obx(() => InkWell(
                                    onTap: () async {
                                      if (leadsController
                                          .isFetchingProgress.value) {
                                        return;
                                      }
                                      await leadsController.fetchLocationInfo();
                                      showDialog(
                                        context: context,
                                        builder: (context) => MapDialog(
                                          addressMap:
                                              leadsController.addressMap.value,
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: leadsController
                                                .isFetchingProgress.value
                                            ? SizedBox(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator())
                                            : Icon(
                                                Icons.location_on_outlined,
                                                color: AppColors.primary,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // SizedBox(
                          //  height: 9.w,
                          //     child: TextField(
                          //       controller:
                          //           leadsController.locationControl,
                          //       onTap: () {},
                          //       style: TextStyle(
                          //           fontSize: 12,
                          //           color: AppColors.mutedColor),
                          //       decoration: InputDecoration(
                          //           floatingLabelAlignment:
                          //               FloatingLabelAlignment.start,
                          //           isCollapsed: true,
                          //           isDense: true,
                          //           contentPadding: EdgeInsets.symmetric(
                          //               horizontal: 10, vertical: 3.w),
                          //           border: OutlineInputBorder(
                          //             borderRadius:
                          //                 BorderRadius.circular(10),
                          //             borderSide: const BorderSide(
                          //                 color: AppColors.mutedColor,
                          //                 width: 0.1),
                          //           ),
                          //           labelText: "Location",
                          //           labelStyle: TextStyle(
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.w400,
                          //             color: AppColors.primary,
                          //           ),
                          //           suffixIcon: IconButton(
                          //               onPressed: () {},
                          //               icon: Icon(
                          //                 Icons.location_on_outlined,
                          //                 color: AppColors.primary,
                          //               ))),
                          //     )),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              child: TextField(
                            style: TextStyle(
                                fontSize: 12, color: AppColors.mutedColor),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3.w),
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
                            maxLines: null,
                            controller: leadsController.remarkscontrol,
                            keyboardType: TextInputType.text,
                          )
                              // salesmanactivityController.multilinetextfield(
                              //     controller:
                              //         leadsController.remarkscontrol,
                              //     label: "Remarks")
                              ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            leadsController.cleardata();
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
                      Obx(() => saveButton(
                            leadsController.isNewRecord.value
                                ? leadsController.isAddEnabled.value
                                : leadsController.isEditEnabled.value,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildWarning(String text, bool isWarning) {
    return Visibility(
      visible: isWarning,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.darkRed,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Column _buildOpenListHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonTextField.textfield(
          suffixicon: true,
          readonly: false,
          keyboardtype: TextInputType.text,
          controller: leadsController.searchControl,
          icon: Icons.search,
          label: "Search",
          onchanged: (value) {
            if (leadsController.searchControl.text.isEmpty) {
              leadsController.filterList.value =
                  leadsController.leadsOpenList.value;
            }
            leadsController.search(value, leadsController.leadsOpenList);
          },
        ),
        // TextField(
        //   controller: leadsController.searchControl,
        //   decoration: InputDecoration(
        //       isCollapsed: true,
        //       hintText: 'Search',
        //       contentPadding: EdgeInsets.all(8)),
        //   onChanged: (value) {
        //     if (leadsController.searchControl.text.isEmpty) {
        //       leadsController.filterList.value =
        //           leadsController.leadsOpenList.value;
        //     }
        //     leadsController.search(value, leadsController.leadsOpenList);
        //   },
        //   onEditingComplete: () async {
        //     await leadsController.changeFocus(context);
        //   },
        // ),
      ],
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
                () => leadsController.isOpenListLoading.value
                    ? SalesShimmer.locationPopShimmer()
                    : leadsController.leadsOpenList.length == 0
                        ? Center(
                            child: Text('No Data Found'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: leadsController.filterList.length,
                            itemBuilder: (context, index) {
                              var item = leadsController.filterList[index];
                              log("${item.name}");
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                child: ExpansionTile(
                                  iconColor: AppColors.primary,
                                  childrenPadding: EdgeInsets.only(
                                      left: 10, right: 20, top: 10, bottom: 10),
                                  title: InkWell(
                                    splashColor:
                                        AppColors.mutedColor.withOpacity(0.2),
                                    splashFactory: InkRipple.splashFactory,
                                    onTap: () async {
                                      await leadsController
                                          .getLeadById(item.leadCode);
                                      homecontroller.chatenabled.value = true;
                                      leadsController.isNewRecord.value = false;
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          '${item.leadCode ?? ''}  -  ${item.name ?? ''}',
                                          minFontSize: 12,
                                          maxFontSize: 13,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AutoSizeText(
                                          'Source : ${item.source ?? ''}',
                                          minFontSize: 10,
                                          maxFontSize: 13,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        AutoSizeText(
                                          'Owner : ${item.owner ?? ''}',
                                          minFontSize: 10,
                                          maxFontSize: 13,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        AutoSizeText(
                                          'Mobile : ${item.mobile ?? ''}',
                                          minFontSize: 10,
                                          maxFontSize: 13,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          border: Border.all(
                                              color: AppColors.mutedColor)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Company",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          if (item.company != '')
                                            AutoSizeText(
                                              '${item.company ?? ''}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 12,
                                              maxFontSize: 12,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "City : ",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                              AutoSizeText(
                                                '${item.city ?? ''}',
                                                minFontSize: 10,
                                                maxFontSize: 12,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Phone",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  if (item.phone != '')
                                                    AutoSizeText(
                                                      '${item.phone ?? ''}',
                                                      minFontSize: 11,
                                                      maxFontSize: 13,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Contact Person",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  ),
                                                  if (item.contactName != '')
                                                    AutoSizeText(
                                                      '${item.contactName ?? ''}',
                                                      minFontSize: 11,
                                                      maxFontSize: 13,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          if (item.country != '' &&
                                              item.area != '')
                                            AutoSizeText(
                                              '${item.area ?? ''} , ${item.country ?? ''}',
                                              minFontSize: 10,
                                              maxFontSize: 12,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
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
    );
  }

  textfield(
      {String? label,
      TextEditingController? controller,
      required suffixicon,
      required TextInputType keyboardtype}) {
    return SizedBox(
        // height: 35.0,
        child: TextField(
      maxLines: 1,
      controller: controller,
      keyboardType: keyboardtype,
      style: TextStyle(fontSize: 12, color: AppColors.mutedColor),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.mutedColor, width: 0.1),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ),
        suffixIcon: suffixicon,
        suffixIconConstraints: BoxConstraints.tightFor(height: 30, width: 80),
      ),
    ));
  }

  Widget saveButton(bool isSaveActive) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: isSaveActive
            ? () async {
                await leadsController.validateField();
                if (leadsController.validateField() == true) {
                  if (leadsController.isNewRecord.value == true) {
                    if (homecontroller.isScreenRightAvailable(
                        screenId: SalesScreenId.leadDetails,
                        type: ScreenRightOptions.Add)) {
                      await leadsController.CreateLead();
                    }
                  } else {
                    if (homecontroller.isScreenRightAvailable(
                        screenId: SalesScreenId.leadDetails,
                        type: ScreenRightOptions.Edit)) {
                      await leadsController.CreateLead();
                    }
                  }
                }
                //    if (salesController.isNewRecord.value == true) {
                // await leadsController.validateField();
                // if (leadsController.validateField() == true) {
                //   if (homecontroller.isScreenRightAvailable(
                //       screenId: SalesScreenId.salesActivity,
                //       type: ScreenRightOptions.Edit)) {
                //     leadsController.CreateLead();
                //   } else {
                //     SnackbarServices.errorSnackbar(
                //         "Screen Edit not available for the User");
                //   }
                // }
                // } else {
                //   if (homecontroller.isScreenRightAvailable(
                //       screenId: SalesScreenId.salesActivity,
                //       type: ScreenRightOptions.Edit)) {
                //   leadsController.updateLead();
                // }
                //   }
              }
            : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSaveActive ? AppColors.primary : AppColors.mutedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() => leadsController.isLoadingsave.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ))
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ))),
      ),
    );
  }
}
