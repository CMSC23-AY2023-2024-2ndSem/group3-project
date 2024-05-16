import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donationdrive_model.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonationDrives(DonationDrive DonationDrive) async {
    try {
      await db.collection("donationdrives").add(DonationDrive.toJson());

      return "Successfully added!";
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

}
