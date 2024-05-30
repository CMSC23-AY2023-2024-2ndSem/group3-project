import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donationdrive_model.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonationDrives(DonationDrive donationDrive) async {
    try {
      await db.collection("donationdrives").add(donationDrive.toJson());

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> deleteDonationDrive(String uuid) async {
    try {
      // await db.collection("donationdrives").where('uid', isEqualTo: uuid).delete();
      final querySnapshot = await db.collection("donationdrives").where('uid', isEqualTo: uuid).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonationDrives() {
    return db.collection("donationdrives").snapshots();
  }

  Stream<QuerySnapshot> getDonationDrivesDetailsByOrganization(String organizationUname) {
    try{
      return db.collection("donationdrives").where("organizationUname", isEqualTo: organizationUname).snapshots();
    } on FirebaseException catch (e) {
      throw "Error in ${e.code}: ${e.message}";
    }
  }

    Future<String> addDonationToDrive(String uuid, String driveName) async {
  try {
    final userDocRef = db.collection("donationdrives").where("name", isEqualTo: driveName).limit(1);
    final userDoc = await userDocRef.get();
    print(userDoc);
    print(userDoc.docs);
    print(userDoc.docs.first);
    final user = userDoc.docs.first;
    final userRef = db.collection("donationdrives").doc(user.id);

    await userRef.update({
      "donations": FieldValue.arrayUnion([uuid])
    });

    return "Successfully added!";
  } on FirebaseException catch (e) {
    return "Error in ${e.code}: ${e.message}";
  }
}


Future<String> updateDonationDrive(String uuid, String driveName, String donationDriveDescription) async {
  try {
    final userDocRef = db.collection("donationdrives").where("uid", isEqualTo: uuid).limit(1);
    final userDoc = await userDocRef.get();
    print(userDoc);
    print(userDoc.docs);
    print(userDoc.docs.first);
    final user = userDoc.docs.first;
    final userRef = db.collection("donationdrives").doc(user.id);

    await userRef.update({
      "name": driveName,
      "description": donationDriveDescription
    });


    return "Successfully updated!";
  } on FirebaseException catch (e) {
    return "Error in ${e.code}: ${e.message}";
  }
}


Future<String> updateDonationDriveStatus(String uuid, bool isOpen) async {
  try {
    final userDocRef = db.collection("donationdrives").where("uid", isEqualTo: uuid).limit(1);
    final userDoc = await userDocRef.get();
    print(userDoc);
    print(userDoc.docs);
    print(userDoc.docs.first);
    final user = userDoc.docs.first;
    final userRef = db.collection("donationdrives").doc(user.id);

    await userRef.update({
      "isOpen": isOpen
    });


    return "Successfully updated!";
  } on FirebaseException catch (e) {
    return "Error in ${e.code}: ${e.message}";
  }
}

}
