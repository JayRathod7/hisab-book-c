import 'dart:io';

import 'package:bachat_book_customer/ConstantClasses/Constant_Class.dart';
import 'package:http/http.dart' as http;

// const baseUrl = "https://bachatbook.loc/api/";
const baseUrl = "http://192.168.31.20/laravel/bachatbook/html/public/api/";

class ApiService {
  static Future UserLogin(String mobile, String deviceId) {
    var fcm_token = Constant_Class.FCM_Token;

    if (fcm_token == null || fcm_token == "") {
      fcm_token = "fcm token getting empty";
    }

    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);

    var url = baseUrl + "customer/login";
    var uri = Uri.parse(url);

    return http.post(uri, body: {
      "phone_no": mobile,
      "device_token": fcm_token,
      "device_id": deviceId,
      "app_version": Constant_Class.AppVersion,
    });
  }

  static Future OTPVarification(
      String mobile, String strOTP, String device_details, String deviceId) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);

    var url = baseUrl + "customer/accountverify";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "phone_no": mobile,
      "otp": strOTP,
      "device_details": device_details,
      "device_id": deviceId,
      "app_version": Constant_Class.AppVersion
    });
  }

  static Future UserLogout(String apiToken) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "customer/logout";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": apiToken,
      "app_version": Constant_Class.AppVersion
    });
  }

  static Future GetProfile(String apiToken) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "customer/getProfile";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": apiToken,
      "app_version": Constant_Class.AppVersion
    });
  }

  static Future SettingApi(String apiToken, String khataBookId) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "customer/setting";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": apiToken,
      "khatabook_id": khataBookId,
      "app_version": Constant_Class.AppVersion
    });
  }

  static TransactoionApi(String apiToken, String KhataBookId, String startDate,
      String endDate, String per_page_data, String page_no) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "customer/lastTransactionRecords";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": apiToken,
      "khatabook_id": KhataBookId,
      "app_version": Constant_Class.AppVersion,
      "start_date": startDate,
      "end_date": endDate,
      "per_page": per_page_data,
      "page_no": page_no
    });
  }

  static Future sendCustomerLoanRequestForm(
      {String? api_token,
      String? firstName,
      String? lastName,
      String? khatabook_no,
      String? email,
      String? phone,
      String? loan_amount,
      String? reference_1,
      String? reference_2,
      File? profileImage,
      File? documentAdharcardFront,
      File? documentAdharcardBackSideImage,
      var documentPancard,
      var documentVotercard}) async {
    Constant_Class.PrintMessage("firstName =>  ${firstName}");
    Constant_Class.PrintMessage("lastName =>  ${lastName}");
    Constant_Class.PrintMessage("khatabook_no =>  ${khatabook_no}");
    Constant_Class.PrintMessage("email =>  ${email}");
    Constant_Class.PrintMessage("phone =>  ${phone}");
    Constant_Class.PrintMessage("loan_amount =>  ${loan_amount}");
    Constant_Class.PrintMessage("reference_1 =>  ${reference_1}");
    Constant_Class.PrintMessage("reference_2 =>  ${reference_2}");
    Constant_Class.PrintMessage("profileImage =>  ${profileImage}");
    Constant_Class.PrintMessage(
        "documentAdharcardFront =>  ${documentAdharcardFront}");
    Constant_Class.PrintMessage(
        "documentAdharcardBackSideImage =>  ${documentAdharcardBackSideImage}");
    Constant_Class.PrintMessage("documentPancard =>  ${documentPancard}");
    Constant_Class.PrintMessage("documentVotercard =>  ${documentVotercard}");

    var url = baseUrl + "customer/createCustomerLoanRequest";
    var postUri = Uri.parse(url);

    var request = new http.MultipartRequest("POST", postUri);

    request.fields['api_token'] = api_token ?? "";
    request.fields['firstName'] = firstName ?? "";
    request.fields['lastName'] = lastName ?? "";
    request.fields['khatabook_id'] = khatabook_no ?? "";
    request.fields['email'] = email ?? "";
    request.fields['phone'] = phone ?? "";
    request.fields['loan_amount'] = loan_amount ?? "";
    request.fields['reference_1'] = reference_1 ?? "";
    request.fields['reference_2'] = reference_2 ?? "";
    request.fields['app_version'] = Constant_Class.AppVersion;

    if (profileImage != null) {
      http.MultipartFile multipartFileFacePhoto =
          await http.MultipartFile.fromPath('loan_request_face_photo',
              profileImage.path); //customer_face_photo
      request.files.add(multipartFileFacePhoto);
    }

    if (documentAdharcardFront != null) {
      http.MultipartFile multipartFileAdharcard =
          await http.MultipartFile.fromPath(
              'adharcard', documentAdharcardFront.path);
      request.files.add(multipartFileAdharcard);
    }

    if (documentAdharcardBackSideImage != null) {
      http.MultipartFile multipartFileAdharcard =
          await http.MultipartFile.fromPath(
              'adharcard_back', documentAdharcardBackSideImage.path);
      request.files.add(multipartFileAdharcard);
    }

    if (documentPancard != null) {
      http.MultipartFile multipartFilePancard =
          await http.MultipartFile.fromPath('pancard', documentPancard.path);
      request.files.add(multipartFilePancard);
    }

    if (documentVotercard != null) {
      http.MultipartFile multipartFileVotercard =
          await http.MultipartFile.fromPath(
              'votercard', documentVotercard.path);
      request.files.add(multipartFileVotercard);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  static AgentCustomerList(String? api_token) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "customer/getAgentCustomers";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": api_token,
      "app_version": Constant_Class.AppVersion
    });
  }

  static Future GetAbout(String? apiToken, String pageName) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "getcmspage";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "api_token": apiToken,
      "page_name": pageName,
      "app_version": Constant_Class.AppVersion
    });
  }

  static Future EditProfileApi(var apiToken, var name, var email, var number,
      var birthday, var address, var img) async {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);
    var url = baseUrl + "editProfile";
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.fields['api_token'] = apiToken;
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['number'] = number;
    request.fields['birthday'] = birthday;
    request.fields['address'] = address;
    request.fields['app_version'] = Constant_Class.AppVersion;

    if (img.isNotEmpty &&
        !(img.startsWith("http://") || img.startsWith("https://"))) {
      File imageFile = File(img);
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Field name expected by the API
        imageFile.path,
      ));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    return responseData;
  }

  static Future getCMSPageContent(String steSlug) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);

    var url = baseUrl + "getcmspage";
    var uri = Uri.parse(url);
    return http.post(uri,
        body: {"page_name": steSlug, "app_version": Constant_Class.AppVersion});
  }

  static Future getLoanList(String api_token) {
    var url = baseUrl + "customer/getMyLoans";
    var uri = Uri.parse(url);
    return http.post(uri, body: {"api_token": api_token});
  }

  static Future sendContactUs(
      String name, String email, String phone, String message) {
    Constant_Class.PrintMessage("app_version => " + Constant_Class.AppVersion);

    var url = baseUrl + "contactus";
    var uri = Uri.parse(url);
    return http.post(uri, body: {
      "name": name,
      "email": email,
      "phone": phone,
      "message": message,
      "app_version": Constant_Class.AppVersion
    });
  }
}
