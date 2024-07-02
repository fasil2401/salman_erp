import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/login_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/password_controller.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  prefilData() async {
    final bool isRemembered =
        UserSimplePreferences.getRememberPassword() ?? false;
    _userNameController.text = await UserSimplePreferences.getUsername() ?? '';
    _passwordController.text =
        isRemembered ? await UserSimplePreferences.getUserPassword() ?? '' : '';
    loginController.getUserName(_userNameController.text);
    loginController.getPassword(_passwordController.text);
  }

  final passwordController = Get.put(PasswordController());
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    prefilData();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              // AppColors.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: height * 0.2,
              padding: const EdgeInsets.only(left: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  /// LOGIN TEXT
                  Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 3.5),

                  /// WELCOME
                  Text('Welcome Back',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: ListView(
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: height * 0.02),

                        Center(
                          child: SizedBox(
                            width: width * 0.35,
                            child:
                                Image.asset(Images.logo, fit: BoxFit.contain),
                          ),
                        ),
                        SizedBox(height: height * 0.05),

                        /// Text Fields
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          // height: 120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 10)),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: height * 0.01),
                              TextField(
                                controller: _userNameController,
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  label: Text(
                                    'User Name',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  isCollapsed: false,
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: (value) {
                                  loginController.getUserName(value);
                                },
                              ),
                              Divider(color: Colors.black54, height: 1),
                              SizedBox(height: height * 0.01),

                              /// PASSWORD
                              Obx(
                                () => TextField(
                                  controller: _passwordController,
                                  obscureText: passwordController.status.value,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    label: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    isCollapsed: false,
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    suffix: InkWell(
                                      onTap: () {
                                        passwordController.check();
                                      },
                                      child: Container(
                                        width: 50,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: SvgPicture.asset(
                                            passwordController.icon.value,
                                            height: passwordController
                                                        .status.value ==
                                                    true
                                                ? 10
                                                : 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    loginController.getPassword(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        InkWell(
                          onTap: () => loginController.rememberPassword(),
                          splashColor: AppColors.lightGrey,
                          splashFactory: InkRipple.splashFactory,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  border: Border.all(
                                    color: AppColors.mutedColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Icon(
                                        Icons.check,
                                        size: 15,
                                        color: loginController.isRemember.value
                                            ? AppColors.primary
                                            : Colors.transparent,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Remember me',
                                minFontSize: 16,
                                maxFontSize: 20,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.mutedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: () async {
                                loginController.saveCredentials();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              child: loginController.isLoading.value
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : Text('Login',
                                      style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Connection Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.mutedColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            Get.toNamed(RouteManager().routes[2].name);
                          },
                          elevation: 2,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
