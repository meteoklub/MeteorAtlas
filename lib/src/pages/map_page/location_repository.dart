import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/models/location_model.dart';

class LocationRepository {
  final Location _location;
  final _locationKey = 'location_key'; // Unique key for caching

  // Privátní konstruktor pro zabránění vytváření více instancí třídy
  LocationRepository._({Location? location})
      : _location = location ?? Location();

  // Statická instance třídy
  static final LocationRepository _instance = LocationRepository._();

  // Metoda pro přístup k instanci třídy
  static LocationRepository get instance => _instance;

  Future<bool> isLocationServiceEnabled() async {
    return await _location.serviceEnabled();
  }

  Future<LocationPermissionStatus> requestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return LocationPermissionStatus.serviceDisabled;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return LocationPermissionStatus.permissionDenied;
      }
    }

    return LocationPermissionStatus.granted;
  }

  Future<void> saveLocationToPrefs(MyLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', location.latitude!);
    prefs.setDouble('longitude', location.longitude!);
  }

  Future<MyLocation?> loadLocationFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      return MyLocation(latitude, longitude);
    }

    return null;
  }

  Future<LocationWithAddress?> getLocationWithAddress() async {
    try {
      final LocationData locationData = await _location.getLocation();
      final List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        final geo.Placemark place = placemarks[0];
        final String address =
            '${place.locality}, ${place.subAdministrativeArea}';
        final MyLocation currentLocation =
            MyLocation(locationData.latitude, locationData.longitude);

        await saveLocationToPrefs(currentLocation);

        return LocationWithAddress(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          address: address,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting location with address: $e');
      return null;
    }
  }

  Future<MyLocation?> getCoordinatesFromAddress(String address) async {
    try {
      final List<geo.Location> locations =
          await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final geo.Location location = locations[0];
        return MyLocation(location.latitude, location.longitude);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting coordinates from address: $e');
      return null;
    }
  }

  Future<MyLocation?> getLocation() async {
    MyLocation? cachedLocation = await loadLocationFromPrefs();

    if (cachedLocation != null) {
      return cachedLocation;
    }

    final LocationData? locationData = await _location.getLocation();
    if (locationData != null) {
      final MyLocation currentLocation =
          MyLocation(locationData.latitude, locationData.longitude);
      await saveLocationToPrefs(currentLocation)
          .then((value) => currentLocation);
    }
  }
}

enum LocationPermissionStatus {
  granted,
  permissionDenied,
  serviceDisabled,
}
