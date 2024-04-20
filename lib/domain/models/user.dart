import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class UserData {
  final User? user;
  final String name;
  final Location location;
  final bool locationPermissionGranted; // Přidána informace o povolení lokace
  final String? username;
  final List<String>? favoriteLocations;

  UserData({
    required this.name,
    required this.location,
    required this.locationPermissionGranted,
    this.user,
    this.username,
    this.favoriteLocations,
  });

  UserData copyWith({
    User? user,
    String? name,
    Location? location,
    bool? locationPermissionGranted,
    String? username,
    List<String>? favoriteLocations,
  }) {
    return UserData(
      user: user ?? this.user,
      name: name ?? this.name,
      location: location ?? this.location,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      username: username ?? this.username,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      location: json['location'],
      locationPermissionGranted: json['locationPermissionGranted'],
      username: json['username'],
      favoriteLocations: List<String>.from(json['favoriteLocations'] ?? []),
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'locationPermissionGranted': locationPermissionGranted,
      'username': username,
      'favoriteLocations': favoriteLocations,
      'user': user,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory UserData.fromJsonString(String jsonString) {
    return UserData.fromJson(jsonDecode(jsonString));
  }
}
