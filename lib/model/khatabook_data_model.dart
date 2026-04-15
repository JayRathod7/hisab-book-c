class SettingModel {
  var message;
  var status;
  var khataBookData;

  SettingModel.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  SettingModel.fromJsonUser(Map json)
      : status = json['status'],
        khataBookData = KhatabookDataModel.fromJson(json["data"]),
        message = json['message'];

  SettingModel.fromJsonStatus(Map json) : status = json['status'];

  Map toJson() {
    return {'status': status, 'message': message};
  }
}

class KhatabookDataModel {
  final String totalSavingAmount;
  final String totalLoanAmount;
  final String totalPendingSavingAmount;
  final String totalPendingLoanAmount;
  final String todayTotalSavingAmount;
  final String todayTotalLoanAmount;
  final String monthlyTotalSavingAmount;
  final String monthlyTotalLoanAmount;

  KhatabookDataModel({
    required this.totalSavingAmount,
    required this.totalLoanAmount,
    required this.totalPendingSavingAmount,
    required this.totalPendingLoanAmount,
    required this.todayTotalSavingAmount,
    required this.todayTotalLoanAmount,
    required this.monthlyTotalSavingAmount,
    required this.monthlyTotalLoanAmount,
  });

  factory KhatabookDataModel.fromJson(Map<String, dynamic> json) {
    return KhatabookDataModel(
      totalSavingAmount: json['total_saving_amount'].toString(),
      totalLoanAmount: json['total_loan_amount'].toString(),
      totalPendingSavingAmount: json['total_pending_saving_amount'].toString(),
      totalPendingLoanAmount: json['total_pending_loan_amount'].toString(),
      todayTotalSavingAmount: json['today_total_saving_amount'].toString(),
      todayTotalLoanAmount: json['today_total_loan_amount'].toString(),
      monthlyTotalSavingAmount: json['monthly_total_saving_amount'].toString(),
      monthlyTotalLoanAmount: json['monthly_total_loan_amount'].toString(),
    );
  }
}
