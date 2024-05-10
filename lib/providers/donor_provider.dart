import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
// import '../models/donor_model.dart';


class DonorProvider with ChangeNotifier {
  FirebaseDonorAPI firebaseService = FirebaseDonorAPI();
  late Stream<QuerySnapshot> _donorsStream;

  DonorProvider() {
    fetchDonors();
  }
  
  Stream<QuerySnapshot> get donors => _donorsStream;

  void fetchDonors() {
    _donorsStream = firebaseService.getAllDonors();
    notifyListeners();
  }
}