import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/donation_provider.dart';


class DonateQrPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> donationInfo = ModalRoute.of(context)!.settings.arguments as List<String>;
    final String donationId = donationInfo[0];
    final String donorOrgUname = donationInfo[1];

    Future<bool> onWillPop() async {
      showDialog(context: context, builder: 

              (BuildContext context) {
                return AlertDialog(
                  title: const Text("Are you sure you want to go back?\n Make sure to take a screenshot of the QR!"),
                  actions: [
                    TextButton(
                      onPressed: () {

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);

                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                  ],
                );
              },
            
            );
      return false; 
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: deprecated_member_use
      ModalRoute.of(context)!.addScopedWillPopCallback(onWillPop);
    });
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(context: context, builder: 

              (BuildContext context) {
                return AlertDialog(
                  title: const Text("Are you sure you want to go back?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                  ],
                );
              },
            
            );
          },
        ),
        title:const Text("Scan QR Code"),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: context
              .watch<DonationProvider>()
              .fetchDonationDetailsByUid(donationId)
              .map(
                (querySnapshot) => querySnapshot.docs.first,
              ),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {

            return const Center(child: Text("No data found!"));
          }
          var donationData = snapshot.data!.data() as Map<String, dynamic>;
          bool isScanned = false;
          if (donationData['status'] == "Confirmed"){
            isScanned = true;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text(donorOrgUname, style: const TextStyle(color: Colors.amber, fontSize: 20)), 
               const Text(" must scan qr code to complete!", style: TextStyle(fontSize: 20)),
               const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrImageView(
                      data: donationId,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                const SizedBox(height: 20),
                if(!isScanned)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(onPressed: 
                () {  
                  showDialog(context: context, builder: 
                    (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Are you sure you want to cancel donation?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<DonationProvider>().updateStatus(donationId, "Canceled");

                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Donation has been canceled!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                        ],
                      );
                    },
                  
                  );
                }, child: const Text("Cancel the Donation", style: TextStyle(color: Colors.cyan))),
                ],),
                const SizedBox(height: 20),
                if (isScanned) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "The QR Code has been scanned!",
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}

