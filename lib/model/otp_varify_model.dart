import 'customer.dart';

class OtpVarifyModel {
  var message;
  var status;
  var customer;

  OtpVarifyModel.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  OtpVarifyModel.fromJsonUser(Map json)
      : status = json['status'],
        customer = Customer.fromJson(json['customer']),
        message = json['message'];

  OtpVarifyModel.fromJsonStatus(Map json) : status = json['status'];

  Map toJson() {
    return {'status': status, 'user': customer, 'message': message};
  }
}
