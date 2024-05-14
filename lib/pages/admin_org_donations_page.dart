import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donation_model.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class AdminOrgDonationsPage extends StatefulWidget {
  final List<String> donations;
  final String orgName;
  const AdminOrgDonationsPage(
      {super.key, required this.donations, required this.orgName});

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
      appBar: AppBar(title: Text(widget.orgName)),
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
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("Donations",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const Divider(
                  endIndent: 15,
                  indent: 15,
                  thickness: 3,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.donations.length,
                      itemBuilder: (context, index) {
                        Stream<QuerySnapshot> orgDonationsStream =
                            FirebaseFirestore.instance
                                .collection("donations")
                                .where("uid",
                                    isEqualTo: widget.donations[index])
                                .snapshots();
                        return StreamBuilder(
                            stream: orgDonationsStream,
                            builder: (context, snapshots) {
                              if (snapshots.hasError) {
                                return Center(
                                  child: Text(
                                      "Error encountered! ${snapshot.error}"),
                                );
                              } else if (snapshots.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshots.hasData) {
                                return const Center(
                                  child: Text("No Donations Found"),
                                );
                              }
                              Donation donation = Donation.fromJson(
                                  snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>);
                              return ListTile(
                                title: Text("Donor: ${donation.donorUname}"),
                                leading: const Icon(
                                    Icons.perm_contact_cal_rounded,
                                    size: 30),
                                subtitle:
                                    Text("Date: ${donation.date.toString()}"),
                              );
                            });
                      }),
                ),
              ],
            );
          }),
    );
  }
}
