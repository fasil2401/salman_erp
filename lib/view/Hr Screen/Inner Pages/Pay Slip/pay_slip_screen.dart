import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/pay_slip_controller.dart';
import 'package:axolon_erp/utils/Calculations/date_range_selector.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/view/components/common_filter_controls.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PaySlipScreen extends StatefulWidget {
  const PaySlipScreen({super.key});

  @override
  State<PaySlipScreen> createState() => _PaySlipScreenState();
}

class _PaySlipScreenState extends State<PaySlipScreen> {
  final payslipController = Get.put(PaySlipController());
  DateTime? _selected;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      CommonFilterControls.buildBottomSheet(context, filter(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Obx(() => CommonFilterControls.reportAppbar(
              baseString: payslipController.baseString.value,
              name: "Pay Slip"))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Obx(() => payslipController.baseString.value.isEmpty
                ? CommonFilterControls.buildEmptyPlaceholder()
                : GetBuilder<PaySlipController>(builder: (controller) {
                    return CommonFilterControls.buildPdfView(
                        controller.bytes.value);
                  })),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          CommonFilterControls.buildBottomSheet(context, filter(context));
        },
        child: SvgPicture.asset(AppIcons.filter,
            color: Colors.white, height: 20, width: 20),
      ),
    );
  }

  filter(BuildContext context) {
    var selectedValue;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Obx(() => CommonTextField.textfield(
            suffixicon: true,
            readonly: true,
            keyboardtype: TextInputType.datetime,
            controller: TextEditingController(
                text:
                    '${payslipController.selectedDate.value.month}/${payslipController.selectedDate.value.year}'),
            label: "Select date",
            onchanged: (value) {
              selectedValue = payslipController.selectedDate.value.month;
            },
            ontap: () async {
              payslipController.selectMonthYear(context);
              print("dateeeeeeeeeeeee");
            },
            icon: Icons.calendar_month_outlined)),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => CommonFilterControls.buildDisplayButton(
                isLoading: payslipController.isLoadingReport.value,
                onTap: () async {
                  await payslipController.getPaySlipList(
                      context,
                      payslipController.selectedDate.value.month,
                      payslipController.selectedDate.value.year);
                },
              ),
            )),
      ],
    );
  }
}
