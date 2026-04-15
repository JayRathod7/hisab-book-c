class LoanListModel {
  final String id;
  final String agentId;
  final String customerId;
  final String khatabookId;
  final String loanNo;
  final String mobileNo;
  final String startDate;
  final String endDate;
  final String interestType;
  final String percentageLoanType;
  final String interestRate;
  final String yearlyInterestRate;
  final String loanAmount;
  final String loanPrincipalAmount;
  final String totalLoanCollection;
  final String emiAmount;
  final String emiMonthlyAmount;
  final String totalLoanInterest;
  final String lastInterestCalcDate;
  final String overdueAmount;
  final String overdueOnlyInterestAmount;
  final String overdueMonth;
  final String adharcard;
  final String adharcardBack;
  final String pancard;
  final String votercard;
  final String customerFacePhoto;
  final String loanRequestFacePhoto;
  final String customerSignature;
  final String loanApproveRejectStatus;
  final String loanApproveRejectComments;
  final String isDisburse;
  final String disburseComments;
  final String isLoanClosed;
  final String loanCloseComments;
  final String reference1;
  final String reference1Status;
  final String reference2;
  final String reference2Status;
  final String status;
  final String verifiedByAdmin;
  final String createdBy;
  final String notAllowedToEdit;
  final String createdAt;
  final String updatedAt;
  final String remainingLoanTotalCollection;

  LoanListModel({
    required this.id,
    required this.agentId,
    required this.customerId,
    required this.khatabookId,
    required this.loanNo,
    required this.mobileNo,
    required this.startDate,
    required this.endDate,
    required this.interestType,
    required this.percentageLoanType,
    required this.interestRate,
    required this.yearlyInterestRate,
    required this.loanAmount,
    required this.loanPrincipalAmount,
    required this.totalLoanCollection,
    required this.emiAmount,
    required this.emiMonthlyAmount,
    required this.totalLoanInterest,
    required this.lastInterestCalcDate,
    required this.overdueAmount,
    required this.overdueOnlyInterestAmount,
    required this.overdueMonth,
    required this.adharcard,
    required this.adharcardBack,
    required this.pancard,
    required this.votercard,
    required this.customerFacePhoto,
    required this.loanRequestFacePhoto,
    required this.customerSignature,
    required this.loanApproveRejectStatus,
    required this.loanApproveRejectComments,
    required this.isDisburse,
    required this.disburseComments,
    required this.isLoanClosed,
    required this.loanCloseComments,
    required this.reference1,
    required this.reference1Status,
    required this.reference2,
    required this.reference2Status,
    required this.status,
    required this.verifiedByAdmin,
    required this.createdBy,
    required this.notAllowedToEdit,
    required this.createdAt,
    required this.updatedAt,
    required this.remainingLoanTotalCollection,
  });

  factory LoanListModel.fromJson(Map<String, dynamic> json) {
    return LoanListModel(
      id: json['id'].toString(),
      agentId: json['agent_id'].toString(),
      customerId: json['customer_id'].toString(),
      khatabookId: json['khatabook_id'].toString(),
      loanNo: json['loan_no'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      interestType: json['interest_type'].toString(),
      percentageLoanType: json['percentage_loan_type'].toString(),
      interestRate: json['intrest_rate'] ?? '',
      yearlyInterestRate: json['yearly_interest_rate'] ?? '',
      loanAmount: json['loan_amount'] ?? '',
      loanPrincipalAmount: json['loan_principal_amount'] ?? '',
      totalLoanCollection: json['total_loan_collection'] ?? '',
      emiAmount: json['emi_amount'] ?? '',
      emiMonthlyAmount: json['emi_monthly_amount'] ?? '',
      totalLoanInterest: json['total_loan_interest'] ?? '',
      lastInterestCalcDate: json['last_interest_cacl_date'] ?? '',
      overdueAmount: json['overdue_amount'] ?? '',
      overdueOnlyInterestAmount: json['overdue_only_intrest_amount'] ?? '',
      overdueMonth: json['overdue_month'] ?? '',
      adharcard: json['adharcard'] ?? '',
      adharcardBack: json['adharcard_back'] ?? '',
      pancard: json['pancard'] ?? '',
      votercard: json['votercard'] ?? '',
      customerFacePhoto: json['customer_face_photo'] ?? '',
      loanRequestFacePhoto: json['loan_request_face_photo'] ?? '',
      customerSignature: json['customer_signature'] ?? '',
      loanApproveRejectStatus: json['loan_approve_reject_status'].toString(),
      loanApproveRejectComments: json['loan_approve_reject_comments'] ?? '',
      isDisburse: json['is_disburse'].toString(),
      disburseComments: json['disburse_comments'] ?? '',
      isLoanClosed: json['is_loan_closed'].toString(),
      loanCloseComments: json['loan_close_comments'] ?? '',
      reference1: json['reference_1'] ?? '',
      reference1Status: json['reference_1_status'].toString(),
      reference2: json['reference_2'] ?? '',
      reference2Status: json['reference_2_status'].toString(),
      status: json['status'].toString(),
      verifiedByAdmin: json['verified_by_admin'].toString(),
      createdBy: json['created_by'] ?? '',
      notAllowedToEdit: json['not_allowed_to_edit'].toString(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      remainingLoanTotalCollection:
          json['remaining_loan_total_collection'] ?? '',
    );
  }
}
