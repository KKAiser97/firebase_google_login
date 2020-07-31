import 'package:firebase_login/events/authentication_event.dart';
import 'package:firebase_login/repository/user_repository.dart';
import 'package:firebase_login/state/authentication_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({AuthenticationState initialState, @required User user})
      : assert(user != null),
        _user = user,
        super(AuthenticationStateInitial());
  final User _user;
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationEventStarted) {
      final isSignedIn = await _user.isSignedIn();
      if (isSignedIn) {
        final firebaseUser = await _user.getUser();
        yield AuthenticationStateSuccess(firebaseUser: firebaseUser);
      } else {
        yield AuthenticationStateFailure();
      }
    } else if (event is AuthenticationEventLoggedIn) {
      yield AuthenticationStateSuccess(firebaseUser: await _user.getUser());
    } else if (event is AuthenticationEventLoggedOut) {
      _user.signOut();
      yield AuthenticationStateFailure();
    }
  }
}
