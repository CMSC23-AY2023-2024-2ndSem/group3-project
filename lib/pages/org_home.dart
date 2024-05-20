import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/donation_model.dart';
import '../providers/auth_provider.dart';
import '../providers/donation_provider.dart';
import '../providers/user_provider.dart';
import 'donation_details_page.dart';
import 'org_details_page.dart';

class OrganizationHomePage extends StatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  State<OrganizationHomePage> createState() => _OrganizationHomePageState();
}

class _OrganizationHomePageState extends State<OrganizationHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
      context.read<DonationProvider>().fetchDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream =
        context.read<UserProvider>().users;

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Donations",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder(
        stream: userStream,
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

          final users =
              snapshot.data!.docs.map((doc) => User.fromDocument(doc)).toList();
          User currentUser = users.firstWhere((user) {
            return user.username ==
                context.read<UserAuthProvider>().user!.email;
          }, orElse: () => User(type: "organization", username: ""));

          if (currentUser.donations.isEmpty) {
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

          return ListView.builder(
            itemCount: currentUser.donations.length,
            itemBuilder: (context, index) {
              Stream<QuerySnapshot> orgDonationsStream = FirebaseFirestore
                  .instance
                  .collection("donations")
                  .where("organizationUname", isEqualTo: currentUser.username)
                  .snapshots();
              return StreamBuilder(
                  stream: orgDonationsStream,
                  builder: (context, snapshots) {
                    if (snapshots.hasError) {
                      return Center(
                        child: Text("Error encountered! ${snapshot.error}"),
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

                    final donations = snapshots.data!.docs
                        .map((doc) => Donation.fromDocument(doc))
                        .toList();


                    Donation donation = donations[index];


                    List<String> donationInfo = [
                      donation.donorUname,
                      donation.organizationUname,
                      donation.donationDriveName,
                      donation.donationCategories.toString(),
                      donation.pickupOrDropOff.toString(),
                      donation.weight,
                      donation.date.toString(),
                      donation.addresses.toString(),
                      donation.contactNumber.toString(),
                      donation.status,
                    ];
                    
                    return Card(
                        color: Colors.grey.shade900,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text("Donor: ${donation.donorUname}"),
                            leading: const Icon(Icons.perm_contact_cal_rounded,
                                color: Colors.orangeAccent, size: 30),
                            subtitle: Text("Date: ${donation.date}"),
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DonationDetailsPage(donationInfo: donationInfo),));
                            },
                          ),
                        ));
                  });
            },
          );
        },
      ),
    );
  }

  Drawer get drawer => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 110,
                      color: Colors.white,
                    ),
                    Text(
                      context.read<UserAuthProvider>().user!.email!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            ListTile(
              title: const Text('Donation'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrganizationHomePage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Donation drives'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrganizationDetailsPage(),
                    ));
              },
            ),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(
                Icons.logout_rounded,
              ),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
