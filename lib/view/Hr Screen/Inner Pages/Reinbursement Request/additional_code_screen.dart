import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/reimbursment_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Reinbursement%20Request/add_update_popup.dart';
import 'package:axolon_erp/view/Hr%20Screen/components/common_widgets.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Components/Sales%20Shimmer/pop_up_shimmer.dart';
import 'package:axolon_erp/view/components/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AdditionalCodeScreen extends StatelessWidget {
  AdditionalCodeScreen({super.key});
  final reimbursementController = Get.put(ReimbursementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additional Code"),
      ),
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CommonTextField.textfield(
                suffixicon: true,
                readonly: false,
                keyboardtype: TextInputType.text,
                icon: Icons.search,
                label: "Search",
                onchanged: (value) {
                  reimbursementController.filterAdditionalCode(value);
                },
              )),
          Expanded(
              child: GetBuilder<ReimbursementController>(
                  builder: (controller) => controller.isLoading.value
                      ? SalesShimmer.locationPopShimmer()
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item =
                                controller.filterAdditionalCodeList[index];
                            return InkWell(
                              onTap: () {
                                CommonWidget.commonDialog(
                                    context: context,
                                    title: "${item.benefitName}",
                                    content: AddUpdatePopUp(
                                      item: item,
                                      isUpdate: false,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 22.w,
                                      child: AutoSizeText(
                                        item.benefitCode ?? '',
                                        maxLines: 2,
                                        maxFontSize: 20,
                                        minFontSize: 14,
                                        style: const TextStyle(
                                            color: AppColors.mutedColor),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                        item.benefitName ?? '',
                                        maxFontSize: 20,
                                        minFontSize: 14,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: AppColors.mutedColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount:
                              controller.filterAdditionalCodeList.length)))
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mutedBlueColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22.w,
              child: AutoSizeText(
                'Code',
                maxLines: 2,
                maxFontSize: 20,
                minFontSize: 14,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: AutoSizeText(
                'Name',
                maxFontSize: 20,
                minFontSize: 14,
                maxLines: 2,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
