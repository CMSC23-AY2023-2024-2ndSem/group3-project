import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';



class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}


class _UserDetailsPageState extends State<UserDetailsPage> {

  auth.User? user;
  @override
  Widget build(BuildContext context) {
    user = context.read<UserAuthProvider>().user as auth.User?;
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs.map((doc) => User.fromDocument(doc)).toList();
            final user = users.firstWhere((user) => user.email == user!.email);
            return Column(
              children: [
                ListTile(
                  title: Text("First Name: ${user.firstName}"),
                ),
                ListTile(
                  title: Text("Last Name: ${user.lastName}"),
                ),
                ListTile(
                  title: Text("Email: ${user.email}"),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );

  }
}
