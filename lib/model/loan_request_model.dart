class LoanRequestModel {
  late String message;
  late String status;

  LoanRequestModel.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  LoanRequestModel.fromJsonUser(Map json)
      : status = json['status'],
        message = json['message'];

  LoanRequestModel.fromJsonStatus(Map json) : status = json['status'];

  Map toJson() {
    return {'status': status, 'message': message};
  }
}
