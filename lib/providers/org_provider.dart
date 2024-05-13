import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week9_authentication/api/firebase_org_api.dart';
import 'package:week9_authentication/models/org_model.dart';

class OrganizationProvider with ChangeNotifier {
  late FirebaseOrganizationAPI firebaseService;
  late Stream<QuerySnapshot> _organizationStream;

  OrganizationProvider() {
    firebaseService = FirebaseOrganizationAPI();
    fetchOrganizations();
  }

  Stream<QuerySnapshot> get organization => _organizationStream;

  Future<void> fetchOrganizations() async {
    _organizationStream = firebaseService.getAllOrganizations();
    notifyListeners();
  }

  Future<void> addOrganization(Organization organization) async {
    String response = await firebaseService.addOrganization(organization);
    print(response);
    notifyListeners();
  }
}