import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/providers/donation_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';


class CompletionPage extends StatefulWidget {
  final String donationUid;
  final String donorUname;
  final String driveUid;
  final String driveName;
  const CompletionPage({super.key, required this.donationUid, required this.donorUname, required this.driveUid, required this.driveName});

  @override
  State<CompletionPage> createState() => _CompletionPageState();
}

class _CompletionPageState extends State<CompletionPage> {
  List<XFile> imageFile = [];
  List<String> imageFileUrl = [];
  List<String> imageUrl = [];
  bool submitClicked = false;
  String donorContactNumber = "";

  @override
  void initState() {
    super.initState();
    _fetchDonorContactNumber();
  }

  Future<void> _fetchDonorContactNumber() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: widget.donorUname)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          donorContactNumber = doc['contactNumber'];
        });
      });
    });
  }


  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFilePick = await picker.pickImage(source: ImageSource.camera);
    if (imageFilePick != null) {
      setState(() {
        imageFile.add(imageFilePick);
        imageFileUrl.add(imageFilePick.name);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFilePick = await picker.pickImage(source: ImageSource.gallery);
    if (imageFilePick != null) {
      setState(() {
        imageFile.add(imageFilePick);
        imageFileUrl.add(imageFilePick.name);
      });
    }
  }

  Future<void> _uploadPhotoToStorage() async {
    if (imageFile.isEmpty) {
      return;
    }

    for (int i = 0; i < imageFile.length; i++) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'sent_proof/${widget.donationUid}_${i}_${DateTime.now()}.jpg');
      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(imageFile[i].path));

      var url = uploadTask.whenComplete(() async {
        imageUrl.add(await ref.getDownloadURL());
      });

    await url.whenComplete(() => setState(() {
        imageUrl = imageUrl;
      }));
    }
  }

  Future<void> _sendSMS(String message, List<String> recipents) async {
  String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
          .catchError((onError) {
          return "Error: ${onError.toString()}";
      });
  print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
            children: [
              Text("Completing Donation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               ],
          ),
          backgroundColor: Colors.amber,
        ),
      body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      
                      children: [
                        const Text("Upload proof of where the donation ended up to complete donation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sending an SMS to\nDonor's Contact Number: ${donorContactNumber}",
                              textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        uploadImageButton(context),
                        submitButton,
                      ],
                    ),
                  )
                ],
              ),
            )
    );
  }

  Widget uploadImageButton(context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                if (!(imageFileUrl.isEmpty && submitClicked) ||
                    imageFileUrl.isNotEmpty && !submitClicked)
                  FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(50, 50, 50, 1)),
                      onPressed: () {
                        uploadImagePopUp(context);
                      },
                      child: const Text("Upload Proof/s",
                          style: TextStyle(color: Colors.amber))),
                if (imageFileUrl.isEmpty && submitClicked)
                  FilledButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 180, 139, 138))),
                      onPressed: () {
                        uploadImagePopUp(context);
                      },
                      child: const Text(
                        "Upload Proof/s of Legitimacy",
                        style: TextStyle(color: Colors.white),
                      )),
                if (imageFileUrl.isEmpty && submitClicked)
                  const Text("Please upload proof of legitimacy",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 180, 139, 138)))
              ],
            ),
            FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(50, 50, 50, 1)),
                onPressed: () {
                  uploadImageContainer(context);
                },
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.amber,
                ))
          ],
        ),
      );

  uploadImagePopUp(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text("Upload options"),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      _takePhoto();
                      Navigator.pop(context);
                    },
                    child: const Text("Take a photo",
                        style: TextStyle(color: Colors.amber))),
                TextButton(
                    onPressed: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: const Text("From gallery",
                        style: TextStyle(color: Colors.amber))),
              ],
            )
          ],
        ),
      );

  uploadImageContainer(context) => showDialog(
      context: context,
      builder: (context) => LayoutBuilder(
            builder: (context, constraints) => AlertDialog(
              scrollable: true,
              backgroundColor: Colors.grey.shade900,
              title: const Text("Proof/s"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imageFile.isNotEmpty)
                    SizedBox(
                      height: constraints.maxHeight * 0.2,
                      width: constraints.maxWidth * 0.9,
                      child: ListView.builder(
                          itemCount: imageFileUrl.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.folder_copy_rounded),
                              title: Text(imageFileUrl[index],
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            content: SizedBox(
                                          height: 250,
                                          child: Image.file(
                                            File(imageFile[index].path),
                                            height: 200,
                                          ),
                                        )));
                              },
                            );
                          }),
                    ),
                  if (imageFile.isEmpty)
                    SizedBox(
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.9,
                        child: const Center(
                          child: Text(
                            "No photos uploaded yet.",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Confirm",
                        style: TextStyle(color: Colors.amber)))
              ],
            ),
          ));

  Widget get submitButton => Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: FilledButton(
          style: FilledButton.styleFrom(
              minimumSize: const Size(300, 55), backgroundColor: Colors.amber),
          onPressed: () async {
            setState(() {
              submitClicked = true;
            });

            if (imageFile.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Completing donation... Please wait."),
                  duration: Duration(seconds: 6),
                ),
              );


              await _uploadPhotoToStorage();


              String message = "Your donation has been fully completed.\nYour donation has been sent to ${widget.driveName}\nThank you for your donation!\nYou can see where your donations ended up here:\n";
              for (int i = 0; i < imageUrl.length; i++) {
              message += "${imageUrl[i]}\n";
              }
              List<String> recipents = [donorContactNumber];

              

              var status = await Permission.sms.status;
              if (!status.isGranted) {
                status = await Permission.sms.request();
              }

              if (status.isGranted) {
                await _sendSMS(message, recipents);
                
                await context.read<DonationProvider>().updateStatus(widget.donationUid, "Completed");

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Donation Completed, SMS sent to donor!"),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("SMS permission not granted"),
                    duration: Duration(seconds: 5),
                  ),
                );
              }

            }
          },
          child: const Text(
            "Complete Donation",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )));

  
}