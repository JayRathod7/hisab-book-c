import 'dart:convert';
import 'dart:io';

import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/agent_customer_list_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/app_text_widget.dart';
import '../ConstantClasses/overlay_container.dart';
import '../model/loan_request_model.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  double deviceWidth = 0;
  bool apiCall = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final firstNameNameHolder = TextEditingController();
  final lastNameHolder = TextEditingController();
  final khatabookNoHolder = TextEditingController();
  final emailHolder = TextEditingController();
  final phoneHolder = TextEditingController();
  final loanAmountHolder = TextEditingController();

  String? _firstName;
  String? _lastName;
  String? _khatabook_id;
  String? _khatabook_no;
  String? _email;
  String? _phone;
  String? _loan_amount;

  String CustomerLoanNo = "";
  String strProfileImageURL = "";
  String strAdharcardURL = "";
  String strAdharcardBackSideURL = "";
  String strPancardURL = "";
  String strVotercardURL = "";

  String SelectionAction = "";
  String ProfileAction = "profile_image";
  String AdharcardAction = "adharcard_image";
  String AdharcardBackSideAction = "adharcard_back_side_image";
  String PancardAction = "pancard_image";
  String VotercardAction = "votercard_image";
  var loanApproveRejectStatus = "";
  var imageCropper = ImageCropper();
  File? _profileImage = null;
  File? _adharcardFrontSideImage = null;
  File? _adharcardBackSideImage = null;
  var _documentPancard = null;
  var _documentVotercard = null;

  bool isFaceDetecting = false;

  bool isErrorProfileImage = false;
  bool isErrorProfileFaceDetected = false;
  bool isErrorAdharcardFrontSideImage = false;
  bool isErroradharcardBackSideImage = false;
  bool isErrorSelect2Document = false;

  bool _Referance1dropdownShown = false;
  bool _Referance2dropdownShown = false;
  final Reference1Holder = TextEditingController();
  final Reference2Holder = TextEditingController();
  String _Reference1 = "";
  String _Reference2 = "";
  List<AgentCustomerListModel> agentCustomerList = [];

  getStoreData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _firstName = preferences.getString("firstname") ?? '';
    _lastName = preferences.getString("lastname") ?? '';
    _khatabook_id = preferences.getString("khatbookid") ?? '';
    _khatabook_no = preferences.getString("khatbookNumber") ?? '';
    _phone = preferences.getString("mobile") ?? '';
    _email = preferences.getString("email") ?? '';

    firstNameNameHolder.text = _firstName!;
    lastNameHolder.text = _lastName!;
    khatabookNoHolder.text = _khatabook_no!;
    phoneHolder.text = _phone!;
    emailHolder.text = _email!;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoreData();
    getAgentCustomerList();
  }

  getAgentCustomerList() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    var api_token = myPref.getString("api_token");

    ApiService.AgentCustomerList(api_token).then((response) {
      var jsonResponse = jsonDecode(response.body);
      print("AGENT CUSTOMERS LIST API RESPONSE==>${jsonResponse}");

      var status = jsonResponse["status"];
      var data = jsonResponse["data"];
      if (status == 1 || status == "success") {
        agentCustomerList.clear();
        if (data != null) {
          if (data is Map) {
            List<dynamic> customerList = data.values.toList();
            agentCustomerList = customerList
                .map((e) => AgentCustomerListModel.fromJson(e))
                .toList();
          }
        }

        print("agenet customer list leghth = > ${agentCustomerList.length}");
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width - 100;
    });
    return Scaffold(
      backgroundColor: ColorsApp.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorsApp.colorPurple,
        // centerTitle: true,
        iconTheme: IconThemeData(
          color: ColorsApp.colorWhite,
        ),
        title: Text(
          "loan_form".tr(),
          style: TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: ColorsApp.colorWhite),
        ),
      ),
      body: new GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            _Referance1dropdownShown = false;
            _Referance2dropdownShown = false;
          },
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    new Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            setState(() {
                              _Referance1dropdownShown = false;
                              _Referance2dropdownShown = false;
                            });
                            return false; // Allows scroll events to propagate
                          },
                          child: SingleChildScrollView(
                              //scrollDirection: Axis.vertical,
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 40, left: 40),
                                child: new Form(
                                  key: _formKey,
                                  child: FormUI(),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                  child: apiCall
                      ? Constant_Class.apiLoadingAnimation(context)
                      : Container()),
            ],
          )),
    );
  }

  Widget FormUI() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            labelText("f_name".tr(), 20),
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
                  controller: firstNameNameHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "f_name".tr()),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateFirstName,
                  onSaved: (val) {
                    _firstName = val.toString();
                  },
                ),
              ),
            ]),
            labelText("l_name".tr(), 20),
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
                  controller: lastNameHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "l_name".tr()),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  validator: validateLastName,
                  onSaved: (val) {
                    _lastName = val.toString();
                  },
                ),
              ),
            ]),
            labelText("book_number".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.book_outlined,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  controller: khatabookNoHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "book_number".tr()),
                  keyboardType: TextInputType.name,
                  validator: validateKhatabookNo,
                  onSaved: (val) {
                    _khatabook_no = val.toString();
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
                  controller: emailHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
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
                  controller: phoneHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "phone_number".tr()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  validator: validatePhone,
                  onSaved: (val) {
                    _phone = val.toString();
                  },
                ),
              ),
            ]),
            labelText("required_loan".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Image.asset('assets/images/icon_rupee.png',
                    height: 20,
                    color: ColorsApp.colorBlack,
                    alignment: Alignment.center),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  controller: loanAmountHolder,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "required_loan".tr()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  validator: validateLoanAmount,
                  onSaved: (val) {
                    _loan_amount = val.toString();
                  },
                ),
              ),
            ]),
            labelText("jamin1".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  controller: Reference1Holder,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "jamin1".tr()),
                  keyboardType: TextInputType.name,
                  validator: validateLastName,
                  // onSaved: (String val) {
                  //   _lastName = val;
                  // },

                  onChanged: (value) {
                    if (value.length > 0) {
                      setState(() {
                        _Referance1dropdownShown = true;
                      });
                    } else {
                      setState(() {
                        _Reference1 = "";
                        _Referance1dropdownShown = false;
                      });
                    }
                  },
                ),
              ),
            ]),
            OverlayContainerReference1Widget(context),
            labelText("jamin2".tr(), 20),
            Stack(children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: ColorsApp.colorBlack,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 10, right: 0, bottom: 0),
                child: TextFormField(
                  controller: Reference2Holder,
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
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: ColorsApp.colorGreyLight),
                      hintText: "jamin2".tr()),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    if (value.length > 0) {
                      setState(() {
                        _Referance2dropdownShown = true;
                      });
                    } else {
                      setState(() {
                        _Reference2 = "";
                        _Referance2dropdownShown = false;
                      });
                    }
                  },
                ),
              ),
            ]),
            OverlayContainerReference2Widget(context),
            SizedBox(height: 20),
            strProfileImageURL != "" && loanApproveRejectStatus == "0"
                ? Container(
                    height: (deviceWidth / 2) + 25,
                    //width: deviceWidth / 2,
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      border:
                          Border.all(color: ColorsApp.colorGrey, width: 0.5),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(10)),
                      color: ColorsApp.colorWhite,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          strProfileImageURL,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        SelectionAction = ProfileAction;
                        _profileImage = null;
                      });
                      checkPermissions(context);
                    },
                    child: SelectCustomerProfilePhoto(),
                  ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                strAdharcardURL != "" && loanApproveRejectStatus == "0"
                    ? Container(
                        height: (deviceWidth / 2) + 25,
                        width: deviceWidth / 2,
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          border: Border.all(
                              color: ColorsApp.colorGrey, width: 0.5),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(10)),
                          color: ColorsApp.colorWhite,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              strAdharcardURL,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            SelectionAction = AdharcardAction;
                            _adharcardFrontSideImage = null;
                          });
                          checkPermissions(context);
                        },
                        child: SelectDocumentAdharcardPhoto(),
                      ),
                strAdharcardBackSideURL != "" && loanApproveRejectStatus == "0"
                    ? Container(
                        height: (deviceWidth / 2) + 25,
                        width: deviceWidth / 2,
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          border: Border.all(
                              color: ColorsApp.colorGrey, width: 0.5),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(10)),
                          color: ColorsApp.colorWhite,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              strAdharcardBackSideURL,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            SelectionAction = AdharcardBackSideAction;
                            _adharcardBackSideImage = null;
                          });
                          checkPermissions(context);
                        },
                        child: SelectDocumentAdharcardBackPhoto(),
                      ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                strVotercardURL != "" && loanApproveRejectStatus == "0"
                    ? Container(
                        height: (deviceWidth / 2) + 25,
                        width: deviceWidth / 2,
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          border: Border.all(
                              color: ColorsApp.colorGrey, width: 0.5),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(10)),
                          color: ColorsApp.colorWhite,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              strVotercardURL,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            SelectionAction = VotercardAction;
                            _documentVotercard = null;
                          });
                          checkPermissions(context);
                        },
                        child: SelectDocument3Photo(),
                      ),
                strPancardURL != "" && loanApproveRejectStatus == "0"
                    ? Container(
                        height: (deviceWidth / 2) + 25,
                        width: deviceWidth / 2,
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          border: Border.all(
                              color: ColorsApp.colorGrey, width: 0.5),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(10)),
                          color: ColorsApp.colorWhite,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              strPancardURL,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            SelectionAction = PancardAction;
                            _documentPancard = null;
                          });
                          checkPermissions(context);
                        },
                        child: SelectDocument2Photo(),
                      ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 14),
              alignment: Alignment.topLeft,
              child: Text(
                "select_document".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: isErrorSelect2Document
                      ? ColorsApp.colorErrorText
                      : Colors.grey,
                ),
              ),
            ),
            _SubmitButton(context),
          ]),
    );
  }

  Future<void> checkPermissions(BuildContext context) async {
    _checkPermission123().then((hasGranted) {
      if (hasGranted) {
        OpenImageAction();
      } else {
        Constant_Class.ToastErrorMessage("error_camera_permission".tr());
      }
    });
  }

  Future<void> OpenImageAction() async {
    if (SelectionAction == ProfileAction) {
      _imgFromCamera();
    } else if (SelectionAction == AdharcardAction) {
      _imgFromCamera();
    } else if (SelectionAction == AdharcardBackSideAction) {
      _imgFromCamera();
    } else if (SelectionAction == PancardAction) {
      _imgFromCamera();
    } else if (SelectionAction == VotercardAction) {
      _imgFromCamera();
    }
  }

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      CroperImage(pickedFile.path);
    }
  }

  Future<void> CroperImage(String seletedFilepath) async {
    var croppedFile = await imageCropper.cropImage(
      sourcePath: seletedFilepath,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        if (SelectionAction == AdharcardAction) {
          _adharcardFrontSideImage = File(croppedFile.path);
          Constant_Class.PrintMessage(
              "file document 1 Image => " + croppedFile.path.toString());
        } else if (SelectionAction == AdharcardBackSideAction) {
          _adharcardBackSideImage = File(croppedFile.path);
          Constant_Class.PrintMessage(
              "file document 1 Image => " + croppedFile.path.toString());
        } else if (SelectionAction == PancardAction) {
          _documentPancard = File(croppedFile.path);
          Constant_Class.PrintMessage(
              "file document 2 Image => " + croppedFile.path.toString());
        } else if (SelectionAction == VotercardAction) {
          _documentVotercard = File(croppedFile.path);
          Constant_Class.PrintMessage(
              "file document 2 Image => " + croppedFile.path.toString());
        } else if (SelectionAction == ProfileAction) {
          Constant_Class.PrintMessage(
              "file customer face Image => " + croppedFile.path.toString());

          if (Constant_Class.isFaceDetectionEnable) {
            _getImageAndDetectFace(File(croppedFile.path));
          } else {
            _getImageFace(File(croppedFile.path));
          }
        }
      });
    }
  }

  void _getImageAndDetectFace(File imageFile) async {
    final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
            performanceMode: FaceDetectorMode.fast,
            enableLandmarks: true,
            enableClassification: true,
            enableContours: false,
            enableTracking: true));

    if (imageFile != null) {
      Constant_Class.PrintMessage("ML_CLASS imageFile => " + imageFile.path);
      Constant_Class.PrintMessage(
          "ML_CLASS faceDetector => " + faceDetector.toString());

      setState(() {
        isFaceDetecting = true;
      });

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      String targetPath1 = tempPath + "/" + timestamp.toString() + '.jpg';
      var compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath1,
        quality: 50,
        rotate: 0,
      );

      try {
        final image = InputImage.fromFilePath(compressedFile!.path.toString());
        List<Face> faces = await faceDetector.processImage(image);

        if (mounted) {
          setState(() {
            isFaceDetecting = false;

            if (faces.length > 0) {
              _profileImage = File(imageFile.path);
              isErrorProfileFaceDetected = false;
            } else {
              _profileImage = null;
              isErrorProfileFaceDetected = true;
            }
          });
        }
      } catch (e) {
        setState(() {
          isFaceDetecting = true;
        });
        Constant_Class.PrintMessage("Test faceDetector " + e.toString());
      }
    }
  }

  void _getImageFace(File imageFile) async {
    if (imageFile != null) {
      Constant_Class.PrintMessage("imageFile => " + imageFile.path);

      setState(() {
        _profileImage = File(imageFile.path);
        isFaceDetecting = false;
      });
    } else {
      setState(() {
        isFaceDetecting = false;
      });
    }
  }

  Future<bool> _checkPermission123() async {
    if (Platform.isAndroid) {
      final status = await Permission.camera.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.camera.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  SelectCustomerProfilePhoto() {
    return Stack(children: [
      _profileImage != null
          ? Container(
              height: (deviceWidth / 2) + 25,
              //width: deviceWidth / 2 + 50,
              padding: EdgeInsets.all(2),
              decoration: new BoxDecoration(
                border: Border.all(color: ColorsApp.colorGrey, width: 0.5),
                borderRadius: new BorderRadius.all(const Radius.circular(10)),
                color: ColorsApp.colorWhite,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _profileImage!,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  )))
          : Column(
              children: [
                Container(
                  height: (deviceWidth / 2) + 25,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    border: Border.all(color: Color(0xFFc5c5ee)),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(10)),
                    color: ColorsApp.colorPurple.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      "take_photo_label".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack,
                      ),
                    ),
                  ),
                ),
                isErrorProfileFaceDetected
                    ? errorContainer("error_face".tr())
                    : SizedBox(),
                isErrorProfileImage
                    ? errorContainer("error_take_photo".tr())
                    : SizedBox(),
              ],
            ),
      isFaceDetecting
          ? Container(
              height: (deviceWidth / 2) + 25,
              //width: deviceWidth / 2 + 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
              child: SpinKitCircle(
                color: ColorsApp.colorPurple.withOpacity(0.2),
                size: 35.0,
              ),
            )
          : SizedBox(
              height: 0,
            ),
    ]);
  }

  Widget SelectDocumentAdharcardPhoto() {
    return _adharcardFrontSideImage != null
        ? Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            padding: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              border: Border.all(color: ColorsApp.colorGrey, width: 0.5),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorWhite,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _adharcardFrontSideImage!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )))
        : Column(
            children: [
              Container(
                height: (deviceWidth / 2) + 25,
                width: deviceWidth / 2,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  border: Border.all(color: Color(0xFFc5c5ee)),
                  borderRadius: new BorderRadius.all(const Radius.circular(10)),
                  color: ColorsApp.colorPurple.withOpacity(0.2),
                ),
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 10),
                child: Center(
                  child: Text(
                    "select_a_card_front".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorBlack,
                    ),
                  ),
                ),
              ),
              isErrorAdharcardFrontSideImage
                  ? errorContainer("error_adhar_front_label".tr())
                  : SizedBox(),
            ],
          );
  }

  Widget SelectDocumentAdharcardBackPhoto() {
    return _adharcardBackSideImage != null
        ? Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            padding: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              border: Border.all(color: ColorsApp.colorGrey, width: 0.5),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorWhite,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _adharcardBackSideImage!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )))
        : Column(
            children: [
              Container(
                height: (deviceWidth / 2) + 25,
                width: deviceWidth / 2,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  border: Border.all(color: Color(0xFFc5c5ee)),
                  borderRadius: new BorderRadius.all(const Radius.circular(10)),
                  color: ColorsApp.colorPurple.withOpacity(0.2),
                ),
                padding: const EdgeInsets.only(
                    right: 10, left: 10, top: 10, bottom: 10),
                child: Center(
                  child: Text(
                    "select_a_card_back".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorBlack,
                    ),
                  ),
                ),
              ),
              isErroradharcardBackSideImage
                  ? errorContainer("error_adhar_back_label".tr())
                  : SizedBox(),
            ],
          );
  }

  Widget SelectDocument2Photo() {
    return _documentPancard != null
        ? Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            padding: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              border: Border.all(color: ColorsApp.colorGrey, width: 0.5),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorWhite,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _documentPancard!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )))
        : Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: Border.all(color: Color(0xFFc5c5ee)),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorPurple.withOpacity(0.2),
            ),
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Center(
              child: Text(
                "select_p_card".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: ColorsApp.colorBlack,
                ),
              ),
            ),
          );
  }

  Widget SelectDocument3Photo() {
    return _documentVotercard != null
        ? Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            padding: EdgeInsets.all(2),
            decoration: new BoxDecoration(
              border: Border.all(color: ColorsApp.colorGrey, width: 0.5),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorWhite,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _documentVotercard!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )))
        : Container(
            height: (deviceWidth / 2) + 25,
            width: deviceWidth / 2,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              border: Border.all(color: Color(0xFFc5c5ee)),
              borderRadius: new BorderRadius.all(const Radius.circular(10)),
              color: ColorsApp.colorPurple.withOpacity(0.2),
            ),
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Center(
              child: Text(
                "select_e_card".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: ColorsApp.colorBlack,
                ),
              ),
            ),
          );
  }

  Widget errorContainer(String strError) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Text(
        strError,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.normal,
          color: ColorsApp.colorErrorText,
        ),
      ),
    );
  }

  Widget OverlayContainerReference1Widget(BuildContext context) {
    return OverlayContainer(
        show: _Referance1dropdownShown,
        position: OverlayContainerPosition(
          0,
          10,
        ),
        child: agentCustomerList.length > 0
            ? Container(
                constraints: new BoxConstraints(
                  maxHeight: 250.0,
                ),
                width: deviceWidth + 50,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 3,
                      spreadRadius: 2,
                    )
                  ],
                ),
                //child: Text("I render outside the \nwidget hierarchy."),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (int index = 0;
                        index < agentCustomerList.length;
                        index++)
                      Container(
                          height: 45.0,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Reference1Holder.text =
                                    agentCustomerList[index].firstname;
                                _Reference1 =
                                    agentCustomerList[index].id.toString();
                                _Referance1dropdownShown = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color: ColorsApp.colorGreyLight),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      color: ColorsApp.colorBlack,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        agentCustomerList[index].firstname,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsApp.colorBlack),
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )),
                          )),
                  ],
                ),
              )
            : SizedBox());
  }

  Widget OverlayContainerReference2Widget(BuildContext context) {
    return OverlayContainer(
        show: _Referance2dropdownShown,
        // Let's position this overlay to the right of the button.
        position: OverlayContainerPosition(
          0,
          10,
        ),
        child: agentCustomerList.length > 0
            ? Container(
                constraints: new BoxConstraints(
                  maxHeight: 250.0,
                ),
                width: deviceWidth + 50,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 3,
                      spreadRadius: 2,
                    )
                  ],
                ),
                //child: Text("I render outside the \nwidget hierarchy."),

                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (int index = 0;
                        index < agentCustomerList.length;
                        index++)
                      Container(
                          height: 45.0,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Reference2Holder.text =
                                    agentCustomerList[index].firstname;
                                _Reference2 =
                                    agentCustomerList[index].id.toString();
                                _Referance2dropdownShown = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color: ColorsApp.colorGreyLight),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      color: ColorsApp.colorBlack,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        agentCustomerList[index].firstname,
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsApp.colorBlack),
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )),
                          )),
                  ],
                ),
              )
            : SizedBox());
  }

  Widget labelText(String strLabel, double marginTop) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      alignment: Alignment.topLeft,
      child: Text(
        strLabel,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.grey),
      ),
    );
  }

  Widget _SubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: ElevatedButton(
        onPressed:
            loanApproveRejectStatus == "" || loanApproveRejectStatus == "2"
                ? () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _validateInputs();
                  }
                : null,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            textStyle: TextStyle(color: Colors.white),
            padding: const EdgeInsets.all(0.0)),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          width: double.infinity,
          decoration: Constant_Class.buttonGradiantDecoration(),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "submit".tr(),
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    Constant_Class.check().then((internet) async {
      if (internet) {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Constant_Class.PrintMessage("loan_form _firstName => $_firstName");
          Constant_Class.PrintMessage("loan_form _lastName => $_lastName");
          Constant_Class.PrintMessage(
              "loan_form _khatabook_no => $_khatabook_no");
          Constant_Class.PrintMessage(
              "loan_form _khatabook_id => $_khatabook_id");
          Constant_Class.PrintMessage("loan_form _email => $_email");
          Constant_Class.PrintMessage("loan_form _phone => $_phone");
          Constant_Class.PrintMessage(
              "loan_form _loan_amount => $_loan_amount");
          Constant_Class.PrintMessage(
              "loan_form _profileImage => $_profileImage");
          Constant_Class.PrintMessage(
              "loan_form _adharcardFrontSideImage => $_adharcardFrontSideImage");
          Constant_Class.PrintMessage(
              "loan_form _adharcardBackSideImage => $_adharcardBackSideImage");
          Constant_Class.PrintMessage(
              "loan_form _documentPancard => $_documentPancard");
          Constant_Class.PrintMessage(
              "loan_form _documentVotercard => $_documentVotercard");
          if (_profileImage == null) {
            Constant_Class.ToastMessage("error_profile".tr());
            setState(() {
              isErrorProfileImage = true;
            });
          } else if (_adharcardFrontSideImage == null) {
            Constant_Class.ToastMessage("error_adharcard_front".tr());
            setState(() {
              isErrorAdharcardFrontSideImage = true;
            });
          } else if (_adharcardBackSideImage == null) {
            Constant_Class.ToastMessage("error_adharcard_back".tr());
            setState(() {
              isErroradharcardBackSideImage = true;
            });
          } else {
            setState(() {
              isErrorProfileImage = false;
              isErrorAdharcardFrontSideImage = false;
              isErroradharcardBackSideImage = false;
              isErrorSelect2Document = false;
              apiCall = true;
            });
            sendRequest(
                firstName: _firstName,
                lastName: _lastName,
                email: _email,
                phone: _phone,
                khatabook_no: _khatabook_id,
                Reference1: _Reference1,
                Reference2: _Reference2,
                profileImage: _profileImage,
                documentAdharcardFront: _adharcardFrontSideImage,
                documentAdharcardBackSideImage: _adharcardBackSideImage,
                documentPancard: _documentPancard,
                documentVotercard: _documentVotercard,
                loan_amount: _loan_amount);
          }
        }
      } else {
        Constant_Class.showNoInternetDialog(context);
      }
    });
  }

  sendRequest(
      {String? firstName,
      String? lastName,
      String? khatabook_no,
      String? email,
      String? phone,
      String? loan_amount,
      String? Reference1,
      String? Reference2,
      File? profileImage,
      File? documentAdharcardFront,
      File? documentAdharcardBackSideImage,
      var documentPancard,
      var documentVotercard}) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    var api_token = myPrefs.getString('api_token') ?? '';
    Constant_Class.PrintMessage("token ==> " + api_token);

    ApiService.sendCustomerLoanRequestForm(
            api_token: api_token.toString(),
            firstName: firstName,
            lastName: lastName,
            khatabook_no: khatabook_no,
            email: email,
            phone: phone,
            loan_amount: loan_amount,
            reference_1: Reference1,
            reference_2: Reference2,
            profileImage: profileImage,
            documentAdharcardFront: documentAdharcardFront,
            documentAdharcardBackSideImage: documentAdharcardBackSideImage,
            documentPancard: documentPancard,
            documentVotercard: documentVotercard)
        .then((response) {
      setState(() {
        apiCall = true;
      });

      var jsonResponse = jsonDecode(response.body);

      var msg = jsonResponse["message"];
      print("Loan Request =>${jsonResponse}");
      try {
        // LoanRequestModel loanRequestModel =
        //     LoanRequestModel.fromJsonUser(jsonResponse);

        // var status = loanRequestModel.status;

        // Constant_Class.ToastMessage(loanRequestModel.message);

        if (msg.toLowerCase() == Constant_Class.strTokenExpire.toLowerCase()) {
          Constant_Class.LoginDataClear(context);
        }
        Constant_Class.ToastMessage(
            msg.isNotEmpty ? msg : Constant_Class.strTryAgainLater);
      } catch (e) {
        Constant_Class.PrintMessage("LOAN REQUEST ERROR => ${e}");
      } finally {
        setState(() {
          apiCall = false;
        });
      }
    });
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

  String? validateKhatabookNo(String? value) {
    if (value.toString().trim().length < 1)
      return "error_khatabook".tr();
    else
      return null;
  }

  String? validateFirstName(String? value) {
    if (value.toString().trim().length < 1)
      return "error_f_name".tr();
    else
      return null;
  }

  String? validateLastName(String? value) {
    if (value.toString().trim().length < 1)
      return "error_l_name".tr();
    else
      return null;
  }

  String? validatePhone(String? value) {
    if (value.toString().trim().length < 1)
      return "error_phone".tr();
    else if (value.toString().trim().length < 10)
      return "error_phone".tr();
    else
      return null;
  }

  String? validateLoanAmount(String? value) {
    if (value.toString().trim().length < 1)
      return "error_loan".tr();
    else if (int.parse(value.toString()) < 1)
      return "error_loan_1".tr();
    else
      return null;
  }
}
