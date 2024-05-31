import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../../providers/user_provider.dart';
import '../../widgets/donation_checkbox.dart';
import '../../widgets/datetime_picker.dart';
import '../../widgets/address_input.dart';
import '../../providers/donation_provider.dart';
import '../../providers/donationdrive_provider.dart';
import '../../models/donation_model.dart';

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

  Future<void> _uploadPhotoToStorage(String donorUname, String organizationUname) async {
    if (_imageFile == null) {
      return;
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('donation_photos/${donorUname}-${organizationUname}-${DateTime.now()}.jpg');
    firebase_storage.UploadTask uploadTask =
        ref.putFile(File(_imageFile!.path));

    var url = uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
    });

    await url.whenComplete(() => setState(() {
        imageUrl = imageUrl;
        print("Photo Uploaded");
      }));
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
                 

                  String uuid = const Uuid().v4();
                    Donation donation = Donation(
                      uid: uuid,
                      donationCategories: donationCategories,
                      date: selectedDate,
                      time: selectedTime,
                      weight: weight,
                      imageUrl: imageUrl, 
                      pickupOrDropOff: pickupOrDropOff,
                      addresses: addresses, // not required
                      contactNumber: contactNumber, // not required
                      organizationUname: widget.donorOrgInfo[1],
                      donorUname: widget.donorOrgInfo[0],
                      donationDriveUid: "",
                      status: "Pending");
                  
                  if(widget.donorOrgInfo[3] != "direct"){
                    donation.donationDriveUid = widget.donorOrgInfo[3];
                  }
                  
                  if(pickupOrDropOff){
                    showDialog(context: context, 
                    builder: 
                    (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Donation"),
                        content: const Text("Are you sure you want to submit this donation?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                               if (_imageFile != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Uploading photo..."),
                                  ),
                                );
                                await _uploadPhotoToStorage(widget.donorOrgInfo[0], widget.donorOrgInfo[1]);
                                donation.imageUrl = imageUrl;
                              }
                              context.read<DonationProvider>().addDonation(donation);
                              context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[0]);
                              context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[1]);

                              if(widget.donorOrgInfo[3] != "direct")
                              {
                                context.read<DonationDriveProvider>().addDonationToDrive(uuid, widget.donorOrgInfo[2]);
                              }

                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Donation for pick-up submitted!"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            child: const Text("Yes", style: TextStyle(color: Colors.cyan)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No", style: TextStyle(color: Colors.cyan)),
                          ),
                        ],
                    );}
                    
                    );
                  
                  }else{ 
                    // drop off
                    showDialog(context: context,
                    builder: 
                    (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Donation"),
                        content: const Text("Are you sure you want to submit this donation?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_imageFile != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Uploading photo..."),
                                  ),
                                );
                                await _uploadPhotoToStorage(widget.donorOrgInfo[0], widget.donorOrgInfo[1]);
                                donation.imageUrl = imageUrl;
                                print(donation.imageUrl);
                                print(donation.imageUrl);
                                print(donation.imageUrl);
                                print(donation.imageUrl);
                              }
                              context.read<DonationProvider>().addDonation(donation);
                              context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[0]);
                              context.read<UserProvider>().addDonationToUser(uuid, widget.donorOrgInfo[1]);
                                if(widget.donorOrgInfo[3] != "direct")
                              {
                                context.read<DonationDriveProvider>().addDonationToDrive(uuid, widget.donorOrgInfo[2]);
                              }
                               var donationInfo = [uuid, widget.donorOrgInfo[2]];
                              Future.delayed(Duration(seconds: 2)
                              , () => Navigator.pushNamed(context, '/donate_qr', arguments: donationInfo)
                              
                              );

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
                    }
                    );

               
                  }
                }
              },
              child: const Text("Submit", style: TextStyle(color: Colors.cyan)),
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
              child: const Text("Cancel", style: TextStyle(color: Colors.cyan)),
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
                icon: Icon(Icons.scale, color: Colors.cyan),
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
            child: const Text("Take Photo", style: TextStyle(color: Colors.cyan)),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            child: const Text("Choose from Gallery", style: TextStyle(color: Colors.cyan)),
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
            Row(
            children: [
              Radio(
              value: true,
              groupValue: pickupOrDropOff,
              onChanged: (value) {
                setState(() {
                pickupOrDropOff = value!;
                });
              },
              activeColor: Colors.cyan,
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
              activeColor: Colors.cyan,
              ),
            ],
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
                hintText: "09XXXXXXXXX",
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
                if (!value.startsWith("09")) {
                  return "Number must start with 09";
                }

                return null;
              },
            ),
          )
        ],
      ));



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
