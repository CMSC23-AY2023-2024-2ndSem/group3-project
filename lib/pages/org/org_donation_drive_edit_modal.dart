import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donationdrive_provider.dart';

class DonationDriveEditModal extends StatelessWidget {
  final String donationDriveUuid;
  final String donationDriveName;
  final String donationDriveDescription;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DonationDriveEditModal({Key? key, required this.donationDriveUuid, required this.donationDriveName, required this.donationDriveDescription})
      : super(key: key);

  Widget _buildContent(BuildContext context) {
    _nameController.text = donationDriveName;
    _descriptionController.text = donationDriveDescription;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Donation Drive Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Donation Drive Description',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Donation Drive"),
      content: _buildContent(context),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            final name = _nameController.text;
            final description = _descriptionController.text;

            if (name.isEmpty || description.isEmpty) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please fill in all fields"),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            if (name == donationDriveName && description == donationDriveDescription) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please change at least one field to update"),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            await context
                .read<DonationDriveProvider>()
                .updateDonationDrive(donationDriveUuid, name, description);
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Donation updated successfully"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text("Submit"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
          ),
        ),
        TextButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
