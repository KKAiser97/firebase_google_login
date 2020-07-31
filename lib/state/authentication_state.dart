import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {
  final FirebaseUser firebaseUser;
  AuthenticationStateSuccess({this.firebaseUser});
  @override
  List<Object> get props => [firebaseUser];
  @override
  String toString() =>
      'AuthenticationStateSuccess, email: ${firebaseUser.email}';
}

class AuthenticationStateFailure extends AuthenticationState {}
