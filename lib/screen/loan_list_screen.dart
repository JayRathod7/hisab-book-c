import 'dart:convert';

import 'package:bachat_book_customer/ConstantClasses/Constant_Class.dart';
import 'package:bachat_book_customer/api_service/api_service.dart';
import 'package:bachat_book_customer/model/loan_list_model.dart';
import 'package:bachat_book_customer/screen/loan_detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/app_text_widget.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  bool apiCall = false;
  List<LoanListModel> loanList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoanList();
  }

  getLoanList() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    var api_token = myPref.getString("api_token");

    try {
      final response = await ApiService.getLoanList(api_token.toString());
      final jsonResponse = jsonDecode(response.body);
      var status = jsonResponse['status'];
      if (status == 1 || status == "success") {
        loanList.clear();

        if (jsonResponse['data'] is Map<String, dynamic>) {
          var loanListData = jsonResponse['data'] as Map<String, dynamic>;
          loanList = loanListData.values
              .map((e) => LoanListModel.fromJson(e))
              .toList();
        }
        setState(() {});
      } else {
        loanList.clear();
        Constant_Class.ToastMessage(jsonResponse['message']);
      }
      Constant_Class.PrintMessage("LOAN LIST RESPONSE => ${jsonResponse}");
    } catch (e) {
      Constant_Class.PrintMessage("LOAN LIST ERROR => ${e}");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: ColorsApp.colorPurple,
          iconTheme: IconThemeData(color: ColorsApp.colorWhite),
          centerTitle: true,
          title: Row(
            children: [
              Text(
                "loan_list".tr(),
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.colorWhite),
              ),
            ],
          ),
        ),
        body: loanList.isEmpty
            ? Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.7,
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          // decoration: BoxDecoration(color: Colors.purple),
                          child: Image.asset(
                            "assets/images/icon_no_loan.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "no_loan_found".tr(),
                        style: TextStyle(
                          color: ColorsApp.colorBlack,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ]),
              )
            : ListView.builder(
                itemCount: loanList.length,
                // itemCount: 10,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  var loanListData = loanList[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => LoanDetailScreen(
                                      loanListMode: loanListData,
                                    )));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/home_back2.jpg"),
                                fit: BoxFit.cover,
                                opacity: 0.5),
                            color: ColorsApp.colorPurple1,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "loan_status".tr(),
                                    style: TextStyle(
                                      color: ColorsApp.colorBlack,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3,
                                        horizontal: 10), // Smaller padding
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          12), // Soft capsule shape
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.6),
                                          width: 0.8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        checkLoanStatus(index),
                                        style: TextStyle(
                                          color: ColorsApp.colorBlack,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12, // Smaller text
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Divider(
                                  color: ColorsApp.colorBlack.withOpacity(0.5),
                                  thickness: 0.6),
                              SizedBox(height: 2),
                              buildRow("loan_no".tr(), loanListData.loanNo),
                              buildRow("loan_amount".tr(),
                                  "${Constant_Class.strCurrencySymbols}${loanListData.loanAmount}"),
                              buildRow("overdue_amount".tr(),
                                  "${Constant_Class.strCurrencySymbols}${loanListData.overdueAmount}"),
                            ],
                          ),
                        ),
                      ));
                }));
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorsApp.colorBlack,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: ColorsApp.colorBlack,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  checkLoanStatus(index) {
    var status = loanList[index].status;
    if (status == "0") {
      return "close".tr();
    } else if (status == "1") {
      return "active".tr();
    }

    // else if(status == "2"){}else{}
  }
}
