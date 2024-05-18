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
        title: Text(widget.donor.name!,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageBar(),
                const SizedBox(height: 20),
                infoItem("Username", widget.donor.username),
                infoItem("Name", widget.donor.name!),
                infoItem("Address", widget.donor.address!),
                infoItem("Contact", widget.donor.contactNumber!),
                infoItem("Number of Donations",
                    widget.donor.donations.length.toString()),
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
              color: Colors.redAccent,
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

  Widget pageBar() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.pink],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: const Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Donor Details",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
