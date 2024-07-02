import 'package:flutter/material.dart';

class expandedItemsRow extends StatelessWidget {
  const expandedItemsRow({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.txtStyle,
    required this.topSpace,
  }) : super(key: key);

  final String text1;
  final String text2;
  final String text3;
  final TextStyle txtStyle;
  final double topSpace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, topSpace, 8, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 3300,
              child: Text(
                text1,
                style: txtStyle,
              )),
          Expanded(
              flex: 3400,
              child: Text(
                text2,
                style: txtStyle,
              )),
          Expanded(
              flex: 3300,
              child: Text(
                text3,
                style: txtStyle,
              ))
        ],
      ),
    );
  }
}
