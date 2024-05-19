import 'package:cloud_firestore/cloud_firestore.dart';

class DonationDrive {
  final String name;
  final String description;
  final String organizationUname;
  final List<String> donations;
  final bool isOpen; 

  DonationDrive({
    required this.name,
    required this.description,
    required this.organizationUname,
    required this.donations,
    required this.isOpen,
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      name: json['name'],
      description: json['description'],
      organizationUname: json['organizationUname'],
      donations: List<String>.from(json['donations']),
      isOpen: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'organizationUname': organizationUname,
      'donations': donations,
    };
  }

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return DonationDrive(
      name: doc['name'],
      description: doc['description'],
      organizationUname: doc['organizationUname'],
      donations: List<String>.from(doc['donations']),
      isOpen: doc['isOpen'],
    );
  }
  



}