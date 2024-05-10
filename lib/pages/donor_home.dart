import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/organization_model.dart';
import '../providers/auth_provider.dart';
import '../providers/organization_provider.dart';
import 'user_details_page.dart';

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
      context.read<OrganizationProvider>().fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> organizationsStream = context.watch<OrganizationProvider>().organizations;
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text("Organizations Available"),
      ),
      body: StreamBuilder(
        stream: organizationsStream,
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

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Organization organization = Organization.fromMap(snapshot.data?.docs[index].data() as Map<String, dynamic>);
              return ListTile(
                title: Text(organization.name),
                trailing: IconButton(
                  icon: const Icon(Icons.handshake),
                  onPressed: () {
                    Navigator.pushNamed(context, '/donate', arguments: organization.name);
                  },
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/donate', arguments: organization.name);
                },
              );
            },
          );
        }

          
    ));
  }

  Drawer get drawer => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white,
              ),
              Text(
                context.read<UserAuthProvider>().user!.email!,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        
        ),
        ListTile(
          title: const Text('Home Page'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DonorHomePage()));
          },
        ),
        ListTile(
          title: const Text('Details'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserDetailsPage()));
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
