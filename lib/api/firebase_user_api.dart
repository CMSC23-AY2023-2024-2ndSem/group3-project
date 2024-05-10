import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Stream<QuerySnapshot> getUserDetailsByEmail(String email) {
    return db.collection("users").where("email", isEqualTo: email).snapshots();
  }
}
