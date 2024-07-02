import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/extensions.dart';
import 'package:axolon_erp/view/components/accordian.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
    as helper;

import '../../controller/app controls/home_controller.dart';
import '../../services/enums.dart';

class CommonFilterControls {
  static String allSelectedText = 'All Selected';

  static String getJsonListFilter(TextEditingController txtController,
      bool isRange, var filterList, bool isProduct) {
    return txtController.text == CommonFilterControls.allSelectedText
        ? ''
        : !isRange
            ? filterList.isEmpty
                ? ""
                : "'${filterList.map((element) => isProduct ? element.productId.toString() : element.code.toString()).join("','")}'"
            : "";
  }

  static Widget buildPdfView(Uint8List bytes) {
    return PDFView(
      pdfData: bytes,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageSnap: false,
      pageFling: false,
      fitPolicy: FitPolicy.WIDTH,
    );
  }

  static Widget buildEmptyPlaceholder() {
    return Container(
      child: Center(child: Text('No Data Found!')),
    );
  }

  static AppBar reportAppbar(
      {required String baseString, required String name}) {
    return AppBar(
      title: Text(name),
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (item) =>
              handleClickOnAppBar(item, baseString: baseString, name: name),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
          position: PopupMenuPosition.under,
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              padding: const EdgeInsets.all(0),
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.print_outlined,
                      size: 20,
                      color: AppColors.mutedColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Print to PDF'),
                  ),
                ],
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              padding: const EdgeInsets.all(0),
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.share,
                      size: 20,
                      color: AppColors.mutedColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Share'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static void handleClickOnAppBar(int item,
      {required String baseString, required String name}) {
    switch (item) {
      case 0:
        exportDataGridToPdf(
            shareorsave: "share", baseString: baseString, name: name);
        break;
      case 1:
        exportDataGridToPdf(
            shareorsave: "save", baseString: baseString, name: name);
        break;
    }
  }

  static Future<void> exportDataGridToPdf(
      {required String shareorsave,
      required String baseString,
      required String name}) async {
    final List<int> bytes = base64.decode(baseString);
    if (shareorsave == "share") {
      await helper.FileSaveHelper.saveAndLaunchFile(bytes, '${name}.pdf');
    } else if (shareorsave == "save") {
      helper.FileSaveHelper.saveAndShareFile(bytes, '${name}.pdf');
    }
  }

  static String getJsonFromToFilter(
      bool isFrom, bool isRange, bool isProduct, var filterList) {
    return "${isRange ? (isFrom ? (isProduct ? filterList[0].productId : filterList[0].code) : (isProduct ? filterList[filterList.length - 1].productId : filterList[filterList.length - 1].code)) : ""}";
  }

  static Widget buildDateRageDropdown(
    BuildContext context, {
    required Object dropValue,
    required Function(dynamic) onChanged,
    required TextEditingController fromController,
    required TextEditingController toController,
    required Function() onTapFrom,
    required Function() onTapTo,
    required bool isFromEnable,
    required bool isToEnable,
    bool isClosing = true,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                child: DropdownButtonFormField2(
              isDense: true,
              value: dropValue,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Dates',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
                // contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
              ),
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: DateRangeSelector.dateRange
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              onSaved: (value) {},
            )),
            Visibility(
              visible: isClosing,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Card(
                      child: Center(
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.mutedColor,
                    ),
                  ))),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Flexible(
              child: _buildTextFeild(
                controller: fromController,
                label: 'From Date',
                enabled: isFromEnable,
                isDate: true,
                onTap: onTapFrom,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: _buildTextFeild(
                controller: toController,
                label: 'To Date',
                enabled: isToEnable,
                isDate: true,
                onTap: onTapTo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildLocationCombo(
    BuildContext context, {
    required Object groupValue,
    required Function(dynamic) onChanged,
    required TextEditingController fromController,
    required TextEditingController toController,
    required TextEditingController singleController,
    required Function() onTapFrom,
    required Function() onTapTo,
    required Function() onTapSingle,
    required bool isMultiple,
    required bool isSingle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Flexible(
                child: RadioListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text("All"),
                    value: "all",
                    groupValue: groupValue,
                    onChanged: onChanged)),
            Flexible(
                child: RadioListTile(
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              title: Text("Single"),
              value: "single",
              groupValue: groupValue,
              onChanged: onChanged,
            )),
            Flexible(
                child: RadioListTile(
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              title: Text("Range"),
              value: "range",
              groupValue: groupValue,
              onChanged: onChanged,
            )),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Visibility(
          visible: isMultiple,
          child: Row(
            children: [
              Flexible(
                child: _buildTextFeild(
                  controller: fromController,
                  label: 'From',
                  enabled: true,
                  isDate: false,
                  onTap: onTapFrom,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: _buildTextFeild(
                  controller: toController,
                  label: 'To',
                  enabled: true,
                  isDate: false,
                  onTap: onTapTo,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isSingle,
          child: _buildTextFeild(
            controller: singleController,
            label: 'Location',
            enabled: true,
            isDate: false,
            onTap: onTapSingle,
          ),
        ),
      ],
    );
  }

  static Widget buildCustomerFilter(
    BuildContext context, {
    required bool isAccordionOpen,
    required Function(dynamic) onToggle,
    required TextEditingController customerController,
    required TextEditingController classController,
    required TextEditingController groupController,
    required TextEditingController areaController,
    required TextEditingController countryController,
    required Function() onTapCustomer,
    required Function() onTapClass,
    required Function() onTapGroup,
    required Function() onTapArea,
    required Function() onTapCountry,
  }) {
    return Accordian.gfaccordian(
      content: [
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
          suffixicon: true,
          readonly: true,
          keyboardtype: TextInputType.text,
          label: "Customers",
          ontap: onTapCustomer,
          controller: customerController,
        ),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Class",
            ontap: onTapClass,
            controller: classController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Group",
            ontap: onTapGroup,
            controller: groupController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Area",
            ontap: onTapArea,
            controller: areaController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Country",
            ontap: onTapCountry,
            controller: countryController),
      ],
      title: "Customers",
      showAccordian: isAccordionOpen,
      ontoggleCollapsed: onToggle,
    );
  }

  static Widget buildSalesPersonrFilter(
    BuildContext context, {
    required bool isAccordionOpen,
    required Function(dynamic) onToggle,
    required TextEditingController salespersonController,
    required TextEditingController divisionController,
    required TextEditingController groupController,
    required TextEditingController areaController,
    required TextEditingController countryController,
    required Function() onTapSalesperson,
    required Function() onTapDivision,
    required Function() onTapGroup,
    required Function() onTapArea,
    required Function() onTapCountry,
  }) {
    return Accordian.gfaccordian(
      content: [
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
          suffixicon: true,
          readonly: true,
          keyboardtype: TextInputType.text,
          label: "Salespersons",
          ontap: onTapSalesperson,
          controller: salespersonController,
        ),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Division",
            ontap: onTapDivision,
            controller: divisionController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Group",
            ontap: onTapGroup,
            controller: groupController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Area",
            ontap: onTapArea,
            controller: areaController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Country",
            ontap: onTapCountry,
            controller: countryController),
      ],
      title: "Salespersons",
      showAccordian: isAccordionOpen,
      ontoggleCollapsed: onToggle,
    );
  }

  static Widget buildProductFilter(
    BuildContext context, {
    required bool isAccordionOpen,
    required Function(dynamic) onToggle,
    required TextEditingController productController,
    required TextEditingController classController,
    required TextEditingController categoryController,
    required TextEditingController brandController,
    required TextEditingController manufacturerController,
    required TextEditingController originController,
    required TextEditingController styleController,
    required Function() onTapProduct,
    required Function() onTapClass,
    required Function() onTapCategory,
    required Function() onTapBrand,
    required Function() onTapManufacturer,
    required Function() onTapOrigin,
    required Function() onTapStyle,
  }) {
    return Accordian.gfaccordian(
      content: [
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
          suffixicon: true,
          readonly: true,
          keyboardtype: TextInputType.text,
          label: "Products",
          ontap: onTapProduct,
          controller: productController,
        ),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Item Class",
            ontap: onTapClass,
            controller: classController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Item Category",
            ontap: onTapCategory,
            controller: categoryController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "ItemBrand",
            ontap: onTapBrand,
            controller: brandController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Manufacturer",
            ontap: onTapManufacturer,
            controller: manufacturerController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Origin",
            ontap: onTapOrigin,
            controller: originController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Style",
            ontap: onTapStyle,
            controller: styleController),
      ],
      title: "Products",
      showAccordian: isAccordionOpen,
      ontoggleCollapsed: onToggle,
    );
  }

  static Widget buildEmployeeFilter(
    BuildContext context, {
    required bool isAccordionOpen,
    required Function(dynamic) onToggle,
    required TextEditingController employeeController,
    required TextEditingController departmentController,
    required TextEditingController locationController,
    required TextEditingController typeController,
    required TextEditingController divisionController,
    required TextEditingController sponsorController,
    required TextEditingController groupController,
    required TextEditingController gradeController,
    required TextEditingController positionController,
    required TextEditingController bankController,
    required TextEditingController accountController,
    required Function() onTapEmployee,
    required Function() onTapDepartment,
    required Function() onTapLocation,
    required Function() onTapType,
    required Function() onTapDivision,
    required Function() onTapSponsor,
    required Function() onTapGroup,
    required Function() onTapGrade,
    required Function() onTapPosition,
    required Function() onTapBank,
    required Function() onTapAccount,
  }) {
    return Accordian.gfaccordian(
      content: [
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
          suffixicon: true,
          readonly: true,
          keyboardtype: TextInputType.text,
          label: "Employees",
          ontap: onTapEmployee,
          controller: employeeController,
        ),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Department",
            ontap: onTapDepartment,
            controller: departmentController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Location",
            ontap: onTapLocation,
            controller: locationController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Type",
            ontap: onTapType,
            controller: typeController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Division",
            ontap: onTapDivision,
            controller: divisionController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Sponsor",
            ontap: onTapSponsor,
            controller: sponsorController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Group",
            ontap: onTapGroup,
            controller: groupController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Grade",
            ontap: onTapGrade,
            controller: gradeController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Position",
            ontap: onTapPosition,
            controller: positionController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Bank",
            ontap: onTapBank,
            controller: bankController),
        SizedBox(
          height: 15,
        ),
        CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.text,
            label: "Account",
            ontap: onTapAccount,
            controller: accountController),
      ],
      title: "Employees",
      showAccordian: isAccordionOpen,
      ontoggleCollapsed: onToggle,
    );
  }

  static Widget buildLocationFilter(BuildContext context,
      {required Function() onTapLocation,
      required TextEditingController locationController}) {
    return CommonTextField.textfield(
      suffixicon: true,
      readonly: true,
      keyboardtype: TextInputType.text,
      label: "Location",
      ontap: onTapLocation,
      controller: locationController,
    );
  }

  static Widget buildItemBrandFilter(BuildContext context,
      {required Function() onTapBrand,
      required TextEditingController brandController}) {
    return CommonTextField.textfield(
      suffixicon: true,
      readonly: true,
      keyboardtype: TextInputType.text,
      label: "Item Brand",
      ontap: onTapBrand,
      controller: brandController,
    );
  }

  static Widget buildItemCategoryFilter(BuildContext context,
      {required Function() onTapCategory,
      required TextEditingController categoryController}) {
    return CommonTextField.textfield(
      suffixicon: true,
      readonly: true,
      keyboardtype: TextInputType.text,
      label: "Item Categories",
      ontap: onTapCategory,
      controller: categoryController,
    );
  }

  static Future<DateTime?> getCalender(
      BuildContext context, DateTime initialDate) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    return newDate;
  }

  static Future<TimeOfDay?> getTimePicker(
      BuildContext context, TimeOfDay initialtime) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initialtime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.primary,
            ),
            dialogBackgroundColor: AppColors.mutedBlueColor,
          ),
          child: child!,
        );
      },
    );
    return newTime;
  }

  static Widget buildDisplayButton(
      {required Function() onTap, required bool isLoading}) {
    return ElevatedButton(
      onPressed: onTap,
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              'Display',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static FloatingActionButton buildFilterButton(BuildContext context,
      {required Widget filter}) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        buildBottomSheet(context, filter);
      },
      child: SvgPicture.asset(AppIcons.filter,
          color: Colors.white, height: 20, width: 20),
    );
  }

  static Future<dynamic> buildBottomSheet(BuildContext context, Widget filter) {
    return showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(child: filter)),
            ));
  }

  static TextField _buildTextFeild(
      {required String label,
      required Function() onTap,
      required bool enabled,
      required bool isDate,
      required TextEditingController controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      onTap: onTap,
      style: TextStyle(
        fontSize: 14,
        color: enabled ? AppColors.primary : AppColors.mutedColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
        ),
        isCollapsed: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffix: Icon(
          isDate ? Icons.calendar_month : Icons.location_pin,
          size: 15,
          color: enabled ? AppColors.primary : AppColors.mutedColor,
        ),
      ),
    );
  }

  static SwitchListTile buildToggleTile(
      {required String toggleText,
      required bool switchValue,
      required Function(bool? value) onToggled}) {
    return SwitchListTile(
        value: switchValue,
        activeColor: AppColors.primary,
        title: AutoSizeText(
          toggleText,
          minFontSize: 12,
          maxFontSize: 14,
          style: TextStyle(
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        onChanged: onToggled);
  }

  static Widget buildReportTypeDropdown(
      {String? title,
      required String selectedValue,
      required List<String> reportTypes,
      required Function(dynamic) onChanged}) {
    return DropdownButtonFormField2(
      isDense: true,
      alignment: Alignment.centerLeft,
      value: reportTypes.firstWhere((element) => element == selectedValue),
      decoration: InputDecoration(
        isCollapsed: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title != null ? title : 'Report Type',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Rubik',
            ),
          ),
        ),
        // contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      isExpanded: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.primary,
      ),
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: reportTypes
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: AutoSizeText(
                item,
                minFontSize: 10,
                maxFontSize: 14,
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      onSaved: (value) {},
    );
  }

  static Flexible buildIncrDecTextBox(
      {required TextEditingController quantityControl,
      required bool isEdit,
      required var quantity}) {
    var edit = isEdit.obs;
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              if (quantity.value > 1) {
                edit.value = false;
                quantity.value--;
              }
            },
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 15,
              child: const Center(child: Icon(Icons.remove)),
            ),
          ),
          Obx(() {
            quantityControl.selection = TextSelection.fromPosition(
                TextPosition(offset: quantityControl.text.length));
            return Flexible(
              child: edit.value
                  ? TextField(
                      autofocus: false,
                      controller: quantityControl,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      onChanged: (value) {
                        value.isNotEmpty
                            ? quantity.value = double.parse(value)
                            : quantity.value = 1.0;
                      },
                      onTap: () => quantityControl.selectAll(),
                    )
                  : Obx(
                      () => InkWell(
                        onTap: () {
                          edit.value = !edit.value;
                          quantityControl.text = quantity.value.toString();
                        },
                        child: Text(quantity.value.toString()),
                      ),
                    ),
            );
          }),
          InkWell(
            onTap: () {
              edit.value = false;
              quantity.value++;
            },
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 15,
              child: const Center(child: Icon(Icons.add)),
            ),
          ),
        ],
      ),
    );
  }

  static Future<dynamic> OnTapCommon(
      {required HomeController homeController,
      required BuildContext context,
      required TextEditingController txtController,
      required FilterComboOptions filterOptions,
      required var selectedList,
      required var isRange,
      required var isProduct}) async {
    var feedback = await homeController.selectCombination(
        context: context,
        controller: txtController,
        option: filterOptions,
        selectedList: selectedList.value);
    selectedList.value = List.from(feedback['list']);
    isRange.value = feedback['isRange'];
    feedback['isRange'] == false
        ? txtController.text = selectedList.value
            .map((element) => isProduct
                ? element.productId.toString()
                : element.code.toString())
            .join(', ')
        : txtController.text =
            "${isProduct ? selectedList.value[0].productId : selectedList.value[0].code} ... ${isProduct ? selectedList.value[selectedList.value.length - 1].productId : selectedList.value[selectedList.value.length - 1].code}";
    if (feedback['isAll']) {
      txtController.text = CommonFilterControls.allSelectedText;
    }
  }
}
