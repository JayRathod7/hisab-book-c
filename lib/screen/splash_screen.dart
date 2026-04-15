import 'dart:async';

import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/screen/home_screen.dart';
import 'package:bachat_book_customer/screen/login_screen.dart';
import 'package:bachat_book_customer/screen/tab_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/Constant_Class.dart';
import 'InfoSliderScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int splashTime = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
    SharedPrefDataget();
  }

  SharedPrefDataget() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String isInfoView = myPrefs.getString('info_view') ?? '';
    final String isLogin = myPrefs.getString('isLogin') ?? '';
    if (isLogin == "yes") {
      Timer(
          Duration(milliseconds: 2000),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => TabBarScreen())));
    } else if (isInfoView == "yes") {
      Timer(
          Duration(milliseconds: 2000),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen())));
    } else {
      Timer(
          Duration(milliseconds: 2000),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => InfoSliderScreen())));
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });

    Constant_Class.AppVersion = _packageInfo.version.toString();
    Constant_Class.AppBuildNumber = _packageInfo.buildNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    return Scaffold(
        // backgroundColor: ColorsApp.colorWhite,
        body: Stack(
      children: <Widget>[
        Container(
            color: ColorsApp.colorWhite,
            child: Center(
              child: Image.asset('assets/images/icon_logo.png',
                  height: 500, width: 500, alignment: Alignment.center),
            )),
      ],
    ));
  }
}
