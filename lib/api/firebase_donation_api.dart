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

  Stream<QuerySnapshot> getDonationsByOrganizationUname(String orgUname) {
    return FirebaseFirestore.instance
        .collection('donations')
        .where('organizationUname', isEqualTo: orgUname)
        .snapshots();
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

  Future<String> updateStatusToConfirm(String uid) async {
    try {
      bool updated = false;
      await db.collection("donations").where("uid", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          querySnapshot.docs.forEach((doc) {
            if (doc.data()["status"] == "Pending") {
              db.collection("donations").doc(doc.id).update({"status": "Confirmed"});
              updated = true;
            }
            
          });
        });
      });
      if (updated){
        return "Successfully updated!"; 
      }
      return "Update Failed";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> linkDonation(String uid, String donationDriveUid) async {
    try {
      bool updated = false;
      print(uid);
      await db.collection("donations").where("uid", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          querySnapshot.docs.forEach((doc) {
              db.collection("donations").doc(doc.id).update({"donationDriveUid": donationDriveUid});
          });
        });
      });

      await db.collection("donationdrives").where("uid", isEqualTo: donationDriveUid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          querySnapshot.docs.forEach((doc) {
              if (!doc.data()["donations"].contains(uid)) {
                db.collection("donationdrives").doc(doc.id).update({"donations": FieldValue.arrayUnion([uid])});
                 updated = true;
              }
            });
          });
        });

      if (updated){
        return "Successfully updated!"; 
      }
      return "Update Failed";
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

  Future<String> deleteDonation(String uuid) async {
    try {
      await db.collection("donations").where("uid", isEqualTo: uuid).limit(1).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          db.collection("donations").doc(doc.id).delete();
        });
      });

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      throw "Error in ${e.code}: ${e.message}";
      
    }
  }

  Future<String> removeLinktoDonations(String uuidOfDrive) async {
    try {
      await db.collection("donations").where("donationDriveUid", isEqualTo: uuidOfDrive).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          db.collection("donations").doc(doc.id).update({"donationDriveUid": ""});
        });
      });

      return "Successfully updated!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }


}
