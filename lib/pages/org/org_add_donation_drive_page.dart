import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:week9_authentication/models/donationdrive_model.dart';
import 'package:week9_authentication/pages/org/org_donation_drives_page.dart';
import 'package:week9_authentication/providers/donationdrive_provider.dart';
import 'package:week9_authentication/providers/user_provider.dart';

class AddDonationDrivePage extends StatefulWidget {
  final String organizationUname;

  const AddDonationDrivePage({super.key, required this.organizationUname});

  @override
  State<AddDonationDrivePage> createState() => _AddDonationDrivePageState();
}

class _AddDonationDrivePageState extends State<AddDonationDrivePage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String description = "";
  bool addClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
            margin: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [heading, nameField, descriptionField, addButton],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Add Donation Drive/Charity",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Donation Drive/Charity Name"),
            hintText: "Enter Donation Drive/Charity name",
            floatingLabelStyle: TextStyle(color: Colors.orangeAccent),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent)
            )
          ),
          onSaved: (value) => setState(() => name = value!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter Donation Drive/Charity name";
            }

            return null;
          },
        ),
      );

  Widget get descriptionField => Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Donation Drive/Charity description"),
              hintText: "About Donation Drive/Charity",
              floatingLabelStyle: TextStyle(color: Colors.orangeAccent),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orangeAccent)
              )
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => setState(() => description = value!),
            validator: (value) {
              if (value!.length > 200) {
                return "Please enter no more than 200 characters";
              }
              return null;
            }),
      );


  Widget get addButton => ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        String uuid = const Uuid().v4();
        DonationDrive donationDrive = DonationDrive(
          uid: uuid, 
          name: name, 
          description: description, 
          organizationUname: widget.organizationUname, 
          donations: [], 
          isOpen: true,
        );
        
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm New Donation Drive"),
              content: const Text("Are sure you want to add this donation drive?"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    context.read<DonationDriveProvider>().addDonationDrives(donationDrive);
                    context.read<UserProvider>().addDonationDriveToUser(uuid, widget.organizationUname);
                    Navigator.popUntil(context, (route) => route is MaterialPageRoute && route.builder(context) is OrganizationDonationDrivesPage);
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
          },
        );
      }
    }, 
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.orangeAccent,
    ),
    child: const Text("add"),
  );
}
