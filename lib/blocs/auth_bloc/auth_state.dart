import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? user;
  final String? error;

  AuthState({this.user, this.error});
}

class AuthLoadingState extends AuthState {
  final bool isLoading;
  AuthLoadingState({this.isLoading = true});
}

class AuthAuthenticatedState extends AuthState {
  @override
  final User user;

  AuthAuthenticatedState({required this.user});
}

class AuthErrorState extends AuthState {
  @override
  final String error;

  AuthErrorState({required this.error});
}
