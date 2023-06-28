import 'dart:async';
import 'dart:io';

import 'package:ble_scan/layout/default_layout.dart';
import 'package:ble_scan/screen/ble_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      if (Platform.isAndroid) {
        Future.delayed(Duration(milliseconds: 500));
        requestLocationPermission();
      } else if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 500));
        requestBlePermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      isAppBar: false,
      isOnWillPop: false,
      isAutomaticallyImplyLeading: false,
      backgroundColor: Color.fromARGB(255, 1, 131, 255),
      title: '',
      body: Center(
        child: Image.asset(
          'assets/images/bluetooth.png',
          width: screenWidth * 0.4,
          height: screenHeight * 0.08,
        ),
      ),
      isSafeArea: true,
    );
  }

  void requestLocationPermission() async {
    var requestLocationStatus = await Permission.location.request();
    var locationStatus = await Permission.location.status;

    if (requestLocationStatus.isGranted) {
      // 요청 동의됨
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        // 요청 동의 + gps 켜짐
        print("serviceStatusIsEnabled position");
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: BleScanScreen(),
          ),
        );
      } else {
        // 요청 동의 + gps 꺼짐
        print("serviceStatusIsDisabled");
      }
    } else if (requestLocationStatus.isPermanentlyDenied ||
        locationStatus.isPermanentlyDenied) {
      // 권한 요청 거부 (android)
      openAppSettings();
    } else if (locationStatus.isRestricted) {
      // 권한 요청 거부 (ios)
      openAppSettings();
    } else if (locationStatus.isDenied) {
      // 권한 요청 거절
    }
  }

  void requestBlePermission() async {
    var requestBleStatus = await Permission.bluetooth.request();
    var bleStatus = await Permission.bluetooth.status;

    if (requestBleStatus.isGranted) {
      // 요청 동의됨
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: BleScanScreen(),
        ),
      );
    } else if (requestBleStatus.isPermanentlyDenied ||
        bleStatus.isPermanentlyDenied) {
      // 권한 요청 거부 (android)
      openAppSettings();
    } else if (bleStatus.isRestricted) {
      // 권한 요청 거부 (ios)
      openAppSettings();
    } else if (bleStatus.isDenied) {
      openAppSettings();
      // 권한 요청 거절
    } else {
      openAppSettings();
    }
  }

  void permissionWarningDialog(Text title, Text content) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
