import 'dart:convert';

class Organization {
  final String organizationUname;

  Organization({
    required this.organizationUname,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      organizationUname: json['organizationUname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationUname': organizationUname,
    };
  }

  static Organization fromMap(Map<String, dynamic> data) {
    return Organization(
      organizationUname: data['organizationUname']
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }
}