part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestLocationPermission extends LocationEvent {}

class GetLocationName extends LocationEvent {
  GetLocationName();

  @override
  List<Object> get props => [];
}

class UpdateLocation extends LocationEvent {
  final LatLng location;

  UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class DeleteLocationAtIndex extends LocationEvent {
  final int index;

  DeleteLocationAtIndex(this.index);

  @override
  List<Object> get props => [index];
}

class SearchUserLocation extends LocationEvent {
  final String address;

  SearchUserLocation(this.address);

  @override
  List<Object> get props => [address];
}

class RenameLocationIndex extends LocationEvent {
  final String titleIndex;
  final int index;
  RenameLocationIndex(this.titleIndex, this.index);

  @override
  List<Object> get props => [titleIndex];
}
