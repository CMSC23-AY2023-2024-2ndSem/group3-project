import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';
import '../../models/donation_model.dart';
import 'donation_details_page.dart';
import 'org_completion_page.dart';
import 'org_home_edit_modal.dart';

class DonationDriveDetailsPage extends StatefulWidget {
  final List donationDriveInfo;

  const DonationDriveDetailsPage({super.key, required this.donationDriveInfo});

  @override
  State<DonationDriveDetailsPage> createState() => _DonationDriveDetailsPageState();
}

class _DonationDriveDetailsPageState extends State<DonationDriveDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donationsStream = context.watch<DonationProvider>().donations;
    
    return Scaffold(
      appBar: AppBar( 
        title: Text("${widget.donationDriveInfo[0]}"),
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



          final donations = 
              snapshot.data!.docs.map((doc) => Donation.fromDocument(doc)).toList();
              List donationsForDrive = donations.where((donation) => donation.donationDriveUid == widget.donationDriveInfo[4]).toList();

             if(donationsForDrive.isEmpty){
                 return Center(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text(
                   "No Donations Found!\n\nStart Linking Donations in your Home Page.",
                   textAlign: TextAlign.center,
                 ),
                  const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Go to Home Page'),
                )],)
                 );
             }else{
              return ListView.builder(
              itemCount: donationsForDrive.length,
              itemBuilder: (context, index) {
                final donation = donationsForDrive[index];

                var donationCategories = donation.donationCategories.entries
                        .where((element) => element.value == true)
                        .map((e) => e.key)
                        .toList();

                    var date = donation.date.toString().split(" ")[0];
                    var time = donation.date.toString().split(" ")[1].split(".")[0];
                    var dateTime = "$date $time";
                    var donorName = donation.donorUname.split("@")[0];

                List<String> donationInfo = [
                      donation.donorUname,
                      donation.organizationUname,
                      widget.donationDriveInfo[0],
                      donationCategories.join(", "),
                      donation.pickupOrDropOff.toString(),
                      donation.weight,
                      dateTime,
                      donation.addresses!.join(" "),
                      donation.contactNumber.toString(),
                      donation.status,
                      donation.imageUrl!,
                    ];

                return Card(
                  color: Colors.grey.shade900,
                                margin: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Donation from ${donorName}"),
                    subtitle: Text("Status: ${donation.status}"),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                                icon: const Icon(Icons.edit,
                                color: Colors.orangeAccent),
                                onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => EditModal(
                                  donationUid: donation.uid,
                                  donationStatus: donation.status,
                                  ),
                                );
                                },
                              ),
                        IconButton(
                                icon: const Icon(Icons.check,
                                color: Colors.amber),
                                onPressed: () {
                                  if(donation.status != "Completed"){
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompletionPage(
                                        donationUid: donation.uid,
                                        donorUname: donation.donorUname,
                                        driveUid: widget.donationDriveInfo[4], 
                                        driveName: widget.donationDriveInfo[0],
                                      ),
                                    ),
                                  );
                                  }else if(donation.status == "Completed"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Donation already completed"),
                                      ),
                                    );
                                  }else if(donation.status == "Cancelled"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Donation already cancelled"),
                                      ),
                                    );
                                  }else if(donation.status == "Pending"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Donation is still pending"),
                                      ),
                                    );
                                  } 
                                },
                              ),
                              ],),
                    onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DonationDetailsPage(donationInfo: donationInfo),));
                            },
                  ),
                ));
              },
            );
             }
        },
      ),
    );
  }

}