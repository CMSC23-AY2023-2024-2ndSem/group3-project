import 'package:flutter/material.dart';
import 'package:week9_authentication/pages/account/signup_page.dart';
import 'package:week9_authentication/pages/account/signuporg_page.dart';

class SignUpOptionPage extends StatefulWidget {
  const SignUpOptionPage({super.key});

  @override
  State<SignUpOptionPage> createState() => _SignUpOptionState();
}

class _SignUpOptionState extends State<SignUpOptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [heading, donorSignUp, orgSignUp],
          ),
        ),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign up as...",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      );

  Widget get donorSignUp => Padding(
        padding: const EdgeInsets.only(top: 80),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
            child: const Text(
              "Donor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      );

  Widget get orgSignUp => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpOrgPage()));
            },
            child: const Text(
              "Organization",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      );
}
