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

  Future<String> updateStatus(String uid, String newStatus) async {
    return await firebaseService.updateStatus(uid, newStatus);
  }
  
  Future<String> updateStatusToConfirm(String uid) async {
    return await firebaseService.updateStatusToConfirm(uid);
  }

  Future<String> linkDonation (String uid, String donationDriveUid) async {
    return await firebaseService.linkDonation(uid, donationDriveUid);
  }


   Stream<QuerySnapshot> fetchDonationDetailsByUid(String donationId) {
    return firebaseService.getDonationDetailsByUid(donationId);

  }

  Future<void> deleteDonation(String uuid) async {
    String response = await firebaseService.deleteDonation(uuid);
    print(response);
    notifyListeners();
  }

  Future<String> removeLinktoDonations(String uuidOfDrive) async {
    return await firebaseService.removeLinktoDonations(uuidOfDrive);
    
  }


}