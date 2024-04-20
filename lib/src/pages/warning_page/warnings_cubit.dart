import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../../domain/models/warnings.dart';
import '../../../repositories/warnings_repo.dart';

abstract class WarningState {}

class WarningInitialState extends WarningState {}

class WarningLoadingState extends WarningState {}

class LongWarningLoadedState extends WarningState {
  final List<LongWarning> warnings;

  LongWarningLoadedState(this.warnings);
}

class GetWarningById extends WarningState {
  final int warningId;

  GetWarningById(this.warningId);
}

class WarningsRegionLoaded extends WarningState {
  final List<LongWarning> warnings;
  final List<String> places;
  WarningsRegionLoaded(this.warnings, this.places);
}

class WarningErrorState extends WarningState {
  final String error;

  WarningErrorState(this.error);
}

// Události cubitu
abstract class WarningEvent {}

class LoadWarningEvent extends WarningEvent {}

class WarningDetailsLoadedState extends WarningState {
  final LongWarning warningDetails;

  WarningDetailsLoadedState(this.warningDetails);
}

class WarningCubit extends Cubit<WarningState> {
  final WarningRepository warningRepository;

  WarningCubit({required this.warningRepository})
      : super(WarningInitialState());
  List<LongWarning> longWarnings = [];
  List<String> places = [];

  Future<String> _getLocationName(Geopoint? coords) async {
    try {
      if (coords != null) {
        List<Placemark> placemarks = await geo.placemarkFromCoordinates(
            coords.lat, coords.lon,
            localeIdentifier: "en");
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          return '${place.locality}, ${place.subAdministrativeArea}';
        }
      }
      return 'No location found';
    } catch (e) {
      throw Exception('Failed to get location name: $e');
    }
  }

  Future<void> loadShortWarnings() async {
    final warningDetails = await warningRepository.getAllWarnings();
    if (warningDetails.isEmpty) {
      emit(WarningErrorState('Failed to load warning details for warning ID'));
      return;
    }
    for (var element in warningDetails) {
      if (element.region.isNotEmpty) {
        places.add(await _getLocationName(element.region.first));
      } else {
        break;
      }
    }
    emit(WarningsRegionLoaded(warningDetails, places));
  }

  Future<LongWarning?> _getWarningDetailsById(String id) async {
    return await warningRepository.getWarningDetailsById(id);
  }
}
