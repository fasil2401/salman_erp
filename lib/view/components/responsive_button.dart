import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponsiveButton extends StatefulWidget {
  const ResponsiveButton(
      {required this.width,
      required this.height,
      required this.child,
      required this.borderRadius,
      required this.onTap,
      Key? key})
      : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final double borderRadius;
  final Function() onTap;

  @override
  _ResponsiveButtonState createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with TickerProviderStateMixin {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        enableFeedback: true,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onHighlightChanged: (value) {
          setState(() {
            isTapped = value;
          });
        },
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          height: isTapped ? widget.height : widget.height + 10,
          width: isTapped ? widget.width : widget.width + 10,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
