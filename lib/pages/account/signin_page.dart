import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/pages/account/signup_page.dart';
import '../../providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heading,
                  appIcon,
                  description,
                  emailField,
                  passwordField,
                  showSignInErrorMessage ? signInErrorMessage : Container(),
                  submitButton,
                  signUpButton
                ],
              ),
            )),
      ),
    );
  }

  Widget get heading => Padding(
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(150, 255, 255, 255),
                    Color.fromARGB(210, 255, 255, 255),
                    Colors.white,
                  ]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: const Text(
                " EL",
                style: TextStyle(
                    height: 1.3,
                    letterSpacing: 1,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            ),
            Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.purple.shade700,
                      Colors.purple.shade500,
                      Colors.purple.shade300
                    ]),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: const Text(
                  "Gives ",
                  style: TextStyle(
                      height: 1.3,
                      letterSpacing: 1,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
          ],
        ),
      );

  Widget get appIcon => const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Icon(
        Icons.handshake_rounded,
        size: 80,
      ));

  Widget get description => const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "Your partner in helping the community",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ));

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(top: 40),
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
              hintText: "juandelacruz09@gmail.com"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(top: 10),
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
              hintText: "******"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            }
            return null;
          },
        ),
      );

  Widget get signInErrorMessage => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Invalid email or password",
          style: TextStyle(color: Colors.red),
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
                String? message = await context
                    .read<UserAuthProvider>()
                    .authService
                    .signIn(email!, password!);

                setState(() {
                  if (message != null && message.isNotEmpty) {
                    showSignInErrorMessage = true;
                  } else {
                    showSignInErrorMessage = false;
                  }
                });
              }
            },
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
      );

  Widget get signUpButton => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No account yet?",
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.purpleAccent),
                ))
          ],
        ),
      );
}
