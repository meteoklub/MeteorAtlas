import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meteoapp/domain/models/user.dart';

class UserRepository {
  UserData _userData = UserData(
    name: '',
    location: Location(
      latitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
    ),
    user: null,
    username: null,
    favoriteLocations: null,
    locationPermissionGranted: false,
  );

  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserData get userData => _userData;

  void setUser(User? user) {
    _userData = _userData.copyWith(user: user);
  }

  void setLocation(Location location) {
    _userData = _userData.copyWith(location: location);
  }

  void setLocationPermissionGranted(bool permissionStatus) {
    _userData = _userData.copyWith(locationPermissionGranted: permissionStatus);
  }

  void setFavoriteLocations(List<String> favoriteLocations) {
    _userData = _userData.copyWith(favoriteLocations: favoriteLocations);
  }

  UserRepository._internal();
}
