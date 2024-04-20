import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

abstract class MapState {}

class MapInitialState extends MapState {}

class MapPositionUpdatedState extends MapState {
  final LatLng newPosition;

  MapPositionUpdatedState(this.newPosition);
}

class MapErrorState extends MapState {
  final String error;

  MapErrorState(this.error);
}

abstract class MapEvent {}

class SetMapPositionEvent extends MapEvent {
  final LatLng newPosition;

  SetMapPositionEvent(this.newPosition);
}

class MapCubit extends Cubit<MapState> {
  late AnimatedMapController _mapController;

  MapCubit() : super(MapInitialState());

  set mapController(AnimatedMapController? controller) {
    _mapController = controller ?? _mapController;
  }

  AnimatedMapController? get mapControllerValue => _mapController;

  void setMapPosition(LatLng newPosition) {
    if (mapControllerValue != null) {
      _mapController.move(
        newPosition,
        10.0,
      ); // Adjust zoom level as needed
      emit(MapPositionUpdatedState(newPosition));
    } else {
      emit(MapErrorState("Map controller is not initialized."));
    }
  }
}
