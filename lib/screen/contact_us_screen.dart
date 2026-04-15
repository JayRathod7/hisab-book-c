import 'dart:async';
import 'dart:convert';

import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/user_login_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/app_text_widget.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool apiCall = false;
  String? _email;
  String? _name;
  String? _phone;
  String? _message;

  final emailHolder = TextEditingController();
  final nameHolder = TextEditingController();
  final phoneHolder = TextEditingController();
  final messageHolder = TextEditingController();

  bool emailReadOnly = false;
  bool nameReadOnly = false;
  bool phoneReadOnly = false;

  @override
  void initState() {
    super.initState();

    getAgentProfile();
  }

  getAgentProfile() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    _name = myPrefs.getString('firstname') ?? '';
    _email = myPrefs.getString('email') ?? '';
    _phone = myPrefs.getString('mobile') ?? '';

    emailHolder.text = _email!;
    nameHolder.text = _name!;
    phoneHolder.text = _phone!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        //drawer: AppDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: ColorsApp.colorPurple,
            iconTheme: IconThemeData(
              color: ColorsApp.colorWhite,
            ),
            title: Text(
              "contact_us".tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: ColorsApp.colorWhite),
            )),
        body: new Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: new Form(
                          key: _formKey,
                          child: FormUI(),
                        ),
                      ),
                    ],
                  )),
            ),
            Center(
                child: apiCall
                    ? Constant_Class.apiLoadingAnimation(context)
                    : Container()),
          ],
        ));
  }

  Widget FormUI() {
    final focus = FocusNode();
    final focus1 = FocusNode();
    final focus2 = FocusNode();

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            labelText("name".tr(), 0),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  readOnly: nameReadOnly,
                  controller: nameHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(left: 40, bottom: 10),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "name".tr()),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateName,
                  onSaved: (val) {
                    _name = val.toString();
                  },
                ),
              ),
            ]),
            labelText("email".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.email_outlined,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  readOnly: emailReadOnly,
                  controller: emailHolder,
                  focusNode: focus,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus1);
                  },
                  decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(left: 40, bottom: 10),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "email".tr()),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  onSaved: (val) {
                    _email = val.toString();
                  },
                ),
              ),
            ]),
            labelText("phone".tr(), 20),
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
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  readOnly: phoneReadOnly,
                  controller: phoneHolder,
                  focusNode: focus1,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus2);
                  },
                  decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(left: 40, bottom: 10),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "phone_number".tr()),
                  keyboardType: TextInputType.number,
                  validator: validatePhone,
                  onSaved: (val) {
                    _phone = val.toString();
                  },
                ),
              ),
            ]),
            labelText("message".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.message_outlined,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  controller: messageHolder,
                  focusNode: focus2,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(left: 40, bottom: 10),
                      labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "message".tr()),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  validator: validateMessage,
                  onSaved: (val) {
                    _message = val.toString();
                  },
                ),
              ),
            ]),
            _submitButton(context),
          ]),
    );
  }

  Widget _submitButton(BuildContext context) {
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
            "submit".tr(),
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

      Constant_Class.PrintMessage("contact_us _name => $_name");
      Constant_Class.PrintMessage("contact_us _email => $_email");
      Constant_Class.PrintMessage("contact_us _phone => $_phone");
      Constant_Class.PrintMessage("contact_us _message => $_message");

      setState(() {
        apiCall = true;
      });
      sendContactUs(_name!, _email!, _phone!, _message!);
    }
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());

    if (value.toString().trim().length > 0) {
      if (!regex.hasMatch(value.toString()))
        return "error_email".tr();
      else
        return null;
    } else {
      return null;
    }
  }

  String? validateName(String? value) {
    if (value.toString().trim().length < 1)
      return "error_name".tr();
    else
      return null;
  }

  String? validateMessage(String? value) {
    if (value.toString().trim().length < 1)
      return "error_msg".tr();
    else
      return null;
  }

  String? validatePhone(String? value) {
    if (value.toString().trim().length < 1)
      return "error_phone".tr();
    else if (value.toString().trim().length < 10)
      return "error_phone_1".tr();
    else
      return null;
  }

  Widget labelText(String strLabel, double marginTop) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.topLeft,
      child: Text(
        strLabel,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: Colors.grey),
      ),
    );
  }

  sendContactUs(String name, String email, String phone, String message) async {
    setState(() {
      apiCall = true;
    });
    var response = await ApiService.sendContactUs(name, email, phone, message);
    var jsonResponse = jsonDecode(response.body);
    Constant_Class.PrintMessage(
        "SEND CONTACT US API RESPONSE => ${jsonResponse}");
    try {
      UserLoginModel loginModel = UserLoginModel.fromJsonUser(jsonResponse);
      var status = loginModel.status;
      if (status == 1) {
        var msg = "${loginModel.message}";
        setState(() {
          _email = "";
          _name = "";
          _phone = "";
          _message = "";
          emailHolder.text = "";
          nameHolder.text = "";
          phoneHolder.text = "";
          messageHolder.text = "";
        });
        Constant_Class.ToastMessage(msg);
      } else {
        var msg = "${loginModel.message}";

        Constant_Class.PrintMessage("API message => $msg");
        Constant_Class.ToastMessage(msg);
      }
    } catch (e) {
      Constant_Class.PrintMessage("ERROR SEND CONTACT US API => ${e}");
    } finally {
      setState(() {
        apiCall = false;
      });
    }
  }
}
