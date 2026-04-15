import 'package:bachat_book_customer/ConstantClasses/Constant_Class.dart';
import 'package:bachat_book_customer/model/loan_list_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ConstantClasses/ColorsApp.dart';
import '../ConstantClasses/app_text_widget.dart';

class LoanDetailScreen extends StatefulWidget {
  LoanListModel? loanListMode;
  LoanDetailScreen({this.loanListMode});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  late LoanListModel loanList;
  String loanCreateAt = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loanList = widget.loanListMode!;
    covertStringToDate();
    setState(() {});
  }

  covertStringToDate() {
    String createdAt = loanList.createdAt;
    var parsedDate = DateTime.parse(createdAt);
    loanCreateAt = DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: ColorsApp.colorWhite,
            ),
            title: Text(
              "loan_detail".tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: ColorsApp.colorWhite),
            )),
        body: Card(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/home_back2.jpg"),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow("loan_no".tr(), loanList.loanNo),
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
                          vertical: 3, horizontal: 10), // Smaller padding
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12), // Soft capsule shape
                        border: Border.all(
                            color: Colors.black.withOpacity(0.6), width: 0.8),
                      ),
                      child: Center(
                        child: Text(
                          checkLoanStatus(),
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "s_date".tr(),
                          style: TextStyle(
                            color: ColorsApp.colorBlack,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          (loanList.startDate.isEmpty ||
                                  loanList.startDate == null ||
                                  loanList.startDate == "")
                              ? "-- --"
                              : loanList.startDate,
                          style: TextStyle(
                            color: ColorsApp.colorBlack,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "e_date".tr(),
                          style: TextStyle(
                            color: ColorsApp.colorBlack,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          (loanList.endDate.isEmpty ||
                                  loanList.endDate == null ||
                                  loanList.endDate == "")
                              ? "-- --"
                              : loanList.endDate,
                          style: TextStyle(
                            color: ColorsApp.colorBlack,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                    color: ColorsApp.colorBlack.withOpacity(0.5),
                    thickness: 0.6),
                buildRow(
                    "loan_amount".tr(),
                    (loanList.loanAmount.isEmpty || loanList.loanAmount == "")
                        ? "-- --"
                        : "${Constant_Class.strCurrencySymbols} ${loanList.loanAmount}"),
                buildRow(
                    "l_principal_amount".tr(),
                    (loanList.loanPrincipalAmount.isEmpty ||
                            loanList.loanPrincipalAmount == "")
                        ? "-- --"
                        : "${Constant_Class.strCurrencySymbols} ${loanList.loanPrincipalAmount}"),
                buildRow(
                    "interest_rate".tr(),
                    (loanList.interestRate.isEmpty ||
                            loanList.interestRate == "")
                        ? "-- --"
                        : loanList.interestRate),
                buildRow("interest_type".tr(),
                    (loanList.interestType == 0) ? "Fixed" : "Percentage"),
                buildRow(
                    "yearly_interest_rate".tr(),
                    (loanList.yearlyInterestRate.isEmpty ||
                            loanList.yearlyInterestRate == "")
                        ? "-- --"
                        : loanList.yearlyInterestRate),
                buildRow(
                    "emi_amount".tr(),
                    (loanList.emiAmount.isEmpty || loanList.emiAmount == "")
                        ? "-- --"
                        : "${Constant_Class.strCurrencySymbols} ${loanList.emiAmount}"),
                buildRow(
                    "emi_monthly_amount".tr(),
                    (loanList.emiMonthlyAmount.isEmpty ||
                            loanList.emiMonthlyAmount == "")
                        ? "-- --"
                        : "${Constant_Class.strCurrencySymbols} ${loanList.emiMonthlyAmount}"),
                buildRow(
                    "total_loan_interest".tr(),
                    (loanList.totalLoanInterest.isEmpty ||
                            loanList.totalLoanInterest == "")
                        ? "-- --"
                        : "${Constant_Class.strCurrencySymbols} ${loanList.totalLoanInterest}"),
                buildRow(
                    "created_at".tr(),
                    (loanList.createdAt.isEmpty || loanList.createdAt == "")
                        ? "-- --"
                        : loanCreateAt),
                buildRow(
                    "reference_1".tr(),
                    (loanList.reference1.isEmpty || loanList.reference1 == "")
                        ? "-- --"
                        : loanList.reference1),
                buildRow(
                    "reference_2".tr(),
                    (loanList.reference2.isEmpty || loanList.reference2 == "")
                        ? "-- --"
                        : loanList.reference2)
              ],
            ),
          ),
        ));
  }

  Widget buildRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      margin: EdgeInsets.only(left: 2, right: 2, top: 6, bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorsApp.colorBlack,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 14,
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

  checkLoanStatus() {
    var status = loanList.status;
    if (status == "0") {
      return "close".tr();
    } else if (status == "1") {
      return "active".tr();
    }

    // else if(status == "2"){}else{}
  }
}
