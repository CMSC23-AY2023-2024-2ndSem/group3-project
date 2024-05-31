import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donationdrive_model.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/org/org_add_donation_drive_page.dart';
import 'package:week9_authentication/pages/org/org_donation_drive_delete_modal.dart';
import 'package:week9_authentication/pages/org/org_donation_drive_details_page.dart';
// import 'package:week9_authentication/pages/org_details_page.dart';
// import 'package:week9_authentication/pages/org_home.dart';
import 'package:week9_authentication/providers/auth_provider.dart';
import '../../providers/donationdrive_provider.dart';
import '../../providers/user_provider.dart';
import 'org_donation_drive_edit_modal.dart';

class OrganizationDonationDrivesPage extends StatefulWidget {
  const OrganizationDonationDrivesPage({super.key});

  @override
  State<OrganizationDonationDrivesPage> createState() =>
      _OrganizationDonationDrivesPageState();
}

class _OrganizationDonationDrivesPageState
    extends State<OrganizationDonationDrivesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
      context.read<DonationDriveProvider>().fetchDonationDrives();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    return Scaffold(
        // drawer: drawer,
        appBar: AppBar(
          title: const Text("Donation Drives",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

            final users = snapshot.data!.docs
                .map((doc) => User.fromDocument(doc))
                .toList();
            User currentUser = users.firstWhere((user) {
              return user.username ==
                  context.read<UserAuthProvider>().user!.email;
            }, orElse: () => User(type: "organization", username: ""));

            if (currentUser.donationDrives.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Icon(Icons.no_backpack_rounded,
                            size: 200,
                            color: Color.fromARGB(50, 255, 255, 255))),
                    const Text("No Donation Drives Yet",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Card(
                        color: Colors.grey.shade900,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: const Text("Add a Donation Drive/Charity"),
                              leading: const Icon(Icons.add,
                                  color: Colors.orangeAccent, size: 30),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddDonationDrivePage(
                                        organizationUname: currentUser.username,
                                      ),
                                    ));
                              },
                            ))),
                  ],
                ),
              );
            }

            return Column(children: [
              Card(
                  color: Colors.grey.shade900,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text("Add a Donation Drive/Charity"),
                        leading: const Icon(Icons.add,
                            color: Colors.orangeAccent, size: 30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddDonationDrivePage(
                                  organizationUname: currentUser.username,
                                ),
                              ));
                        },
                      ))),
              Expanded(
                child: ListView.builder(
                    itemCount: currentUser.donationDrives.length,
                    itemBuilder: (context, index) {
                      Stream<QuerySnapshot> orgDonationDriveStream =
                          FirebaseFirestore.instance
                              .collection("donationdrives")
                              .where("organizationUname",
                                  isEqualTo: currentUser.username)
                              .snapshots();
                      return StreamBuilder(
                          stream: orgDonationDriveStream,
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
                                child: Text("No Donation Drives Found"),
                              );
                            }

                            final donationDrives = snapshots.data!.docs
                                .map((doc) => DonationDrive.fromDocument(doc))
                                .toList();
                            
                            DonationDrive donationDrive = donationDrives[index];

                            String isOpen = "";
                            if (donationDrive.isOpen == true) {
                              isOpen = "Open";
                            } else {
                              isOpen = "Closed";
                            }

                            List donationDriveInfo = [
                              donationDrive.name,
                              donationDrive.description,
                              donationDrive.organizationUname,
                              isOpen,
                              donationDrive.uid
                            ];

                            return Card(
                                color: Colors.grey.shade900,
                                margin: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                      title: Text(
                                          donationDrive.name),
                                          subtitle: Text(donationDrive.description),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DonationDriveDetailsPage(
                                                      donationDriveInfo:
                                                          donationDriveInfo),
                                            ));
                                      },
                                      trailing: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Switch(
                                              value: donationDrive.isOpen,
                                              onChanged: (value) {
                                                context.read<DonationDriveProvider>().updateDonationDriveStatus(
                                                  donationDrive.uid, value);
                                              },
                                              activeColor: Colors.amber,
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.orangeAccent),
                                            onPressed: () {
                                              showDialog(
                                              context: context,
                                              builder: (BuildContext context) => (
                                                DonationDriveEditModal(
                                                  donationDriveUuid: donationDrive.uid,
                                                  donationDriveName: donationDrive.name,
                                                  donationDriveDescription: donationDrive.description,
                                                )
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
                                                builder: (BuildContext context) => (
                                                  DonationDriveDeleteModal(
                                                    donationDrive: donationDrive,
                                                    username: currentUser.username,
                                                  )
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )),
                                ));
                          });
                    }),
              )
            ]);
          },
        ));
  }
}

//   Drawer get drawer => Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//                 decoration: const BoxDecoration(
//                   color: Colors.orangeAccent,
//                 ),
//                 child: Column(
//                   children: [
//                     const Icon(
//                       Icons.account_circle,
//                       size: 110,
//                       color: Colors.white,
//                     ),
//                     Text(
//                       context.read<UserAuthProvider>().user!.email!,
//                       style: const TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )),
//             ListTile(
//               title: const Text('Donation'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const OrganizationHomePage(),
//                     ));
//               },
//             ),
//             ListTile(
//               title: const Text('Donation Drives'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const OrganizationDonationDrivesPage(),
//                     ));
//               },
//             ),
//             ListTile(
//               title: const Text('Profile'),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const OrganizationDetailsPage(),
//                     ));
//               },
//             ),
//             const Divider(thickness: 2),
//             ListTile(
//               title: const Text('Logout'),
//               leading: const Icon(
//                 Icons.logout_rounded,
//               ),
//               onTap: () {
//                 context.read<UserAuthProvider>().signOut();
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       );
//
// }
