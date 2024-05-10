import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/organization_provider.dart';
import '../widgets/DonationItemCategoryCheckBox.dart';
import '../widgets/DateTimePicker.dart';
import '../widgets/AddressInput.dart';

class DonatePage extends StatefulWidget {
  final String organizationName;

  DonatePage({required this.organizationName});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> donationCategories = {};
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool pickupOrDropOff = true;
  String weight = "";
  List<String> addresses = [];
  String contactNumber = "";
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
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                DonationItemCategoryCheckBox(
                  onChanged: (Map<String, bool> categories) {
                    setState(() {
                      donationCategories = categories;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(children: [
                    pickupOrDropOffSwitch,
                  weightInputField,
                ],),
                const SizedBox(height: 20),
                DateTimePicker(
                  onChanged: (DateTime, TimeOfDay) {
                    setState(() {
                      selectedDate = DateTime;
                      selectedTime = TimeOfDay;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (pickupOrDropOff)
                  MultipleAddressInput(
                    onChanged: (List<String> addresses) {
                      setState(() {
                        this.addresses = addresses;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                if(pickupOrDropOff)
                    Row(children: [
                      contactNumberField,
                    ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  submitButton,
                  cancelButton,
                ],),
              ],
                  ),
                ),
              ),
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
            print(pickupOrDropOff);
            print(weight);
            print(selectedDate);
            print(selectedTime);
            print(addresses);
            print(contactNumber);
          }
        },
        child: const Text("Submit"),
      );
  
  Widget get cancelButton => ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Cancel"),
      );

  Widget get pickupOrDropOffSwitch => Row(
        children: [
          const Text("Pickup or Drop-off"),
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
          
          onSaved: (value) => setState(() => weight = value!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the weight of the items";
            }

            return null;
          },
        ),
      );

    Widget get contactNumberField => Expanded(
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Contact Number"),
            hintText: "Enter your contact number",
          ),
          onSaved: (value) => setState(() => contactNumber = value!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your contact number";
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
