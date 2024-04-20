import 'package:equatable/equatable.dart';

import '../../../domain/models/location_model.dart';
import '../../domain/models/forecast_model.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionGranted extends LocationState {
  final LocationWithAddress location;
  LocationPermissionGranted(this.location);

  @override
  List<Object?> get props => [];
}

class LocationPermissionDenied extends LocationState {}

class LocationDetailsLoaded extends LocationState {
  final WeatherModel forecast;
  final List<LocationWithAddress>? visitedLocations;

  LocationDetailsLoaded(this.forecast, {this.visitedLocations});
  LocationDetailsLoaded copyWith({
    WeatherModel? forecast,
    List<LocationWithAddress>? visitedLocations,
  }) {
    return LocationDetailsLoaded(
      forecast ?? this.forecast,
      visitedLocations: visitedLocations ?? this.visitedLocations,
    );
  }

  @override
  List<Object> get props => [forecast];
}

class LocationNameFetchFailed extends LocationState {
  final String err;

  LocationNameFetchFailed(this.err);

  @override
  List<Object?> get props => [err];
}

class WeatherModel {
  final List<Forecast> hourly;
  final List<Forecast> daily;
  final String place;

  WeatherModel(this.hourly, this.daily, this.place);
}
