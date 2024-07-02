// import 'dart:convert';
// import 'dart:developer';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:axolon_erp/controller/app%20controls/home_controller.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:pdf/pdf.dart' as pdf;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:sizer/sizer.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_datagrid_export/export.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:axolon_erp/utils/File%20Save%20Helper/file_save_helper.dart'
//     as helper;

// import '../../../../controller/app controls/Sales Controls/sales_profitability_controller.dart';
// import '../../../../services/enums.dart';
// import '../../../../utils/Calculations/date_range_selector.dart';
// import '../../../../utils/Calculations/items_range_selector.dart';
// import '../../../../utils/Calculations/report_type_selector.dart';
// import '../../../../utils/constants/asset_paths.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/snackbar.dart';
// import '../../../../utils/date_formatter.dart';
// import '../../../Inventory Screen/components/expandedItemsRow.dart';
// import '../../../components/common_text_field.dart';

// class SalesProfitabilityFilterScreen extends StatefulWidget {
//   SalesProfitabilityFilterScreen({super.key});

//   @override
//   State<SalesProfitabilityFilterScreen> createState() =>
//       _SalesProfitabilityFilterScreenState();
// }

// class _SalesProfitabilityFilterScreenState extends State<SalesProfitabilityFilterScreen> {
//   final salesProfitabilityController = Get.put(SalesProfitabilityController());
//   final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
//   final ScrollController _scrollController = ScrollController();
//   final homeController = Get.put(HomeController());

// var isRange = false.obs;

//   TextEditingController itemsControl = TextEditingController();

// TextEditingController customersControl = TextEditingController();
//   TextEditingController classControl = TextEditingController();
//   TextEditingController groupControl = TextEditingController();
//   TextEditingController areaControl = TextEditingController();
//   TextEditingController countryControl = TextEditingController();

//   var selectedItemList = {}.obs;

// var selectedCustomeList = {}.obs;
//   var selectedClassList = {}.obs;
//   var selectedGroupList = {}.obs;
//   var selectedAreaList = {}.obs;
//   var selectedCountryList = {}.obs;

//   var selectedSysdocValue;
//   var selectedItemTypeValue;
//   @override
//   void initState() {
    
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sales Profitability Filter'),
//       ),
//       body:      SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Obx(() => DropdownButtonFormField2(
//                           isDense: true,
//                           value: DateRangeSelector.dateRange[
//                               salesProfitabilityController.dateIndex.value],
//                           decoration: InputDecoration(
//                             isCollapsed: true,
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             label: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Dates',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: 'Rubik',
//                                 ),
//                               ),
//                             ),
//                             // contentPadding: EdgeInsets.zero,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           isExpanded: true,
//                           icon: Icon(
//                             Icons.arrow_drop_down,
//                             color: AppColors.primary,
//                           ),
//                           buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                           dropdownDecoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           items: DateRangeSelector.dateRange
//                               .map(
//                                 (item) => DropdownMenuItem(
//                                   value: item,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         item.label,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: 'Rubik',
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (value) {
//                             selectedSysdocValue = value;
//                             salesProfitabilityController.selectDateRange(
//                                 selectedSysdocValue.value,
//                                 DateRangeSelector.dateRange
//                                     .indexOf(selectedSysdocValue));
//                           },
//                           onSaved: (value) {},
//                         )),
//                   ),
//                   // IconButton(
//                   //     onPressed: () {
//                   //       Navigator.pop(context);
//                   //     },
//                   //     icon: Card(
//                   //         child: Center(
//                   //       child: Icon(
//                   //         Icons.close,
//                   //         size: 15,
//                   //         color: AppColors.mutedColor,
//                   //       ),
//                   //     )))
                
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Obx(
//                       () => _buildTextFeild(
//                         controller: TextEditingController(
//                           text: DateFormatter.dateFormat
//                               .format(salesProfitabilityController.fromDate.value)
//                               .toString(),
//                         ),
//                         label: 'From Date',
//                         enabled: salesProfitabilityController.isFromDate.value,
//                         isDate: true,
//                         onTap: () {
//                           salesProfitabilityController.selectDate(context, true);
//                         },
//                         onChange: () {},
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Flexible(
//                     child: Obx(
//                       () => _buildTextFeild(
//                           controller: TextEditingController(
//                             text: DateFormatter.dateFormat
//                                 .format(salesProfitabilityController.toDate.value)
//                                 .toString(),
//                           ),
//                           label: 'To Date',
//                           enabled: salesProfitabilityController.isToDate.value,
//                           isDate: true,
//                           onTap: () {
//                             salesProfitabilityController.selectDate(context, false);
//                           },
//                           onChange: () {}),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Obx(() => DropdownButtonFormField2(
//                           isDense: true,
//                           value: ReportTypeSelector.reportRange[
//                               salesProfitabilityController.catalogueIndex.value],
//                           decoration: InputDecoration(
//                             isCollapsed: true,
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             label: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 'Report Type',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: 'Rubik',
//                                 ),
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           isExpanded: true,
//                           icon: Icon(
//                             Icons.arrow_drop_down,
//                             color: AppColors.primary,
//                           ),
//                           buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                           dropdownDecoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           items: ReportTypeSelector.reportRange
//                               .map(
//                                 (item) => DropdownMenuItem(
//                                   value: item,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         item.label,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: 'Rubik',
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (value) {},
//                           onSaved: (value) {},
//                         )),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15,
//               ),
        
//               //Items start
             
//         //        Container(
//         //         child:       Column(children: [
//         //   Row(
//         //         children: [
//         //           Flexible(
//         //             child: Obx(() => DropdownButtonFormField2(
//         //                   isDense: true,
//         //                   value: ItemsRangeSelector.itemRange[
//         //                       salesProfitabilityController.catalogueIndex.value],
//         //                   decoration: InputDecoration(
//         //                     isCollapsed: true,
//         //                     contentPadding: const EdgeInsets.symmetric(vertical: 5),
//         //                     label: Padding(
//         //                       padding: const EdgeInsets.all(8.0),
//         //                       child: Text(
//         //                         'Items',
//         //                         style: TextStyle(
//         //                           fontSize: 14,
//         //                           color: AppColors.primary,
//         //                           fontWeight: FontWeight.w400,
//         //                           fontFamily: 'Rubik',
//         //                         ),
//         //                       ),
//         //                     ),
//         //                     border: OutlineInputBorder(
//         //                       borderRadius: BorderRadius.circular(10),
//         //                     ),
//         //                   ),
//         //                   isExpanded: true,
//         //                   icon: Icon(
//         //                     Icons.arrow_drop_down,
//         //                     color: AppColors.primary,
//         //                   ),
//         //                   buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//         //                   dropdownDecoration: BoxDecoration(
//         //                     borderRadius: BorderRadius.circular(15),
//         //                   ),
//         //                   items: ItemsRangeSelector.itemRange
//         //                       .map(
//         //                         (item) => DropdownMenuItem(
//         //                           value: item,
//         //                           child: Row(
//         //                             mainAxisAlignment: MainAxisAlignment.start,
//         //                             crossAxisAlignment: CrossAxisAlignment.start,
//         //                             children: [
//         //                               Text(
//         //                                 item.label,
//         //                                 style: TextStyle(
//         //                                   fontSize: 14,
//         //                                   color: AppColors.primary,
//         //                                   fontWeight: FontWeight.w400,
//         //                                   fontFamily: 'Rubik',
//         //                                 ),
//         //                               ),
//         //                             ],
//         //                           ),
//         //                         ),
//         //                       )
//         //                       .toList(),
//         //                   onChanged: (value) {
//         //                     selectedItemTypeValue = value;
//         //                     salesProfitabilityController.selectItemTypeRange(
//         //                       selectedItemTypeValue.value,'item'
//         //                     );
//         //                   },
//         //                   onSaved: (value) {},
//         //                 )),
//         //           ),
//         //         ],
//         //       ),
//         //       SizedBox(
//         //         height: 15,
//         //       ),
//         //        Obx(() => Visibility(
//         //             child: Row(
//         //               children: [
//         //                 Flexible(
//         //                   child: _buildTextFeild(
//         //                       controller: TextEditingController(
//         //                         text: salesProfitabilityController
//         //                                 .fromProduct.value.description ??
//         //                             ' ',
//         //                       ),
//         //                       label: 'From',
//         //                       enabled: true,
//         //                       isDate: false,
//         //                       onTap: () async {
//         //                         var product = await homeController.selectProduct(
//         //                           context: context,
//         //                         );
//         //                         if (product.productId != null) {
//         //                           log(product.productId.toString());
//         //                           salesProfitabilityController
//         //                               .selectFromProduct(product);
//         //                         }
//         //                       },
//         //                       onChange: () {
//         //                         // salesProfitabilityController.fromRange.value = fromRange.text;
//         //                       }),
//         //                 ),
//         //                 SizedBox(
//         //                   width: 10,
//         //                 ),
//         //                 Flexible(
//         //                   child: _buildTextFeild(
//         //                       controller: TextEditingController(
//         //                         text: salesProfitabilityController
//         //                                 .toProduct.value.description ??
//         //                             ' ',
//         //                       ),
//         //                       label: 'To',
//         //                       enabled: true,
//         //                       isDate: false,
//         //                       onTap: () async {
//         //                         var product = await homeController.selectProduct(
//         //                           context: context,
//         //                         );
//         //                         if (product.productId != null) {
//         //                           log(product.productId.toString());
//         //                           salesProfitabilityController
//         //                               .selectToProduct(product);
//         //                         }
//         //                       },
//         //                       onChange: () {
//         // // salesProfitabilityController.toRange.value = toRange.text;
//         //                       }),
//         //                 ),
//         //               ],
//         //             ),
//         //             visible: salesProfitabilityController.isShowItemFromTo.value,
//         //           )),
//         //       Obx(() => Visibility(
//         //             child: SizedBox(
//         //               height: 15,
//         //             ),
//         //             visible: salesProfitabilityController.isShowItemFromTo.value,
//         //           )),
//         //       Obx(() => Visibility(
//         //             child: Row(
//         //               children: [
//         //                 Flexible(
//         //                   child: _buildTextFeild(
//         //                       controller: TextEditingController(
//         //                         text: salesProfitabilityController
//         //                                 .fromProduct.value.description ??
//         //                             ' ',
//         //                       ),
//         //                       label: 'Single Item',
//         //                       enabled: true,
//         //                       isDate: false,
//         //                       onTap: () async {
//         //                         var product = await homeController.selectProduct(
//         //                           context: context,
//         //                         );
//         //                         if (product.productId != null) {
//         //                           log(product.productId.toString());
//         //                           salesProfitabilityController
//         //                               .selectFromProduct(product);
//         //                         }
//         //                       },
//         //                       onChange: () {
//         //                         // salesProfitabilityController.fromRange.value = fromRange.text;
//         //                       }),
//         //                 ),
//         //               ],
//         //             ),
//         //             visible: salesProfitabilityController.isShowItemSingle.value,
//         //           )),
//         //     Obx(() => Visibility(
//         //             child: SizedBox(
//         //               height: 15,
//         //             ),
//         //             visible: salesProfitabilityController.isShowItemSingle.value,
//         //           )),
        
//         //       ],),
             
//         //       ),
        
              
           
//         //items end
        
//         // New Items Start
      
//       Center(
//                   child: Text(
//                     "Items",
//                     style: TextStyle(
//                         color: AppColors.primary,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//       SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Items",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Class",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Category",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Brand",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Manufacture",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//         SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Origin",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//         SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Style",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
      
//         // New Items End
        
//         // Sales Persons Start
      
//       Center(
//                   child: Text(
//                     "Sales Persons",
//                     style: TextStyle(
//                         color: AppColors.primary,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//       SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Sales Person",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Division",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Group",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Area",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
//        SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Country",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
      
//         // Sales Persons End

//           // Customers Start
      
//       Center(
//                   child: Text(
//                     "Customers",
//                     style: TextStyle(
//                         color: AppColors.primary,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//        SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             height: 9.w,
//             child: CommonTextField.textfield(
//                 suffixicon: true,
//                 readonly: true,
//                 keyboardtype: TextInputType.text,
//                 label: "Customers",
//                 ontap: () async {
//                   selectedCustomeList.value =
//                       await homeController.selectCombination(
//                           context: context,
//                           controller: customersControl,
//                           option: FilterComboOptions.Customer,
//                           selectedList: selectedCustomeList['list']);
//                   selectedCustomeList['isRange'] == false
//                       ? customersControl.text = selectedCustomeList['list']
//                           .map((element) => element.code.toString())
//                           .join(', ')
//                       : customersControl.text =
//                           "${selectedCustomeList['list'][0].code} ... ${selectedCustomeList['list'][selectedCustomeList['list'].length - 1].code}";
//                 },
//                 controller: customersControl),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           SizedBox(
//             height: 9.w,
//             child: CommonTextField.textfield(
//                 suffixicon: true,
//                 readonly: true,
//                 keyboardtype: TextInputType.text,
//                 label: "Class",
//                 ontap: () async {
//                   selectedClassList.value = await homeController.selectCombination(
//                     context: context,
//                     controller: classControl,
//                     option: FilterComboOptions.Class,
//                   );
//                   selectedClassList['isRange'] == false
//                       ? classControl.text = selectedClassList['list']
//                           .map((element) => element.code.toString())
//                           .join(', ')
//                       : classControl.text =
//                           "${selectedClassList['list'][0].code} ... ${selectedClassList['list'][selectedClassList['list'].length - 1].code}";
//                 },
//                 controller: classControl),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           SizedBox(
//             height: 9.w,
//             child: CommonTextField.textfield(
//                 suffixicon: true,
//                 readonly: true,
//                 keyboardtype: TextInputType.text,
//                 label: "Group",
//                 ontap: () async {
//                   // log(selectedGroupList['list'].length.toString(),
//                   // name: 'listgroup');
//                   selectedGroupList.value = await homeController.selectCombination(
//                       context: context,
//                       controller: groupControl,
//                       option: FilterComboOptions.Group,
//                       selectedList: selectedGroupList['list']);
//                   selectedGroupList['isRange'] == false
//                       ? groupControl.text = selectedGroupList['list']
//                           .map((element) => element.code.toString())
//                           .join(', ')
//                       : groupControl.text =
//                           "${selectedGroupList['list'][0].code} ... ${selectedGroupList['list'][selectedGroupList['list'].length - 1].code}";
//                 },
//                 controller: groupControl),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           SizedBox(
//             height: 9.w,
//             child: CommonTextField.textfield(
//                 suffixicon: true,
//                 readonly: true,
//                 keyboardtype: TextInputType.text,
//                 label: "Area",
//                 ontap: () async {
//                   selectedAreaList.value = await homeController.selectCombination(
//                     context: context,
//                     controller: areaControl,
//                     option: FilterComboOptions.Area,
//                   );
//                   selectedAreaList['isRange'] == false
//                       ? areaControl.text = selectedAreaList['list']
//                           .map((element) => element.code.toString())
//                           .join(', ')
//                       : areaControl.text =
//                           "${selectedAreaList['list'][0].code} ... ${selectedAreaList['list'][selectedAreaList['list'].length - 1].code}";
//                 },
//                 controller: areaControl),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           SizedBox(
//             height: 9.w,
//             child: CommonTextField.textfield(
//                 suffixicon: true,
//                 readonly: true,
//                 keyboardtype: TextInputType.text,
//                 label: "Country",
//                 ontap: () async {
//                   selectedCountryList.value =
//                       await homeController.selectCombination(
//                     context: context,
//                     controller: countryControl,
//                     option: FilterComboOptions.Country,
//                   );
//                   selectedCountryList['isRange'] == false
//                       ? countryControl.text = selectedCountryList['list']
//                           .map((element) => element.code.toString())
//                           .join(', ')
//                       : countryControl.text =
//                           "${selectedCountryList['list'][0].code} ... ${selectedCountryList['list'][selectedCountryList['list'].length - 1].code}";
//                 },
//                 controller: countryControl),
//           ),
//          SizedBox(
//             height: 15,
//           ),
      
//         // Customers End
      
//       // Locations Start
      
//       Center(
//                   child: Text(
//                     "Locations",
//                     style: TextStyle(
//                         color: AppColors.primary,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//       SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 9.w,
//               child: CommonTextField.textfield(
//                   suffixicon: true,
//                   readonly: true,
//                   keyboardtype: TextInputType.text,
//                   label: "Location",
//                   ontap: () async {
//                     selectedItemList.value =
//                         await homeController.selectCombination(
//                       context: context,
//                       controller: itemsControl,
//                       option: FilterComboOptions.Item,
//                     );
//                     selectedItemList['isRange'] == false
//                         ? itemsControl.text = selectedItemList['list']
//                             .map((element) => element.productId.toString())
//                             .join(', ')
//                         : itemsControl.text =
//                             "${selectedItemList['list'][0].productId} ... ${selectedItemList['list'][selectedItemList['list'].length - 1].productId}";
                  
//                   },
//                   controller: itemsControl
//                   ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
      
       
      
//         // Locations End

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     salesProfitabilityController.getProductCatalog(
//                         context: context);
//                   },
//                   child:
//                       Obx(() => salesProfitabilityController.isLoadingReport.value
//                           ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.white),
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : Text(
//                               'Display',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             )),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
  
//       );
//   }

//   _buildFilter(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: DateRangeSelector.dateRange[
//                           salesProfitabilityController.dateIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Dates',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         // contentPadding: EdgeInsets.zero,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: DateRangeSelector.dateRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedSysdocValue = value;
//                         salesProfitabilityController.selectDateRange(
//                             selectedSysdocValue.value,
//                             DateRangeSelector.dateRange
//                                 .indexOf(selectedSysdocValue));
//                       },
//                       onSaved: (value) {},
//                     )),
//               ),
//               IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Card(
//                       child: Center(
//                     child: Icon(
//                       Icons.close,
//                       size: 15,
//                       color: AppColors.mutedColor,
//                     ),
//                   )))
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Row(
//             children: [
//               Flexible(
//                 child: Obx(
//                   () => _buildTextFeild(
//                     controller: TextEditingController(
//                       text: DateFormatter.dateFormat
//                           .format(salesProfitabilityController.fromDate.value)
//                           .toString(),
//                     ),
//                     label: 'From Date',
//                     enabled: salesProfitabilityController.isFromDate.value,
//                     isDate: true,
//                     onTap: () {
//                       salesProfitabilityController.selectDate(context, true);
//                     },
//                     onChange: () {},
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Flexible(
//                 child: Obx(
//                   () => _buildTextFeild(
//                       controller: TextEditingController(
//                         text: DateFormatter.dateFormat
//                             .format(salesProfitabilityController.toDate.value)
//                             .toString(),
//                       ),
//                       label: 'To Date',
//                       enabled: salesProfitabilityController.isToDate.value,
//                       isDate: true,
//                       onTap: () {
//                         salesProfitabilityController.selectDate(context, false);
//                       },
//                       onChange: () {}),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: ReportTypeSelector.reportRange[
//                           salesProfitabilityController.catalogueIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Report Type',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: ReportTypeSelector.reportRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {},
//                       onSaved: (value) {},
//                     )),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),

//           //Items start
         
//            Container(
//             child:       Column(children: [
//   Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: ItemsRangeSelector.itemRange[
//                           salesProfitabilityController.catalogueIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Items',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: ItemsRangeSelector.itemRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedItemTypeValue = value;
//                         salesProfitabilityController.selectItemTypeRange(
//                           selectedItemTypeValue.value,'item'
//                         );
//                       },
//                       onSaved: (value) {},
//                     )),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
//            Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'From',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .toProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'To',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectToProduct(product);
//                             }
//                           },
//                           onChange: () {
// // salesProfitabilityController.toRange.value = toRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowItemFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowItemFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'Single Item',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowItemSingle.value,
//               )),
//         Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowItemSingle.value,
//               )),

//           ],),
     
//           ),

          
       
// //items end


//        //sales persons start  
//     Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: ItemsRangeSelector.itemRange[
//                           salesProfitabilityController.catalogueIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Sales Persons',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: ItemsRangeSelector.itemRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedItemTypeValue = value;
//                         salesProfitabilityController.selectItemTypeRange(
//                           selectedItemTypeValue.value,'salesperson'
//                         );
//                       },
//                       onSaved: (value) {},
//                     )),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
       
        
//   Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'From',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .toProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'To',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectToProduct(product);
//                             }
//                           },
//                           onChange: () {
// // salesProfitabilityController.toRange.value = toRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowSalesPersonFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowSalesPersonFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'Single Sales Person',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowSalesPersonSingle.value,
//               )),
//         Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowSalesPersonSingle.value,
//               )),

// //Sales Persons end

// //Customers start
//              Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: ItemsRangeSelector.itemRange[
//                           salesProfitabilityController.catalogueIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Customers',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: ItemsRangeSelector.itemRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedItemTypeValue = value;
//                         salesProfitabilityController.selectItemTypeRange(
//                           selectedItemTypeValue.value,'customer'
//                         );
//                       },
//                       onSaved: (value) {},
//                     )),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
       
             
//   Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'From',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .toProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'To',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectToProduct(product);
//                             }
//                           },
//                           onChange: () {
// // salesProfitabilityController.toRange.value = toRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowCustomerFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowCustomerFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'Single Customer',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowCustomerSingle.value,
//               )),
//         Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowCustomerSingle.value,
//               )),


// //Customers end

// //Location start

//     Row(
//             children: [
//               Flexible(
//                 child: Obx(() => DropdownButtonFormField2(
//                       isDense: true,
//                       value: ItemsRangeSelector.itemRange[
//                           salesProfitabilityController.catalogueIndex.value],
//                       decoration: InputDecoration(
//                         isCollapsed: true,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                         label: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Locations',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Rubik',
//                             ),
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       isExpanded: true,
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.primary,
//                       ),
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: ItemsRangeSelector.itemRange
//                           .map(
//                             (item) => DropdownMenuItem(
//                               value: item,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.label,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Rubik',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedItemTypeValue = value;
//                         salesProfitabilityController.selectItemTypeRange(
//                           selectedItemTypeValue.value,'location'
//                         );
//                       },
//                       onSaved: (value) {},
//                     )),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
       
             
//   Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'From',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .toProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'To',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectToProduct(product);
//                             }
//                           },
//                           onChange: () {
// // salesProfitabilityController.toRange.value = toRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowLocationFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowLocationFromTo.value,
//               )),
//           Obx(() => Visibility(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: _buildTextFeild(
//                           controller: TextEditingController(
//                             text: salesProfitabilityController
//                                     .fromProduct.value.description ??
//                                 ' ',
//                           ),
//                           label: 'Single Location',
//                           enabled: true,
//                           isDate: false,
//                           onTap: () async {
//                             var product = await homeController.selectProduct(
//                               context: context,
//                             );
//                             if (product.productId != null) {
//                               log(product.productId.toString());
//                               salesProfitabilityController
//                                   .selectFromProduct(product);
//                             }
//                           },
//                           onChange: () {
//                             // salesProfitabilityController.fromRange.value = fromRange.text;
//                           }),
//                     ),
//                   ],
//                 ),
//                 visible: salesProfitabilityController.isShowLocationSingle.value,
//               )),
//         Obx(() => Visibility(
//                 child: SizedBox(
//                   height: 15,
//                 ),
//                 visible: salesProfitabilityController.isShowLocationSingle.value,
//               )),


// //Location end

//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton(
//               onPressed: () {
//                 salesProfitabilityController.getProductCatalog(
//                     context: context);
//               },
//               child:
//                   Obx(() => salesProfitabilityController.isLoadingReport.value
//                       ? SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : Text(
//                           'Display',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         )),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   TextField _buildTextFeild(
//       {required String label,
//       required Function() onTap,
//       required bool enabled,
//       required bool isDate,
//       required TextEditingController controller,
//       required Function() onChange}) {
//     return TextField(
//       controller: controller,
//       readOnly: true,
//       enabled: enabled,
//       onTap: onTap,
//       style: TextStyle(
//         fontSize: 14,
//         color: enabled ? AppColors.primary : AppColors.mutedColor,
//         fontWeight: FontWeight.w400,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           fontSize: 14,
//           color: AppColors.primary,
//           fontWeight: FontWeight.w400,
//         ),
//         isCollapsed: true,
//         contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         suffix: Icon(
//           isDate ? Icons.calendar_month : null,
//           size: 15,
//           color: enabled ? AppColors.primary : AppColors.mutedColor,
//         ),
//       ),
//       onChanged: onChange(),
//     );
//   }
// }
