import 'dart:convert';
import 'package:flutter/material.dart';

class Donation {
  final Map<String, bool> donationCategories;
  final DateTime date;
  final TimeOfDay time;
  final bool pickupOrDropOff;
  final String weight;
  final List<String>? addresses;
  final String? contactNumber;
  final String? qrData;
  final String? imageUrl;
  final String? organization; 

  Donation({
    required this.donationCategories,
    required this.date,
    required this.time,
    required this.pickupOrDropOff,
    required this.weight,
    this.addresses,
    this.contactNumber,
    this.qrData,
    this.imageUrl,
    required this.organization,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationCategories: (json['donationCategories'] as Map).cast<String, bool>(),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(hour: json['time']['hour'], minute: json['time']['minute']),
      pickupOrDropOff: json['pickupOrDropOff'],
      weight: json['weight'],
      addresses: List<String>.from(json['addresses']),
      contactNumber: json['contactNumber'],
      qrData: json['qrData'],
      imageUrl: json['imageUrl'],
      organization: json['organization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donationCategories': donationCategories,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'pickupOrDropOff': pickupOrDropOff,
      'weight': weight,
      'addresses': addresses,
      'contactNumber': contactNumber,
      'qrData': qrData,
      'imageUrl': imageUrl,
      'organization': organization,
    };
  }

  static Donation fromMap(Map<String, dynamic> data) {
    return Donation(
      donationCategories: (data['donationCategories'] as Map).cast<String, bool>(),
      date: DateTime.parse(data['date']),
      time: TimeOfDay(hour: data['time']['hour'], minute: data['time']['minute']),
      pickupOrDropOff: data['pickupOrDropOff'],
      weight: data['weight'],
      addresses: List<String>.from(data['addresses']),
      contactNumber: data['contactNumber'],
      qrData: data['qrData'],
      imageUrl: data['imageUrl'], 
      organization: data['organization'],
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }
}
