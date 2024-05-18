import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/signuporg_page.dart';
import 'package:week9_authentication/providers/user_provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? address;
  String? contactNumber;

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
                  firstNameField,
                  lastNameField,
                  emailField,
                  passwordField,
                  addressField,
                  contactNumberField,
                  submitButton,
                  orgSignUp
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

  Widget get firstNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("First Name"),
            hintText: "Enter your first name",
          ),
          onSaved: (value) => setState(() => firstName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your first name";
            }

            return null;
          },
        ),
      );

  Widget get lastNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Last Name"),
            hintText: "Enter your last name",
          ),
          onSaved: (value) => setState(() => lastName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your last name";
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

  Widget get submitButton => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
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
                  await context
                      .read<UserAuthProvider>()
                      .authService
                      .signUp(firstName!, lastName!, email!, password!);
                }

                if (mounted) {
                  User user = User(
                      type: "donor",
                      username: email!,
                      name: "$firstName $lastName",
                      address: address!,
                      contactNumber: contactNumber!,
                      status: true,
                      donations: [],
                      proofs: [],
                      openForDonation: false,
                      orgDescription: "");
                  await context
                      .read<UserProvider>()
                      .firebaseService
                      .addUsertoDB(user.toJson());
                }

                // check if the widget hasn't been disposed of after an asynchronous action
                if (mounted) {
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: (context) => const SignInPage()));
                }
              }
            },
            child: const Text("Continue")),
      );

  Widget get orgSignUp => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SizedBox(
          child: Column(
            children: [
              const Text("Want to manage donations? "),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpOrgPage()));
                  },
                  child: const Text(
                    "Join as an Organization",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );
}
