import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Logistics%20Controller/container_tracker__controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/lead_controller.dart';
import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterLeadDialogContent extends StatelessWidget {
  FilterLeadDialogContent({
    required this.filterList,
    required this.filterId,
    super.key,
  });
  List<dynamic> filterList;
  final leadController = Get.put(LeadController());
  final homeController = Get.put(HomeController());
  String filterId;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leadController.filterSearchList.value = filterList;
      leadController.update();
    });
    return SizedBox(
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
                leadController.searchFilter(
                  filterId: filterId,
                  value: value,
                );
              },
              // onEditingComplete: () async {
              //   await leadController.changeFocus(context);
              // },
              isSearch: true),
          Flexible(
            child: GetBuilder<LeadController>(
              builder: (_) {
                return (filterId == _.statusFilterId
                        ? _.isLoading.value
                        : homeController.isLoading.value)
                    ? popShimmer()
                    : filterList.isEmpty
                        ? Text("No Data")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _.filterSearchList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  _.selectFilterValue(
                                      filterId: filterId,
                                      value: filterId != _.salesPersonFilterId
                                          ? "${_.filterSearchList[index]}"
                                          : _.filterSearchList[index].code);

                                  if (filterId == _.leadFilterId) {
                                    Navigator.pop(context);
                                  }
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          // if (filterId == _.statusFilterId)
                                          //   Container(
                                          //     height: 12,
                                          //     width: 12,
                                          //     margin:
                                          //         EdgeInsets.only(right: 10),
                                          //     decoration: BoxDecoration(
                                          //       border: Border.all(
                                          //           color: AppColors.lightGrey,
                                          //           width: 0.4),
                                          //       borderRadius:
                                          //           BorderRadius.circular(2),
                                          //       color: _.filterSearchList[index]
                                          //                       .hexColorCode ==
                                          //                   null ||
                                          //               _
                                          //                       .filterSearchList[
                                          //                           index]
                                          //                       .hexColorCode ==
                                          //                   ''
                                          //           ? Colors.white
                                          //           : Color(int.parse(
                                          //                   '${_.filterSearchList[index].hexColorCode!.split('#')[1]}',
                                          //                   radix: 16) +
                                          //               0xFF000000),
                                          //     ),
                                          //   ),
                                          Expanded(
                                            child: AutoSizeText(
                                              filterId != _.salesPersonFilterId
                                                  ? "${_.filterSearchList[index]}"
                                                  : "${_.filterSearchList[index].code} - ${_.filterSearchList[index].name}",
                                              minFontSize: 8,
                                              maxFontSize: 14,
                                              style: const TextStyle(
                                                color: AppColors.mutedColor,
                                              ),
                                            ),
                                          ),
                                          filterId == _.statusFilterId &&
                                                      _.statusFilterList
                                                          .contains(
                                                              _.filterSearchList[
                                                                  index]
                                                              // .code
                                                              ) ||
                                                  filterId ==
                                                          _
                                                              .salesPersonFilterId &&
                                                      _.salesPersonFilterList
                                                          .contains(_
                                                              .filterSearchList[
                                                                  index]
                                                              .code)
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: AppColors.primary,
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
              },
            ),
          )
        ],
      ),
    );
  }
}
