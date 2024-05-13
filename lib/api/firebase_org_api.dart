import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week9_authentication/models/org_model.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrganization(Organization organization) async {
    try {
      await db.collection("organizations").add(organization.toJson());

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organizations").snapshots();
  }
}