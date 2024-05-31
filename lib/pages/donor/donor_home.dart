import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'donor_pending.dart';
import '../../models/user_model.dart';
import '../../models/donationdrive_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/donationdrive_provider.dart';
import 'donor_details_page.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
      context.read<UserProvider>().fetchOrganizations();
      context.read<DonationDriveProvider>().fetchDonationDrives();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;
    Stream<QuerySnapshot> donationDrivesStream = context.watch<DonationDriveProvider>().donationdrives;

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Organizations Available",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text("No Organizations Found"),
            );
          }

          final users =
              snapshot.data!.docs.map((doc) => User.fromDocument(doc)).toList();
          List organizations = users
              .where((user) =>
                  user.type == "organization" &&
                  user.status == true)
              .toList();
          User currentUser = users.firstWhere((user) {
            return user.username ==
                context.read<UserAuthProvider>().user!.email;
          }, orElse: () => User(type: "donor", username: ""));

          return StreamBuilder<QuerySnapshot>(
            stream: donationDrivesStream,
            builder: (context, drivesSnapshot) {
              if (drivesSnapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${drivesSnapshot.error}"),
                );
              } else if (drivesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!drivesSnapshot.hasData) {
                return const Center(
                  child: Text("No Donation Drives Found"),
                );
              }

              final donationDrives = drivesSnapshot.data!.docs
                  .map((doc) => DonationDrive.fromDocument(doc))
                  .toList();

              return ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  User organization = organizations[index];
                  List<String> donorOrgInfo = [
                    currentUser.username,
                    organization.username,
                    organization.name!,
                    "direct"
                  ];

                  List orgDonationDrives = donationDrives.where((drive) => drive.organizationUname == organization.username).toList();

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              organization.name!,
                              style: const TextStyle(fontSize: 20, color: Colors.amber),
                            ),
                            leading: const Icon(
                              Icons.groups_rounded,
                              size: 30,
                              color: Colors.cyan,
                            ),
                            subtitle: Text("${organization.orgDescription}"),
                            trailing: organization.openForDonation! ? IconButton(
                              icon: const Icon(
                              Icons.volunteer_activism_rounded,
                              size: 30,
                              color: Colors.cyan,
                              ),
                              onPressed: () {
                              Navigator.pushNamed(context, '/donate',
                                arguments: donorOrgInfo);
                              },
                            ) : const IconButton(
                              icon: Icon(
                              Icons.volunteer_activism_rounded,
                              size: 30,
                              color: Colors.grey,
                              ),
                              onPressed: null,
                            ),
                            onTap: () {
                                if(organization.openForDonation!){
                                  Navigator.pushNamed(context, '/donate',
                                    arguments: donorOrgInfo);
                                }else{

                                }
                              },

                          ),
                          (orgDonationDrives.isEmpty)
                              ? const SizedBox(height: 0)
                              : const Divider(),
                          ...orgDonationDrives.map((drive) {
                               List<String> driveInfo = [
                                currentUser.username,
                                organization.username,
                                drive.name,
                                drive.uid
                              ];
                            return ListTile(
                              title: Text(drive.name),
                              subtitle: Text("${drive.description}"),
                                leading: const Icon(Icons.favorite_border, color: Colors.cyan),
                              trailing: drive.isOpen ? IconButton(
                                icon: const Icon(
                                  Icons.volunteer_activism_rounded,
                                  size: 30,
                                  color: Colors.cyan,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/donate', arguments: driveInfo);
                                },
                              ) : const IconButton(
                                icon: Icon(
                                  Icons.volunteer_activism_rounded,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                                onPressed: null, 
                              ),
                              onTap: () {
                          if(drive.isOpen){
                            Navigator.pushNamed(context, '/donate', arguments: driveInfo);
                          }else{

                          }
                        },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.cyan.shade200,
                Colors.cyan.shade300,
                Colors.cyan.shade400,
                Colors.cyan.shade500,
              ])),
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
              ),
            ),
            ListTile(
              title: const Text('Donate to Organizations'),
              leading: const Icon(Icons.favorite,
                  color: Colors.cyan),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pending Donations'),
              leading: const Icon(Icons.pending,
                  color: Colors.cyan),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonorPending()),
                );
              },
            ),
            ListTile(
              title: const Text('User Profile'),
              leading: const Icon(Icons.account_box_rounded,
                  color: Colors.cyan),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DonorDetailsPage()),
                );
              },
            ),
            const Divider(thickness: 2),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout_rounded,
                  color: Colors.cyan),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
