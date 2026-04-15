import 'dart:convert';
import 'dart:io';

import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/screen/bottom_sheet_otp.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/app_text_widget.dart';
import '../model/user_login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneHolder = TextEditingController();
  String? _phone;
  bool apiCall = false;
  String strDevicesDetails = "";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // getFCMToken();
    // TODO: implement initState
    super.initState();
    _initPackageInfoAndDeviceDetails();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfoAndDeviceDetails() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic>? deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData!;
      strDevicesDetails = deviceData.toString();
    });

    Constant_Class.PrintMessage("_deviceData => " + strDevicesDetails);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'sdk_version': build.version.sdkInt,
      'release_version': build.version.release,
      'brand': build.brand,
      'model': build.model,
      'isPhysicalDevice': build.isPhysicalDevice,
      'app_version': _packageInfo.version,
      'os ': "Android"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      'app_version': _packageInfo.version,
      'os ': "Ios"
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.black,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
          decoration: new BoxDecoration(color: ColorsApp.colorWhite),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Image.asset(
                          "assets/images/icon_logo.png",
                          height: 280,
                        ),
                      ),
                      // SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: ColorsApp.colorPurple
                                        .withOpacity(0.6), // Soft purple shadow
                                    spreadRadius:
                                        0.2, // Slight spread for a smooth effect
                                    blurRadius:
                                        2, // Increased blur for a soft shadow
                                    offset: Offset(1, 1)),
                                BoxShadow(
                                    color: ColorsApp.colorPurple
                                        .withOpacity(0.6), // Soft purple shadow
                                    spreadRadius:
                                        0.2, // Slight spread for a smooth effect
                                    blurRadius:
                                        2, // Increased blur for a soft shadow
                                    offset: Offset(0, 0)),
                                // BoxShadow(
                                //   color: ColorsApp.colorBlack.withOpacity(
                                //       0.05), // Secondary light shadow
                                //   spreadRadius: 1,
                                //   blurRadius: 0.10,
                                //   offset: Offset(-2,
                                //       -2), // Light upper shadow for 3D effect
                                // ),
                              ],
                              border: Border.all(
                                  color: ColorsApp.colorPurple, width: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              color: ColorsApp.colorWhite),
                          height: 200,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: EdgeInsets.only(
                              right: 30, left: 30, top: 10, bottom: 0),
                          child: new Form(
                            key: _formKey,
                            child: FormUI(),
                          ),
                        ),
                      ),
                    ]),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     // color: ColorsApp.colorWhite,
              //     height: 30,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           Constant_Class.AppVersionLabel +
              //               Constant_Class.AppVersion,
              //           style: TextStyle(
              //               fontSize: 14,
              //               fontFamily: "Poppins",
              //               color: ColorsApp.colorGrey),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                  child: apiCall
                      ? Constant_Class.apiLoadingAnimation(context)
                      : Container()),
            ],
          )),
    );
  }

  Widget FormUI() {
    final focus = FocusNode();
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "phone_number".tr(),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: ColorsApp.colorBlack),
            ),
          ),
          Stack(children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
              child: Icon(
                Icons.phone_iphone_rounded,
                color: ColorsApp.colorBlack,
                size: 25,
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 35, top: 10, right: 0, bottom: 0),
              child: Text(
                "+91",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.colorBlack),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
              child: TextFormField(
                controller: phoneHolder,
                focusNode: focus,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                decoration: new InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorBlack),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorBlack),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorBlack),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorErrorText),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.colorGrey),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 65, bottom: 10),
                    labelStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: ColorsApp.colorBlack),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: ColorsApp.colorGreyLight),
                    hintText: "phone_number".tr()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: validatePhone,
                onSaved: (val) {
                  _phone = val.toString();
                },
              ),
            ),
          ]),
          _loginButton(context)
        ]);
  }

  // String? validatePhone(String? value) {
  //   if (value.toString().trim().length < 1)
  //     return "error_phone".tr();
  //   else if (value.toString().trim().length < 10)
  //     return "error_phone_1".tr();
  //   else
  //     return null;
  // }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return "error_phone".tr();
    else if (value.trim().length != 10)
      return "error_phone_1".tr(); // Ensure exactly 10 digits
    else
      return null;
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(const Radius.circular(5)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          textStyle: TextStyle(
            color: ColorsApp.colorWhite,
          ),
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: () {
          Constant_Class.hideKeyBoard(context);
          Constant_Class.check().then((internet) {
            if (internet) {
              _validateInputs();
            } else {
              Constant_Class.showNoInternetDialog(context);
            }
          });
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: Constant_Class.buttonGradiantDecoration(),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "login".tr(),
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: ColorsApp.colorWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Constant_Class.check().then((internet) async {
        if (internet != null && internet) {
          Constant_Class.PrintMessage("Login _phone => ${phoneHolder.text}");
          setState(() {
            apiCall = true;
          });

          UserLogin(_phone!);
        } else {
          Constant_Class.ToastMessage("no_network_login".tr());
        }
      });
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor.toString(); // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id.toString(); // unique ID on Android
    }
  }

  UserLogin(String mobile) async {
    String deviceId = await _getId();
    Constant_Class.PrintMessage("deviceId => " + deviceId);

    try {
      ApiService.UserLogin(mobile.trim(), deviceId).then((response) {
        setState(() {
          try {
            final responseJson = json.decode(response.body);
            UserLoginModel user = UserLoginModel.fromJsonStatus(responseJson);

            var status = "${user.status}";
            Constant_Class.PrintMessage("API responseJson => $responseJson");
            Constant_Class.PrintMessage("API Status => $status");

            if (status == "1" || status == "success") {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return BottomSheetOtp(_phone!, strDevicesDetails);
                },
              );
            } else {
              UserLoginModel userLogin =
                  UserLoginModel.fromJsonfail(responseJson);
              var message = userLogin.message;
              Constant_Class.PrintMessage("API message => $message");
              Constant_Class.ToastMessage(message);
            }

            setState(() {
              apiCall = false;
            });
          } on SocketException catch (e) {
            setState(() {
              apiCall = false;
            });
            Constant_Class.ToastMessage(Constant_Class.strTryAgainLater);
            throw SocketException(e.toString());
          } catch (e) {
            setState(() {
              apiCall = false;
            });
            Constant_Class.ToastMessage(Constant_Class.strTryAgainLater);
            Constant_Class.PrintMessage(
                "Test catch error 1 => " + e.toString());
          }
        });
      });
    } catch (e) {
      print("Catch Error => ${e.toString()}");
    }
  }
}
