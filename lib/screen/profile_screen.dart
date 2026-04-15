import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bachat_book_customer/ConstantClasses/ColorsApp.dart';
import 'package:bachat_book_customer/ConstantClasses/app_text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ConstantClasses/Constant_Class.dart';
import '../api_service/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = "";
  String img = "";
  String name = "";
  String KhatabookNo = "";
  String phone = "";
  String email = "";
  String dob = "";
  String address = "";
  File? _imageFile;

  final userIdController = TextEditingController();
  final nameController = TextEditingController();
  final khataBookController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  bool apiCall = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    setState(() {
      apiCall = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool internet =
        await Constant_Class.check(); // Await to ensure we have a result

    if (internet) {
      setState(() {
        nameController.text =
            "${preferences.getString("firstname") ?? ""} ${preferences.getString("lastname") ?? ""}";
        img = preferences.getString("profilePicture") ?? "";
        phoneController.text = preferences.getString("mobile") ?? "";
        addressController.text = preferences.getString("address") ?? "";
        emailController.text = preferences.getString("email") ?? "";
        userIdController.text = preferences.getString("userId") ?? "";
        dobController.text = preferences.getString("dob") ?? "";
        khataBookController.text =
            preferences.getString("khatbookNumber") ?? "";
      });
    } else {
      Constant_Class.showNoInternetDialog(context);
    }

    setState(() {
      apiCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: ColorsApp.colorWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: ColorsApp.colorPurple,
                          image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/home_card_back.png"),
                              fit: BoxFit.cover,
                              opacity: 0.1),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 14,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: h * 0.055,
                            width: w * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorsApp.colorWhite.withOpacity(0.1),
                            ),
                            child: Image.asset("assets/images/back_icon.png"),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 170),
                        padding: const EdgeInsets.only(top: 80),
                        decoration: BoxDecoration(
                            color: ColorsApp.colorWhite,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Column(
                          children: [
                            Text(
                              "profile".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorsApp.colorBlack,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                profileDetailBox(
                                    controller: nameController,
                                    label: "name".tr(),
                                    hintText: "name",
                                    icon: Icons.person),
                                profileDetailBox(
                                    label: "customer_id".tr(),
                                    controller: userIdController,
                                    hintText: "user id",
                                    readOnly: true,
                                    icon: Icons.badge),
                                profileDetailBox(
                                    controller: khataBookController,
                                    label: "khata_book_id".tr(),
                                    readOnly: true,
                                    icon: Icons.menu_book_outlined),
                                profileDetailBox(
                                    controller: phoneController,
                                    label: "number".tr(),
                                    hintText: "Phone number",
                                    icon: Icons.phone),
                                profileDetailBox(
                                    controller: emailController,
                                    label: "email".tr(),
                                    hintText: "Email id",
                                    icon: Icons.email),
                                profileDetailBox(
                                    hintText: "Date of Birth",
                                    controller: dobController,
                                    label: "birthdate".tr(),
                                    icon: Icons.date_range),
                                profileDetailBox(
                                    hintText: "Address",
                                    controller: addressController,
                                    label: "address".tr(),
                                    addressIconLocation: true,
                                    icon: Icons.location_on_rounded),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 100),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ColorsApp.colorWhite,
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                ColorsApp.colorPurple.withOpacity(0.2),
                            child: SizedBox(
                              // width: 80,
                              // height: 80,
                              child: ClipOval(
                                child: (img.isEmpty || img == "")
                                    ? Image.asset(
                                        "assets/images/icon_no_profile.png",
                                        fit: BoxFit.cover,
                                      )
                                    : (img.startsWith("http") ||
                                            img.startsWith("https"))
                                        ? Image.network(
                                            img,
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 120,
                                          )
                                        : Image.file(
                                            File(img),
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 120,
                                          ),
                              ),
                            )),
                      ),
                      Positioned(
                          top: 180,
                          right: 0,
                          left: 90,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        ColorsApp.colorGrey.withOpacity(0.1)),
                                child: Icon(Icons.edit)),
                          ))
                    ],
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 30, left: 16, right: 16),
                    decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(5)),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        textStyle: TextStyle(
                          color: ColorsApp.colorWhite,
                        ),
                        padding: const EdgeInsets.all(0.0),
                      ),
                      onPressed: () {
                        updateProfile();
                      },
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: Constant_Class.buttonGradiantDecoration(),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "edit_profile".tr(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: ColorsApp.colorWhite),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          apiCall ? Constant_Class.apiLoadingAnimation(context) : SizedBox()
        ],
      ),
    );
  }

  updateProfile() async {
    var name = nameController.text.trim();
    var number = phoneController.text.trim();
    var email = emailController.text.trim();
    var dob = dobController.text.trim();
    var address = addressController.text.trim();
    var allCheck = false;
    if (name.isEmpty || name == "") {
      Constant_Class.ToastMessage("Please enter name");
      allCheck = true;
    } else if (number.isEmpty || number == "") {
      Constant_Class.ToastMessage("Please enter phone number");
      allCheck = true;
    } else if (!RegExp(r'^\d{10}$').hasMatch(number)) {
      // Ensure it's a 10-digit number
      Constant_Class.ToastMessage("Please enter a valid 10-digit phone number");
      allCheck = true;
    } else if (email.isEmpty || email == "") {
      Constant_Class.ToastMessage("Please enter email");
      allCheck = true;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Constant_Class.ToastMessage("Please enter a valid email address");
      allCheck = true;
    }

    if (allCheck == false) {
      editProfileApi(name, email, number, dob, address, img);
    }
  }

  editProfileApi(var name, var email, var number, var birthday, var address,
      var img) async {
    setState(() => apiCall = true); // Start API call
    SharedPreferences myPref = await SharedPreferences.getInstance();
    var api_token = myPref.getString("api_token");
    try {
      final response = await ApiService.EditProfileApi(
          api_token.toString(), name, email, number, birthday, address, img);
      final responseJson = json.decode(response.body);
      var status = responseJson["status"].toString();
      if (status == "1") {
        Constant_Class.ToastMessage(responseJson["message"]);
      } else {
        Constant_Class.ToastMessage(responseJson["message"]);
      }
    } catch (e) {
      Constant_Class.PrintMessage("EDIT PROFILE API => $e");
    } finally {
      setState(() => apiCall = false);
    }
  }

  Future<void> _pickImage() async {
    // Request camera permission
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          // _imageFile = File(pickedFile.path);
          img = pickedFile.path;
        });
      }
    } else if (status.isDenied) {
      Constant_Class.ToastMessage('error_camera'.tr());
    }
  }
  // profileDetailBox(
  //     {required String label,
  //     required String info,
  //     required IconData icon,
  //     bool addressIconLocation = false}) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
  //     margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
  //     decoration: BoxDecoration(
  //       color: ColorsApp.colorWhite,
  //       borderRadius: BorderRadius.circular(10),
  //       border: Border.all(color: ColorsApp.colorPurple, width: 0.1),
  //       boxShadow: [
  //         BoxShadow(
  //           color:
  //               ColorsApp.colorPurple.withOpacity(0.08), // Soft purple shadow
  //           spreadRadius: 1,
  //           blurRadius: 4,
  //           offset: Offset(2, 3), // Slight shadow below for depth
  //         ),
  //         BoxShadow(
  //           color: ColorsApp.colorBlack.withOpacity(0.05), // Light black shadow
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: Offset(-1, -1), // Opposite light shadow for realism
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       crossAxisAlignment: addressIconLocation
  //           ? CrossAxisAlignment.start
  //           : CrossAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           size: 24,
  //           color: ColorsApp.colorGrey,
  //         ),
  //         SizedBox(width: 10),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             // mainAxisAlignment: MainAxisAlignment,
  //             children: [
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: ColorsApp.colorGrey,
  //                   fontFamily: "Poppins",
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               SizedBox(height: 4),
  //               Text(info,
  //                   maxLines: 3,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(
  //                       fontFamily: "Poppins",
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 16,
  //                       color: ColorsApp.colorBlack))
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //

  profileDetailBox(
      {required String label,
      required TextEditingController controller,
      required IconData icon,
      String? hintText,
      bool readOnly = false,
      bool addressIconLocation = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: ColorsApp.colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsApp.colorPurple, width: 0.1),
        boxShadow: [
          BoxShadow(
            color: ColorsApp.colorPurple.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
          BoxShadow(
            color: ColorsApp.colorBlack.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: addressIconLocation
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: ColorsApp.colorGrey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12, // Set label size to 12
                    color: ColorsApp.colorGrey,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  readOnly: readOnly,
                  controller: controller,
                  maxLines: addressIconLocation ? 2 : 1,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: ColorsApp.colorBlack,
                      overflow: TextOverflow.ellipsis),
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none, // Removes border
                    contentPadding: EdgeInsets.zero, // Aligns properly
                    isDense: true, // Reduces height padding
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
