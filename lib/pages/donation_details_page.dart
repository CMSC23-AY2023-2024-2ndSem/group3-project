import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donation_model.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class DonationDetailsPage extends StatefulWidget {
  final List<String> donationInfo;

  const DonationDetailsPage({super.key, required this.donationInfo});

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
              infoItem('Donor Username', widget.donationInfo[0]),
              infoItem('Donation Category', widget.donationInfo[3]),
              infoItem('Type of Delivery', widget.donationInfo[4]),
              infoItem('Weight', widget.donationInfo[5]),
              infoItem('Date', widget.donationInfo[6]),
              infoItem('Address', widget.donationInfo[7]),
              infoItem('Contact Number', widget.donationInfo[8]),
              infoItem('Status', widget.donationInfo[9]),
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

}