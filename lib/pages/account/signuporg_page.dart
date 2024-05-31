import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/providers/user_provider.dart';
import 'package:week9_authentication/widgets/muladdress_signup_input.dart';
import '../../providers/auth_provider.dart';
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
  List<String> addresses = [];
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.purple.shade400,
              Colors.purple.shade500,
              Colors.purple.shade600,
              Colors.purple.shade700,
            ])),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appIcon,
                  heading,
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      children: [
                        nameField,
                        emailField,
                        passwordField,
                        addressField,
                        contactNumberField,
                        descriptionField,
                        uploadImageButton(context),
                        submitButton,
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget get appIcon => const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Icon(
        Icons.handshake_rounded,
        color: Colors.white,
        size: 60,
      ));

  Widget get heading => const Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Text(
          "Sign Up as Organization",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(18),
            fillColor: Color.fromRGBO(50, 50, 50, 1),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(50, 50, 50, 1),
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.purple, style: BorderStyle.solid, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.redAccent, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.purple, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(18),
              fillColor: Color.fromRGBO(50, 50, 50, 1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(18),
              fillColor: Color.fromRGBO(50, 50, 50, 1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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

  Widget get addressField => MultipleAddressSignUpInput(
        onChanged: (List<String> addresses) {
          setState(() {
            this.addresses = addresses;
          });
        },
      );

  Widget get contactNumberField => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(18),
            fillColor: Color.fromRGBO(50, 50, 50, 1),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(50, 50, 50, 1),
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.purple, style: BorderStyle.solid, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.redAccent, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.purple, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(18),
              fillColor: Color.fromRGBO(50, 50, 50, 1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(50, 50, 50, 1),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.purple, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      child: const Text("Upload Proof/s of Legitimacy",
                          style: TextStyle(color: Colors.purpleAccent))),
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
                  //  uploadImagePopUp(context);
                  uploadImageContainer(context);
                },
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.purpleAccent,
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
                        style: TextStyle(color: Colors.purpleAccent))),
                TextButton(
                    onPressed: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: const Text("From gallery",
                        style: TextStyle(color: Colors.purpleAccent))),
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
              title: const Text("Proof/s of Legitimacy"),
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
                        style: TextStyle(color: Colors.purpleAccent)))
              ],
            ),
          ));

  Widget get submitButton => Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: FilledButton(
          style: FilledButton.styleFrom(
              minimumSize: const Size(300, 55), backgroundColor: Colors.purple),
          onPressed: () async {
            setState(() {
              submitClicked = true;
            });

            if (_formKey.currentState!.validate() && imageFile.isNotEmpty) {
              _formKey.currentState!.save();

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
                orgSignUpPrompt(context);
              }
            }
          },
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )));

  orgSignUpPrompt(context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text("Registration Status"),
          content: Text(
              "Thank you for showing interest in supporting us, $name! Please give us time to approve your registration."),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      if (mounted) {
                        await _uploadPhotoToStorage();

                        await context
                            .read<UserAuthProvider>()
                            .authService
                            .signUp(name!, "", email!, password!);

                        User user = User(
                            type: "organization",
                            username: email!,
                            name: name,
                            address: addresses,
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

                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "I Understand",
                      style: TextStyle(color: Colors.purpleAccent),
                    )),
              ],
            )
          ],
        ),
      );
}
