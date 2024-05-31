import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/pages/admin/admin_home.dart';
import 'package:week9_authentication/pages/org/org_home.dart';
import '../providers/user_provider.dart';
import 'donor/donor_home.dart';
import '../providers/auth_provider.dart';
import 'account/signin_page.dart';
import 'package:week9_authentication/models/user_model.dart' as user;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<auth.User?> authUserStream =
        context.watch<UserAuthProvider>().userStream;
    Stream<QuerySnapshot> userStream = context.read<UserProvider>().users;

    return StreamBuilder(
        stream: authUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            return const SignInPage();
          }

          final userEmail = snapshot.data!.email;

          return StreamBuilder(
              stream: userStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  final users = snapshot.data!.docs
                      .map((doc) => user.User.fromDocument(doc))
                      .toList();
                  user.User currentUser =
                      users.firstWhere((user) { return user.username == userEmail;
                      }, orElse: () => user.User(type: "donor", username: ""));

                  if (currentUser.type == "donor") {
                    return const DonorHomePage();
                  } else if (currentUser.type == "organization") {
                    return const OrganizationHomePage();
                  } else if (currentUser.type == "admin") {
                    return const AdminHomePage();
                  } else {
                    return const SignInPage();
                  }
                }
              });
        });
  }
}