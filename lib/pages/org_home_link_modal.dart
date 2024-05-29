
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class LinkModal extends StatelessWidget {
  final String donationUid;
  final Map<String,String> donationDrives;
  final String donationCurrentDrive;
  final TextEditingController _formFieldController = TextEditingController();

  LinkModal({super.key, required this.donationUid , required this.donationDrives, required this.donationCurrentDrive});

  Widget _buildContent(BuildContext context) {
    if(donationCurrentDrive == ""){
      return DropdownButtonFormField<String>(
      onChanged: (newValue) {
        _formFieldController.text = newValue!;
      },
      items: [
        for (var donationDrive in donationDrives.entries)
          DropdownMenuItem(
            value: donationDrive.key,
            child: Text(donationDrive.value),
          ),
      ],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
    } else {
      return DropdownButtonFormField<String>(
      value: donationCurrentDrive,
      onChanged: (newValue) {
        _formFieldController.text = newValue!;
      },
      items: [
        for (var donationDrive in donationDrives.entries)
          DropdownMenuItem(
            value: donationDrive.key,
            child: Text(donationDrive.value),
          ),
      ],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Link to a Donation Drive"),
      content: _buildContent(context),

      actions: <Widget>[
        TextButton(
          onPressed: () {

            if (_formFieldController.text.isEmpty) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a valid Donation Drive"),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            context
                  .read<DonationProvider>()
                  .linkDonation(donationUid, _formFieldController.text);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Donation Linked Successfully"),
                  duration: Duration(seconds: 2),
                ),
              );
              
          },
          child: const Text("Submit")
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
