import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donation_model.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class DonationDetailsPage extends StatefulWidget {
  const DonationDetailsPage({super.key});

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream = context.watch<DonationProvider>().donations;
    
    return Scaffold(
      appBar: AppBar( title: const Text("Donation Details"),),
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Donor: ")
            ],
          );
        },
      ),
    );
  }

}