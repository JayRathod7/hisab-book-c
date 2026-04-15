import 'dart:convert';

import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../model/beanCMS.dart';

class CMSpageScreen extends StatefulWidget {
  String strFlag;
  CMSpageScreen(this.strFlag);

  @override
  _CMSpageScreenState createState() => _CMSpageScreenState(strFlag);
}

class _CMSpageScreenState extends State<CMSpageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String strTitle = "";
  String strDiscription = "";
  bool apiCall = false;
  String strFlag;
  _CMSpageScreenState(this.strFlag);

  @override
  void initState() {
    super.initState();

    getCMSPageContent();
  }

  getCMSPageContent() async {
    Constant_Class.check().then((internet) async {
      if (internet != null && internet) {
        setState(() {
          apiCall = true;
        });

        ApiService.getCMSPageContent(strFlag).then((response) {
          setState(() {
            try {
              final responseJson = json.decode(response.body);
              beanCMS cms = beanCMS.fromJsonStatus(responseJson);

              var status = "${cms.status}";

              Constant_Class.PrintMessage("API Status => $status");
              Constant_Class.PrintMessage("API responseJson => $responseJson");

              if (status == "1") {
                beanCMS cms = beanCMS.fromJsonCMS(responseJson['data']);

                var title = "${cms.title}";
                var description = "${cms.description}";

                strTitle = title;
                strDiscription = description;
              } else {
                beanCMS cms = beanCMS.fromJsonfail(responseJson);
                var message = "${cms.message}";

                if (Constant_Class.strTokenExpire.toLowerCase() ==
                    message.toLowerCase()) {
                  Constant_Class.LoginDataClear(context);
                } else {
                  Constant_Class.ToastMessage(message);
                }
              }

              setState(() {
                apiCall = false;
              });
            } catch (e) {
              Constant_Class.PrintMessage("Test SupplierList " + e.toString());
              Constant_Class.ToastMessage(Constant_Class.strTryAgainLater);

              setState(() {
                apiCall = false;
              });
            }
          });
        });
      } else {
        Constant_Class.showNoInternetDialog(context);
        // Constant_Class.ToastErrorMessage(
        //     "Please check your internet connection.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        //drawer: AppDrawer(),
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                        left: 15, top: 25, right: 15, bottom: 5),
                    //height: 80,
                    color: ColorsApp.colorPurple,
                    alignment: Alignment.center,
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
                                }, // handle your image tap here
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, right: 10, left: 10, bottom: 10),
                                  child: Image.asset(
                                      'assets/images/icon_back_arrow.png',
                                      height: 30,
                                      color: ColorsApp.colorWhite,
                                      alignment: Alignment.center),
                                )),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                strTitle,
                                // textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.colorWhite),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {}, // handle your image tap here
                                child: Icon(
                                  Icons.download_rounded,
                                  size: 30,
                                  color: ColorsApp.colorPurple,
                                )),
                          ),
                        ])),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Html(
                          data: strDiscription,
                          style: {
                            "html": Style(
                              backgroundColor: Colors.white,
                              textAlign: TextAlign.justify,
                              fontFamily: 'Poppins',
                              //color: Colors.white,
                            ),
                          },
                        )),
                  ),
                ),
              ],
            ),
            Center(
                child: apiCall
                    ? Constant_Class.apiLoadingAnimation(context)
                    : Container()),
          ],
        ));
  }
}
