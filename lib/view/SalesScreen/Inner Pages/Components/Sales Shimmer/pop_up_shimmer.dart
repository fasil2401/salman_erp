import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SalesShimmer {
  static Widget popUpShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Quantity ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary),
              ),
              Center(
                child: Text(
                  'Stock',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 15,
                        child: const Center(child: Icon(Icons.remove)),
                      ),
                    ),
                    Flexible(
                        child: TextField(
                      autofocus: false,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration.collapsed(hintText: ''),
                      onChanged: (value) {
                        // setQuantity(value);
                      },
                    )),
                    InkWell(
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 15,
                        child: const Center(child: Icon(Icons.add)),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              // controller: na meController,
              controller: TextEditingController(text: ''),

              readOnly: true,
              onTap: () {},
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.mutedColor, width: 0.1),
                ),
                isCollapsed: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                labelText: 'Unit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget locationPopShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Location",
              style: TextStyle(
                color: AppColors.mutedColor,
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) => SizedBox(
          height: 5,
        ),
      ),
    );
  }
}
