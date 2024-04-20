import 'package:equatable/equatable.dart';

import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:meteoapp/repositories/forecast_api_provider.dart';
import '../../../domain/models/location_model.dart';
import '../../repositories/user_repository.dart';
import '../../src/pages/map_page/location_repository.dart';
import 'location_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'location_event.dart';

class LocationBloc extends HydratedBloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<RequestLocationPermission>(_mapRequestLocationPermissionToState);
    on<UpdateLocation>(getLocationProps);
    on<DeleteLocationAtIndex>(removeIndex);
    on<RenameLocationIndex>(renameLocation);
    on<SearchUserLocation>(searchLocation);
  }

  final _repo = LocationRepository.instance;
  final _forecastRepo = ForecastApiProvider();
  List<LocationWithAddress> visitedLocations = [];

  Future<void> searchLocation(
    SearchUserLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      var results = await _repo.getCoordinatesFromAddress(event.address);
      emit((state as LocationDetailsLoaded).copyWith());
    } catch (e) {
      // Zde můžete zpracovat chyby, pokud se vyskytnou
      emit(LocationNameFetchFailed(e.toString()));
    }
  }

  @override
  LocationState? fromJson(Map<String, dynamic> json) {
    try {
      final visitedLocationsJson = json['visitedLocations'] as List<dynamic>;
      visitedLocations = visitedLocationsJson
          .map((e) => LocationWithAddress.fromJson(e as Map<String, dynamic>))
          .toList();
      return LocationDetailsLoaded(
        WeatherModel(
          [], // Provide your default values here
          [],
          '',
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(LocationState state) {
    if (state is LocationDetailsLoaded) {
      return {
        'visitedLocations': visitedLocations.map((e) => e.toJson()).toList(),
      };
    }
    return null;
  }

  void renameLocation(
    RenameLocationIndex event,
    Emitter<LocationState> emit,
  ) {
    final List<LocationWithAddress> updatedLocations =
        List.of(visitedLocations);
    final LocationWithAddress location = visitedLocations[event.index];
    final LocationWithAddress updatedLocation =
        location.copyWith(title: event.titleIndex);
    updatedLocations[event.index] = updatedLocation;
    visitedLocations = updatedLocations;
    emit((state as LocationDetailsLoaded)
        .copyWith(visitedLocations: updatedLocations));
  }

  void removeIndex(
    DeleteLocationAtIndex event,
    Emitter<LocationState> emit,
  ) {
    visitedLocations.removeAt(event.index);
    emit((state as LocationDetailsLoaded)
        .copyWith(visitedLocations: visitedLocations));
  }

  Future<void> _mapRequestLocationPermissionToState(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    LocationPermissionStatus permissionStatus = await _repo.requestPermission();

    UserRepository().setLocationPermissionGranted(
        permissionStatus == LocationPermissionStatus.granted);

    emit(LocationInitial());
  }

  Future<void> getLocationProps(
    UpdateLocation event,
    Emitter<LocationState> emit,
  ) async {
    final dailyForecast = await _forecastRepo.getDailyForecast(
      event.location.latitude,
      event.location.longitude,
    );
    final hourlyForecast = await _forecastRepo.getHourlyForecast(
      event.location.latitude,
      event.location.longitude,
    );
    List<Placemark> placemarks = await geo.placemarkFromCoordinates(
        event.location.latitude, event.location.longitude,
        localeIdentifier: "en");
    if (placemarks.isNotEmpty &&
        hourlyForecast.isNotEmpty &&
        dailyForecast.isNotEmpty) {
      Placemark place = placemarks[0];
      if (!visitedLocations.any((location) =>
          location.latitude == event.location.latitude &&
          location.longitude == event.location.longitude)) {
        visitedLocations.add(LocationWithAddress(
          latitude: event.location.latitude,
          longitude: event.location.longitude,
          address: getPlace(place),
          index: visitedLocations.length.toString(),
        ));
      } else {}
      emit(LocationDetailsLoaded(
          WeatherModel(
            hourlyForecast,
            dailyForecast,
            getPlace(place),
          ),
          visitedLocations: visitedLocations));
    }
  }

  void addVisitedPlace(LocationWithAddress place) {
    visitedLocations.add(place);
  }

  // Metoda pro získání seznamu navštívených míst
  List<LocationWithAddress> getVisitedPlaces() {
    return visitedLocations;
  }

  String getPlace(Placemark? place) {
    String? buffer, country, city, street;
    if (place?.isoCountryCode?.isNotEmpty ?? false) {
      country = (place!.isoCountryCode!);
    }
    if (place?.administrativeArea?.isNotEmpty ?? false) {
      city = (place!.administrativeArea!);
    }
    if (place?.subAdministrativeArea?.isNotEmpty ?? false) {
      street = (place!.subAdministrativeArea!);
    }
    buffer = (('$country, ') + (('$city, ')) + (street ?? ''));
    return buffer;
  }
}
