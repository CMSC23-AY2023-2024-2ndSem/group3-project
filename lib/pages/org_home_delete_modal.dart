import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class DeleteModal extends StatelessWidget {
  final String donationUid;

  DeleteModal({Key? key, required this.donationUid});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Confirmation"),
      content: Text("Are you sure you want to delete this donation?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.read<DonationProvider>().deleteDonation(donationUid);
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Donation deleted successfully"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
