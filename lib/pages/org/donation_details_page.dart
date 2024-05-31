import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/donation_provider.dart';

class DonationDetailsPage extends StatefulWidget {
  final List<String> donationInfo;

  const DonationDetailsPage({super.key, required this.donationInfo});

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().fetchDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream =
        context.watch<DonationProvider>().donations;

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

          String deliveryType = "";

          if (widget.donationInfo[4] == "true") {
            deliveryType = "Pick up";
          } else if (widget.donationInfo[4] == "false") {
            deliveryType = "Drop off";
          }

          if (deliveryType == "Drop off") {
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoItem('Donor Username', widget.donationInfo[0]),
                infoItem('Donation Drive:', widget.donationInfo[2]),
                infoItem('Donation Category', widget.donationInfo[3]),
                infoItem('Type of Delivery', deliveryType),
                infoItem('Weight (Kg)', widget.donationInfo[5]),
                infoItem('Date', widget.donationInfo[6]),
                // infoItem('Address', widget.donationInfo[7]),
                // infoItem('Contact Number', widget.donationInfo[8]),
                infoItem('Status', widget.donationInfo[9]),
                donationPhoto()
              ],
            ));
          } else {
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoItem('Donor Username', widget.donationInfo[0]),
                infoItem('Donation Drive:', widget.donationInfo[2]),
                infoItem('Donation Category', widget.donationInfo[3]),
                infoItem('Type of Delivery', deliveryType),
                infoItem('Weight (Kg)', widget.donationInfo[5]),
                infoItem('Date', widget.donationInfo[6]),
                infoItem('Address', widget.donationInfo[7]),
                infoItem('Contact Number', widget.donationInfo[8]),
                infoItem('Status', widget.donationInfo[9]),
                donationPhoto()
              ],
            ));
          }
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

  Widget donationPhoto() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          if (widget.donationInfo[10].isNotEmpty)
          const Row(
            children: [
              Text(
                "Donation Photo",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (widget.donationInfo[10].isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(15),
                  child: Image.network(
                    widget.donationInfo[10],
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
