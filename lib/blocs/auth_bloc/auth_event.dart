abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final bool checkPassword;
  SignUpEvent(
      {this.checkPassword = false,
      required this.email,
      required this.password});
}

class LogOut extends AuthEvent {}
