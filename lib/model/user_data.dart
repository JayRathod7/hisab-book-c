import 'dart:convert';

class CustomerData {
  final String id;
  final String userId;
  final String customerCustomNo;
  final String firstname;
  final String lastname;
  final String phoneNo;
  final String email;
  final String birthdate;
  final String address;
  final String profilePicture;
  final String adharcard;
  final String adharcardBack;
  final String pancard;
  final String votercard;
  final String createdBy;
  final String gender;
  final String allowSms;
  final String status;
  final String otp;
  final String apiToken;
  final String deviceToken;
  final String deviceId;
  final String verifiedByAdmin;
  final String createdAt;
  final String updatedAt;
  final List<Khatabook> khatabooks;

  CustomerData({
    required this.id,
    required this.userId,
    required this.customerCustomNo,
    required this.firstname,
    required this.lastname,
    required this.phoneNo,
    required this.email,
    required this.birthdate,
    required this.address,
    required this.profilePicture,
    required this.adharcard,
    required this.adharcardBack,
    required this.pancard,
    required this.votercard,
    required this.createdBy,
    required this.gender,
    required this.allowSms,
    required this.status,
    required this.otp,
    required this.apiToken,
    required this.deviceToken,
    required this.deviceId,
    required this.verifiedByAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.khatabooks,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      customerCustomNo: json['customer_custom_no'].toString(),
      firstname: json['firstname'].toString(),
      lastname: json['lastname'].toString(),
      phoneNo: json['phone_no'].toString(),
      email: json['email'].toString(),
      birthdate: json['birthdate'].toString(),
      address: json['address'].toString(),
      profilePicture: json['profile_picture'].toString(),
      adharcard: json['adharcard'].toString(),
      adharcardBack: json['adharcard_back'].toString(),
      pancard: json['pancard'].toString(),
      votercard: json['votercard'].toString(),
      createdBy: json['created_by'].toString(),
      gender: json['gender'].toString(),
      allowSms: json['allow_sms'].toString(),
      status: json['status'].toString(),
      otp: json['otp'].toString(),
      apiToken: json['api_token'].toString(),
      deviceToken: json['device_token'].toString(),
      deviceId: json['device_id'].toString(),
      verifiedByAdmin: json['verified_by_admin'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      khatabooks: (json['khatabooks'] as List<dynamic>?)
              ?.map((e) => Khatabook.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Khatabook {
  final String khatabookId;
  final String khatabookNo;
  final String durationDays;
  final String khatabookStartDate;
  final String khatabookEndDate;

  Khatabook({
    required this.khatabookId,
    required this.khatabookNo,
    required this.durationDays,
    required this.khatabookStartDate,
    required this.khatabookEndDate,
  });

  factory Khatabook.fromJson(Map<String, dynamic> json) {
    return Khatabook(
      khatabookId: json['khatabook_id'].toString(),
      khatabookNo: json['khatabook_no'].toString(),
      durationDays: json['duration_days'].toString(),
      khatabookStartDate: json['khatabook_start_date'].toString(),
      khatabookEndDate: json['khatabook_end_date'].toString(),
    );
  }
}
