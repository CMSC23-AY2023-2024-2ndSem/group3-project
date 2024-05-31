import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week9_authentication/models/user_model.dart';
import 'package:week9_authentication/pages/admin/admin_donor_details_page.dart';
import 'package:week9_authentication/providers/user_provider.dart';

class AdminDonorsPage extends StatefulWidget {
  const AdminDonorsPage({super.key});

  @override
  State<AdminDonorsPage> createState() => _AdminDonorsPageState();
}

class _AdminDonorsPageState extends State<AdminDonorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
        .collection("users")
        .where("type", isEqualTo: "donor")
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Donors",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Donors Found"),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Column(
                  children: [
                    pageBar(),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Icon(Icons.person_off_rounded,
                            size: 200,
                            color: Color.fromARGB(50, 255, 255, 255))),
                    const Text("No Donors Found",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ));
              }

              return Column(
                children: [
                  pageBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        User donor = User.fromJson(snapshot.data?.docs[index]
                            .data() as Map<String, dynamic>);
                        // String? userID = snapshot.data?.docs[index].reference.id;
                        return Card(
                            color: Colors.grey.shade900,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  donor.name!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminDonorDetailsPage(
                                                  donor: donor)));
                                },
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              );
            }));
  }

  Widget pageBar() {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      color: Colors.grey.shade900,
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Donor Directory",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
