import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/admin_donors_page.dart';
import 'package:week9_authentication/pages/admin_organizations_page.dart';
import 'package:week9_authentication/providers/auth_provider.dart';
import 'package:week9_authentication/providers/user_provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;
    Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: false)
        .snapshots();

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(title: const Text("Organization Approval")),
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
                  child: Text("No Organizations Found"),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Text("Approval list is empty",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Icon(Icons.hourglass_empty,
                        size: 200, color: Color.fromARGB(50, 255, 255, 255))
                  ],
                ));
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  User organization = User.fromJson(snapshot.data?.docs[index]
                      .data() as Map<String, dynamic>);
                  String? userID = snapshot.data?.docs[index].reference.id;
                  return ListTile(
                    title: Text(organization.name!),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () {
                        print(userID);
                        context.read<UserProvider>().updateUserStatus(userID!);
                      },
                    ),
                  );
                },
              );
            }));
  }

  Drawer get drawer => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: Column(
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 100,
                color: Colors.white,
              ),
              Text(
                "ADMIN",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('Organization Approval'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          //View Organizations and Donations
          title: const Text('Organizations'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminOrganizationsPage()));
          },
        ),
        ListTile(
          //View Donor
          title: const Text('Donors'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDonorsPage()));
          },
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ]));
}
