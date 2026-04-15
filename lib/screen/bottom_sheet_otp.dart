import 'dart:convert';
import 'dart:io';

import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/otp_varify_model.dart';
import 'package:bachat_book_customer/model/user_login_model.dart';
import 'package:bachat_book_customer/screen/tab_bar_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import 'home_screen.dart';

class BottomSheetOtp extends StatefulWidget {
  String phone_number, strDevicesDetails;
  BottomSheetOtp(this.phone_number, this.strDevicesDetails);

  @override
  _BottomSheetOtp createState() =>
      _BottomSheetOtp(phone_number, strDevicesDetails);
}

class _BottomSheetOtp extends State<BottomSheetOtp> {
  String phone_number, strDevicesDetails;
  _BottomSheetOtp(this.phone_number, this.strDevicesDetails);

  String otp = "";
  bool apiCall = false;
  bool isCountDownFinish = false;

  final CountdownController _controller = CountdownController(autoStart: false);
  @override
  void initState() {
    super.initState();
    _startCountDown();
    Constant_Class.PrintMessage("Number => ${phone_number}");
  }

  void _startCountDown() {
    _controller.start();
    isCountDownFinish = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: ColorsApp.colorLightPurple,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 25,
            top: 25,
            right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'otp_screen_label'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorsApp.colorBlack),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'enter_otp'.tr(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: ColorsApp.colorGrey),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
                        child: PinCodeTextField(
                          appContext: context,
                          textStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: ColorsApp.colorBlack,
                          ),
                          length: 6,
                          blinkWhenObscuring: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeColor: ColorsApp.colorPurple,
                            selectedColor: ColorsApp.colorPurple,
                            selectedFillColor: ColorsApp.colorPurple,
                            inactiveColor: ColorsApp.colorGrey,
                            inactiveFillColor: ColorsApp.colorGrey,
                          ),
                          cursorColor: ColorsApp.colorBlack,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: ColorsApp.colorTransparent,
                          enableActiveFill: false,
                          keyboardType: TextInputType.phone,
                          onCompleted: (pin) {
                            Constant_Class.PrintMessage("Completed: " + pin);
                            setState(() {
                              otp = pin;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              otp = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            return false;
                          },
                        )),
                    _CountDownText(),
                    SizedBox(height: 5),
                    _ConfirmButton(context),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _CountDownText() {
    return Container(
      margin: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
      child: Center(
        child: isCountDownFinish
            ? MaterialButton(
                onPressed: () {
                  Constant_Class.check().then((intenet) {
                    if (intenet != null && intenet) {
                      setState(() {
                        apiCall = true;
                      });
                      ReSendOTP();
                    } else {
                      Constant_Class.ToastErrorMessage("error_resent_otp".tr());
                    }
                  });
                },
                child: new Text(
                  'resend_otp'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w900,
                      color: ColorsApp.colorPurple),
                ),
              )
            : Countdown(
                // controller: _controller,
                seconds: 60,
                build: (_, double time) {
                  return Text(
                    'resend_otp_label_1'.tr() +
                        time.toString().split('.')[0] +
                        'resend_otp_label_2'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack),
                  );
                },
                interval: const Duration(seconds: 1),
                onFinished: () {
                  setState(() {
                    isCountDownFinish = true;
                  });
                },
              ),
      ),
    );
  }

  Widget _ConfirmButton(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(const Radius.circular(25)),
      ),
      margin: EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          textStyle: TextStyle(color: Colors.white),
          padding: const EdgeInsets.all(0.0),
        ),
        onPressed: otp.length == 6
            ? () {
                Constant_Class.PrintMessage("OTP is =>  " + otp);
                Constant_Class.check().then((intenet) {
                  if (intenet != null && intenet) {
                    if (otp.length == 6) {
                      Constant_Class.hideKeyBoard(context);
                      setState(() {
                        apiCall = true;
                      });

                      OTPVarification(phone_number, otp);
                    } else {
                      Constant_Class.ToastMessage("error_otp".tr());
                    }
                  } else {
                    Constant_Class.ToastErrorMessage(
                        "error_otp_verification".tr());
                  }
                });
              }
            : null,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(const Radius.circular(25)),
              gradient: new SweepGradient(
                colors: [
                  otp.length == 6
                      ? ColorsApp.colorPurple
                      : ColorsApp.colorDarkBlu1,
                  otp.length == 6
                      ? ColorsApp.colorPurple
                      : ColorsApp.colorDarkBlu1,
                  otp.length == 6
                      ? ColorsApp.colorPurple
                      : ColorsApp.colorDarkBlu1,
                ],
                stops: [0, 0.5, 1],
                center: Alignment.bottomRight,
              )),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "confirm".tr(),
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsApp.colorWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Future<String> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor.toString(); // unique ID on iOS
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.id.toString(); // unique ID on Android
  //   }
  // }

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

  ReSendOTP() async {
    String deviceId = await _getId();
    Constant_Class.PrintMessage("deviceId => " + deviceId);

    ApiService.UserLogin(phone_number, deviceId).then((response) {
      setState(() {
        try {
          final responseJson = json.decode(response.body);
          UserLoginModel user = UserLoginModel.fromJsonStatus(responseJson);

          var status = "${user.status}";
          Constant_Class.PrintMessage("API responseJson => $responseJson");
          Constant_Class.PrintMessage("API Status => $status");

          if (status == "1") {
            UserLoginModel userLogin =
                UserLoginModel.fromJsonUser(responseJson);
            Constant_Class.ToastMessage(userLogin.message.toString());

            setState(() {
              apiCall = false;
              _startCountDown();
            });
          } else {
            apiCall = false;
            UserLoginModel userLogin =
                UserLoginModel.fromJsonfail(responseJson);
            var message = userLogin.message;
            Constant_Class.PrintMessage("API message => $message");
            Constant_Class.ToastMessage(message);
          }
        } catch (e) {
          apiCall = false;
          Constant_Class.ToastMessage(Constant_Class.strTryAgainLater);
          Constant_Class.PrintMessage("Test catch error 2 => " + e.toString());
        }
      });
    });
  }

  OTPVarification(String mobile, String strOTP) async {
    String deviceId = await _getId();
    Constant_Class.PrintMessage("deviceId => " + deviceId);
    Constant_Class.PrintMessage("deviceDetails => " + strDevicesDetails);
    Constant_Class.PrintMessage("phone => " + mobile);

    ApiService.OTPVarification(mobile, strOTP, strDevicesDetails, deviceId)
        .then((response) {
      setState(() {
        try {
          final responseJson = json.decode(response.body);
          OtpVarifyModel otpVarify =
              OtpVarifyModel.fromJsonStatus(responseJson);

          var status = "${otpVarify.status}";
          Constant_Class.PrintMessage("API responseJson => $responseJson");
          Constant_Class.PrintMessage("API Status => $status");

          if (status == "1") {
            Navigator.pop(context);

            OtpVarifyModel otpVarify =
                OtpVarifyModel.fromJsonUser(responseJson);

            var firstname = otpVarify.customer.firstname ?? '';
            var lastname = otpVarify.customer.lastname ?? '';
            var userId = "${otpVarify.customer.userId}";
            var id = "${otpVarify.customer.id}";
            var email = otpVarify.customer.email ?? '';
            var mobile = otpVarify.customer.phoneNo ?? '';
            var dob = otpVarify.customer.birthdate ?? '';
            var apiToken = otpVarify.customer.apiToken ?? '';
            var address = otpVarify.customer.address ?? '';
            var profilePicture = otpVarify.customer.profilePicture ?? '';

            Constant_Class.PrintMessage("API userId => $userId");
            Constant_Class.PrintMessage("API id => $id");
            Constant_Class.PrintMessage("API firstname => $firstname");
            Constant_Class.PrintMessage("API lastname => $lastname");
            Constant_Class.PrintMessage("API email => $email");
            Constant_Class.PrintMessage("API mobile => $mobile");
            Constant_Class.PrintMessage("API dob => $dob");
            Constant_Class.PrintMessage("API api_token => $apiToken");
            Constant_Class.PrintMessage("API address => $address");
            Constant_Class.PrintMessage(
                "API profilePicture => $profilePicture");

            setLoginSharedPrefData(firstname, lastname, dob, userId, email,
                mobile, apiToken, address, profilePicture);

            apiCall = false;
          } else {
            apiCall = false;
            OtpVarifyModel otpVarify =
                OtpVarifyModel.fromJsonfail(responseJson);
            var message = otpVarify.message;
            Constant_Class.PrintMessage("API message => $message");
            Constant_Class.ToastMessage(message);
          }
        } catch (e) {
          apiCall = false;
          Constant_Class.ToastMessage(Constant_Class.strTryAgainLater);
          Constant_Class.PrintMessage("Test catch error 3 => " + e.toString());
        }
      });
    });
  }

  setLoginSharedPrefData(
      var firstname,
      var lastname,
      var dob,
      var userId,
      var email,
      var mobile,
      var api_token,
      var address,
      var profilePicture) async {
    Constant_Class.isUpdateAPIData = true;
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('firstname', firstname);
    myPrefs.setString('lastname', lastname);
    myPrefs.setString('dob', dob);
    myPrefs.setString('userId', userId);
    myPrefs.setString('email', email);
    myPrefs.setString('mobile', mobile);
    myPrefs.setString('api_token', api_token);
    myPrefs.setString('isLogin', "yes");
    myPrefs.setString('address', address);
    myPrefs.setString('profilePicture', profilePicture);
    // show kahatabook dialog box if app open first time
    myPrefs.setString("firstTime", "yes");

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => TabBarScreen()));
  }
}
