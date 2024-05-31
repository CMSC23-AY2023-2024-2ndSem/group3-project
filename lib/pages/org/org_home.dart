import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:week9_authentication/pages/home_page.dart';
import 'org_donation_drives_page.dart';
import '../../models/user_model.dart';
import '../../models/donation_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/donation_provider.dart';
// import '../providers/donationdrive_provider.dart';
import '../../providers/user_provider.dart';
import 'donation_details_page.dart';
import 'org_details_page.dart';
import 'org_home_delete_modal.dart';
import 'org_home_edit_modal.dart';
import 'org_home_link_modal.dart';
import 'qr_scanner_page.dart';


class OrganizationHomePage extends StatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  State<OrganizationHomePage> createState() => _OrganizationHomePageState();
}

class _OrganizationHomePageState extends State<OrganizationHomePage> {
  Map<String, String> drivesUidNameMap = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
      context.read<DonationProvider>().fetchDonations();
    });
    
      _setupDonationDrivesListener();
  }

  void _setupDonationDrivesListener() {
    FirebaseFirestore.instance
      .collection("donationdrives")
      .where("organizationUname", isEqualTo: context.read<UserAuthProvider>().user!.email!)
      .snapshots()
      .listen((querySnapshot) {
        Map<String, String> updatedDrivesUidNameMap = {};
        for (var doc in querySnapshot.docs) {
          String uid = doc.data()['uid'];
          String name = doc.data()['name'];
          updatedDrivesUidNameMap[uid] = name;
        }
        setState(() {
          drivesUidNameMap = updatedDrivesUidNameMap;
        });
      });
  }
  
  

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream =
        context.watch<UserProvider>().users;
    

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Donations",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
         actions: [
    IconButton(
      icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrScannerPage()),
        );
      },
    ),
  ],
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
                  .orderBy("date", descending: true)
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
                
                    var donationCategories = donation.donationCategories.entries
                        .where((element) => element.value == true)
                        .map((e) => e.key)
                        .toList();

                    var date = donation.date.toString().split(" ")[0];
                    var time = donation.date.toString().split(" ")[1].split(".")[0];
                    var dateTime = "$date $time";
                    var donorName = donation.donorUname.split("@")[0];

                    String driveName = drivesUidNameMap[donation.donationDriveUid] ?? "Unassigned";

                    List<String> donationInfo = [
                      donation.donorUname,
                      donation.organizationUname,
                      driveName,
                      donationCategories.join(", "),
                      donation.pickupOrDropOff.toString(),
                      donation.weight,
                      dateTime,
                      donation.addresses!.join(" "),
                      donation.contactNumber.toString(),
                      donation.status,
                      donation.imageUrl!,
                    ];

                    
                    return Card(
                        color: Colors.grey.shade900,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text("Donor: ${donorName}"),
                            subtitle: Text("${driveName}\n${donation.status}"),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              IconButton(
                                icon: const Icon(Icons.link, 
                                color: Colors.orangeAccent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => LinkModal(
                                      donationUid: donation.uid,
                                      donationDrives: drivesUidNameMap,
                                      donationCurrentDrive: donation.donationDriveUid,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                color: Colors.orangeAccent),
                                onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => EditModal(
                                  donationUid: donation.uid,
                                  donationStatus: donation.status,
                                  ),
                                );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                color: Colors.red),
                                onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => DeleteModal(
                                  donationUid: donation.uid,
                                  donationDonorUname: donation.donorUname,
                                  donationOrgUname: donation.organizationUname,
                                  ),
                                );
                                },
                              ),
                              
                              ],
                            ),
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
               Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const OrganizationHomePage(),
                //     ));
              },
            ),
            ListTile(
              title: const Text('Donation Drives'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrganizationDonationDrivesPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
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