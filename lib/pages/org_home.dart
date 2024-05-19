import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donation_model.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/providers/auth_provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class OrganizationHomePage extends StatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  State<OrganizationHomePage> createState() => _OrganizationHomePageState();
}

class _OrganizationHomePageState extends State<OrganizationHomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream = context.watch<DonationProvider>().donations;
    
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(title: const Text("Donations"),),
      body: StreamBuilder(
        stream: donationsStream,
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
          
          final users = snapshot.data!.docs.map((doc) => User.fromDocument(doc)).toList();

          User currentUser = users.firstWhere((user) {
            return user.username == context.read<UserAuthProvider>().user!.email;
          }, orElse: () => User(type: "organization", username: ""));
          
          List<Donation> donations = snapshot.data!.docs.map((doc) {
            Donation donation = Donation.fromJson(doc.data() as Map<String, dynamic>);
            if (donation.organizationUname == currentUser.username) {
              return donation;
            }
            return null;
          }).whereType<Donation>().toList();
        
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              Donation donation = donations[index];
              return ListTile(
                title: Text("Donation from ${donation.donorUname}"),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    Navigator.pushNamed(context, '/donation-details');
                  },
                ),
                onTap:() {
                  Navigator.pushNamed(context, '/donation-details');
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
          )
        ),
        ListTile(
          title: const Text('Donation'),
          onTap: () {
            
          },
        ),
        ListTile(
          title: const Text('Donation drives'),
          onTap: () {
            
          },
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            
          },
        ),
      ],
    ),
  );
}