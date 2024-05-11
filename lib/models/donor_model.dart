import 'dart:convert';

class Donor {
  final String name;
  final String username;
  final String password;
  final String address;
  final String contactNumber;
  final bool status;
  final List<String> donations;

  Donor({
    required this.name,
    required this.username,
    required this.password,
    required this.address,
    required this.contactNumber,
    required this.status,
    required this.donations,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      name: json['name'],
      username: json['username'],
      password: json['password'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      status: json['status'],
      donations: json['donations'],
    );
  }

  static List<Donor> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donor donor) {
    return {
      'name': donor.name,
      'username': donor.username,
      'password': donor.password,
      'address': donor.address,
      'contactNumber': donor.contactNumber,
      'status': donor.status,
      'donations': donor.donations,
    };
  }

  
}