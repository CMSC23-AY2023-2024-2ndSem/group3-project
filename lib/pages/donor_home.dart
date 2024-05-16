import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
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
      context.read<UserProvider>().fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(
          title: const Text("Organizations Available", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.cyan, 
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

              final users = snapshot.data!.docs
                  .map((doc) => User.fromDocument(doc))
                  .toList();

              List<dynamic> organizations =
                  users.where((user) => user.type == "organization" && user.status == true).toList();
              User currentUser = users.firstWhere((user) {
                return user.username ==
                    context.read<UserAuthProvider>().user!.email;
              }, orElse: () => User(type: "donor", username: ""));
              return ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  User organization = organizations[index];
                  List<String> donorOrgInfo = [
                    currentUser.username,
                    organization.username,
                    organization.name!
                  ];
                  return ListTile(
                    title: Text(organization.name!,
                    
                      style: const TextStyle(fontSize: 20),),
                    leading: const Icon(
                      Icons.groups_rounded,
                      size: 30,
                       color: Colors.amber),
                    subtitle: Text(
                        "${organization.donations.length} donations received"),
                    trailing: IconButton(
                        icon: const Icon(Icons.volunteer_activism_rounded, size: 30, color: Color.fromARGB(255, 187, 134, 252)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/donate',
                            arguments: donorOrgInfo);
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/donate',
                          arguments: donorOrgInfo);
                    },
                  );
                },
              );
            }));
  }

  Drawer get drawer => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.cyan,
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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('Donate to Organizations'),
          leading: const Icon(Icons.favorite, color: Color.fromARGB(255, 187, 134, 252)),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('User Profile'),
          leading: const Icon(Icons.account_box_rounded, color: Color.fromARGB(255, 187, 134, 252)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DonorDetailsPage()));
          },
        ),
        const Divider(thickness: 2),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.logout_rounded, color: Color.fromARGB(255, 187, 134, 252)),
          onTap: () {
            context.read<UserAuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
      ]));
}
