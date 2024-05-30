import 'package:week9_authentication/models/donationdrive_model.dart';

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

  Stream<QuerySnapshot> get donationdrives => _donationdrivesStream;

  Future<void> fetchDonationDrives() async {
    _donationdrivesStream = firebaseService.getAllDonationDrives();
    notifyListeners();
  }

  Future<void> addDonationDrives(DonationDrive donationDrive) async {
    String response = await firebaseService.addDonationDrives(donationDrive);
    print(response);
    notifyListeners();
  }

  Future<void> deleteDonationDrive(String uuid) async {
    String response = await firebaseService.deleteDonationDrive(uuid);
    print(response);
    notifyListeners();
  }

  Future<void> updateDonationDrive(String uuid, String name, String description) async {
    String response = await firebaseService.updateDonationDrive(uuid, name, description);
    print(response);
    notifyListeners();
  }

  Future<void> updateDonationDriveStatus(String uuid, bool isOpen) async {
    String response = await firebaseService.updateDonationDriveStatus(uuid, isOpen);
    print(response);
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