import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_user_api.dart';

class UserProvider with ChangeNotifier {
  FirebaseUserAPI firebaseService = FirebaseUserAPI();
  late Stream<QuerySnapshot> _userStream;
  late Stream<QuerySnapshot> _organizationStream;
  late Stream<QuerySnapshot> _donorStream;

  UserProvider() {
    fetchUsers();
    fetchOrganizations();
    fetchDonors();
  }


  Stream<QuerySnapshot> get users => _userStream;
  Stream<QuerySnapshot> get organizations => _organizationStream;
  Stream<QuerySnapshot> get donors => _donorStream;

  Future<void> fetchUsers() async {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  Future<void> fetchOrganizations() async {
    _organizationStream = firebaseService.getUsersByOrganizationType();
    notifyListeners();
  }

  Future<void> fetchDonors() async {
    _donorStream = firebaseService.getUsersByDonorType();
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchUserDetailsByUsername(String username) {
    return firebaseService.getUserDetailsByUsername(username);
  }

  Future<void> addDonationToUser(String uuid, String username) async {
    await firebaseService.addDonationToUser(uuid, username);
  }

  Future<void> addDonationDriveToUser(String uuid, String username) async {
    await firebaseService.addDonationDriveToUser(uuid, username);
  }

  Future<void> addUsertoDB(Map<String, dynamic> user) async {
    await firebaseService.addUsertoDB(user);
    notifyListeners();
  }

  Future<void> updateUserStatus(String id, bool status) async {
    await firebaseService.updateUserStatus(id, status);
    notifyListeners();
  }

  Future<void> updateDonationStatus(String username, bool status) async {
    await firebaseService.updateDonationStatus(username, status);
    notifyListeners();
  }

  Future<void> deleteDonationDriveToUser(String uuid, String username) async {
    await firebaseService.deleteDonationDriveToUser(uuid, username);
  }

  Future<void> deleteDonationToUser(String uuid, String username) async {
    await firebaseService.deleteDonationToUser(uuid, username);
  }

  

    



}
