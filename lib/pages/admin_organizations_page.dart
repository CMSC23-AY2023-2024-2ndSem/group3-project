import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/admin_org_donations_page.dart';
import 'package:week9_authentication/providers/user_provider.dart';

class AdminOrganizationsPage extends StatefulWidget {
  const AdminOrganizationsPage({super.key});

  @override
  State<AdminOrganizationsPage> createState() => _AdminOrganizationsPageState();
}

class _AdminOrganizationsPageState extends State<AdminOrganizationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .where("type", isEqualTo: "organization")
        .where("status", isEqualTo: true)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Organizations",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.redAccent,
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
                  child: Text("No Organizations Found"),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Icon(Icons.groups_sharp,
                            size: 200,
                            color: Color.fromARGB(50, 255, 255, 255))),
                    Text("No Organizations Found",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ));
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  User organization = User.fromJson(snapshot.data?.docs[index]
                      .data() as Map<String, dynamic>);
                  // String? userID = snapshot.data?.docs[index].reference.id;
                  return ListTile(
                    title: Text(
                      organization.name!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    leading: const Icon(
                      Icons.groups_rounded,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminOrgDonationsPage(
                                    donations: organization.donations,
                                    orgName: organization.name!,
                                  )));
                    },
                  );
                },
              );
            }));
  }
}
