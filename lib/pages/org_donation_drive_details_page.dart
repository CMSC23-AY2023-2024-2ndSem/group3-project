import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donationdrive_provider.dart';

class DonationDriveDetailsPage extends StatefulWidget {
  final List donationDriveInfo;

  const DonationDriveDetailsPage({super.key, required this.donationDriveInfo});

  @override
  State<DonationDriveDetailsPage> createState() => _DonationDriveDetailsPageState();
}

class _DonationDriveDetailsPageState extends State<DonationDriveDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream = context.watch<DonationDriveProvider>().donationdrives;
    
    return Scaffold(
      appBar: AppBar( 
        title: const Text("Donation Details"),
        backgroundColor: Colors.orangeAccent,
      ),
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
            return SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoItem('Donation Drive/Charity Name', widget.donationDriveInfo[0]),
                infoItem('Description', widget.donationDriveInfo[1]),
                infoItem('Organization', widget.donationDriveInfo[2]),
                infoItem('Status', widget.donationDriveInfo[3]),
              ],
            )
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