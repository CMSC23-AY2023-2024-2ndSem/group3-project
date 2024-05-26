import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseAuthApi {
  late FirebaseAuth auth;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuthApi() {
    auth = FirebaseAuth.instance;
  }

  Stream<User?> fetchUser() {
    return auth.authStateChanges();
  }

  User? getUser() {
    return auth.currentUser;
  }

  Future<void> signUp(String firstName, String lastName, String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (lastName == ""){
      print("ORG DETECTED");
      //for organization since lastName is hardcoded to ""
      await userCredential.user!.updateDisplayName(firstName);
    }else{
      //for donor
      print("DONOR DETECTED");
      await userCredential.user!.updateDisplayName('$firstName $lastName');
    }
    
    // TODO handle type(donor or organization) to firestore (don't know if this should be in this file)
    // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
    //   'email': email,
      

    // });
  } on FirebaseAuthException catch (e) {
    print('Firebase Error: ${e.code} : ${e.message}');
  } catch (e) {
    print('Error: $e');
  }
}

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(credentials);
      print('&*&*&*&&*&*&*&*&*&&&*&*&*&*&*&*&*&*');
      return "Success";
    } on FirebaseException catch (e) {
      return ('Firebase Error: ${e.code} : ${e.message}');
    } catch (e) {
      return ('Error: $e');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> checkEmailExists(String email) async {
    QuerySnapshot result = await db.collection('users').where('username', isEqualTo: email.toLowerCase()).get();
    return result.docs.isNotEmpty;
  }
}
