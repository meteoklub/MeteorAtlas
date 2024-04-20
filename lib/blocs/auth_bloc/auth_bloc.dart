import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/blocs/auth_bloc/auth_event.dart';

import '../../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthState()) {
    on<SignInEvent>(_mapSignInToState);
    on<SignUpEvent>(_mapSignUpToState);
    on<LogOut>(_mapLogOutState);
  }

  Future<void> _mapSignInToState(
      SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    User? user = await _authRepository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );

    if (user != null) {
      emit(AuthAuthenticatedState(user: user));
    } else {
      emit(AuthErrorState(error: "Failed to sign in"));
    }
  }

  Future<void> _mapLogOutState(LogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    await _authRepository.signOut().then((value) {
      emit(AuthState(user: null));
    });
  }

  Future<void> _mapSignUpToState(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final regex = InputValidator.isValidEmail(event.email) &&
        InputValidator.isValidPassword(event.password);
    if (regex) {
      User? user = await _authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      }
    } else {
      emit(AuthErrorState(error: "Failed to sign up"));
    }
  }
}

class InputValidator {
  static bool isValidEmail(String email) {
    // Validace e-mailu pomocí regexu
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Validace hesla (například alespoň 8 znaků)
    return password.length >= 8;
  }
}
