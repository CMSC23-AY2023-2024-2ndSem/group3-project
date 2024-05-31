import 'package:cloud_firestore/cloud_firestore.dart';

class DonationDrive {
  final String uid;
  final String name;
  final String description;
  final String organizationUname;
  final List<String> donations;
  late final bool isOpen; 

  DonationDrive({
    required this.uid,
    required this.name,
    required this.description,
    required this.organizationUname,
    required this.donations,
    required this.isOpen,
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      organizationUname: json['organizationUname'],
      donations: List<String>.from(json['donations']),
      isOpen: json['isOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'organizationUname': organizationUname,
      'donations': donations,
      'isOpen': isOpen,
    };
  }

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return DonationDrive(
      uid: doc['uid'],
      name: doc['name'],
      description: doc['description'],
      organizationUname: doc['organizationUname'],
      donations: List<String>.from(doc['donations']),
      isOpen: doc['isOpen'],
    );
  }
  



}