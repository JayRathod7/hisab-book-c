import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/ConstantClasses/Constant_Class.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/app_text_widget.dart';
import 'login_screen.dart';

class InfoSliderScreen extends StatefulWidget {
  const InfoSliderScreen({super.key});

  @override
  State<InfoSliderScreen> createState() => _InfoSliderScreenState();
}

class _InfoSliderScreenState extends State<InfoSliderScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  bool _isLastPage = false;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
        _isLastPage = _controller.page?.round() == 2;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: _currentPage.round() == index
              ? ColorsApp.colorPurple // Active dot
              : ColorsApp.colorGrey, // Inactive dot
          shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    return new Scaffold(
        backgroundColor: ColorsApp.colorWhite,
        body: new Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              children: [
                // InfoScreen1(context),
                // InfoScreen2(context),
                // InfoScreen3(context),
                buildIntroScreen(
                  context,
                  image: "assets/images/intro_11.png",
                  title: "saving".tr(),
                  description: "intro1".tr(),
                ),
                buildIntroScreen(
                  context,
                  image: "assets/images/intro_22.png",
                  title: "statistics".tr(),
                  description: "intro2".tr(),
                  isSvg: false,
                ),
                buildIntroScreen(
                  context,
                  image: "assets/images/intro_33.png",
                  title: "management".tr(),
                  description: "intro3".tr(),
                  isSvg: false,
                ),
              ],
            ),
            if (!_isLastPage)
              Positioned(
                bottom: 40,
                right: 20,
                child: FloatingActionButton(
                    onPressed: () {
                      int nextPage = _controller.page!.toInt() + 1;
                      if (nextPage < 3) {
                        _controller.animateToPage(
                          nextPage,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    backgroundColor: ColorsApp.colorPurple,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white)),
              ),
            if (_isLastPage)
              Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: _OpenANewWorldButton(context)),
            if (!_isLastPage)
              Positioned(
                bottom: 60,
                left: 40,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDot(0),
                      buildDot(1),
                      buildDot(2),
                    ],
                  ),
                ),
              ),
            Positioned(
              right: 50,
              left: 50,
              child: Image.asset(
                "assets/images/icon_logo.png",
                height: 200,
              ),
            ),
          ],
        ));
  }

  Widget buildIntroScreen(BuildContext context,
      {required String image,
      required String title,
      required String description,
      bool isSvg = false}) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 180),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.colorPurple, width: 0.6),
            color: ColorsApp.colorPurple.withOpacity(0.8),
            // color: ColorsApp.colorPurple.withOpacity(0.6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// **Image**
              isSvg
                  ? SvgPicture.asset(image, height: 220)
                  : Image.asset(image, height: 220, fit: BoxFit.contain),

              SizedBox(height: 30),

              /// **Title**
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: ColorsApp.colorWhite,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: ColorsApp.colorWhite.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget InfoScreen1(BuildContext context) {
    return Container(
      // height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
      child: Card(
        elevation: 5, // Adds a shadow for better UI
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorsApp.colorPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              /// **Top Image**
              Positioned(
                top: 30,
                child: Image.asset("assets/images/intro_1.png",
                    height: 220, fit: BoxFit.contain),
              ),
              Positioned(
                top: 300,
                child: Column(
                  children: [
                    Text(
                      "saving".tr().toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w900,
                        color: ColorsApp.colorBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'intro1'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // /// **Bottom Button**
              // Positioned(
              //   bottom: 10,
              //   child: MaterialButton(
              //     onPressed: () {
              //       _controller.jumpToPage(1);
              //     },
              //     color: ColorsApp.colorPurple,
              //     child: SvgPicture.asset(
              //       'assets/images/icon_arrow_right.svg',
              //       height: 20,
              //       width: 20,
              //     ),
              //     padding: const EdgeInsets.all(15),
              //     shape: const CircleBorder(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget InfoScreen2(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Container(
            height: 500,
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/images/intro_2.svg",
                height: 250,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 60,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                onPressed: () {
                  _controller.jumpToPage(2);
                },
                color: ColorsApp.colorPurple,
                textColor: Colors.white,
                child: SvgPicture.asset('assets/images/icon_arrow_right.svg',
                    height: 20, width: 20, alignment: Alignment.bottomCenter),
                padding: EdgeInsets.all(15),
                shape: CircleBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50, top: 500),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "statistics".tr().toUpperCase(),
                        style: TextStyle(
                            fontSize: 35,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: ColorsApp.colorBlack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "intro2".tr(),
                        // "Invest your Way! we help you \n create a personalized strategy to \n pursue your goals.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Poppins",
                            color: ColorsApp.colorGrey),
                        textAlign: TextAlign.center,
                      ),
                    ])),
          ),
        ],
      ),
    );
  }

  Widget InfoScreen3(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 70, right: 0, left: 0),
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _OpenANewWorldButton(context),
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 50, top: 500),
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "management".tr().toUpperCase(),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: ColorsApp.colorBlack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "intro3".tr(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Poppins",
                            color: ColorsApp.colorGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))),
          Container(
            height: 500,
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/images/intro_3.svg",
                height: 250,
                color: ColorsApp.colorPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _OpenANewWorldButton(BuildContext context) {
    return Container(
      height: 45,
      width: 250,
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
          GoToLoginScreen(context);
        },
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: Constant_Class.buttonGradiantDecoration(),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "login".tr().toUpperCase(),
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                color: ColorsApp.colorWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  GoToLoginScreen(BuildContext context) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('info_view', "yes");

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
