import 'dart:convert';

class Organization{
  final String name;
  final String username;
  final String password;
  final String address;
  final String contactNumber;
  final bool status;

  Organization({
    required this.name,
    required this.username,
    required this.password,
    required this.address,
    required this.contactNumber,
    required this.status,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'],
      username: json['username'],
      password: json['password'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      status: json['status'],
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'name': organization.name,
      'username': organization.username,
      'password': organization.password,
      'address': organization.address,
      'contactNumber': organization.contactNumber,
      'status': organization.status,
    };
  }

  static Organization fromMap(Map<String, dynamic> data) {
    return Organization(
      name: data['name'],
      username: data['username'],
      password: data['password'],
      address: data['address'],
      contactNumber: data['contactNumber'],
      status: data['status'],
    );
  }

  
}