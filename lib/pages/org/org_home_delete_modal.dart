import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

import '../../providers/user_provider.dart';

class DeleteModal extends StatelessWidget {
  final String donationUid;
  final String donationDonorUname;
  final String donationOrgUname;

  DeleteModal({Key? key, required this.donationUid, required this.donationDonorUname, required this.donationOrgUname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Confirmation"),
      content: Text("Are you sure you want to delete this donation?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.read<DonationProvider>().deleteDonation(donationUid);
            context.read<UserProvider>().deleteDonationToUser(donationUid, donationDonorUname);
            context.read<UserProvider>().deleteDonationToUser(donationUid, donationOrgUname);
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
