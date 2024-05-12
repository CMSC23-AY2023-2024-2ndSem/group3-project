import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';



class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}


class UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
            final user = users.firstWhere((user) => user.name == user!.name);
            return Column(
              children: [
                ListTile(
                  title: Text("Email: ${user.name}"),
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
