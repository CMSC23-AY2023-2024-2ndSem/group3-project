import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/admin/admin_donors_page.dart';
import 'package:week9_authentication/pages/admin/admin_organizations_page.dart';
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
        appBar: AppBar(
          title: const Text(
            "Organization Approval",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
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
                return Center(
                    child: Column(
                  children: [
                    pageBar(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Text("Approval list is empty",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(Icons.hourglass_empty,
                        size: 200, color: Color.fromARGB(50, 255, 255, 255))
                  ],
                ));
              }

              return Column(
                children: [
                  pageBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        User organization = User.fromJson(
                            snapshot.data?.docs[index].data()
                                as Map<String, dynamic>);
                        String? userID =
                            snapshot.data?.docs[index].reference.id;
                        return Card(
                          color: Colors.grey.shade900,
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(organization.name!,
                                  style: const TextStyle(fontSize: 18)),
                              leading: const Icon(
                                Icons.app_registration_rounded,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  size: 30,
                                ),
                                onPressed: () {
                                  print(organization.proofs);
                                  showDialog(
                                      context: context,
                                      builder: (context) => LayoutBuilder(
                                            builder: (context, constraints) =>
                                                AlertDialog(
                                              backgroundColor:
                                                  Colors.grey.shade900,
                                              scrollable: true,
                                              title: const Center(
                                                child: Text(
                                                  "Proof/s of Legitimacy",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Divider(),
                                                  SizedBox(
                                                    height:
                                                        constraints.maxHeight *
                                                            0.2,
                                                    width:
                                                        constraints.maxWidth *
                                                            0.9,
                                                    child: ListView.builder(
                                                        itemCount: organization
                                                            .proofs!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .folder_copy_rounded),
                                                            title: Text(
                                                                "Proof ${index + 1}",
                                                                style: const TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                            backgroundColor:
                                                                                Colors.grey.shade900,
                                                                            content:
                                                                                SizedBox(height: 250, child: Image.network(organization.proofs![index], height: 200)),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Navigator.pop(context),
                                                                                child: const Text("Back", style: TextStyle(color: Colors.redAccent)),
                                                                              )
                                                                            ],
                                                                          ));
                                                            },
                                                          );
                                                        }),
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      child: const Text(
                                                        "Approve",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                      onPressed: () {
                                                        print(userID);
                                                        context
                                                            .read<
                                                                UserProvider>()
                                                            .updateUserStatus(
                                                                userID!, true);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              "Organization approved!"),
                                                        ));
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("Back",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                          textAlign:
                                                              TextAlign.end),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  // Widget pageBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: const BorderRadius.only(
  //           bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
  //       color: Colors.grey.shade900,
  //     ),
  //     margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
  //     child: const Column(
  //       children: [

  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.all(30.0),
  //               child: Text(
  //                 "Pending Organization Sign Up",
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                  "Pending Organization Sign Up",
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

  Drawer get drawer => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.red.shade600,
            Colors.red.shade500,
            Colors.red.shade400,
            Colors.red.shade300,
          ])),
          child: const Column(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                size: 110,
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
          leading: const Icon(
            Icons.checklist_rtl_rounded,
            color: Colors.redAccent,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          //View Organizations and Donations
          title: const Text('Organizations'),
          leading: const Icon(
            Icons.corporate_fare_rounded,
            color: Colors.redAccent,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminOrganizationsPage()));
          },
        ),
        ListTile(
          //View Donor
          title: const Text('Donors'),
          leading: const Icon(
            Icons.group,
            color: Colors.redAccent,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDonorsPage()));
          },
        ),
        const Divider(thickness: 2),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(
            Icons.logout_rounded,
            color: Colors.redAccent,
          ),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ]));
}
