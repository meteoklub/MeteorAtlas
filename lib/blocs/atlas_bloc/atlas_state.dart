part of 'atlas_bloc.dart';

class AtlasState extends Equatable {
  const AtlasState();

  @override
  List<Object> get props => [];
}

class AtlasInitialState extends AtlasState {}

class AtlasLoadingState extends AtlasState {}

class AtlasLoadedState extends AtlasState {
  final List<AtlasModel> atlasList;

  const AtlasLoadedState({required this.atlasList});

  @override
  List<Object> get props => [atlasList];
}

class AtlasErrorState extends AtlasState {
  final String error;

  const AtlasErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
