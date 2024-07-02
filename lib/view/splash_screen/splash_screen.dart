import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:axolon_erp/controller/Api%20Controls/login_token_controller.dart';
import 'package:axolon_erp/controller/app%20controls/splash_screen_controller.dart';
import 'package:axolon_erp/main.dart';
import 'package:axolon_erp/services/Api%20Services/api_services.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/controller/ui%20controls/package_info_controller.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loginController = Get.put(LoginTokenController());
  final packageInfoCOntroller = Get.put(PackageInfoController());

  final splashScreenController = Get.put(SplashScreenController());
  @override
  void initState() {
    super.initState();
    // initNotification();
  }

  
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width * 0.9,
              child: Image.asset(
                Images.logo_gif,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      'version :${packageInfoCOntroller.version.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedColor,
                      ),
                    ),
                  ),
                  Text(
                    'License :Evaluation',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
