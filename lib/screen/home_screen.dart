import 'dart:convert';

import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/khatabook_data_model.dart';
import 'package:bachat_book_customer/model/transaction_model.dart';
import 'package:bachat_book_customer/model/user_data.dart';
import 'package:bachat_book_customer/screen/agent_profile_screen.dart';
import 'package:bachat_book_customer/screen/loan_list_screen.dart';
import 'package:bachat_book_customer/screen/profile_screen.dart';
import 'package:bachat_book_customer/screen/search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/Constant_Class.dart';
import '../ConstantClasses/app_text_widget.dart';
import '../ConstantClasses/custome_page_transition.dart';
import '../ConstantClasses/popup_menu1.dart';
import '../model/dashboad_screen_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double deviceWidth = 0;
  double deviceWidth1 = 0;
  String customerName = "";
  bool apiCall = false;
  List<Khatabook> khataBookList = [];
  List<TransactionRecord> lastTransaction = [];
  int selectedKhataBookIndex = -1;
  String selectedKhataBookId = "";
  String selectedKhataBookNumber = "";

  String totalSavingAmount = "0.00";
  String todayTotalSavingAmount = "0.00";
  String monthTotalSavingAmount = "0.00";
  String totalPendingSavingAmount = "0.00";

  String totalLoanAmount = "0.00";
  String totalPendingLoanAmount = "0.00";
  String todayTotalLoanAmount = "0.00";
  String monthTotalLoanAmount = "0.00";
  String isFirstTimeOpenApp = "0.00";
  String profileImg = "";

  String startDate = "";
  String endDate = "";
  String lastTransactionDate = "";
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerData();
    fetchProfileData();
  }

  getCustomerData() async {
    if (mounted) {
      setState(() {
        apiCall = true; // Show loading state
      });
    }

    DateTime _endDate = DateTime.now();
    DateTime _startDate = _endDate.subtract(Duration(days: 100));
    startDate = DateFormat("yyyy-MM-dd").format(_startDate);
    endDate = DateFormat("yyyy-MM-dd").format(_endDate);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String fname = preferences.getString("firstname") ?? "User";
    String lname = preferences.getString("lastname") ?? "";

    setState(() {
      selectedKhataBookId = preferences.getString("khatbookid") ?? "";
      selectedKhataBookNumber = preferences.getString("khatbookNumber") ?? "";
      isFirstTimeOpenApp = preferences.getString("firstTime") ?? "no";
      selectedKhataBookIndex = preferences.getInt("selected_book_index") ?? -1;
      profileImg = preferences.getString("profilePicture") ?? "";
      customerName = "$fname $lname";
      apiCall = false;
    });

    if (isFirstTimeOpenApp != "yes") {
      khatabookRecords();
      transactionsAPI();
    }
    Constant_Class.PrintMessage("Customer Name => $customerName");
    Constant_Class.PrintMessage("selectedKhataBookId => $selectedKhataBookId");
    Constant_Class.PrintMessage(
        "selectedKhataBookNumber => $selectedKhataBookNumber");
    Constant_Class.PrintMessage("isFirstTimeOpenApp => $isFirstTimeOpenApp");
  }

  fetchProfileData() async {
    setState(() => apiCall = true); // Start API call

    SharedPreferences myPref = await SharedPreferences.getInstance();
    var api_token = myPref.getString("api_token");
    isFirstTimeOpenApp = myPref.getString("firstTime") ?? "no";

    try {
      final response = await ApiService.GetProfile(api_token.toString());
      final responseJson = json.decode(response.body);

      print("PROFILE API RESPONSE => ${responseJson}");

      DashboardScreenModel dashboardScreenModel =
          DashboardScreenModel.fromJsonStatus(responseJson);
      var status = dashboardScreenModel.status;

      if (status == "success") {
        dashboardScreenModel = DashboardScreenModel.fromJsonUser(responseJson);
        khataBookList = dashboardScreenModel.customerData.khatabooks;
        if (isFirstTimeOpenApp == "yes") {
          if (khataBookList.length != 1) {
            khatabookDialogBox();
          } else {
            selectedKhataBookIndex = 0;
            myPref.setInt("selected_book_index", 0);
            selectedKhataBookNumber = khataBookList.first.khatabookNo;
            selectedKhataBookId = khataBookList.first.khatabookId;
            selectedKhataBookApi(selectedKhataBookId, selectedKhataBookNumber);
          }
        }
      } else {
        dashboardScreenModel = DashboardScreenModel.fromJsonfail(responseJson);
        if (dashboardScreenModel.message.toLowerCase() ==
            Constant_Class.strTokenExpire.toLowerCase()) {
          Constant_Class.LoginDataClear(context);
        }
        Constant_Class.ToastMessage(dashboardScreenModel.message.isNotEmpty
            ? dashboardScreenModel.message
            : Constant_Class.strTryAgainLater);
      }
    } catch (e) {
      Constant_Class.PrintMessage("PROFILE API ERROR => $e");
    } finally {
      setState(() => apiCall = false);
    }
  }

  showKhataBookListDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => isFirstTimeOpenApp == "yes" ? false : true,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: ColorsApp.colorWhite,
                  insetPadding: EdgeInsets.only(left: 12, right: 12, top: 0),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 16, bottom: 16, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // "Select Your Khata Book",
                          "select_book_lbl".tr(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: khataBookList.length,
                          itemBuilder: (context, index) {
                            final khataBook = khataBookList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      selectedKhataBookIndex = index;
                                      pref.setInt("selected_book_index",
                                          selectedKhataBookIndex);
                                      selectedKhataBookId =
                                          khataBook.khatabookId;
                                      selectedKhataBookNumber =
                                          khataBook.khatabookNo;
                                    });
                                  }, // Close dialog
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.only(left: 12, right: 12),

                                    backgroundColor:
                                        selectedKhataBookIndex == index
                                            ? ColorsApp.colorLightPurple
                                            : ColorsApp.colorWhite,
                                    elevation: 2,
                                    // shadowColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: selectedKhataBookIndex != index
                                            ? ColorsApp.colorPurple
                                            : Colors.transparent,
                                        width: selectedKhataBookIndex == index
                                            ? 2
                                            : 0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.book,
                                          color: ColorsApp.colorPurple
                                              .withOpacity(0.8),
                                          size: 30),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "khatabook_no".tr() +
                                                  khataBook.khatabookNo,
                                              style: TextStyle(
                                                color: selectedKhataBookIndex !=
                                                        index
                                                    ? ColorsApp.colorBlack
                                                    : ColorsApp.colorPurple,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                              )),
                                          Text(
                                            "duratioin".tr() +
                                                ((khataBook.durationDays ==
                                                            "null" ||
                                                        khataBook.durationDays
                                                            .isEmpty)
                                                    ? "-- --"
                                                    : khataBook.durationDays) +
                                                " days".tr(),
                                            style: TextStyle(
                                                color: selectedKhataBookIndex !=
                                                        index
                                                    ? ColorsApp.colorBlack
                                                    : ColorsApp.colorPurple,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      selectedKhataBookIndex == index
                                          ? Icon(Icons.done_outline,
                                              color: ColorsApp.colorPurple)
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: () {
                            Constant_Class.check().then((internet) {
                              if (internet) {
                                if (selectedKhataBookIndex == -1) {
                                  Constant_Class.ToastMessage(
                                      "Plase Select Khata Book");
                                } else {
                                  selectedKhataBookApi(selectedKhataBookId,
                                      selectedKhataBookNumber);
                                  Navigator.pop(context);
                                }
                              } else {
                                Navigator.pop(context);
                                Constant_Class.showNoInternetDialog(context);
                              }
                            });
                          },
                          child: Container(
                            decoration:
                                Constant_Class.buttonGradiantDecoration(),
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            child: Center(
                              child: Text(
                                "select_book".tr(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.colorWhite),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  selectedKhataBookApi(String Khatabookid, String khatabookNumber) async {
    setState(() {
      apiCall = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("firstTime", "no");
    isFirstTimeOpenApp = 'no';
    preferences.setString("khatbookid", Khatabookid);
    preferences.setString("khatbookNumber", khatabookNumber);

    // Wait for 1 second before calling APIs
    await Future.delayed(Duration(seconds: 1));

    // Call both functions and wait for them to finish before setting apiCall = false
    await getCustomerData();
    await khatabookRecords();

    setState(() {
      apiCall = false; // Set apiCall to false after API calls are completed
    });
  }

  khatabookRecords() async {
    setState(() => apiCall = true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var api_token = preferences.getString("api_token");
    var khatabookId = preferences.getString("khatbookid");

    Constant_Class.PrintMessage("api token => $api_token");
    Constant_Class.PrintMessage("khatabook id => $khatabookId");

    try {
      final response = await ApiService.SettingApi(
          api_token.toString(), khatabookId.toString());

      final responseJson = jsonDecode(response.body);
      Constant_Class.PrintMessage("SETTING API RESPONSE=> $responseJson");

      SettingModel settingModel = SettingModel.fromJsonStatus(responseJson);
      if (settingModel.status == "success") {
        settingModel = SettingModel.fromJsonUser(responseJson);

        totalSavingAmount =
            settingModel.khataBookData.totalSavingAmount ?? "0.00";
        totalPendingSavingAmount =
            settingModel.khataBookData.totalPendingSavingAmount ?? "0.00";
        todayTotalSavingAmount =
            settingModel.khataBookData.todayTotalSavingAmount ?? "0.00";
        monthTotalSavingAmount =
            settingModel.khataBookData.monthlyTotalSavingAmount ?? "0.00";

        // ================================ Loan ===============================
        totalLoanAmount = settingModel.khataBookData.totalLoanAmount ?? "0.00";
        totalPendingLoanAmount =
            settingModel.khataBookData.totalPendingLoanAmount ?? "0.00";
        todayTotalLoanAmount =
            settingModel.khataBookData.todayTotalLoanAmount ?? "0.00";
        monthTotalLoanAmount =
            settingModel.khataBookData.monthlyTotalLoanAmount ?? "0.00";

        // transactionsAPI();
      } else {
        SettingModel errorModel = SettingModel.fromJsonfail(responseJson);
        if (errorModel.message.toLowerCase() ==
            Constant_Class.strTokenExpire.toLowerCase()) {
          Constant_Class.LoginDataClear(context);
        }
        Constant_Class.ToastMessage(errorModel.message.isNotEmpty
            ? errorModel.message
            : Constant_Class.strTryAgainLater);
      }
    } catch (e) {
      Constant_Class.PrintMessage("SETTING API ERROR => $e");
    } finally {
      setState(() => apiCall = false);
    }
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
          khatabookId.toString(), startDate, endDate, "10", "1");
      final responseJson = jsonDecode(response.body);
      Constant_Class.PrintMessage("TRANSACTION API RESPOSE => $responseJson");
      TransactionModel transactionModel =
          TransactionModel.fromJson(responseJson);
      var status = transactionModel.status;
      if (status == "success") {
        lastTransaction.clear();
        setState(() {
          lastTransaction.addAll(transactionModel.transactionRecords);
        });
        var lastDate = DateTime.parse(lastTransaction.last.transactionDatetime);
        var formatDate = DateFormat("dd-MMM-yyyy HH:mm").format(lastDate);
        lastTransactionDate = formatDate;
      } else {
        lastTransaction.clear();
        TransactionModel transactionModel =
            TransactionModel.fromJson(responseJson);
        var msg = transactionModel.msg;
        Constant_Class.ToastMessage("${msg}");
      }
    } catch (e) {
      Constant_Class.PrintMessage("TRANSACTION API ERROR => $e");
    } finally {
      setState(() => apiCall = false); // End API call
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      setState(() {
        deviceWidth = MediaQuery.of(context).size.width - 40;
        deviceWidth1 = MediaQuery.of(context).size.width - 60;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsApp.colorWhite,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 14, right: 14),
                          height: MediaQuery.of(context).size.height * 0.20,
                          decoration: BoxDecoration(
                              color: ColorsApp.colorPurple,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/home_card_back.png"),
                                  fit: BoxFit.cover,
                                  opacity: 0.1),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(spreadRadius: 0.2, blurRadius: 1.9)
                              ])),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CustomPageTransition(page: ProfileScreen()),
                                );
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ProfileScreen()));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28.0,
                                    backgroundColor: ColorsApp.colorWhite,
                                    child: SizedBox(
                                      // height: 100,
                                      // width: 100,
                                      child: ClipOval(
                                          child: (profileImg != "" ||
                                                  profileImg.isNotEmpty)
                                              ? Image.network(profileImg)
                                              : Image.asset(
                                                  "assets/images/icon_no_profile.png",
                                                  fit: BoxFit.cover,
                                                  height: 35,
                                                )),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "welcome".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.colorWhite),
                                      ),
                                      Text(customerName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: ColorsApp.colorWhite)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CustomPageTransition(
                                      page: AgentProfileScreen()),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           AgentProfileScreen()),
                                // );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: ColorsApp.colorBlack,
                                        width: 0.4)),
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: CircleAvatar(
                                      radius: 16.0,
                                      backgroundColor: ColorsApp.colorWhite,
                                      child: Icon(Icons.person)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 28,
                        child: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "my_balance".tr(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.colorWhite),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                Constant_Class.strCurrencySymbols +
                                    " " +
                                    (totalSavingAmount.isEmpty
                                        ? "XX.XX"
                                        : totalSavingAmount),
                                style: TextStyle(
                                    fontSize: 38,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.colorWhite),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 26,
                        bottom: 16,
                        child: GestureDetector(
                          onTap: () {
                            khatabookDialogBox();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 12, right: 4, top: 6, bottom: 6),
                            decoration: BoxDecoration(
                                color: ColorsApp.colorWhite,
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: [
                                Text(
                                  "khata_book".tr() + selectedKhataBookNumber,
                                  style: TextStyle(
                                    color: ColorsApp.colorPurple,
                                    fontSize: 10,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  // color: ColorsApp.colorWhite,
                                  color: ColorsApp.colorPurple,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  savingBalanceBox(),
                  SizedBox(height: 20),
                  loanBalanceBox(),
                  SizedBox(height: 20),
                  lastTransaction.isNotEmpty
                      ? _last10TransactionView()
                      : SizedBox()
                ],
              ),
            ),
            Center(
                child: apiCall
                    ? Constant_Class.apiLoadingAnimation(context)
                    : Container()),
          ],
        ),
      ),
    );
  }

  khatabookDialogBox() async {
    Constant_Class.check().then((internet) {
      if (internet) {
        showKhataBookListDialog();
      } else {
        Constant_Class.showNoInternetDialog(context);
      }
    });
  }

  Widget _last10TransactionView() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
      decoration: BoxDecoration(
          // color: ColorsApp.colorPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: ColorsApp.colorPurple1, width: 0.1)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            // margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            // height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsApp.colorWhite, // Clean White Background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: ColorsApp.colorPurple1, width: 0.1),
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
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "recent_transaction".tr(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.colorBlack,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CustomPageTransition(page: SearchScreen(false)),
                    );
                    //
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SearchScreen(false)));
                  },
                  child: Text(
                    "view_all_transaction".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.colorPurple,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  // left: 10,
                  // right: 10,
                  top: 3,
                  bottom: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: ColorsApp.colorPurple1, width: 0.1),
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(0),
                  topLeft: const Radius.circular(0),
                ),
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
                color: ColorsApp.colorWhite,
              ),
              padding: const EdgeInsets.only(
                  left: 26, top: 12, right: 0, bottom: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // SizedBox(width: 10),
                    Text(
                      "date".tr(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 40),
                    Text(
                      "saving_A".tr(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 40),
                    Text(
                      "loan_A".tr(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 30),
                    Text(
                      "total_A".tr(),
                      style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(width: 10),
                  ])),
          lastTransaction.isEmpty
              ? SizedBox(
                  height: 100,
                  child: Center(
                    child: Text("Transaction Not Found"),
                  ),
                )
              : Container(
                  // margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: ColorsApp.colorWhite,
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
                          offset: Offset(
                              -1, -1), // Opposite light shadow for realism
                        ),
                      ],
                      border: Border.symmetric(
                          horizontal: BorderSide(
                              color: ColorsApp.colorPurple, width: 0.1),
                          vertical: BorderSide(
                              color: ColorsApp.colorPurple, width: 0.1))),
                  child: Column(
                    children: [
                      for (int index = 0;
                          index <
                              (lastTransaction.length > 10
                                  ? 10
                                  : lastTransaction.length);
                          index++)
                        SizedBox(
                          height: 30,
                          width: double.infinity,
                          child: transaction(index),
                        )
                    ],
                  ),
                ),
          // Container(
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 10),
          //   height: 30,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: ColorsApp.colorPurple1, width: 0.5),
          //     borderRadius: new BorderRadius.only(
          //       bottomLeft: const Radius.circular(20),
          //       bottomRight: const Radius.circular(20),
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: ColorsApp.colorPurple
          //             .withOpacity(0.08), // Soft purple shadow
          //         spreadRadius: 1,
          //         blurRadius: 4,
          //         offset: Offset(2, 3), // Slight shadow below for depth
          //       ),
          //       BoxShadow(
          //         color: ColorsApp.colorBlack
          //             .withOpacity(0.05), // Light black shadow
          //         spreadRadius: 1,
          //         blurRadius: 3,
          //         offset: Offset(-1, -1), // Opposite light shadow for realism
          //       ),
          //     ],
          //     color: ColorsApp.colorWhite,
          //   ),
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => SearchScreen(false)));
          //     },
          //     child: Text(
          //       "view_all_transaction".tr(),
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 14,
          //         fontFamily: "Poppins",
          //         fontWeight: FontWeight.w500,
          //         decoration: TextDecoration.underline,
          //         color: ColorsApp.colorBlack,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  transaction(index) {
    String strComment = lastTransaction[index].comment != null &&
            lastTransaction[index].comment != ""
        ? lastTransaction[index].comment
        : "";
    String formattedDate = DateFormat("dd MMM yyyy").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(lastTransaction[index].transactionDatetime));
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
      // margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: ColorsApp.colorWhite,
        border: Border.all(color: ColorsApp.colorPurple, width: 0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: (deviceWidth / 4) + 0,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    formattedDate,
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
                //           // padding: EdgeInsets.only(left: 10),
                //           offset: Offset(20.0, 5.0),
                //           child: Container(
                //             // color: Colors.purple,
                //             child: Icon(
                //               Icons.info_outline_rounded,
                //               size: 14,
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
                // ),
              ],
            ),
          ),
          Container(color: ColorsApp.colorPurple, width: 0.2),
          Container(
            padding: EdgeInsets.only(left: 2, right: 2),
            width: (deviceWidth / 4) - 4,
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
          Container(color: ColorsApp.colorPurple, width: 0.2),
          Container(
            padding: EdgeInsets.only(left: 2, right: 2),
            width: (deviceWidth / 4) - 4,
            child: Text(Constant_Class.strCurrencySymbols + " ${loanAmount}",
                style: TextStyle(
                    color: ColorsApp.colorBlack.withOpacity(0.7),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                textAlign: TextAlign.center),
          ),
          Container(color: ColorsApp.colorPurple, width: 0.2),
          Container(
            padding: EdgeInsets.only(left: 2, right: 4),
            width: deviceWidth / 4,
            child: Text(
              Constant_Class.strCurrencySymbols + "${totalAmount}",
              style: TextStyle(
                  color: ColorsApp.colorBlack.withOpacity(0.7),
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  savingBalanceBox() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 14, right: 14),
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: ColorsApp.colorWhite, // White background
        border: Border.all(
            color: ColorsApp.colorPurple1.withOpacity(0.9),
            width: 0.1), // Subtle border
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
              color:
                  ColorsApp.colorPurple.withOpacity(0.1), // Soft purple shadow
              spreadRadius: 0.2, // Slight spread for a smooth effect
              blurRadius: 2, // Increased blur for a soft shadow
              offset: Offset(2, 5)),
          BoxShadow(
            color: ColorsApp.colorBlack
                .withOpacity(0.02), // Secondary light shadow
            spreadRadius: 1,
            blurRadius: 0.10,
            offset: Offset(-2, -2), // Light upper shadow for 3D effect
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "saving_balance".tr(),
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.colorBlack),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "last_transaction".tr() + "${lastTransactionDate}",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorBlack.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorsApp.colorPurple, // Set the border color
                    width: 0.8, // Set the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(100), // Apply border radius
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: CircleAvatar(
                      radius: 18,
                      backgroundColor: ColorsApp.colorWhite,
                      child: Image.asset(
                        "assets/images/wallet_icon.png",
                        height: 20,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "available_balance".tr(),
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: ColorsApp.colorBlack),
          ),
          Text(
            Constant_Class.strCurrencySymbols + " ${todayTotalSavingAmount}",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: ColorsApp.colorBlack),
          ),
        ],
      ),
    );
  }

  loanBalanceBox() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 14, right: 14, top: 0),
      decoration: BoxDecoration(
        color: ColorsApp.colorWhite, // Light Purple Background
        border: Border.all(
          color:
              ColorsApp.colorPurple1.withOpacity(0.9), // Subtle purple border
          width: 0.1, // Slightly increased for better visibility
        ),
        borderRadius: BorderRadius.circular(20), // Smooth rounded corners
        boxShadow: [
          BoxShadow(
            color:
                ColorsApp.colorPurple.withOpacity(0.12), // Soft purple shadow
            spreadRadius: 0.2, // More spread for smooth effect
            blurRadius: 2, // Increased blur for a lifted card effect
            offset: Offset(2, 5), // Shadow direction
          ),
          BoxShadow(
            color: ColorsApp.colorBlack.withOpacity(0.04), // Light black shadow
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(-2, -2), // Opposite light shadow for depth
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 14, top: 16, right: 14, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "loan_balance".tr(),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: ColorsApp.colorBlack),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CustomPageTransition(page: LoanListScreen()),
                    );
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LoanListScreen()));
                  },
                  child: Text(
                    "show_transaction".tr(),
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: ColorsApp.colorPurple),
                  ),
                )
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.only(left: 14, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 10, bottom: 0, left: 10, right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/home_card_back.png"),
                          fit: BoxFit.cover,
                          opacity: 0.2),
                      color: ColorsApp.colorPurple,
                      boxShadow: [
                        BoxShadow(spreadRadius: 0.1, blurRadius: 0.2)
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "total_outstanding".tr(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: ColorsApp.colorWhite.withOpacity(0.9)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          Constant_Class.strCurrencySymbols +
                              " ${totalLoanAmount}",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.colorWhite),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 10, right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/home_card_back.png"),
                          fit: BoxFit.cover,
                          opacity: 0.2),
                      color: ColorsApp.colorPurple,
                      boxShadow: [
                        BoxShadow(spreadRadius: 0.1, blurRadius: 0.2)
                      ],
                      // borderRadius: BorderRadius.circular(10),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "total_overdue".tr(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: ColorsApp.colorWhite.withOpacity(0.9)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          Constant_Class.strCurrencySymbols +
                              " ${totalPendingLoanAmount}",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: ColorsApp.colorWhite),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // SizedBox(height: 16),
        ],
      ),
    );
  }
}
