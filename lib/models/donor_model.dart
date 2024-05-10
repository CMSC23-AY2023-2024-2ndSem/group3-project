// Donors’ View
// ○ Homepage - List of organizations where donors can send their donations
// ○ Donate
// ■ Will open upon selecting an organization
// ■ Enter the following information:
// ● Donation item category checkbox:
// ○ Food
// ○ Clothes
// ○ Cash
// ○ Necessities
// ○ Others (can add more categories as necessary)
// ● Select if the items are for pickup or drop-off
// ● Weight of items to donate in kg/lbs
// ● Photo of the items to donate (optional input)
// ○ Should be able to use the phone camera

// ● Date and time for pickup/drop-off
// ● Address (for pickup) - can save multiple addresses
// ● Contact no (for pickup)
// ■ If the item is for drop-off, the donor should be able to generate a
// QR code that must be scanned by the organization to update the
// donation status
// ■ A Donation can be canceled

// this will be in the firebase storage

import 'dart:convert';

// fields for the donor
// name
// username
// password
// address/es
// contact number
// status

class Donor {
  final String name;
  final String username;
  final String password;
  final String address;
  final String contactNumber;
  final bool status;

  Donor({
    required this.name,
    required this.username,
    required this.password,
    required this.address,
    required this.contactNumber,
    required this.status,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      name: json['name'],
      username: json['username'],
      password: json['password'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      status: json['status'],
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
    };
  }
}