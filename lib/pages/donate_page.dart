import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/organization_provider.dart';
import '../widgets/DonationItemCategoryCheckBox.dart';
import '../widgets/DateTimePicker.dart';
import '../widgets/AddressInput.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../providers/donation_provider.dart';
import '../models/donation_model.dart';

class DonatePage extends StatefulWidget {
  final String organizationName;

  const DonatePage({super.key, required this.organizationName});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {

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
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }
  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
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

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('donation_photos/${DateTime.now()}.jpg');
    firebase_storage.UploadTask uploadTask = ref.putFile(File(_imageFile!.path));

    uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
      print('Image URL: $imageUrl');
    });

    await uploadTask.whenComplete(() => print('Photo uploaded'));
  }

  Future<void> generateQRCode() async {
    setState(() {
      qrData = "";
    });
  }


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
                      checkBoxes,
                      weightInputField,
                      photoButtons,
                      if (_imageFile != null) imageHolder,
                      if (_imageFile != null) submitPhotoButton,
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
      )
    );
  }
  
  Widget get resolveButtons => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              Donation donation = Donation(
                donationCategories: donationCategories,
                date: selectedDate,
                time: selectedTime,
                weight: weight,
                imageUrl: imageUrl, // not required
                pickupOrDropOff: pickupOrDropOff,
                addresses: addresses, // not required
                contactNumber: contactNumber, // not required
                qrData: qrData, // ????   not required
                organization: widget.organizationName,
              );
              context.read<DonationProvider>().addDonation(donation);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Donation submitted!"),
                ),
              );
              Navigator.pop(context);

            }
          },
          child: const Text("Submit"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
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
              ),
              
              onSaved: (value) => setState(() => weight = value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the weight of the items";
                }

                return null;
              },
            ),
          )
      ],));

  
  Widget get photoButtons => Padding(padding: 
    const EdgeInsets.only(bottom: 30),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _takePhoto,
          child: const Text("Take Photo"),
        ),
        ElevatedButton(
          onPressed: _pickImageFromGallery,
          child: const Text("Upload from Gallery"),
        ),
      ],
    ));

  Widget get submitPhotoButton => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: _uploadPhotoToStorage,
        child: const Text("Send to Storage"),
      ),
  ],)
  );

  Widget get imageHolder => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(children: [
      Expanded(
        child: Image.file(
                File(_imageFile!.path),
                height: 200,
              ),
      )
    ],));

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
              const Text("Pickup",
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
    
  Widget get addressInput => 
    MultipleAddressInput(
      onChanged: (List<String> addresses) {
        setState(() {
          this.addresses = addresses;
        });
      },
    );

  Widget get contactNumberField => Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(children: [
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

                  return null;
                },
              ),
            )
          ],)
    );
  
  Widget get qrCode => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: 
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),);
  
  Widget get dateTimePickerW => 
  DateTimePicker(
                onChanged: (dateTime, timeOfDay) {
                  setState(() {
                    selectedDate = dateTime;
                    selectedTime = timeOfDay;
                  });
                },
              );
  
  Widget get checkBoxes =>
  DonationItemCategoryCheckBox(
                  onChanged: (Map<String, bool> categories) {
                    setState(() {
                      donationCategories = categories;
                    });
                  },
                );


}
