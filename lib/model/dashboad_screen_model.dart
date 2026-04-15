import 'package:bachat_book_customer/model/user_data.dart';

class DashboardScreenModel {
  var message;
  var status;
  var customerData;

  DashboardScreenModel.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  DashboardScreenModel.fromJsonUser(Map json)
      : status = json['status'],
        customerData = CustomerData.fromJson(json['data']),
        message = json['message'];

  DashboardScreenModel.fromJsonStatus(Map json) : status = json['status'];

  // Map toJson() {
  //   return {'status': status, 'user': data, 'message': message};
  // }
}
