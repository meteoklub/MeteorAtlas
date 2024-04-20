class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});
}

class MyLocation {
  double? latitude;
  double? longitude;

  MyLocation(this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory MyLocation.fromMap(Map<String, dynamic> map) {
    return MyLocation(
      map['latitude'] ?? 0.0,
      map['longitude'] ?? 0.0,
    );
  }
}

class LocationWithAddress {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? title;
  final String? index;

  LocationWithAddress({
    this.title,
    this.latitude,
    this.longitude,
    this.address,
    this.index,
  });

  LocationWithAddress copyWith({
    String? title,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationWithAddress(
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      index: index ?? this.index,
    );
  }

  factory LocationWithAddress.fromJson(Map<String, dynamic> json) {
    return LocationWithAddress(
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'index': index,
    };
  }
}
