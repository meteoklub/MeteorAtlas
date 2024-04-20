import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBuilderBloc extends Bloc<HomeEvent, PageState> {
  PageBuilderBloc() : super(const PageStateChanged(0)) {
    on<ChangePage>(
        (event, emit) => emit(PageStateChanged(actualPage = event.index)));
  }
  var actualPage = 0;
}
