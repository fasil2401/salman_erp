import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/lead_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/constants/snackbar.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/Calculations/tax_calculations.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/Theme/color_helper.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Leads%20Screen/components/filter_dilog_content.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Leads%20Screen/components/map_dialog.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:cell_calendar/cell_calendar.dart';
// import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LeadListScreen extends StatefulWidget {
  LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  @override
  void initState() {
    super.initState();
    _initializeLeadList();
  }

  Future<void> _initializeLeadList() async {
    final selectedDateIndex =
        UserSimplePreferences.getLeadDateFilter()?.toInt() ?? 0;
    leadController.dateIndex.value = selectedDateIndex;
    await leadController.selectDateRange(
      DateRangeSelector.dateRange[selectedDateIndex].value,
      selectedDateIndex,
    );
    await leadController.getLeadList();
  }

  final leadController = Get.put(LeadController());
  final homeController = Get.put(HomeController());
  var selectedValue;

  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    int? savedIndex = UserSimplePreferences.getLeadDateFilter();
    // final events = EventCalendar.sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Lead List'),
        actions: [
          IconButton(
            onPressed: () {
              if (leadController.isLeadListLoading.value) {
                return;
              }
              leadController.getLeadList();
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(children: [
                Obx(() => CommonFilterControls.buildDateRageDropdown(
                      context,
                      isClosing: false,
                      dropValue: DateRangeSelector
                          .dateRange[leadController.dateIndex.value],
                      onChanged: (value) async {
                        selectedValue = value;
                        await leadController.selectDateRange(
                            selectedValue.value,
                            DateRangeSelector.dateRange.indexOf(selectedValue));
                        leadController.getLeadList();
                      },
                      fromController: TextEditingController(
                        text: DateFormatter.dateFormat
                            .format(leadController.fromDate.value)
                            .toString(),
                      ),
                      toController: TextEditingController(
                        text: DateFormatter.dateFormat
                            .format(leadController.toDate.value)
                            .toString(),
                      ),
                      onTapFrom: () {
                        leadController.selectDate(context, true);
                      },
                      onTapTo: () {
                        leadController.selectDate(context, false);
                      },
                      isFromEnable: leadController.isFromDate.value,
                      isToEnable: leadController.isToDate.value,
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => buildExpansionTextFields(
                            controller: leadController.searchController.value,
                            onTap: () {},
                            isReadOnly: false,
                            onChanged: (value) {},
                            focus: _focusNode,
                            disableSuffix: true,
                            hint: 'Search',
                            isSearch: true),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        leadController.searchLeadLIst(
                            leadController.searchController.value.text.trim());
                        // leadController.filterLeadListAccordingTodate();
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
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // leadController.getLeadList();
                        leadController.clearSearch();
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
                                            context)))));
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
                          '${leadController.filterSearchLeadList.length} Results',
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
                            value: leadController.showCompletedToggle.value,
                            onChanged: (value) {
                              leadController.toggleCompleted();
                              leadController.getLeadList();
                            },
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GetBuilder<LeadController>(
                    builder: (controller) => controller.isLeadListLoading.value
                        ? popShimmer()
                        : controller.filterSearchLeadList.isEmpty
                            ? const Text("No Data")
                            : ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 8,
                                    ),
                                shrinkWrap: true,
                                key: Key("Lead_list"),
                                itemCount:
                                    controller.filterSearchLeadList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var item =
                                      controller.filterSearchLeadList[index];
                                  return InkWell(
                                      onDoubleTap: () {
                                        leadController
                                            .getLeadByidFromListScreen(item);
                                        Get.toNamed(RouteManager.lead);
                                      },
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                            item.hexColorCode ==
                                                                ''
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
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          dividerColor: Colors
                                                              .transparent),
                                                  child: IgnorePointer(
                                                      ignoring: false,
                                                      child: ExpansionTile(
                                                          // initiallyExpanded: isExpanded,

                                                          tilePadding:
                                                              EdgeInsets.zero,
                                                          // trailing: const SizedBox(
                                                          //   width: 0,
                                                          // ),
                                                          textColor:
                                                              Colors.black,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          title: InkWell(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                Null;
                                                              },
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          16,
                                                                          8,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  Text(
                                                                                    '${item.docId ?? ''} ',
                                                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                                                                                  ),
                                                                                  Flexible(
                                                                                    fit: FlexFit.loose,
                                                                                    child: SizedBox(
                                                                                      width: item.leadName!.length > 16 ? MediaQuery.of(context).size.width * 0.28 : null,
                                                                                      child: Text(
                                                                                        ": ${item.leadName ?? ''}",
                                                                                        // textAlign: TextAlign.start,
                                                                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      FocusScope.of(context).unfocus();
                                                                                      leadController.sysDocId.value.text = '';
                                                                                      leadController.voucherId.value.text = item.docId ?? '';
                                                                                      leadController.statusCode.value.text = item.status ?? '';
                                                                                      leadController.statusName.value.text = leadController.getActionStatusCombo(item.status ?? '').name ?? '';
                                                                                      leadController.statusRef1Name.value = leadController.getActionStatusCombo(item.status ?? '').ref1Name == null || leadController.getActionStatusCombo(item.status ?? '').ref1Name == '' ? 'Ref 1' : leadController.getActionStatusCombo(item.status ?? '').ref1Name!;
                                                                                      leadController.statusRef2Name.value = leadController.getActionStatusCombo(item.status ?? '').ref2Name == null || leadController.getActionStatusCombo(item.status ?? '').ref2Name == '' ? 'Ref 2' : leadController.getActionStatusCombo(item.status ?? '').ref2Name!;
                                                                                      leadController.actualDate.value = DateTime.now();
                                                                                      leadController.refDate.value = DateTime.now();
                                                                                      updateActionStatus(
                                                                                        context,
                                                                                        () async {
                                                                                          await leadController.getActionStatusComboList();
                                                                                          await showStatusList(context: context, list: leadController.actionStatusChangingList.value, controller: leadController);
                                                                                          leadController.statusCode.value.text = leadController.selectedStatusValue.value.code.toString();
                                                                                          leadController.statusName.value.text = leadController.selectedStatusValue.value.name.toString();
                                                                                          leadController.statusRef1Name.value = leadController.selectedStatusValue.value.ref1Name == null || leadController.selectedStatusValue.value.ref1Name == '' ? 'Ref 1' : leadController.selectedStatusValue.value.ref1Name!;
                                                                                          leadController.statusRef2Name.value = leadController.selectedStatusValue.value.ref2Name == null || leadController.selectedStatusValue.value.ref2Name == '' ? 'Ref 2' : leadController.selectedStatusValue.value.ref2Name!;
                                                                                        },
                                                                                        leadController,
                                                                                        () async {
                                                                                          await leadController.createActionLogStatus(
                                                                                            index,
                                                                                          );
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        color: item.hexColorCode == null || item.hexColorCode == '' ? Colors.transparent : Color(int.parse('${item.hexColorCode!.split('#')[1]}', radix: 16) + 0xFF000000),
                                                                                      ),
                                                                                      child: Text(
                                                                                        item.status ?? '',
                                                                                        style: TextStyle(fontSize: 12, color: item.hexColorCode == null || item.hexColorCode == '' ? Colors.black : ColorHelper.getContrastingTextColorFromHex(item.hexColorCode!), fontWeight: FontWeight.w500),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]),
                                                                              ),
                                                                              Text(
                                                                                item.leadCreated == null || item.leadCreated == '' ? "" : "${DateFormatter.dateFormat.format(item.leadCreated!)}",
                                                                                maxLines: 1,
                                                                                textAlign: TextAlign.end,
                                                                                style: const TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                              ),
                                                                            ]),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        _buildTileText(
                                                                            text: item.salesperson ??
                                                                                '',
                                                                            title:
                                                                                'Salesperson'),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        _buildTileText(
                                                                            text: item.leadOwnerName ??
                                                                                '',
                                                                            title:
                                                                                'Lead Owner Name.'),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        _buildTileText(
                                                                            text:
                                                                                "${item.sourceLeadId ?? ''}",
                                                                            title:
                                                                                'Source Lead Id'),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                leadController.whatsAppLaunch(item.mobile ?? '');
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                AppIcons.whatsapp,
                                                                                color: Colors.grey.shade900,
                                                                                height: 20,
                                                                                width: 20,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                controller.phoneCallLaunch(item.mobile ?? '');
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                AppIcons.phone,
                                                                                height: 20,
                                                                                width: 20,
                                                                                color: Colors.grey.shade900,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                controller.emailLaunch(item.email ?? '');
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                AppIcons.mail,
                                                                                color: Colors.grey.shade900,
                                                                                height: 20,
                                                                                width: 20,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                await leadController.getNextFollowUpDatesList(leadId: item.docId ?? '', index: index);
                                                                                if (leadController.followUpCalendarDates.isEmpty) {
                                                                                  SnackbarServices.errorSnackbar('No followups found!');
                                                                                  return;
                                                                                }
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      insetPadding: EdgeInsets.all(10),
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                      title: popupTitle(
                                                                                          onTap: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          title: "Schedule"),
                                                                                      content: Container(
                                                                                        width: double.maxFinite,
                                                                                        child: CellCalendar(
                                                                                          cellCalendarPageController: cellCalendarPageController,
                                                                                          events: leadController.followUpCalendarDates.value,
                                                                                          todayMarkColor: AppColors.darkGreen,
                                                                                          dateTextStyle: TextStyle(
                                                                                            fontWeight: FontWeight.w400,
                                                                                          ),
                                                                                          daysOfTheWeekBuilder: (dayIndex) {
                                                                                            final labels = [
                                                                                              "Sun",
                                                                                              "Mon",
                                                                                              "Tue",
                                                                                              "Wed",
                                                                                              "Thu",
                                                                                              "Fri",
                                                                                              "Sat"
                                                                                            ];
                                                                                            return Padding(
                                                                                              padding: const EdgeInsets.only(bottom: 4.0),
                                                                                              child: Text(
                                                                                                labels[dayIndex],
                                                                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: labels[dayIndex] == 'Sun' ? AppColors.darkRed : AppColors.mutedColor),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          monthYearLabelBuilder: (datetime) {
                                                                                            final year = datetime!.year.toString();
                                                                                            final month = datetime.month.monthName;
                                                                                            return Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  // const SizedBox(width: 16),
                                                                                                  Text(
                                                                                                    "$month  $year",
                                                                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
                                                                                                  ),
                                                                                                  const Spacer(),
                                                                                                  IconButton(
                                                                                                    padding: EdgeInsets.zero,
                                                                                                    icon: const Icon(
                                                                                                      Icons.calendar_month_rounded,
                                                                                                      color: AppColors.primary,
                                                                                                      size: 20,
                                                                                                    ),
                                                                                                    onPressed: () {
                                                                                                      cellCalendarPageController.animateToDate(
                                                                                                        DateTime.now(),
                                                                                                        curve: Curves.linear,
                                                                                                        duration: const Duration(milliseconds: 300),
                                                                                                      );
                                                                                                    },
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          onCellTapped: (date) {
                                                                                            final eventsOnTheDate = leadController.followUpCalendarDates.value.where((event) {
                                                                                              final eventDate = event.eventDate;
                                                                                              return eventDate.year == date.year && eventDate.month == date.month && eventDate.day == date.day;
                                                                                            }).toList();
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (_) => AlertDialog(
                                                                                                      insetPadding: EdgeInsets.all(10),
                                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                                      title: popupTitle(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                          },
                                                                                                          title: "${date.month.monthName} ${date.day}"),
                                                                                                      // Text("${date.month.monthName} ${date.day}"),
                                                                                                      content: SizedBox(
                                                                                                        width: MediaQuery.of(context).size.width,
                                                                                                        child: Column(
                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                          children: eventsOnTheDate
                                                                                                              .map(
                                                                                                                (event) => Container(
                                                                                                                  width: double.infinity,
                                                                                                                  padding: const EdgeInsets.all(8),
                                                                                                                  margin: const EdgeInsets.only(bottom: 12),
                                                                                                                  decoration: BoxDecoration(color: event.eventBackgroundColor, borderRadius: BorderRadius.circular(6)),
                                                                                                                  child: Text(
                                                                                                                    event.eventName,
                                                                                                                    style: TextStyle(
                                                                                                                      fontSize: 14,
                                                                                                                      color: Colors.white,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )
                                                                                                              .toList(),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ));
                                                                                          },
                                                                                          onPageChanged: (firstDate, lastDate) {
                                                                                            /// Called when the page was changed
                                                                                            /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Obx(() => leadController.isCalendarLoading.value && leadController.selectedIndex.value == index
                                                                                  ? SizedBox(
                                                                                      width: 15,
                                                                                      height: 15,
                                                                                      child: CircularProgressIndicator(
                                                                                        strokeWidth: 2,
                                                                                        color: AppColors.mutedColor,
                                                                                      ))
                                                                                  : SvgPicture.asset(AppIcons.calendar1, color: Colors.grey.shade900, height: 20, width: 20)),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                leadController.launchInBrowser(item.website ?? '');
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                AppIcons.www,
                                                                                color: Colors.grey.shade900,
                                                                                height: 20,
                                                                                width: 20,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 15),
                                                                            InkWell(
                                                                                onTap: () async {
                                                                                  FocusScope.of(context).unfocus();
                                                                                  leadController.getActionStatusLogList(item.docId ?? '');
                                                                                  showTimelineAlertDialog(
                                                                                    context,
                                                                                  );
                                                                                },
                                                                                child: SvgPicture.asset(AppIcons.history, color: Colors.grey.shade900, height: 21, width: 21)),
                                                                            SizedBox(width: 15),
                                                                            Obx(() =>
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    if (leadController.isFetchingProgress.value) {
                                                                                      return;
                                                                                    }

                                                                                    await leadController.fetchLocationInfo(index: index);
                                                                                    if (leadController.addressMap.isNotEmpty) {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => MapDialog(
                                                                                          addressMap: leadController.addressMap.value,
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: leadController.isFetchingProgress.value && leadController.selectedIndex.value == index
                                                                                      ? SizedBox(
                                                                                          width: 15,
                                                                                          height: 15,
                                                                                          child: CircularProgressIndicator(
                                                                                            strokeWidth: 2,
                                                                                            color: AppColors.mutedColor,
                                                                                          ))
                                                                                      : Icon(
                                                                                          Icons.location_on_outlined,
                                                                                          color: Colors.grey.shade900,
                                                                                          size: 22,
                                                                                        ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ]))),
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Container(
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20)),
                                                                    ),
                                                                    child: Padding(
                                                                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                          Divider(
                                                                            thickness:
                                                                                1.5,
                                                                            color:
                                                                                AppColors.lightGrey,
                                                                          ),
                                                                          // Row(
                                                                          //   mainAxisAlignment:
                                                                          //       MainAxisAlignment.spaceBetween,
                                                                          //   children: [
                                                                          //     _buildTileText(text: item.leadSourceName ?? '' ?? '', title: 'Lead Source Name'),
                                                                          //     // Text(
                                                                          //     //   "Lead Source Name : ${item.leadSourceName ?? ''}",
                                                                          //     //   textAlign: TextAlign.start,
                                                                          //     //   style: TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          //     // ),
                                                                          //     Text(
                                                                          //       "Campaign Name : ${item.campaignName ?? ''}",
                                                                          //       textAlign: TextAlign.start,
                                                                          //       style: TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          //     ),
                                                                          //   ],
                                                                          // ),
                                                                          buildTileTwoHeaderText(
                                                                              firstTitle: 'Lead Source Name',
                                                                              firstText: "${item.leadSourceName ?? ''}",
                                                                              secondTitle: "Campaign Name",
                                                                              secondText: "${item.campaignName ?? ''}"),
                                                                          SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          // Row(
                                                                          //   mainAxisAlignment:
                                                                          //       MainAxisAlignment.spaceBetween,
                                                                          //   children: [
                                                                          //     Text(
                                                                          //       "Country Name : ${item.countryName ?? ''}",
                                                                          //       textAlign: TextAlign.start,
                                                                          //       style: TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          //     ),
                                                                          //     Text(
                                                                          //       "Area Name : ${item.areaName ?? ''}",
                                                                          //       textAlign: TextAlign.start,
                                                                          //       style: const TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          //     ),
                                                                          //   ],
                                                                          // ),
                                                                          buildTileTwoHeaderText(
                                                                              firstTitle: 'Country Name',
                                                                              firstText: "${item.countryName ?? ''}",
                                                                              secondTitle: "Area Name",
                                                                              secondText: "${item.areaName ?? ''}"),

                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          buildTileTwoHeaderText(
                                                                              firstTitle: 'Contact Name',
                                                                              firstText: "${item.contactName ?? ''}",
                                                                              secondTitle: "Mobile",
                                                                              secondText: "${item.mobile ?? ''}"),

                                                                          // Text(
                                                                          //   "Contact Name : ${item.contactName ?? ''}",
                                                                          //   textAlign:
                                                                          //       TextAlign.start,
                                                                          //   style:
                                                                          //       TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          // ),
                                                                          // const SizedBox(
                                                                          //   height:
                                                                          //       11,
                                                                          // ),
                                                                          // Row(
                                                                          //   mainAxisAlignment:
                                                                          //       MainAxisAlignment.spaceBetween,
                                                                          //   children: [
                                                                          // Text(
                                                                          //   "Mobile : ${item.mobile ?? ''}",
                                                                          //   textAlign:
                                                                          //       TextAlign.start,
                                                                          //   style:
                                                                          //       TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                          // ),
                                                                          // Row(
                                                                          //   children: [
                                                                          //     InkWell(
                                                                          //       onTap: () {
                                                                          //         leadController.whatsAppLaunch(item.mobile ?? '');
                                                                          //       },
                                                                          //       child: SvgPicture.asset(
                                                                          //         AppIcons.whatsapp,
                                                                          //         color: Colors.grey.shade900,
                                                                          //         height: 20,
                                                                          //         width: 20,
                                                                          //       ),
                                                                          //     ),
                                                                          //     SizedBox(
                                                                          //       width: 15,
                                                                          //     ),
                                                                          //     InkWell(
                                                                          //       onTap: () {
                                                                          //         controller.phoneCallLaunch(item.mobile ?? '');
                                                                          //       },
                                                                          //       child: SvgPicture.asset(
                                                                          //         AppIcons.phone,
                                                                          //         height: 20,
                                                                          //         width: 20,
                                                                          //         color: Colors.grey.shade900,
                                                                          //       ),
                                                                          //     ),
                                                                          //   ],
                                                                          // ),
                                                                          //   ],
                                                                          // ),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Website : ${item.website ?? ''}",
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                              ),
                                                                              // InkWell(
                                                                              //   onTap: () {
                                                                              //     leadController.launchInBrowser(item.website ?? '');
                                                                              //   },
                                                                              //   child: SvgPicture.asset(
                                                                              //     AppIcons.www,
                                                                              //     color: Colors.grey.shade900,
                                                                              //     height: 20,
                                                                              //     width: 20,
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                11,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Email : ${item.email ?? ''}",
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(fontSize: 13, color: AppColors.mutedColor),
                                                                              ),
                                                                              // InkWell(
                                                                              //   onTap: () {
                                                                              //     controller.emailLaunch(item.email ?? '');
                                                                              //   },
                                                                              //   child: SvgPicture.asset(
                                                                              //     AppIcons.mail,
                                                                              //     color: Colors.grey.shade900,
                                                                              //     height: 20,
                                                                              //     width: 20,
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ]))))
                                                          ]))))));
                                }))
              ]))),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            leadController.cleardata();
            Get.toNamed(RouteManager.lead);
          },
          child: Icon(Icons.add),
          backgroundColor: AppColors.primary),
    );
  }

  DateTime get _now => DateTime.now();

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
                      controller: leadController.statusFilterController.value,
                      onTap: () {
                        _buildFilterDialog(context,
                            filterId: leadController.statusFilterId,
                            filterList: leadController.statusFilter);
                      },
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (homeController.user.value.isAdmin == true)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextFieldLabel('SalesPerson'),
                    Obx(
                      () => buildExpansionTextFields(
                        controller:
                            leadController.salesPersonFilterController.value,
                        onTap: () {
                          _buildFilterDialog(context,
                              filterId: leadController.salesPersonFilterId,
                              filterList: leadController.salesPersonFilter);
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
                  buildTextFieldLabel('Lead'),
                  Obx(
                    () => buildExpansionTextFields(
                      controller: leadController.leadIdFilterController.value,
                      onTap: () {
                        _buildFilterDialog(context,
                            filterId: leadController.leadFilterId,
                            filterList: leadController.leadFilter);
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
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: AppColors.mutedBlueColor,
                ),
                onPressed: () {
                  leadController.clearFilter();
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
                    // leadController.filterLeadSearchList();
                    leadController.getLeadList();
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
      {required String filterId, var filterList}) {
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
            content: FilterLeadDialogContent(
                filterId: filterId, filterList: filterList),
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

  Row buildTileTwoHeaderText(
      {required String firstTitle,
      required String firstText,
      required String secondTitle,
      required String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTileText(title: firstTitle, text: firstText)),
        SizedBox(
          width: 5,
        ),
        Expanded(child: _buildTileText(title: secondTitle, text: secondText))
      ],
    );
  }
}

Widget timeline(
  BuildContext context,
) {
  final actionStatusLogController = Get.put(LeadController());
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
                                          ],
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
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ));
              },
            ));
}

void showTimelineAlertDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                'Status Log',
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
        content: Container(
          width: double.maxFinite,
          child: timeline(context),
        ),
      );
    },
  );
}
