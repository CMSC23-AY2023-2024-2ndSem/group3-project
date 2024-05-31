import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/account/signuporg_page.dart';
import 'package:week9_authentication/providers/user_provider.dart';
import '../../providers/auth_provider.dart';

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
  List<String> addresses = [];
  String? contactNumber;

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
            // margin: const EdgeInsets.all(30),
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
                        firstNameField,
                        lastNameField,
                        emailField,
                        passwordField,
                        addressField,
                        contactNumberField,
                        submitButton,
                        orgSignUp,
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
          "Sign Up as Donor",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );

  Widget get firstNameField => Padding(
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
            label: Text("First Name"),
            hintText: "Enter your first name",
          ),
          onSaved: (value) => setState(() => firstName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your first name";
            } else if (!RegExp(r"^[a-zA-Z\s\'-]+$").hasMatch(value)){
              return "Please enter a valid name format";
            }

            return null;
          },
        ),
      );

  Widget get lastNameField => Padding(
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
            label: Text("Last Name"),
            hintText: "Enter your last name",
          ),
          onSaved: (value) => setState(() => lastName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your last name";
            } else if (!RegExp(r"^[a-zA-Z\s\'-]+$").hasMatch(value)) {
              return "Please enter a valid name format";
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

  Widget get addressField => Padding(
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
            label: Text("Address"),
            hintText: "Enter your address",
          ),
          onSaved: (value) => setState(() => addresses.add(value!)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your address";
            }

            return null;
          },
        ),
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
            hintText: "09XXXXXXXXX",
          ),
          onSaved: (value) => setState(() => contactNumber = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your contact number";
            } else if (int.tryParse(value) == null) {
              return "Please enter numbers only";
            } else if (value.length != 11 || value.substring(0, 2) != "09") {
              return "Please enter valid contact number";
            }

            return null;
          },
        ),
      );

  Widget get submitButton => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size(300, 55),
                backgroundColor: Colors.purple),
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
                      address: addresses,
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
                }
              }
            },
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
      );

  Widget get orgSignUp => Padding(
        padding: const EdgeInsets.only(top: 30),
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
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Text(
                      "Join as an Organization",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent),
                    ),
                  )),
            ],
          ),
        ),
      );
}
