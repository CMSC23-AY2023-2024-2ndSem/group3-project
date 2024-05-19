import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/signin_page.dart';
import 'package:week9_authentication/providers/user_provider.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUpOrgPage extends StatefulWidget {
  const SignUpOrgPage({super.key});

  @override
  State<SignUpOrgPage> createState() => _SignUpOrgState();
}

class _SignUpOrgState extends State<SignUpOrgPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? password;
  String? address;
  String? contactNumber;
  String? description;
  List<XFile> imageFile = [];
  List<String> imageFileUrl = [];
  List<String> imageUrl = [];
  bool submitClicked = false;

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
              'proofoflegitimacy_photos/${email!}_${i}_${DateTime.now()}.jpg');
      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(imageFile[i].path));

      uploadTask.whenComplete(() async {
        imageUrl.add(await ref.getDownloadURL());
        print('Image URL: ${imageUrl[i]}');
      });

      await uploadTask.whenComplete(() => print('Photo uploaded'));
    }
  }

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
                children: [
                  heading,
                  nameField,
                  emailField,
                  passwordField,
                  addressField,
                  contactNumberField,
                  descriptionField,
                  uploadImageButton(context),
                  submitButton
                ],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Organization Name"),
            hintText: "Enter your organization name",
          ),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your organization name";
            }

            return null;
          },
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "Enter a valid email"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !value.contains("@") ||
                !value.contains(".")) {
              return "Please enter a valid email format";
            }

            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "At least 8 characters"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            } else if (value.length < 8) {
              return "Password must be at least 8 characters";
            }
            return null;
          },
        ),
      );

  Widget get addressField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Address"),
            hintText: "Enter your address",
          ),
          onSaved: (value) => setState(() => address = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your address";
            }

            return null;
          },
        ),
      );

  Widget get contactNumberField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Contact No."),
            hintText: "Enter your contact number",
          ),
          onSaved: (value) => setState(() => contactNumber = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your contact number";
            } else if (int.tryParse(value) == null) {
              return "Please enter numbers only";
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
              label: Text("Organization description"),
              hintText: "About you",
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

  Widget uploadImageButton(context) => Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                if (!(imageFileUrl.isEmpty && submitClicked) ||
                    imageFileUrl.isNotEmpty && !submitClicked)
                  ElevatedButton(
                      onPressed: () {
                        uploadImagePopUp(context);
                      },
                      child: const Text("Upload Proof/s of Legitimacy")),
                if (imageFileUrl.isEmpty && submitClicked)
                  ElevatedButton(
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
            ElevatedButton(
                onPressed: () {
                  //  uploadImagePopUp(context);
                  uploadImageContainer(context);
                },
                child: const Icon(Icons.image_outlined))
          ],
        ),
      );

  uploadImagePopUp(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Upload options"),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      _takePhoto();
                      Navigator.pop(context);
                    },
                    child: const Text("Take a photo")),
                TextButton(
                    onPressed: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: const Text("Choose from gallery")),
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
              title: const Text("Proof/s of Legitimacy"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Confirm"))
              ],
            ),
          ));

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        setState(() {
          submitClicked = true;
        });

        if (_formKey.currentState!.validate() && imageFile.isNotEmpty) {
          _formKey.currentState!.save();

          await _uploadPhotoToStorage();
          print(imageUrl);

          bool emailExists = await context
              .read<UserAuthProvider>()
              .authService
              .checkEmailExists(email!);
          if (emailExists) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Email already exists"),
            ));
            return;
          }
          if (mounted) {
            await context
                .read<UserAuthProvider>()
                .authService
                .signUp(name!, "", email!, password!);
          }

          if (mounted) {
            User user = User(
                type: "organization",
                username: email!,
                name: name,
                address: address!,
                contactNumber: contactNumber!,
                status: false,
                donations: [],
                proofs: imageUrl,
                openForDonation: true,
                orgDescription: description);
            await context
                .read<UserProvider>()
                .firebaseService
                .addUsertoDB(user.toJson());
          }

          // orgSignUpPrompt(context);

          // check if the widget hasn't been disposed of after an asynchronous action
          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: const Text("Continue"));

  orgSignUpPrompt(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Upload options"),
          content: const Text(
              "Thank you for showing interest in helping the community! Please give us time to approve your registration."),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                    },
                    child: const Text("I Understand")),
              ],
            )
          ],
        ),
      );
}
