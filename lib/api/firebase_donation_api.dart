import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Donation donation) async {
    try {
      await db.collection("donations").add(donation.toJson());

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonations() {
    return db.collection("donations").snapshots();
  }


  Future<String> updateStatus(String uid, String value) async {
    try {
      await db.collection("donations").where("uid", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          db.collection("donations").doc(doc.id).update({"status": value});
        });
      });

      return "Successfully updated!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getDonationDetailsByUid(String donationId) {
    try{
      return db.collection("donations").where("uid", isEqualTo: donationId).snapshots();
    } on FirebaseException catch (e) {
      throw "Error in ${e.code}: ${e.message}";
    }
  }


}
