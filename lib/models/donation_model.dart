import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Donation {
  final String uid;
  final Map<String, bool> donationCategories;
  final DateTime date;
  final TimeOfDay time;
  final bool pickupOrDropOff;
  final String weight;
  final List<String>? addresses;
  final String? contactNumber;
  final String? qrData;
  final String? imageUrl;
  final String donorUname;
  final String organizationUname; 
  late String donationDriveName;
  late String status;

  Donation({
    required this.uid,
    required this.donationCategories,
    required this.date,
    required this.time,
    required this.pickupOrDropOff,
    required this.weight,
    this.addresses,
    this.contactNumber,
    this.qrData,
    this.imageUrl,
    required this.donorUname,
    required this.organizationUname,
    required this.donationDriveName,
    required this.status,

  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      uid: json['uid'],
      donationCategories: (json['donationCategories'] as Map).cast<String, bool>(),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: json['time']['hour'], minute: json['time']['minute']),
      pickupOrDropOff: json['pickupOrDropOff'],
      weight: json['weight'],
      addresses: List<String>.from(json['addresses']),
      contactNumber: json['contactNumber'],
      qrData: json['qrData'],
      imageUrl: json['imageUrl'],
      donorUname: json['donorUname'],
      organizationUname: json['organizationUname'],
      donationDriveName: json['donationDriveName'],
      status: json['status'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'donationCategories': donationCategories,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'pickupOrDropOff': pickupOrDropOff,
      'weight': weight,
      'addresses': addresses,
      'contactNumber': contactNumber,
      'qrData': qrData,
      'imageUrl': imageUrl,
      'donorUname': donorUname,
      'organizationUname': organizationUname,
      'donationDriveName': donationDriveName,
      'status': status,
    };
  }

  static Donation fromMap(Map<String, dynamic> data) {
    return Donation(
      uid: data['uid'],
      donationCategories: (data['donationCategories'] as Map).cast<String, bool>(),
      date: DateTime.parse(data['date']),
      time: TimeOfDay(hour: data['time']['hour'], minute: data['time']['minute']),
      pickupOrDropOff: data['pickupOrDropOff'],
      weight: data['weight'],
      addresses: List<String>.from(data['addresses']),
      contactNumber: data['contactNumber'],
      qrData: data['qrData'],
      imageUrl: data['imageUrl'], 
      donorUname: data['donorUname'],
      organizationUname: data['organizationUname'],
      donationDriveName: data['donationDriveName'],
      status: data['status'],
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  static fromDocument(QueryDocumentSnapshot<Object?> doc) {
    return Donation(
      uid: doc['uid'],
      donationCategories: (doc['donationCategories'] as Map).cast<String, bool>(),
      date: DateTime.parse(doc['date']),
      time: TimeOfDay(hour: doc['time']['hour'], minute: doc['time']['minute']),
      pickupOrDropOff: doc['pickupOrDropOff'],
      weight: doc['weight'],
      addresses: List<String>.from(doc['addresses']),
      contactNumber: doc['contactNumber'],
      qrData: doc['qrData'],
      imageUrl: doc['imageUrl'],
      donorUname: doc['donorUname'],
      organizationUname: doc['organizationUname'],
      donationDriveName: doc['donationDriveName'],
      status: doc['status'],
    );
    
  }
}
