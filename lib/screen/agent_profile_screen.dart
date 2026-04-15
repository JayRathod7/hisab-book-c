import 'dart:ui';

import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ConstantClasses/ColorsApp.dart';

class AgentProfileScreen extends StatefulWidget {
  const AgentProfileScreen({super.key});

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: ColorsApp.colorWhite,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(),
                width: double.infinity,
                height: h * 0.3,
                child: Image.asset(
                  "assets/images/dummy_agent.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: h * 0.27, // Adjust this to position it correctly
              left: h * 0.1,
              right: h * 0.1,
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                height: h * 0.05,
                // width: w * 0.60,
                decoration: BoxDecoration(
                  color: ColorsApp.colorPurple.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "total_customers".tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorWhite,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "100",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 14,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: h * 0.055,
                  width: w * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorsApp.colorPurple,
                  ),
                  child: Image.asset("assets/images/back_icon.png"),
                ),
              ),
            ),
            Positioned(
              top: h * 0.33,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "agent_details".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack,
                      ),
                    ),
                    CustomLabel(
                      label: "agent_no".tr(),
                      info: "001",
                      img: "assets/images/agent_p1.png",
                    ),
                    CustomLabel(
                      label: "name".tr(),
                      info: "Agent Name",
                      img: "assets/images/agent_p2.png",
                    ),
                    CustomLabel(
                      label: "phone".tr(),
                      info: "9825092850",
                      isIcon: true,
                      icon: Icons.call,
                      iconColor: ColorsApp.colorWhite,
                    ),
                    CustomLabel(
                      label: "email".tr(),
                      info: "TestAgent@gmail.com",
                      isIcon: true,
                      icon: Icons.email,
                      iconColor: ColorsApp.colorWhite,
                    ),
                    CustomLabel(
                      label: "address".tr(),
                      info: "Rajkot",
                      isIcon: true,
                      icon: Icons.location_on,
                      iconColor: ColorsApp.colorWhite,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: h * 0.17,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      "agent_contact".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        contactIcon(
                          onTap: () {
                            _launchEmail();
                          },
                          icon: Icons.email,
                        ),
                        contactIcon(
                          onTap: () {
                            _launchPhoneDialer();
                          },
                          icon: Icons.phone,
                        ),
                        contactIcon(
                          onTap: () {
                            _launchSMS();
                          },
                          icon: Icons.message,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactIcon({required VoidCallback onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: ColorsApp.colorPurple,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            icon,
            size: 28,
            color: ColorsApp.colorWhite,
          )),
    );
  }

  Widget CustomLabel(
      {required String label,
      required String info,
      String? img,
      bool isIcon = false,
      IconData? icon,
      Color? iconColor}) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: ColorsApp.colorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(spreadRadius: 0.1, blurRadius: 2.50)]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ColorsApp.colorPurple
                .withOpacity(0.6), // Background color of the circle
            child: ClipOval(
              child: isIcon == true
                  ? Icon(
                      icon,
                      color: iconColor,
                    )
                  : Image.asset(
                      img!,
                      fit: BoxFit.cover, // Ensures the image fills the circle
                      width:
                          30, // To make sure the image fits the CircleAvatar size
                      height: 30,
                      color: iconColor,
                    ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorGrey),
                ),
                Text(info,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack))
              ],
            ),
          )
        ],
      ),
    );
  }

  _launchPhoneDialer() async {
    final Uri _url = Uri(scheme: 'tel', path: "9825098250");
    if (await canLaunch(_url.toString())) {
      await launch(_url.toString());
    } else {
      throw 'Could not launch "phoneNumber"';
    }
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'testuser@gmail.com',
      queryParameters: {
        'subject': "subject",
      },
    );

    print("${emailLaunchUri.toString()}");
    await launchUrl(emailLaunchUri);
  }

  _launchSMS() async {
    final Uri _smsLaunchUri = Uri(
      scheme: 'sms',
      path: "9825098250",
      queryParameters: {'body': "set testing msg"},
    );
    if (await canLaunch(_smsLaunchUri.toString())) {
      await launch(_smsLaunchUri.toString());
    } else {
      throw 'Could not launch SMS app';
    }
  }
}
