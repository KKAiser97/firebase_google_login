import 'package:firebase_login/events/login_event.dart';
import 'package:firebase_login/repository/user_repository.dart';
import 'package:firebase_login/state/login_state.dart';
import 'package:firebase_login/validators/validators.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  User _user;
  LoginBloc({@required User user})
      : assert(user != null),
        _user = user,
        super(LoginState.initial());
  //Give 2 adjacent events a "debounce time" --> tạo độ trễ giữa 2 lần nhập liệu
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> event,
      TransitionFunction<LoginEvent, LoginState> transitionFunction) {
    final debounceStream = event.where((event) {
      return (event is LoginEventEmailChanged ||
          event is LoginEventPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    final nonDebounceStream = event.where((event) {
      return (event is! LoginEventEmailChanged ||
          event is! LoginEventPasswordChanged);
    });
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFunction);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEventEmailChanged) {
      yield state.cloneAndUpdate(
          isValidEmail: Validators.isValidEmail(event.email));
    } else if (event is LoginEventPasswordChanged) {
      yield state.cloneAndUpdate(
          isValidPassword: Validators.isValidPassword(event.password));
    } else if (event is LoginEventWithGooglePressed) {
      try {
        await _user.signInWithGoogle();
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    } else if (event is LoginEventWithEmailAndPasswordPressed) {
      try {
        await _user.signInWithEmailAndPassword(event.email, event.password);
        yield LoginState.success();
      } catch (_) {
        yield LoginState.failure();
      }
    }
  }
}
