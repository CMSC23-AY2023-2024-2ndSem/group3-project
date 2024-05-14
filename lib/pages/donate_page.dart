import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';
import '../widgets/donation_checkbox.dart';
import '../widgets/datetime_picker.dart';
import '../widgets/address_input.dart';
import '../providers/donation_provider.dart';
import '../models/donation_model.dart';

class DonatePage extends StatefulWidget {
  final List<String> donorOrgInfo;

  const DonatePage({super.key, required this.donorOrgInfo});

  @override
  DonatePageState createState() => DonatePageState();
}

class DonatePageState extends State<DonatePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> donationCategories = {};
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool pickupOrDropOff = false;
  String weight = "";
  List<String> addresses = [];
  String contactNumber = "";
  String qrData = "";
  XFile? _imageFile;
  String imageUrl = "";


  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Future<void> _uploadPhotoToStorage() async {
    if (_imageFile == null) {
      return;
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('donation_photos/${DateTime.now()}.jpg');
    firebase_storage.UploadTask uploadTask =
        ref.putFile(File(_imageFile!.path));

    uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
      print('Image URL: $imageUrl');
    });

    await uploadTask.whenComplete(() => print('Photo uploaded'));
  }


  // TODO: Make QR Code work
  Future<void> generateQRCode() async {
    setState(() {
      qrData = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Donate to ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(widget.donorOrgInfo[2], style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.cyan,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: context
              .watch<UserProvider>()
              .fetchUserDetailsByUsername(widget.donorOrgInfo[1])
              .map(
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  margin: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        checkBoxes,
                        weightInputField,
                        photoButtons,
                        if (_imageFile != null) imageHolder,
                        pickupOrDropOffSwitch,
                        dateTimePickerW,
                        if (pickupOrDropOff) addressInput,
                        if (pickupOrDropOff) contactNumberField,
                        resolveButtons,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget get resolveButtons => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (donationCategories.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one category"),
                    ),
                  );
                  return;
                }

                if(pickupOrDropOff){
                  if(addresses.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter at least one address"),
                      ),
                    );
                    return;
                  }
                }
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (_imageFile != null) {
                    await _uploadPhotoToStorage();
                  }

                  String uuid = const Uuid().v4();
                  Donation donation = Donation(
                      uid: uuid,
                      donationCategories: donationCategories,
                      date: selectedDate,
                      time: selectedTime,
                      weight: weight,
                      imageUrl: imageUrl, // not required
                      pickupOrDropOff: pickupOrDropOff,
                      addresses: addresses, // not required
                      contactNumber: contactNumber, // not required
                      organizationUname: widget.donorOrgInfo[1],
                      donorUname: widget.donorOrgInfo[0],
                      status: "Pending");

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Donation"),
                        content: const Text("Are you sure you want to submit this donation?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if(!pickupOrDropOff){
                                final result = await showDialog<String>(context: context, builder: 
                                (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      textAlign: TextAlign.center,
                                      "${widget.donorOrgInfo[2]} has to Scan QR Code",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    content: SizedBox( 
                                        width: 275, 
                                        height: 275, 
                                        child: qrCode,
                                      ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, "Cancel");
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                });

                                if (result == "Success") { // TODO: Not working as intended
                                  print("QR Code Scanned");
                                  donation.status = "Completed";
                                  print("Dropoff Donation Completed");
                                  context.read<DonationProvider>().addDonation(donation);
                                  context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[0]);
                                  context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[1]);
                                } 
                                else if (result == "Cancel"){
                                  print(result);
                                }
                              }else{
                                print("Pickup Donation Completed");
                                context.read<DonationProvider>().addDonation(donation);
                                context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[0]);
                                context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[1]);
                                Navigator.pop(context);
                              }

                              Navigator.pop(context);
                            
                            },
                            child: const Text("Submit"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Submit"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(context: context, 
                builder: 
                (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cancel Donation"),
                    content: const Text("Are you sure you want to cancel this donation?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
                      ),
                    ],
                  );
                });
              },
              child: const Text("Cancel"),
            )
          ],
        ),
      );

  Widget get weightInputField => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Weight of items (kg)"),
                hintText: "Weight in kg",
                icon: Icon(Icons.scale, color: Color.fromARGB(255, 187, 134, 252)),
              ),
              onSaved: (value) => setState(() => weight = value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the weight of the items";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a valid number";
                }

                return null;
              },
            ),
          )
        ],
      ));

  Widget get photoButtons => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _takePhoto,
            child: const Text("Take Photo"),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            child: const Text("Choose from Gallery"),
          ),
        ],
      ));


  Widget get imageHolder => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: Image.file(
              File(_imageFile!.path),
              height: 200,
            ),
          )
        ],
      ));

  Widget get pickupOrDropOffSwitch => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: true,
            groupValue: pickupOrDropOff,
            onChanged: (value) {
              setState(() {
                pickupOrDropOff = value!;
              });
            },
          ),
          const Text(
            "Pickup",
            style: TextStyle(fontSize: 16),
          ),
          Radio(
            value: false,
            groupValue: pickupOrDropOff,
            onChanged: (value) {
              setState(() {
                pickupOrDropOff = value!;
              });
            },
          ),
          const Text(
            "Drop-off",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ));

  Widget get addressInput => MultipleAddressInput(
        onChanged: (List<String> addresses) {
          setState(() {
            this.addresses = addresses;
          });
        },
      );

  Widget get contactNumberField => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Expanded(
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
                if (value.length != 11) {
                  return "Number must be 11 digits long";
                }
                if (int.tryParse(value) == null) {
                  return "Please enter a valid number";
                }

                return null;
              },
            ),
          )
        ],
      ));

  Widget get qrCode => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
          backgroundColor: Colors.white,
        ),
      );

  Widget get dateTimePickerW => DateTimePicker(
        onChanged: (dateTime, timeOfDay) {
          setState(() {
            selectedDate = dateTime;
            selectedTime = timeOfDay;
          });
        },
      );

  Widget get checkBoxes => DonationItemCategoryCheckBox(
        onChanged: (Map<String, bool> categories) {
          setState(() {
            donationCategories = categories;
          });
        },
      );
}
