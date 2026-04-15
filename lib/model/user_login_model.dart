class UserLoginModel {
  late String message;
  late int status;

  UserLoginModel.fromJsonfail(Map json)
      : status = json['status'],
        message = json['message'];

  UserLoginModel.fromJsonUser(Map json)
      : status = json['status'],
        message = json['message'];

  UserLoginModel.fromJsonStatus(Map json) : status = json['status'];

  Map toJson() {
    return {'status': status, 'message': message};
  }
}
