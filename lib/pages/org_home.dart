import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donation_model.dart';
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
      appBar: AppBar(title: Text("Donations"),),
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
        
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Donation donation = Donation.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>
              );
              return ListTile(
                title: Text(donation.uid),
                onTap:() {
                  
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