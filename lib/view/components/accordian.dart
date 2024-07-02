import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class Accordian {
  static gfaccordian(
      {required List<Widget> content,
      required String title,
      required bool showAccordian,
      required Function(dynamic) ontoggleCollapsed}) {
    return GFAccordion(
        title: title,
        showAccordion: showAccordian,
        titleBorderRadius: BorderRadius.circular(5),
        expandedTitleBackgroundColor: AppColors.primary,
        collapsedTitleBackgroundColor: AppColors.lightGrey,
        collapsedIcon:
            const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
        expandedIcon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        textStyle: TextStyle(
          color: showAccordian == true ? AppColors.white : AppColors.primary,
        ),
        onToggleCollapsed: ontoggleCollapsed,
        // contentBackgroundColor: AppColors.mutedBlueColor,
        titlePadding: EdgeInsets.only(right: 5, top: 5, bottom: 5, left: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        contentChild: Container(
          margin: EdgeInsets.only(top: 15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: content,
          ),
        ));
  }
}
