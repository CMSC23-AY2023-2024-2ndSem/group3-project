import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
    };
  }

  static User fromMap(Map<String, dynamic> data) {
    return User(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
    );
  }

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return User(
      email: doc['email'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
    );
  }

}
