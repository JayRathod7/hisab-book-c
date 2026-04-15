import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/login_screen.dart';
import 'ColorsApp.dart';
import 'app_text_widget.dart';

class Constant_Class {
  static String strTokenExpire = "Authentication fail";
  static String strTryAgainLater = "Something is wrong, please try again later";

  static String strCurrencySymbols = "₹";
  static String FCM_Token = "";

  static String AppVersionLabel = "Installed V. ";
  static String AppVersion = "";
  static String AppBuildNumber = "";

  static String strRegisterNo = "DIPP137057"; // Logo Register number

  static String uploadDateFormate = "yyyy-MM-dd HH:mm:ss";

  static bool isGetCustomerCollection = false;

  static bool isSendCustomerLive = false;

  static bool isUpdateAPIData = true;

  static bool isFaceDetectionEnable = true;

  static bool isNotificationUnread = true;

  static String notificationCounter = "0";

  //languages...................................
  static Locale setLocalEnglishLanguage = const Locale('en', '');

  static PrintMessage(var message) {
    if (kDebugMode) {
      print(message.toString());
    }
  }

  static Widget apiLoadingAnimation(BuildContext context) {
    return Container(
      color: Color(0x50000000),
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: ColorsApp.colorWhite.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12)),
          child: SpinKitFadingCircle(
            color: ColorsApp.colorPurple,
            size: 50.0,
          ),
        ),
      ),
    );
  }

  static Future<bool> isNotNullEmpty(String string) async {
    if (string != null && string != "" && string != "null") {
      return true;
    }
    return false;
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      return false;
    }
    return false;
  }

  static showNoInternetDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return Dialog(
          backgroundColor: ColorsApp.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 20, bottom: 20), // Adjust padding
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevent full-screen occupation
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.signal_cellular_connected_no_internet_4_bar_sharp,
                    size: 50, color: ColorsApp.colorBlack),
                SizedBox(height: 20),
                Text(
                  "no_network".tr(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ColorsApp.colorBlack,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          color: ColorsApp.colorPurple,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("Ok",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorsApp.colorWhite,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static LoginDataClear(BuildContext context) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    myPrefs.setString('firstname', "");
    myPrefs.setString('lastname', "");
    myPrefs.setString('dob', "");
    myPrefs.setString('userId', "");
    myPrefs.setString('email', "");
    myPrefs.setString('mobile', "");
    myPrefs.setString('api_token', "");
    myPrefs.setString('firstTime', "");
    myPrefs.setString('khatbookid', "");
    myPrefs.setString('khatbookNumber', "");
    myPrefs.setInt('selected_book_index', -1);
    myPrefs.setString('isLogin', "");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        ModalRoute.withName("/Login"));
  }

  static ToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorsApp.colorPurple,
        textColor: ColorsApp.colorWhite,
        fontSize: 14.0);
  }

  static ToastErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFFbb302b),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // static buttonGradiantDecoration() {
  //   return BoxDecoration(
  //     boxShadow: <BoxShadow>[
  //       BoxShadow(
  //         color: Color(0x50637bee),
  //         offset: Offset(3, 3),
  //         blurRadius: 3.0,
  //       ),
  //     ],
  //     borderRadius: new BorderRadius.all(const Radius.circular(25)),
  //     gradient: SweepGradient(
  //       colors: [
  //         ColorsApp.colorGradiant1,
  //         ColorsApp.colorGradiant2,
  //         ColorsApp.colorGradiant3
  //       ],
  //       stops: [0, 0.5, 1],
  //       center: Alignment.bottomRight,
  //     ),
  //   );
  // }
//
  static buttonGradiantDecoration() {
    return BoxDecoration(
      color: ColorsApp.colorPurple,
      // boxShadow: [
      //   BoxShadow(
      //     color: Color(0x50637bee),
      //     offset: Offset(3, 3),
      //     blurRadius: 3.0,
      //   ),
      // ],
      borderRadius: BorderRadius.all(Radius.circular(25)),
      // gradient: SweepGradient(
      //   colors: [
      //     Color(0xff3CAFEF), // Theme color
      //     Color(0xff258FEF), // Deeper Blue
      //     Color(0xff1A66CC), // Darker Blue
      //   ],
      //   stops: [0, 0.5, 1],
      //   center: Alignment.bottomRight,
      // ),
    );
  }
}
