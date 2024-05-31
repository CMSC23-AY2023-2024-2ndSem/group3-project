import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// import '../pages/org_donation_drives_page.dart';
// import '../pages/org_home.dart';
import '../../models/user_model.dart' as user;
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';

class OrganizationDetailsPage extends StatefulWidget {
  const OrganizationDetailsPage({super.key});

  @override
  State<OrganizationDetailsPage> createState() => _OrganizationDetailsPageState();
}

class _OrganizationDetailsPageState extends State<OrganizationDetailsPage> {
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
      // drawer: drawer,
      appBar: AppBar(
        title: const Text("Organization Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("No data available"),
            );
          }

          final users =
              snapshot.data!.docs.map((doc) => user.User.fromDocument(doc)).toList();
          user.User organization = users.firstWhere((user) =>
              authUser?.email == user.username && user.type == "organization");
          
          late String organizationStatus;

              if(organization.status == true) {
              organizationStatus = "Approved";
            } else if (organization.status == false) {
              organizationStatus = "Pending";
            }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              infoItem("Account Type", "Organization"),
              infoItem("Username", organization.username),
              infoItem("Organization Name", organization.name!),
              // infoItem("Address", organization.address! as String),
              infoItem("Contact", organization.contactNumber!),
              infoItem("Account Status", organizationStatus),
              SwitchListTile(
                title: const Text('Open for Donation'),
                value: organization.openForDonation!,
                onChanged: (newValue) async {
                  await context
                      .read<UserProvider>()
                      .updateDonationStatus(organization.username, newValue);
                },
              ),
            ],
          );
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

  // Drawer get drawer => Drawer(
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           DrawerHeader(
  //             decoration: const BoxDecoration(
  //               color: Colors.orangeAccent,
  //             ),
  //             child: Column(
  //               children: [
  //                 const Icon(
  //                   Icons.account_circle,
  //                   size: 110,
  //                   color: Colors.white,
  //                 ),
  //                 Text(
  //                   context.read<UserAuthProvider>().user!.email!,
  //                   style: const TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           ListTile(
  //             title: const Text('Donation'),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const OrganizationHomePage(),
  //                 ),
  //               );
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('Donation Drives'),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const OrganizationDonationDrivesPage(),
  //                 ),
  //               );
  //             },
  //           ),
  //           ListTile(
  //             title: const Text('Profile'),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const OrganizationDetailsPage(),
  //                 ),
  //               );
  //             },
  //           ),
  //           const Divider(thickness: 2),
  //           ListTile(
  //             title: const Text('Logout'),
  //             leading: const Icon(
  //               Icons.logout_rounded,
  //             ),
  //             onTap: () {
  //               context.read<UserAuthProvider>().signOut();
                  //  Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     );
}
