import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/donationdrive_model.dart';
import 'package:week9_authentication/providers/donationdrive_provider.dart';
import 'package:week9_authentication/providers/user_provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class DonationDriveDeleteModal extends StatelessWidget {
  final DonationDrive donationDrive;
  final String username;

  const DonationDriveDeleteModal({super.key, required this.donationDrive, required this.username});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Donation Drive: "),
      content: const Text("Are sure you want to delete this donation drive?"),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read<DonationDriveProvider>().deleteDonationDrive(donationDrive.uid);
            context.read<UserProvider>().deleteDonationDriveToUser(donationDrive.uid, username);
            context.read<DonationProvider>().removeLinktoDonations(donationDrive.uid);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
          ),
          child: const Text("Confirm"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
