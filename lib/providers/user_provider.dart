import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_user_api.dart';

class UserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late Stream<QuerySnapshot> _usersStream;

  UserProvider() {
   fetchUsers();
  }

  Stream<QuerySnapshot> get users => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }



  


}
