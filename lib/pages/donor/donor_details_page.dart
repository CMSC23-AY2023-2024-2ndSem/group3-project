import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../models/user_model.dart' as user;
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';

class DonorDetailsPage extends StatefulWidget {
  const DonorDetailsPage({super.key});

  @override
  DonorDetailsPageState createState() => DonorDetailsPageState();
}

class DonorDetailsPageState extends State<DonorDetailsPage> {

       @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }


  auth.User? authUser;
  @override
  Widget build(BuildContext context) {
    authUser = context.read<UserAuthProvider>().user;
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.cyan, 
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.hasData) {
            final users = snapshot.data!.docs.map((doc) => user.User.fromDocument(doc)).toList();
            user.User donor = users.firstWhere((user) => authUser?.email == user!.username && user.type == "donor");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                infoItem("Account Type", "Donor"),
                infoItem("Username", donor.username),
                infoItem("Name", donor.name!),
                infoItem("Address", donor.address![0]),
                infoItem("Contact", donor.contactNumber!),
                infoItem("Number of Donations", donor.donations.length.toString()),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget infoItem(String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            info,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }


}
