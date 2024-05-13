import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Stream<QuerySnapshot> getUserDetailsByUsername(String username) {
    return db.collection("users").where("username", isEqualTo: username).snapshots();
  }

  Stream<QuerySnapshot> getUsersByOrganizationType() {
  return FirebaseFirestore.instance
      .collection('users')
      .where('type', isEqualTo: 'organization')
      .snapshots();
  }

  Stream<QuerySnapshot> getUsersByDonorType() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'donor')
        .snapshots();
  }

  Future<String> addDonationToUser(String uuid, String username) async {
  try {
    final userDocRef = db.collection("users").where("username", isEqualTo: username).limit(1);
    final userDoc = await userDocRef.get();
    final user = userDoc.docs.first;
    final userRef = db.collection("users").doc(user.id);

    await userRef.update({
      "donations": FieldValue.arrayUnion([uuid])
    });

    return "Successfully added!";
  } on FirebaseException catch (e) {
    return "Error in ${e.code}: ${e.message}";
  }
}

  Future<String> addUsertoDB(Map<String, dynamic> user) async {
    try {
      await db.collection("users").add(user);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> updateUserStatus(String id)async{
    try {
      await db.collection("users").doc(id).update({"status": true});

      return "User approved";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    } 
  }
  



}
