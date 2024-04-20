import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitialState()) {
    on<RequestPermissionEvent>(_mapRequestPermissionEventToState);
    on<InitializeNotificationEvent>(_mapInitializeNotificationEventToState);
    on<OnMessageReceivedEvent>(_mapOnMessageReceivedEventToState);
  }
  final _messaging = NotificationRepository();

  Future<void> _mapInitializeNotificationEventToState(
    InitializeNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _messaging.setupForegroundMessage();
    await _messaging.setupBackgroundMessage();
    emit(NotificationInitialState());
  }

  Future<void> _mapRequestPermissionEventToState(
    RequestPermissionEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _messaging.handleNotificationPermission();

    emit(NotificationPermissionGrantedState());
  }

  Future<RemoteMessage?> _mapOnMessageReceivedEventToState(
    OnMessageReceivedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationReceivedState(
      title: event.message.notification?.title ?? '',
      body: event.message.notification?.body ?? '',
    ));
    return event.message;
  }
}
