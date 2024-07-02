import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/enums.dart';

class CommonController extends GetxController {
  var commonFilterList = [].obs;
  var commonItemList = [].obs;
  selectOption(
      {required BuildContext context,
      required String heading,
      required var list,
      required FilterComboOptions options,
      }) async {
    var selectedComboItem;
    commonFilterList.value = list;
    commonItemList.value = list;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Center(
            child: Text(
              heading,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.all(8)),
                onChanged: (value) {
                  if (value.isEmpty) {
                    commonFilterList.value = commonItemList;
                  }
                  searchOptionList(value, commonItemList,options);
                },
                // onEditingComplete: () async {
                //   await changeFocus(context);
                // },
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: commonFilterList.length,
                      itemBuilder: (context, index) {
                        var item = commonFilterList[index];
                        return InkWell(
                          onTap: () {
                            selectedComboItem = item;
                            // Navigator.pop(context);
                            Navigator.pop(context);
                            // commonFilterList.value = list;
                            // return this.customer.value;
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                "${options == FilterComboOptions.Item? item.productId : item.code} - ${ options == FilterComboOptions.Item? item.description : item.name}",
                                minFontSize: 12,
                                maxFontSize: 16,
                                style: TextStyle(
                                  color: AppColors.mutedColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
    return selectedComboItem;
  }

  searchOptionList(String value, var list, FilterComboOptions options) {
    commonFilterList.value = list.value
        .where((element) =>
            (options == FilterComboOptions.Item? element.productId : element.code).toLowerCase().contains(value.toLowerCase()) ||
            ( options == FilterComboOptions.Item? element.description : element.name).toLowerCase().contains(value.toLowerCase()) as bool)
        .toList();
    // commonFilterList.value = list.value.from();
  }
}
