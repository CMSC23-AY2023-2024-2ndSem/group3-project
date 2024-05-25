import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String type;
  final String username;
  final String? name;
  final List<String>? address;
  final String? contactNumber;
  final bool? status;
  final List<String> donations;
  final List<String> donationDrives; 
  final List<String>? proofs;
  final String? orgDescription;
  final bool? openForDonation;

  User({
    required this.type,
    required this.username,
    this.name,
    this.address,
    this.contactNumber,
    this.status,
    this.donations = const [],
    this.donationDrives = const [],
    this.proofs,
    this.orgDescription,
    this.openForDonation
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type: json['type'],
      name: json['name'],
      username: json['username'],
      address: List<String>.from(json['address']),
      contactNumber: json['contactNumber'],
      status: json['status'],
      donations: List<String>.from(json['donations']),
      donationDrives: List<String>.from(json['donationDrives']),
      proofs: List<String>.from(json['proofs']),
      orgDescription: json['orgDescription'],
      openForDonation: json['openForDonation']

    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'username': username,
      'address': address,
      'contactNumber': contactNumber,
      'status': status,
      'donations': donations,
      'donationDrives': donationDrives,
      'proofs': proofs,
      'orgDescription': orgDescription,
      'openForDonation': openForDonation

    };

}

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return User(
      type: doc['type'],
      username: doc['username'],
      name: doc['name'],
      address: List<String>.from(doc['address']),
      contactNumber: doc['contactNumber'],
      status: doc['status'],
      donations: List<String>.from(doc['donations']),
      donationDrives: List<String>.from(doc['donationDrives']),
      proofs: List<String>.from(doc['proofs']),
      orgDescription: doc['orgDescription'],
      openForDonation: doc['openForDonation']      
    );
  }


}