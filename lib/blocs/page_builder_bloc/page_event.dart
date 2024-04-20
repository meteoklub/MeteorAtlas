part of 'page_builder_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class ChangePage extends HomeEvent {
  final int index;
  const ChangePage(this.index);
  @override
  List<Object?> get props => [];
}
