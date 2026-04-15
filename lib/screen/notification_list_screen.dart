import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorsApp.colorWhite,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                // decoration: BoxDecoration(color: Colors.purple),
                child: Image.asset(
                  "assets/images/icon_no_notification.png",
                  color: ColorsApp.colorPurple,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "no_notification".tr(),
                style: TextStyle(
                  color: ColorsApp.colorBlack,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]),
      ),
    );
  }
}
