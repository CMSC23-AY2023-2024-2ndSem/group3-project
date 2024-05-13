import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class AdminOrgDonationsPage extends StatefulWidget {
  final List<String> donations;
  const AdminOrgDonationsPage({super.key, required this.donations});

  @override
  State<AdminOrgDonationsPage> createState() => _AdminOrgDonationsPageState();
}

class _AdminOrgDonationsPageState extends State<AdminOrgDonationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().fetchDonations();
    });
  }
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream =
        context.read<DonationProvider>().donations;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Donations")),
      body: StreamBuilder(
          stream: donationsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Donations Found"),
              );
            }

            if (widget.donations.isEmpty) {
              return const Center(
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Icon(Icons.no_backpack_rounded,
                            size: 200,
                            color: Color.fromARGB(50, 255, 255, 255))),
                    Text("No Donations Yet",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }
            print(widget.donations);
            final donations = widget.donations.map((donation) => FirebaseFirestore
                                                                  .instance
                                                                  .collection("donations")
                                                                  .where("uid", isEqualTo: donation).get()).toList();
            // final donationDoc = donations.map((doc){ });
            
            return ListView.builder(
                itemCount: widget.donations.length,
                itemBuilder: (context, index) {
                  
                  return ListTile(
                    title: Text(widget.donations[index]),
                    leading: const Icon(Icons.list, size: 30),
                  );
                });
          }),
    );
  }
}
