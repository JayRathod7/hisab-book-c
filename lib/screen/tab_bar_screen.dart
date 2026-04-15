import 'dart:ffi';

import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/screen/loan_request_screen.dart';
import 'package:bachat_book_customer/screen/menu_tab.dart';
import 'package:bachat_book_customer/screen/profile_screen.dart';
import 'package:bachat_book_customer/screen/search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/custom _bottomBar.dart';
import 'home_screen.dart';
import 'notification_list_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Pass callback
    SearchScreen(true),
    LoanRequestScreen(),
    NotificationListScreen(),
    MenuTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 10),
        height: 110,
        width: 70,
        // color: Colors.pink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () => _onItemTapped(2),
                backgroundColor: ColorsApp.colorPurple,
                elevation: 8.0,
                shape: const CircleBorder(),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: ColorsApp.colorWhite,
                )),
            SizedBox(height: 8),
            Text(
              "add".tr(),
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: _selectedIndex == 2
                      ? ColorsApp.colorPurple
                      : ColorsApp.colorGrey),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        padding: EdgeInsets.zero, elevation: 10,
        color: ColorsApp.colorWhite,
        shadowColor: ColorsApp.colorPurple,
        // padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Row(children: [
              SizedBox(width: 4),
              BottomNavItem(
                icon: Icons.home,
                label: 'home'.tr(),
                isSelected: _selectedIndex == 0,
                onPressed: () => _onItemTapped(0),
              ),
              BottomNavItem(
                icon: Icons.search,
                label: 'search'.tr(),
                isSelected: _selectedIndex == 1,
                onPressed: () => _onItemTapped(1),
              ),
            ]),
            Spacer(),
            Row(
              children: [
                BottomNavItem(
                  icon: Icons.notifications,
                  label: 'notifications'.tr(),
                  isSelected: _selectedIndex == 3,
                  onPressed: () => _onItemTapped(3),
                ),
                BottomNavItem(
                  icon: Icons.menu,
                  label: 'more'.tr(),
                  isSelected: _selectedIndex == 4,
                  onPressed: () => _onItemTapped(4),
                ),
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
