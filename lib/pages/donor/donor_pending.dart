import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';

class DonorPending extends StatefulWidget {
  const DonorPending({super.key});

  @override
  _DonorPendingState createState() => _DonorPendingState();
}

class _DonorPendingState extends State<DonorPending> {
  auth.User? authUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().fetchDonations();
      context.read<UserProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    authUser = context.read<UserAuthProvider>().user;
    Stream<QuerySnapshot> donationStream = context.watch<DonationProvider>().donations;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Donations", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final donations = snapshot.data!.docs
                .map((doc) => Donation.fromDocument(doc))
                .where((donation) => donation.donorUname == authUser?.email && donation.status == "Pending") 
                .toList();
            
            if (donations.isEmpty) {
              return const Center(child: Text("No pending donations found."));
            }

            return ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];
                return Card(
                  color: Colors.grey.shade900,
                                margin: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                  title: Text("Donation to ${donation.organizationUname}"),
                  subtitle: Text("Date: ${donation.date}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    onPressed: () {
                      showDialog(context: context, builder: 
                        (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Are you sure you want to cancel this donation?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<DonationProvider>().updateStatus(donation.uid, "Canceled");
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                            ],
                          );
                        },
                      
                      );
                    },
                  ),
                )
                ));
              },
            );
          } else {
            return const Center(child: Text("No data found!"));
          }
        },
      ),
    );
  }
}
