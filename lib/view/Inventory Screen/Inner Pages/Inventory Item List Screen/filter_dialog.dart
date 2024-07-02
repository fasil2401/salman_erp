import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Inventory%20Controls/inventory_item_list_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDiailog extends StatelessWidget {
  FilterDiailog({
    required this.filterList,
    required this.filterId,
    super.key,
  });
  List<dynamic> filterList;
  final itemListController = Get.put(ItemListController());
  String filterId;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemListController.filterSearchList.value = filterList;
      itemListController.update();
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
                itemListController.searchFilter(
                  filterId: filterId,
                  value: value,
                );
              },
              // onEditingComplete: () async {
              //   await itemListController.changeFocus(context);
              // },
              isSearch: true),
          Flexible(
            child: GetBuilder<ItemListController>(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _.filterSearchList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {


                        _.selectFilterValue(

                            filterId: filterId,
                           value:
                           "${_.filterSearchList[index].code}${filterId == 'locationFilterId' ? '- ${_.filterSearchList[index].name}' : ""}");

                           //value: "${_.filterSearchList[index].code} - ${_.filterSearchList[index].name}");

                        //    if (filterId != _.statusFilterId) {
                        Navigator.pop(context);
                        //  }
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    "${_.filterSearchList[index].code} - ${_.filterSearchList[index].name}",
                                    minFontSize: 8,
                                    maxFontSize: 14,
                                    style: const TextStyle(
                                      color: AppColors.mutedColor,
                                    ),
                                  ),
                                ),
                                // filterId == _.statusFilterId &&
                                //         _.statusFilterList
                                //             .contains(_.filterSearchList[index])
                                //     ? const Icon(
                                //         Icons.check,
                                //         size: 15,
                                //         color: AppColors.primary,
                                //       )
                                //     : Container()
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
