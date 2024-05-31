
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';

class EditModal extends StatelessWidget {
  final String donationUid;
  final String donationStatus;
  final TextEditingController _formFieldController = TextEditingController();

  EditModal({super.key, required this.donationUid, required this.donationStatus});

  Widget _buildContent(BuildContext context) {
    bool isCompleted = false;
    if(donationStatus == "Completed"){
      isCompleted = true;
    }
    return DropdownButtonFormField<String>(
      value: donationStatus,
      onChanged: !isCompleted ? (newValue) {
        _formFieldController.text = newValue!;
      } : null,
      items: [
        DropdownMenuItem(
          value: 'Pending',
          child: Text('Pending'),
        ),
        DropdownMenuItem(
          value: 'Confirmed',
          child: Text('Confirmed'),
        ),
        DropdownMenuItem(
          value: 'Scheduled for Pick-up',
          child: Text('Scheduled for Pick-up'),
        ),
        DropdownMenuItem(
          value: 'Canceled',
          child: Text('Canceled'),
        ),
        DropdownMenuItem(
          value: 'Completed',
          child: Text('Completed', style: TextStyle(color: Colors.grey)),
          enabled: false,
        ),

      ],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Status"),
      content: _buildContent(context),

      actions: <Widget>[
        TextButton(
          onPressed: () {

            if (_formFieldController.text.isEmpty) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a status"),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
            
            if (_formFieldController.text == donationStatus) {
              Navigator.of(context).pop();
              return;
            }

            context
                  .read<DonationProvider>()
                  .updateStatus(donationUid, _formFieldController.text);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Donation status updated successfully"),
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
