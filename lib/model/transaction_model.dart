class TransactionModel {
  var status;
  final List<TransactionRecord> transactionRecords;
  final String msg;

  TransactionModel({
    required this.status,
    required this.msg,
    required this.transactionRecords,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      status: json["status"].toString(),
      msg: json["message"] ?? "",
      transactionRecords: (json["transaction_records"] as List<dynamic>?)
              ?.map((e) => TransactionRecord.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TransactionRecord {
  final String id;
  final String khatabookId;
  final String agentId;
  final String temporaryAgentId;
  final String transactionNo;
  final String savingAmount;
  final String dayByDaySavingAmount;
  final String loanId;
  final String loanAmount;
  final String dayByDayLoanAmount;
  final String comment;
  final String status;
  final String loanClosed;
  final String savingClosed;
  final String transactionDatetime;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String receivedDatetime;
  final String penalty;
  final String withdraw;

  TransactionRecord({
    required this.id,
    required this.khatabookId,
    required this.agentId,
    required this.temporaryAgentId,
    required this.transactionNo,
    required this.savingAmount,
    required this.dayByDaySavingAmount,
    required this.loanId,
    required this.loanAmount,
    required this.dayByDayLoanAmount,
    required this.comment,
    required this.status,
    required this.loanClosed,
    required this.savingClosed,
    required this.transactionDatetime,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.receivedDatetime,
    required this.penalty,
    required this.withdraw,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json["id"]?.toString() ?? "",
      khatabookId: json["khatabook_id"]?.toString() ?? "",
      agentId: json["agent_id"]?.toString() ?? "",
      temporaryAgentId: json["temporary_agent_id"]?.toString() ?? "",
      transactionNo: json["transaction_no"] ?? "",
      savingAmount: json["saving_amount"] ?? "",
      dayByDaySavingAmount: json["day_by_day_saving_amount"] ?? "",
      loanId: json["loan_id"]?.toString() ?? "",
      loanAmount: json["loan_amount"] ?? "",
      dayByDayLoanAmount: json["day_by_day_loan_amount"] ?? "",
      comment: json["comment"] ?? "",
      status: json["status"]?.toString() ?? "",
      loanClosed: json["loan_closed"]?.toString() ?? "",
      savingClosed: json["saving_closed"]?.toString() ?? "",
      transactionDatetime: json["transaction_datetime"] ?? "",
      createdBy: json["created_by"]?.toString() ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      receivedDatetime: json["received_datetime"] ?? "",
      penalty: json["penalty"]?.toString() ?? "",
      withdraw: json["withdraw"]?.toString() ?? "",
    );
  }
}
