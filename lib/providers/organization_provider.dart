import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_organization_api.dart';
// import '../models/organization_model.dart';


class OrganizationProvider with ChangeNotifier {
  late FirebaseOrganizationAPI firebaseService;
  late Stream<QuerySnapshot> _organizationsStream;

  OrganizationProvider() {
    firebaseService = FirebaseOrganizationAPI();
    fetchOrganizations();
  }
  
  Stream<QuerySnapshot> get organizations => _organizationsStream;

  Future<void> fetchOrganizations() async {
    _organizationsStream = firebaseService.getAllOrganizations();
    notifyListeners();
  }

  Stream<QuerySnapshot> getOrganizationByName(String name) {
    return firebaseService.getOrganizationByName(name);
  }


}
