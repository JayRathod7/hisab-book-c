import 'dart:convert';

import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/user_login_model.dart';
import 'package:bachat_book_customer/screen/CMSpageScreen.dart';
import 'package:bachat_book_customer/screen/contact_us_screen.dart';
import 'package:bachat_book_customer/screen/loan_list_screen.dart';
import 'package:bachat_book_customer/screen/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/custome_page_transition.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  String profileImg = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePic();
  }

  getProfilePic() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    profileImg = preferences.getString("profilePicture") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //     backgroundColor: ColorsApp.colorPurple,
      //     title: Text(
      //       "More Information",
      //       style: GoogleFonts.openSansCondensed(
      //           color: ColorsApp.colorWhite,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w900),
      //     ),
      //     centerTitle: true),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: new BoxDecoration(
                  color: ColorsApp.colorPurple,
                  image: new DecorationImage(
                      image: new AssetImage("assets/images/home_card_back.png"),
                      fit: BoxFit.cover,
                      opacity: 0.1),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 120),
                padding: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                    color: ColorsApp.colorWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    menuTabList(
                        icon: Icons.person_2_outlined,
                        label: "profile".tr(),
                        info: "p_label".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageTransition(page: ProfileScreen()),
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => ProfileScreen()));
                        }),
                    menuTabList(
                        icon: Icons.info_outline,
                        label: "about_us".tr(),
                        info: "a_label".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageTransition(
                                page: CMSpageScreen("about-us")),
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CMSpageScreen("about-us")));
                        }),
                    menuTabList(
                        icon: Icons.document_scanner_outlined,
                        label: "t&c".tr(),
                        info: "t&c_label".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageTransition(
                                page: CMSpageScreen("terms-conditions")),
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CMSpageScreen("terms-conditions")));
                        }),
                    menuTabList(
                        icon: Icons.privacy_tip_outlined,
                        label: "policy".tr(),
                        info: "policy_label".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageTransition(
                                page: CMSpageScreen("privacy-policy")),
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CMSpageScreen("privacy-policy")));
                        }),
                    menuTabList(
                        icon: Icons.contacts_outlined,
                        label: "contact_us".tr(),
                        info: "contact_label".tr(),
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageTransition(page: ContactUsScreen()),
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ContactUsScreen()));
                        }),
                    menuTabList(
                        icon: Icons.share,
                        label: "share".tr(),
                        info: "share_label".tr(),
                        onTap: () {
                          var msg = "DownLoad this applicaiton";
                          Share.share(msg);
                        }),
                    menuTabList(
                        icon: Icons.logout_sharp,
                        label: "logout".tr(),
                        info: "logout_label".tr(),
                        onTap: () {
                          logOutDialogBox();
                        }),
                    SizedBox(height: 6),
                    Text(
                      Constant_Class.AppVersionLabel +
                          Constant_Class.AppVersion,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w900,
                          color: ColorsApp.colorGrey.withOpacity(0.2)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorsApp.colorWhite, shape: BoxShape.circle),
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: ColorsApp.colorPurple.withOpacity(0.2),
                    child: SizedBox(
                      // width: 110,
                      // height: 110,
                      child: ClipOval(
                          child: (profileImg != "" || profileImg.isNotEmpty)
                              ? Image.network(profileImg)
                              : Image.asset(
                                  "assets/images/icon_no_profile.png",
                                  fit: BoxFit.fill,
                                  height: 80,
                                )),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuTabList(
      {required String label,
      required String info,
      required VoidCallback onTap,
      required IconData icon,
      bool addressIconLocation = false}) {
    return InkWell(
      onTap: onTap,
      splashColor: ColorsApp.colorTransparent, // Removes splash color
      highlightColor: ColorsApp.colorTransparent,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
        decoration: BoxDecoration(
            color: ColorsApp.colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorsApp.colorPurple, width: 0.1),
            boxShadow: [
              BoxShadow(
                color: ColorsApp.colorPurple
                    .withOpacity(0.08), // Soft purple shadow
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(2, 3), // Slight shadow below for depth
              ),
              BoxShadow(
                color: ColorsApp.colorBlack
                    .withOpacity(0.05), // Light black shadow
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(-1, -1), // Opposite light shadow for realism
              ),
            ]),
        child: Row(
          crossAxisAlignment: addressIconLocation
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: ColorsApp.colorBlack.withOpacity(0.7),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsApp.colorBlack,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    info,
                    // maxLines: 3,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: ColorsApp.colorGrey),
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ColorsApp.colorBlack,
            )
          ],
        ),
      ),
    );
  }

  logOutDialogBox() async {
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
                Icon(Icons.logout, size: 50, color: ColorsApp.colorBlack),
                SizedBox(height: 20),
                Text(
                  "log_out_conformation".tr(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("cancel".tr(),
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorsApp.colorBlack,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        clickOnLogoutBtn();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 10),
                        decoration: BoxDecoration(
                            color: ColorsApp.colorPurple,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("logout".tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorsApp.colorWhite,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  clickOnLogoutBtn() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    var api_token = myPrefs.getString("api_token");
    Constant_Class.PrintMessage("token ==> " + api_token.toString());

    ApiService.UserLogout(api_token.toString()).then((response) async {
      try {
        final responseJson = json.decode(response.body);
        UserLoginModel customer = UserLoginModel.fromJsonStatus(responseJson);

        var status = "${customer.status}";
        Constant_Class.PrintMessage("API responseJson => $responseJson");
        Constant_Class.PrintMessage("API Status => $status");
        Constant_Class.LoginDataClear(context);
      } catch (e) {
        Constant_Class.LoginDataClear(context);
      }
    });
  }
}
