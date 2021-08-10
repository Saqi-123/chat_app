import 'dart:io';

import 'package:flutter/material.dart';

class UserProfileData {
  String uid;
  String email;
  String name;
  String username;
  String image;
  String bio;
  String link;
  List<dynamic> tags;
  UserProfileData(
      {@required this.uid, @required this.email, @required this.name, @required this.image});
  UserProfileData.fromJson(Map<String, dynamic> json) {
    this.uid = json['id'];
    this.name = json['name'];
    this.email = json['email'];
    this.image = json['image_urls'];
    this.bio = json['bio'] ?? '';
    this.username = json['username'] ?? '';
    this.link = json['link'] ?? '';
    this.tags = json['tags'] ?? [];
  }
}
