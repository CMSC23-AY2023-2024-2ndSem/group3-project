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
      appBar: AppBar(
        title: Text(
          widget.orgName,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
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
              return Center(
                child: Column(
                  children: [
                    pageBar(),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Icon(Icons.no_backpack_rounded,
                            size: 200,
                            color: Color.fromARGB(50, 255, 255, 255))),
                    const Text("No Donations Yet",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }
            return Column(
              children: [
                pageBar(),
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
                              return Card(
                                  color: Colors.grey.shade900,
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title:
                                          Text("Donor: ${donation.donorUname}"),
                                      leading: const Icon(
                                          Icons.perm_contact_cal_rounded,
                                          color: Colors.redAccent,
                                          size: 30),
                                      subtitle: Text(
                                          "Date: ${donation.date.toString()}"),
                                    ),
                                  ));
                            });
                      }),
                ),
              ],
            );
          }),
    );
  }

  Widget pageBar() {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      color: Colors.grey.shade900,
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Donations",
                  style: TextStyle(
                      fontSize: 20,
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
