import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String type; // Admin, Donor, Organization
  final String username;
  final String? name;
  final String? address;
  final String? contactNumber;
  final bool? status;
  final List<String> donations; // donors and organizations only, not sure about type, also works with donors and organizations right? refId of a donation goes here?
  final List<String>? proofs; // For organizations only, not sure about type
  //final String? orgName; name of organization different from name of user or not???

  User({
    required this.type,
    required this.username,
    this.name,
    this.address,
    this.contactNumber,
    this.status,
    this.donations = const [],
    this.proofs,
    // this.orgName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type: json['type'],
      name: json['name'],
      username: json['username'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      status: json['status'],
      donations: List<String>.from(json['donations']),
      proofs: List<String>.from(json['proofs']),
      // orgName: json['orgName'],
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
      'proofs': proofs,
      // 'orgName': orgName,
    };

}

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return User(
      type: doc['type'],
      username: doc['username'],
      name: doc['name'],
      address: doc['address'],
      contactNumber: doc['contactNumber'],
      status: doc['status'],
      donations: List<String>.from(doc['donations']),
      proofs: List<String>.from(doc['proofs']),
      // orgName: doc['orgName'],
    );
  }


}