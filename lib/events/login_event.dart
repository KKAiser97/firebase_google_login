import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEventEmailChanged extends LoginEvent {
  final String email;

  LoginEventEmailChanged({this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'Email changed: $email';
}

class LoginEventPasswordChanged extends LoginEvent {
  final String password;

  LoginEventPasswordChanged({this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'Email changed: $password';
}

//press 'Sign in with Google'
class LoginEventWithGooglePressed extends LoginEvent {}

class LoginEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;
  LoginEventWithEmailAndPasswordPressed({this.email, this.password});
  @override
  List<Object> get props => [email, password];
  @override
  String toString() =>
      'LoginEventWithEmailAndPasswordPressed, email = $email, password =$password';
}
