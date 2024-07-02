import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({Key? key}) : super(key: key);

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
    return Scaffold(
      body: Center(
        child: Text('Redirect Screen'),
      ),
    );
  }
}
