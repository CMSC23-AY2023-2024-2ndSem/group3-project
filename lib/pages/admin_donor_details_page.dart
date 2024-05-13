import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class AdminDonorDetailsPage extends StatefulWidget {
  final User donor;
  const AdminDonorDetailsPage({super.key, required this.donor});

  @override
  AdminDonorDetailsPageState createState() => AdminDonorDetailsPageState();
}

class AdminDonorDetailsPageState extends State<AdminDonorDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final users = snapshot.data!.docs
            //     .map((doc) => User.fromDocument(doc))
            //     .toList();
            // User donor = users.firstWhere(
            //     (user) => user.name == user!.name && user.type == "donor");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                infoItem("Username", widget.donor.username),
                infoItem("Name", widget.donor.name!),
                infoItem("Address", widget.donor.address!),
                infoItem("Contact", widget.donor.contactNumber!),
                infoItem(
                    "Number of Donations", widget.donor.donations.length.toString()),
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