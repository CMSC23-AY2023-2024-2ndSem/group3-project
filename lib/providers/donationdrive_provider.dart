import '../api/firebase_donationdrive_api.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationDriveProvider with ChangeNotifier {
  late FirebaseDonationDriveAPI firebaseService;
  late Stream<QuerySnapshot> _donationdrivesStream;

  DonationDriveProvider() {
    firebaseService = FirebaseDonationDriveAPI();
    fetchDonationDrives();
  }

  Stream<QuerySnapshot> get donationdrivess => _donationdrivesStream;

  Future<void> fetchDonationDrives() async {
    _donationdrivesStream = firebaseService.getAllDonationDrives();
    notifyListeners();
  }

  Future<void> addDonationToDrive(String uuid, String driveName) async {
    await firebaseService.addDonationToDrive(uuid, driveName);
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchDonationDriveDetailsByOrganization(String organizationUname) {
    return firebaseService.getDonationDrivesDetailsByOrganization(organizationUname);
  }





}