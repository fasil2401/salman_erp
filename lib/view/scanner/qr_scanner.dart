import 'dart:developer';
import 'dart:io';

import 'package:axolon_erp/controller/app%20controls/connection_setting_controller.dart';
import 'package:axolon_erp/model/connection_qr_model.dart';
import 'package:axolon_erp/utils/Encryption/encryptor.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/components/custom_buttons.dart';
import 'package:axolon_erp/view/connection_settings/connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final connectionsettingController = Get.put(ConnectionSettingController());
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool flash = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else {
      controller!.resumeCamera();
    }
  }

  // void readQr() async {
  //   if (result != null) {
  //     controller!.pauseCamera();
  //     print('result!.code.runtimeType: ${result!.code.runtimeType}');
  //     var respone = connectionQrModelFromJson(result!.code!);
  //     print(EncryptData.decryptAES(respone.connectionName));
  //     controller!.dispose();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          controller!.toggleFlash();
          setState(() {
            flash = !flash;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              !flash ? Icons.light_mode_outlined : Icons.light_mode_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // controller?.resumeCamera();
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: AppColors.primary,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: IconButton(
                onPressed: () async {
                  await connectionsettingController.getImage();
                  var result = await Scan.parse(
                      connectionsettingController.image.value.path);
                  controller?.pauseCamera();
                  Get.off(() => ConnectionScreen(
                        jsonData: result,
                      ));
                },
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  controller!.pauseCamera();
                  Get.back();
                },
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onQRViewCreated(QRViewController controller) async {
    controller.resumeCamera();
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      log('=======================${result!.code}');
      // var respone = connectionQrModelFromJson(result!.code);
      // print(EncryptData.decryptAES(respone.connectionName));
      // itemController.updateValues(result!.code!);
      // Navigator.pop(context);

      controller.pauseCamera();
      Get.off(() => ConnectionScreen(
            jsonData: result!.code,
          ));
      // Get.back();
      // Get.off(()=> ItemDetails());
      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHome()));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
