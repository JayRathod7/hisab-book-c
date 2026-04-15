class AgentCustomerListModel {
  final String id;
  final String userId;
  final String temporaryUserId;
  final String customerCustomNo;
  final String firstname;
  final String lastname;
  final String phoneNo;
  final String email;
  final String address;
  final String gender;
  final DateTime createdAt;

  AgentCustomerListModel({
    required this.id,
    required this.userId,
    required this.temporaryUserId,
    required this.customerCustomNo,
    required this.firstname,
    required this.lastname,
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.gender,
    required this.createdAt,
  });

  factory AgentCustomerListModel.fromJson(Map<String, dynamic> json) {
    return AgentCustomerListModel(
      id: json['id']?.toString() ?? "",
      userId: json['user_id']?.toString() ?? "",
      temporaryUserId: json['temporary_user_id']?.toString() ?? "",
      customerCustomNo: json['customer_custom_no']?.toString() ?? "",
      firstname: json['firstname'] ?? "",
      lastname: json['lastname'] ?? "",
      phoneNo: json['phone_no']?.toString() ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
      gender: json['gender']?.toString() ?? "",
      createdAt: json['created_at'] != null && json['created_at'] is String
          ? DateTime.tryParse(json['created_at']) ??
              DateTime.now() // Handle invalid date
          : DateTime.now(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "temporary_user_id": temporaryUserId,
      "customer_custom_no": customerCustomNo,
      "firstname": firstname,
      "lastname": lastname,
      "phone_no": phoneNo,
      "email": email,
      "address": address,
      "gender": gender,
      "created_at": createdAt.toIso8601String(),
    };
  }
}

// Function to parse list of customers from JSON response
List<AgentCustomerListModel> parseCustomers(Map<String, dynamic> json) {
  if ((json['status'] == 1 || json['status'] == "success") &&
      json['data'] != null) {
    return (json['data'] as Map<String, dynamic>)
        .values
        .map((item) => AgentCustomerListModel.fromJson(item))
        .toList();
  }
  return [];
}
