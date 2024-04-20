part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationPermissionGrantedState extends NotificationState {}

class NotificationReceivedState extends NotificationState {
  final String title;
  final String body;

  NotificationReceivedState({required this.title, required this.body});
}
