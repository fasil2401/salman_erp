import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProvider {
  static Widget popShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return const Card(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Location",
              style: TextStyle(
                color: AppColors.mutedColor,
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
      ),
    );
  }

  static Widget singleShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Location",
            style: TextStyle(
              color: AppColors.mutedColor,
            ),
          ),
        )));
  }

  static Widget gridShimmer({int? crossAxisCount, int? itemCount}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: itemCount ?? 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount ?? 4, // Number of columns
        ),
        itemBuilder: (context, index) {
          
          return GridTile(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                            // color: AppColors.darkRed,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const Text(
                    '',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget productPopUpShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
}
