part of 'notification_bloc.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class InitializeNotificationEvent extends NotificationEvent {}

class RequestPermissionEvent extends NotificationEvent {}

class OnMessageReceivedEvent extends NotificationEvent {
  final RemoteMessage message;

  const OnMessageReceivedEvent(this.message);
}
