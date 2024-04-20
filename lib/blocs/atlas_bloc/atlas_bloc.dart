import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/atlas_model.dart';
import '../../repositories/atlas_repository.dart';

part 'atlas_event.dart';
part 'atlas_state.dart';

class AtlasBloc extends Bloc<AtlasEvent, AtlasState> {
  final AtlasApiProvider _atlasApiProvider = AtlasApiProvider();

  AtlasBloc() : super(AtlasInitialState());

  @override
  Stream<AtlasState> mapEventToState(AtlasEvent event) async* {
    if (event is FetchAtlasListEvent) {
      yield AtlasLoadingState();

      try {
        final List<AtlasModel> atlasList =
            await _atlasApiProvider.getAtlasList();
        yield AtlasLoadedState(atlasList: atlasList);
      } catch (e) {
        yield AtlasErrorState(error: "Failed to load atlas list");
      }
    }
  }
}
