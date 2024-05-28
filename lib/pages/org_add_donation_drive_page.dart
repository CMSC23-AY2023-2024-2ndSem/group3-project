import 'package:flutter/material.dart';
import 'package:week9_authentication/models/donationdrive_model.dart';

class AddDonationDrivePage extends StatefulWidget {
  const AddDonationDrivePage({super.key});

  @override
  State<AddDonationDrivePage> createState() => _AddDonationDrivePageState();
}

class _AddDonationDrivePageState extends State<AddDonationDrivePage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  bool submitClicked = false;

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
                children: [heading, nameField, descriptionField, submitButton],
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
          ),
          onSaved: (value) => setState(() => name = value),
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
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => setState(() => description = value),
            validator: (value) {
              if (value!.length > 200) {
                return "Please enter no more than 200 characters";
              }
              return null;
            }),
      );


  Widget get submitButton => ElevatedButton(
    onPressed: () {}, child: const Text("submit"),
  );
}
