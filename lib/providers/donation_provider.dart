import '../api/firebase_donation_api.dart';
import '../models/donation_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationProvider with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationsStream;

  DonationProvider() {
    firebaseService = FirebaseDonationAPI();
    fetchDonations();
  }

  Stream<QuerySnapshot> get donations => _donationsStream;

  Future<void> fetchDonations() async {
    _donationsStream = firebaseService.getAllDonations();
    notifyListeners();
  }

  Future<void> fetchDonationsByOrganizationUname(String orgUname) async {
    _donationsStream = firebaseService.getDonationsByOrganizationUname(orgUname);
    notifyListeners();
  }

  Future<void> addDonation(Donation donation) async {
    String response = await firebaseService.addDonation(donation);
    print(response);
    notifyListeners();
  }

  // NOT TESTED based on TODO app
  Future<String> updateStatus(String id, String value) async {
    return await firebaseService.updateStatus(id, value);
  }
}