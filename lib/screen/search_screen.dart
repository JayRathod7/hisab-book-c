import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/app_text_widget.dart';
import '../ConstantClasses/popup_menu1.dart';
import '../api_service/api_service.dart';
import '../model/transaction_model.dart';

class SearchScreen extends StatefulWidget {
  bool isTabClick;
  SearchScreen(this.isTabClick);

  @override
  _SearchScreenState createState() => _SearchScreenState(this.isTabClick);
}

class _SearchScreenState extends State<SearchScreen> {
  bool isTabClick;
  _SearchScreenState(this.isTabClick);
  double deviceWidth = 0;
  double deviceWidth1 = 0;
  bool apiCall = false;
  List<TransactionRecord> lastTransaction = [];
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionsAPI();
    getDate();
  }

  getDate() async {
    DateTime _endDate = DateTime.now();
    DateTime _startDate = _endDate.subtract(Duration(days: 30));
    startDate = DateFormat("yyyy-MM-dd").format(_startDate);
    endDate = DateFormat("yyyy-MM-dd").format(_endDate);
    print("start Date : ${startDate}");
    print("end Date : ${endDate}");
  }

  transactionsAPI() async {
    setState(() => apiCall = true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var api_token = preferences.getString("api_token");
    var khatabookId = preferences.getString("khatbookid");

    Constant_Class.PrintMessage("token ==> ${api_token.toString()}");
    Constant_Class.PrintMessage("start date ==> ${startDate}");
    Constant_Class.PrintMessage("end date ==> ${endDate}");
    try {
      final response = await ApiService.TransactoionApi(api_token.toString(),
          khatabookId.toString(), startDate, endDate, "100", "1");
      final responseJson = jsonDecode(response.body);
      Constant_Class.PrintMessage("TRANSACTION API RESPOSE => $responseJson");
      TransactionModel transactionModel =
          TransactionModel.fromJson(responseJson);
      var status = transactionModel.status;
      if (status == "success") {
        Constant_Class.PrintMessage(
            "TRANSACTION API RESPONSE => ${transactionModel.transactionRecords}");
        setState(() {
          lastTransaction.clear();
          lastTransaction.addAll(transactionModel.transactionRecords);
        });
      } else {
        lastTransaction.clear();
        TransactionModel transactionModel =
            TransactionModel.fromJson(responseJson);
        if (transactionModel.msg.toLowerCase() ==
            Constant_Class.strTokenExpire.toLowerCase()) {
          Constant_Class.LoginDataClear(context);
        }
        Constant_Class.ToastMessage(transactionModel.msg.isNotEmpty
            ? transactionModel.msg
            : Constant_Class.strTryAgainLater);
      }
    } catch (e) {
      Constant_Class.PrintMessage("TRANSACTION API ERROR => $e");
    } finally {
      if (mounted) {
        setState(() {
          apiCall = false;
        });
      }
    }
  }

  selectDateAndTime() async {
    if (mounted) {
      setState(() {
        apiCall = true;
      });
    }
    var pickedDate = await showDateRangePicker(
        context: context,
        locale: const Locale('en', 'IN'),
        fieldEndHintText: 'dd/mm/yyyy',
        fieldStartHintText: 'dd/mm/yyyy',
        firstDate: DateTime(1950),
        lastDate: DateTime(2100),
        saveText: "Apply");

    if (pickedDate != null) {
      DateTime _startDate = pickedDate.start;
      DateTime _endDate = pickedDate.end;

      startDate = DateFormat("yyyy-MM-dd").format(_startDate);
      endDate = DateFormat("yyyy-MM-dd").format(_endDate);

      print("Start Date: $startDate");
      print("End Date: $endDate");
      await transactionsAPI(); // Ensure API call completes before resetting apiCall
    }

    setState(() {
      apiCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      deviceWidth = MediaQuery.of(context).size.width - 40;
      deviceWidth1 = MediaQuery.of(context).size.width - 60;
    });
    return Scaffold(
        backgroundColor: ColorsApp.colorWhite,
        appBar: AppBar(
          backgroundColor: ColorsApp.colorPurple,
          iconTheme: IconThemeData(
            color: ColorsApp.colorWhite,
          ),
          title: Row(
            children: [
              Text(
                "transaction_history".tr(),
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.colorWhite),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(
                Icons.filter_alt_rounded,
                color: ColorsApp.colorWhite,
              ),
              onSelected: (String value) {
                filterListUsingDate(value);
              },
              itemBuilder: (BuildContext context) => [
                _buildPopupMenuItem("today", "Today"),
                _buildPopupMenuItem("yesterday", "Yesterday"),
                _buildPopupMenuItem("this_week", "This Week"),
                _buildPopupMenuItem("this_month", "This Month"),
                _buildPopupMenuItem("this_year", "This Year"),
                _buildPopupMenuItem("custom", "Custom Date"),
              ],
            ),
            SizedBox(width: 10),
          ],
        ),
        body: new Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: ColorsApp.colorPurple, width: 0.4)),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      // margin: EdgeInsets.only(top: 10, bottom: 0),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorsApp.colorPurple, width: 0.1),
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: ColorsApp.colorPurple
                                    .withOpacity(0.08), // Soft purple shadow
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(
                                    2, 3) // Slight shadow below for depth
                                ),
                            BoxShadow(
                                color: ColorsApp.colorBlack
                                    .withOpacity(0.05), // Light black shadow
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(
                                    -1, -1) // Opposite light shadow for realism
                                ),
                          ],
                          color: ColorsApp.colorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            DateFormat('dd-MM-yyyy').format(
                                DateFormat('yyyy-MM-dd').parse(startDate)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: ColorsApp.colorBlack,
                                decoration: TextDecoration.underline),
                          ),
                          Text(
                            "to".tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.colorBlack,
                            ),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(
                                DateFormat('yyyy-MM-dd').parse(endDate)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.colorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    lastTransaction.length != 0
                        ? Container(
                            margin: EdgeInsets.only(
                                // left: 10,
                                top: 3,
                                // right: 10,
                                bottom: 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsApp.colorPurple, width: 0.1),
                              borderRadius: new BorderRadius.only(
                                topRight: const Radius.circular(0),
                                topLeft: const Radius.circular(0),
                              ),
                              color: ColorsApp.colorWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: ColorsApp.colorPurple
                                      .withOpacity(0.08), // Soft purple shadow
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(
                                      2, 3), // Slight shadow below for depth
                                ),
                                BoxShadow(
                                  color: ColorsApp.colorBlack
                                      .withOpacity(0.05), // Light black shadow
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(-1,
                                      -1), // Opposite light shadow for realism
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 26, top: 12, right: 0, bottom: 12),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  // SizedBox(width: 10),
                                  Text(
                                    "date".tr(),
                                    style: TextStyle(
                                        color: ColorsApp.colorBlack,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 40),
                                  Text(
                                    "saving_A".tr(),
                                    style: TextStyle(
                                        color: ColorsApp.colorBlack,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(width: 40),
                                  Text(
                                    "loan_A".tr(),
                                    style: TextStyle(
                                        color: ColorsApp.colorBlack,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(width: 30),
                                  Text(
                                    "total_A".tr(),
                                    style: TextStyle(
                                        color: ColorsApp.colorBlack,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(width: 10),
                                ]))
                        : SizedBox(),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: ColorsApp.colorWhite,
                        borderRadius: BorderRadius.only(
                          bottomRight: lastTransaction.isEmpty
                              ? Radius.circular(20)
                              : Radius.circular(0),
                          bottomLeft: lastTransaction.isEmpty
                              ? Radius.circular(20)
                              : Radius.circular(0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsApp.colorPurple
                                .withOpacity(0.08), // Soft purple shadow
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset:
                                Offset(2, 3), // Slight shadow below for depth
                          ),
                          BoxShadow(
                            color: ColorsApp.colorBlack
                                .withOpacity(0.05), // Light black shadow
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(
                                -1, -1), // Opposite light shadow for realism
                          ),
                        ],
                        border: Border.all(
                            color: ColorsApp.colorPurple, width: 0.1),
                      ),
                      margin: EdgeInsets.only(
                          top: 3,
                          // left: 11, right: 11,
                          bottom: lastTransaction.isEmpty ? 0 : 3),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          for (int index = 0;
                              index < lastTransaction.length;
                              index++)
                            SizedBox(
                                height: 45.0,
                                width: double.infinity,
                                child: ListRow(index)),
                        ],
                      ),
                    )),
                    lastTransaction.length != 0
                        ? finalTotalFooterRow()
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Center(
                child: apiCall
                    ? Constant_Class.apiLoadingAnimation(context)
                    : Container()),
            apiCall
                ? SizedBox()
                : Center(
                    child: lastTransaction.length == 0
                        ? Container(
                            margin: const EdgeInsets.only(
                                top: 100, left: 0, right: 0, bottom: 0),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/icon_transaction.png',
                                    height: 50,
                                    width: 50,
                                    color: ColorsApp.colorGrey,
                                    alignment: Alignment.center),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "statement_n_available".tr(),
                                  style: TextStyle(
                                      color: ColorsApp.colorGrey,
                                      fontFamily: "Poppins",
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ))
                        : SizedBox()),
          ],
        ));
  }

  finalTotalFooterRow() {
    var saving = 0.00;
    var loan = 0.00;
    var total = 0.00;
    for (var i in lastTransaction) {
      saving += double.parse(i.savingAmount);
      print("saving => ${saving}");
      loan += double.parse(i.loanAmount);
      print("loan=> ${loan}");
    }
    total = saving + loan;
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0),
      height: 50,
      child: Column(
        children: [
          Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
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
                ],
                border: Border.symmetric(
                    vertical:
                        BorderSide(color: ColorsApp.colorPurple, width: 0.2)),
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                color: ColorsApp.colorWhite,
              ),
              // padding: const EdgeInsets.only(
              //     left: 30, top: 12, right: 0, bottom: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "total".tr(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 40),
                    Text(
                      Constant_Class.strCurrencySymbols + saving.toString(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 30),
                    Text(
                      Constant_Class.strCurrencySymbols + loan.toString(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 30),
                    Text(
                      Constant_Class.strCurrencySymbols + total.toString(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 10),
                  ])),
        ],
      ),
    );
  }

  void filterListUsingDate(String value) {
    final now = DateTime.now();

    if (value == "today") {
      // Get today's date in the format yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      startDate = formattedDate;
      endDate = formattedDate;
    } else if (value == "yesterday") {
      // Get yesterday's date
      DateTime yesterday = now.subtract(Duration(days: 1));
      String formattedDate = DateFormat('yyyy-MM-dd').format(yesterday);
      startDate = formattedDate;
      endDate = formattedDate;
    } else if (value == "this_week") {
      // Get the start and end date for the current week
      DateTime startOfWeek =
          now.subtract(Duration(days: now.weekday - 1)); // Start of this week
      DateTime endOfWeek = startOfWeek
          .add(Duration(days: 6)); // End of this week (6 days after start)

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endOfWeek);

      startDate = formattedStartDate;
      endDate = formattedEndDate;
    } else if (value == "this_month") {
      // Get the start and end date for the current month
      DateTime startOfMonth =
          DateTime(now.year, now.month, 1); // First day of this month
      DateTime endOfMonth =
          DateTime(now.year, now.month + 1, 0); // Last day of this month

      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startOfMonth);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endOfMonth);

      startDate = formattedStartDate;
      endDate = formattedEndDate;
    } else if (value == "this_year") {
      DateTime startOfYear = DateTime(now.year, now.month, now.day);
      DateTime enfOfYear = DateTime(now.year - 1, now.month, now.day);
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startOfYear);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(enfOfYear);
      startDate = formattedEndDate;
      endDate = formattedStartDate;
    } else if (value == "custom") {
      selectDateAndTime();
    } else {
      Constant_Class.PrintMessage(
          "not selected any filter : ${Constant_Class.strTryAgainLater}");
    }
    Constant_Class.PrintMessage("start date $startDate");
    Constant_Class.PrintMessage("end date $endDate");
    if (value != "custom") {
      setState(() {
        apiCall = true;
      });
      transactionsAPI();
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String label) {
    return PopupMenuItem(
      value: value,
      child: Text(label),
    );
  }

  Widget ListRow(int index) {
    String strComment = lastTransaction[index].comment != null &&
            lastTransaction[index].comment != ""
        ? lastTransaction[index].comment
        : "";

    var _formatDateDDMMMYYYY = strComment != "" ? 'dd MMM yyyy' : 'dd MMM yyyy';

    String date = DateFormat(_formatDateDDMMMYYYY)
        .format(DateTime.parse(lastTransaction[index].transactionDatetime));

    var savingAmount = (lastTransaction[index].savingAmount == "" ||
            lastTransaction[index].savingAmount == null)
        ? "0.00"
        : lastTransaction[index].savingAmount;
    var loanAmount = (lastTransaction[index].loanAmount == "" ||
            lastTransaction[index].loanAmount == null)
        ? "0.00"
        : lastTransaction[index].loanAmount;
    var totalAmount = double.parse(savingAmount) + double.parse(loanAmount);

    return Container(
      // margin: EdgeInsets.only(bottom: 2, top: 2),
      decoration: lastTransaction.length != 0
          ? BoxDecoration(
              color: ColorsApp.colorWhite,
              border: Border.all(color: ColorsApp.colorPurple, width: 0.1),
            )
          : BoxDecoration(
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
              ],
              border: Border.symmetric(
                  vertical:
                      BorderSide(color: ColorsApp.colorPurple, width: 0.2)),
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(25),
                bottomRight: const Radius.circular(25),
              ),
              color: ColorsApp.colorWhite,
            ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: (deviceWidth1 / 4) + 0,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorsApp.colorBlack.withOpacity(0.7),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: strComment != null && strComment != ""
                  //       ? PopupMenuButton1(
                  //           padding: EdgeInsets.all(0),
                  //           offset: Offset(20.0, 5.0),
                  //           child: Container(
                  //             padding: EdgeInsets.all(0),
                  //             child: Icon(
                  //               Icons.info_outline_rounded,
                  //               size: 15,
                  //               color: ColorsApp.colorGrey,
                  //             ),
                  //           ),
                  //           elevation: 5.0,
                  //           tooltip: 'Customer comment',
                  //           onSelected: (value) {
                  //             if (value == 0) {
                  //               dispose();
                  //             }
                  //           },
                  //           itemBuilder: (context) => [
                  //             PopupMenuItem1(
                  //               height: 30,
                  //               child: Text(
                  //                 strComment,
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //               textStyle: TextStyle(
                  //                   fontFamily: 'Poppins',
                  //                   fontWeight: FontWeight.normal,
                  //                   fontSize: 14),
                  //               value: 0,
                  //             )
                  //           ],
                  //         )
                  //       : SizedBox(),
                  // )
                ],
              ),
            ),
            Container(color: ColorsApp.colorPurple, width: 0.1),
            Container(
              padding: EdgeInsets.only(left: 2, right: 2),
              width: (deviceWidth1 / 4) - 4,
              child: Text(
                Constant_Class.strCurrencySymbols + " ${savingAmount}",
                style: TextStyle(
                    color: ColorsApp.colorBlack.withOpacity(0.7),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Container(color: ColorsApp.colorPurple, width: 0.1),
            Container(
              width: (deviceWidth1 / 4) - 4,
              padding: EdgeInsets.only(left: 2, right: 2),
              child: Text(
                Constant_Class.strCurrencySymbols + " ${loanAmount}",
                style: TextStyle(
                    color: ColorsApp.colorBlack.withOpacity(0.7),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Container(color: ColorsApp.colorPurple, width: 0.1),
            Container(
              width: deviceWidth / 4,
              padding: EdgeInsets.only(left: 2, right: 4),
              child: Text(
                Constant_Class.strCurrencySymbols + " ${totalAmount}",
                style: TextStyle(
                    color: ColorsApp.colorBlack.withOpacity(0.7),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
    );
  }
}
