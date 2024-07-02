import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:axolon_erp/controller/app%20controls/connection_setting_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Local%20Db%20Controller/local_settings_controller.dart';
import 'package:axolon_erp/controller/ui%20controls/password_controller.dart';
import 'package:axolon_erp/model/connection_qr_model.dart';
import 'package:axolon_erp/model/Local%20Db%20Model/connection_setting_model.dart';
import 'package:axolon_erp/utils/Encryption/encryptor.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/date_formatter.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:axolon_erp/view/scanner/qr_scanner.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode;
import 'package:share_plus/share_plus.dart';

class ConnectionScreen extends StatefulWidget {
  ConnectionScreen({Key? key, this.connectionModel, this.jsonData = ''})
      : super(key: key);

  ConnectionModel? connectionModel;
  final String? jsonData;

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final passwordController = Get.put(PasswordController());

  final connectionSettingController = Get.put(ConnectionSettingController());

  final localSettingsController = Get.put(LocalSettingsController());

  final _connectiionNameController = TextEditingController();
  final _serverIpController = TextEditingController();
  final _webPortController = TextEditingController();
  final _databaseNameController = TextEditingController();
  final _httpPortController = TextEditingController();
  final _erpPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocalSettings();
    prefillData();
  }

  var settingsList = <ConnectionModel>[
    // ConnectionModel(
    //     connectionName: '',
    //     serverIp: '',
    //     webPort: '',
    //     httpPort: '',
    //     erpPort: '',
    //     databaseName: '')
  ];

  final qrKey = GlobalKey();

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateFormatter.dateFormat.format(DateTime.now()).toString()}axolonERP(${_connectiionNameController.text}).png',
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {
          log(imgFile.path.toString());
          //In here you can show snackbar or do something in the backend at successfull download
          Share.shareXFiles([XFile('${imgFile.path}')]);
          // Get.snackbar(
          //   'QR Code',
          //   'QR Code saved to gallery as ${DateFormatter.dateFormat.format(DateTime.now()).toString()}axolonERP(${_connectiionNameController.text}).png',
          //   duration: Duration(seconds: 2),
          // );
        });
      }
    }
  }

  getLocalSettings() async {
    await localSettingsController.getLocalSettings();
    List<dynamic> settings = localSettingsController.connectionSettings;
    settings.forEach((element) {
      setState(() {
        settingsList.add(element);
      });
    });

    // print(settings);
  }

  selectSettings(ConnectionModel settings) async {
    setState(() {
      _connectiionNameController.text = settings.connectionName!;
      _serverIpController.text = settings.serverIp!;
      _webPortController.text = settings.webPort!;
      _databaseNameController.text = settings.databaseName!;
      _httpPortController.text = settings.httpPort!;
      _erpPortController.text = settings.erpPort!;
    });
    await UserSimplePreferences.setUsername(settings.userName ?? '');
    await UserSimplePreferences.setUserPassword(settings.password ?? '');
    await connectionSettingController
        .getConnectionName(settings.connectionName!);
    await connectionSettingController.getServerIp(settings.serverIp!);
    await connectionSettingController.getWebPort(settings.webPort!);
    await connectionSettingController.getDatabaseName(settings.databaseName!);
    await connectionSettingController.getHttpPort(settings.httpPort!);
    await connectionSettingController.getErpPort(settings.erpPort!);
    print(connectionSettingController.serverIp.value);
  }

  fillDataOnScan() async {
    var jsonData = connectionQrModelFromJson(widget.jsonData!);
    var connectionName = EncryptData.decryptAES(jsonData.connectionName);
    var serverIp = EncryptData.decryptAES(jsonData.serverIp);
    var webPort = EncryptData.decryptAES(jsonData.webPort);
    var databaseName = EncryptData.decryptAES(jsonData.databaseName);
    var httpPort = EncryptData.decryptAES(jsonData.httpPort);
    var erpPort = EncryptData.decryptAES(jsonData.erpPort);
    print(connectionName);
    print(serverIp);
    print(webPort);
    print(databaseName);
    print(httpPort);
    print(erpPort);
    setState(() {
      _connectiionNameController.text = connectionName;
      _serverIpController.text = serverIp;
      _webPortController.text = webPort;
      _databaseNameController.text = databaseName;
      _httpPortController.text = httpPort;
      _erpPortController.text = erpPort;
    });
  }

  assignControllers() async {
    await connectionSettingController
        .getConnectionName(_connectiionNameController.text);
    await connectionSettingController.getServerIp(_serverIpController.text);
    await connectionSettingController.getWebPort(_webPortController.text);
    await connectionSettingController
        .getDatabaseName(_databaseNameController.text);
    await connectionSettingController.getHttpPort(_httpPortController.text);
    await connectionSettingController.getErpPort(_erpPortController.text);
  }

  prefillData() async {
    if (widget.jsonData != '') {
      fillDataOnScan();
    } else if (widget.connectionModel != null) {
      setState(() {
        _connectiionNameController.text =
            widget.connectionModel!.connectionName ?? '';
        _serverIpController.text = widget.connectionModel!.serverIp ?? '';
        _webPortController.text = widget.connectionModel!.webPort ?? '';
        _databaseNameController.text =
            widget.connectionModel!.databaseName ?? '';
        _httpPortController.text = widget.connectionModel!.httpPort ?? '';
        _erpPortController.text = widget.connectionModel!.erpPort ?? '';
      });
    } else {
      String connectionName =
          await UserSimplePreferences.getConnectionName() ?? '';
      String serverIp = await UserSimplePreferences.getServerIp() ?? '';
      String webPort = await UserSimplePreferences.getWebPort() ?? '';
      String databaseName = await UserSimplePreferences.getDatabase() ?? '';
      String httpPort = await UserSimplePreferences.getHttpPort() ?? '';
      String erpPort = await UserSimplePreferences.getErpPort() ?? '';
      setState(() {
        _connectiionNameController.text = connectionName;
        _serverIpController.text = serverIp;
        _webPortController.text = webPort;
        _databaseNameController.text = databaseName;
        _httpPortController.text = httpPort;
        _erpPortController.text = erpPort;
      });
    }
  }

  createNew() async {
    setState(() {
      _connectiionNameController.text = '';
      _serverIpController.text = '';
      _webPortController.text = '';
      _databaseNameController.text = '';
      _httpPortController.text = '9018';
      _erpPortController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    print(settingsList);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  Text('Connection',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 3.5),

                  /// WELCOME
                  Text('Set your connection settings',
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
                    child: Stack(
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.03),

                                Center(
                                  child: SizedBox(
                                    width: width * 0.35,
                                    child: Image.asset(Images.logo,
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                // SizedBox(height: height * 0.035),

                                /// Text Fields
                                Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 30),
                                      child: Obx(
                                        () => RepaintBoundary(
                                          key: qrKey,
                                          child: barcode.BarcodeWidget(
                                            backgroundColor: Colors.white,
                                            barcode: barcode.Barcode.qrCode(),
                                            data: connectionSettingController
                                                .qrData.value,
                                            width: width * 0.3,
                                            height: width * 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 20),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      // height: height * 0.5,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                blurRadius: 20,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10)),
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Visibility(
                                            visible: settingsList.isNotEmpty,
                                            child: DropdownButtonFormField2(
                                              isDense: true,
                                              dropdownFullScreen: true,
                                              // value: settingsList[0],

                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 18,
                                              ),
                                              decoration: InputDecoration(
                                                isCollapsed: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                              ),
                                              hint: const Text(
                                                'Select Company',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              isExpanded: true,
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.primary,
                                              ),
                                              iconSize: 20,
                                              // buttonHeight: 37,
                                              buttonPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              items: settingsList
                                                  .map(
                                                    (item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(
                                                        item.connectionName!,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) async {
                                                var settings =
                                                    value as ConnectionModel;
                                                selectSettings(settings);
                                              },
                                              onSaved: (value) {},
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Stack(
                                            children: [
                                              _buildTextField(
                                                textInputType:
                                                    TextInputType.text,
                                                controller:
                                                    _connectiionNameController,
                                                label: 'Connection Name',
                                                onChanged: (value) {
                                                  connectionSettingController
                                                      .getConnectionName(value);
                                                },
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                        () => QRViewExample());
                                                  },
                                                  child: const Icon(
                                                    Icons.qr_code_rounded,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black54,
                                            height: 1,
                                          ),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .nameWarning.value,
                                                text:
                                                    'Enter the connection name or scan the QR code'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          _buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _serverIpController,
                                            label: 'Server IP',
                                            onChanged: (value) {
                                              connectionSettingController
                                                  .getServerIp(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .ipWarning.value,
                                                text: 'Enter the server IP'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          _buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _webPortController,
                                            label: 'Web Service Port',
                                            onChanged: (value) async {
                                              await connectionSettingController
                                                  .getWebPort(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .webPortWarning.value,
                                                text:
                                                    'Enter the web service port ex:- 0000:00'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          _buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _databaseNameController,
                                            label: 'Database Name',
                                            onChanged: (value) async {
                                              await connectionSettingController
                                                  .getDatabaseName(value);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .databaseNameWarning
                                                        .value,
                                                text:
                                                    'Enter the database name'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      _buildTextField(
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _erpPortController,
                                                        label: 'ERP Port',
                                                        onChanged:
                                                            (value) async {
                                                          await connectionSettingController
                                                              .getErpPort(
                                                                  value);
                                                        },
                                                      ),
                                                      Divider(
                                                          color: Colors.black54,
                                                          height: 1),
                                                      Obx(
                                                        () => _buildWarning(
                                                            isVisible:
                                                                connectionSettingController
                                                                    .erpPortWarning
                                                                    .value,
                                                            text:
                                                                'Enter the ERP port'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // SizedBox(width: width * 0.05),
                                                // Flexible(
                                                //   child: Column(
                                                //     children: [
                                                //       _buildTextField(
                                                //         textInputType:
                                                //             TextInputType
                                                //                 .number,
                                                //         controller:
                                                //             _httpPortController,
                                                //         label: 'Http Port',
                                                //         onChanged:
                                                //             (value) async {
                                                //           await connectionSettingController
                                                //               .getHttpPort(
                                                //                   value);
                                                //         },
                                                //       ),
                                                //       Divider(
                                                //           color: Colors.black54,
                                                //           height: 1),
                                                //       Obx(
                                                //         () => _buildWarning(
                                                //             isVisible:
                                                //                 connectionSettingController
                                                //                     .httpPortWarning
                                                //                     .value,
                                                //             text:
                                                //                 'Enter the http port'),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Positioned(
                                    //   top: height * 0.0,
                                    //   right: width * 0.065,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       createNew();
                                    //     },
                                    //     child: CircleAvatar(
                                    //       backgroundColor: AppColors.primary,
                                    //       radius: 30,
                                    //       child: Icon(
                                    //         Icons.add,
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          height: 40,
                                          // width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child:
                                              Buttons.buildElevatedButtonCancel(
                                                  text: 'Cancel',
                                                  onPressed: () {
                                                    // Get.back();
                                                    // Get.offAll(() =>
                                                    //     ConnectionScreen());
                                                    getLocalSettings();
                                                  },
                                                  color:
                                                      AppColors.mutedBlueColor,
                                                  textColor:
                                                      AppColors.primary)),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        height: 40,
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Buttons.buildElevatedButton(
                                            text: 'Continue',
                                            onPressed: () async {
                                              await connectionSettingController
                                                  .validateForm(
                                                      connectionName:
                                                          _connectiionNameController
                                                              .text,
                                                      serverIp:
                                                          _serverIpController
                                                              .text,
                                                      webPort:
                                                          _webPortController
                                                              .text,
                                                      databaseName:
                                                          _databaseNameController
                                                              .text,
                                                      httpPort:
                                                          _httpPortController
                                                              .text,
                                                      erpPort:
                                                          _erpPortController
                                                              .text);
                                              await setData();
                                              // await assignControllers();
                                              await getLocalSettings();
                                              connectionSettingController
                                                  .saveSettings(settingsList);
                                            },
                                            color: AppColors.primary,
                                            textColor: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.error,
                                        radius: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 18,
                                          child: Icon(
                                            Icons.delete_outline_outlined,
                                            color: AppColors.error,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        deleteConnection();
                                      },
                                    ),
                                    GFButton(
                                      onPressed: () {
                                        settingsList.clear();
                                        createNew();
                                      },
                                      text: "Add New",
                                      buttonBoxShadow: true,
                                      color: AppColors.primary,
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      type: GFButtonType.outline,
                                      shape: GFButtonShape.pills,
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.success,
                                        radius: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 18,
                                          child: Icon(
                                            Icons.share_outlined,
                                            color: AppColors.success,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        // await assignControllers();
                                        await setData();
                                        takeScreenShot();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(
                                          'version : ${UserSimplePreferences.getVersion() ?? ''}',
                                          minFontSize: 12,
                                          maxFontSize: 16,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AutoSizeText(
                                          'License : Evaluation',
                                          minFontSize: 12,
                                          maxFontSize: 16,
                                          style: TextStyle(
                                            color: AppColors.mutedColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarning({
    required String text,
    required bool isVisible,
  }) {
    return Visibility(
      visible: isVisible,
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 10, top: 5),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.error,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  TextField _buildTextField({
    required TextEditingController controller,
    required String label,
    required Function(String value) onChanged,
    required TextInputType textInputType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: InputBorder.none,
        label: Text(
          label,
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
      onChanged: onChanged,
    );
  }

  deleteConnection() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Are you Sure, You want to delete this?',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Wait',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await localSettingsController
                  .deleteConnectionSettings(_connectiionNameController.text);
              await setPrefereces();
              createNew();
              Get.offAll(() => ConnectionScreen());
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  setData() async {
    // await connectionSettingController.validateForm();
    await connectionSettingController
        .getConnectionName(_connectiionNameController.text);
    await connectionSettingController.getServerIp(_serverIpController.text);
    await connectionSettingController.getWebPort(_webPortController.text);
    await connectionSettingController
        .getDatabaseName(_databaseNameController.text);
    await connectionSettingController.getErpPort(_erpPortController.text);
    await connectionSettingController.getHttpPort(_httpPortController.text);
  }

  setPrefereces() async {
    await UserSimplePreferences.setUsername('');
    await UserSimplePreferences.setUserPassword('');
    await UserSimplePreferences.setConnectionName('');
    await UserSimplePreferences.setServerIp('');
    await UserSimplePreferences.setWebPort('');
    await UserSimplePreferences.setDatabase('');
    await UserSimplePreferences.setErpPort('');
    await UserSimplePreferences.setHttpPort('9018');
  }
}
