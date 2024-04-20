part of 'page_builder_bloc.dart';

abstract class PageState extends Equatable {
  const PageState();
}

class PageStateChanged extends PageState {
  final int page;

  const PageStateChanged(this.page);
  @override
  List<Object?> get props => [page];
}
