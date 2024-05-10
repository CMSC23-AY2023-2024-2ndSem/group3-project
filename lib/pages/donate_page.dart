// from the donor home page, the user can click an organization and go to this page, it will be a form that will be filled out by the user to "donate"

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/organization_provider.dart';
import '../widgets/DonationItemCategoryCheckBox .dart';

class DonatePage extends StatefulWidget {
  final String organizationName;

  DonatePage({required this.organizationName});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> donationCategories = {};
  bool pickupOrDropOff = true;
  int weight = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to ${widget.organizationName}"),
      ),
      body:StreamBuilder<DocumentSnapshot>(
        stream: context.watch<OrganizationProvider>().getOrganizationByName(widget.organizationName).map(
              (querySnapshot) => querySnapshot.docs.first,
            ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                DonationItemCategoryCheckBox(
                  onChanged: (Map<String, bool> categories) {
                    setState(() {
                      donationCategories = categories;
                    });
                  },
                ),
                Row(children: [
                    pickupOrDropOffSwitch,
                  weightInputField,
                ],),
                submitButton
                
              ],
            ),
          );
        },
      )
    );
  }

  Widget get submitButton => ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            print(donationCategories);
          }
        },
        child: const Text("Submit"),
      );


  // make widget for Select if the items are for pickup or drop-off (switch class) and Weight of items to donate in kg/lbs (num input)
  Widget get pickupOrDropOffSwitch => Row(
        children: [
          Text("Pickup or Drop-off"),
          Switch(
            value: pickupOrDropOff,
            onChanged: (value) {
              setState(() {
                pickupOrDropOff = value;
              });
            },
          ),
        ],
      );
    
  Widget get weightInputField => Expanded(
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Weight of items (kg)"),
            hintText: "Weight in kg",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the weight of the items";
            }

            return null;
          },
        ),
      );
  
  // Widget get heading => const Padding(
  //       padding: EdgeInsets.only(bottom: 30),
  //       child: Text(
  //         "Donate",
  //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  //       ),
  //     );

  // Widget get firstNameField => Padding(
  //   padding: const EdgeInsets.only(bottom: 30),
  //   child: TextFormField(
  //     decoration: const InputDecoration(
  //       border: OutlineInputBorder(),
  //       label: Text("First Name"),
  //       hintText: "Enter your first name",
  //     ),
  //     onSaved: (value) => setState(() => firstName = value),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return "Please enter your first name";
  //       }

  //       return null;
  //     },
  //   ),
  // );


}
