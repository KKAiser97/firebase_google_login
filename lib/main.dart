import 'package:firebase_login/blocs/authentication_bloc.dart';
import 'package:firebase_login/events/authentication_event.dart';
import 'package:firebase_login/screens/home_screen.dart';
import 'package:firebase_login/screens/login_screen.dart';
import 'package:firebase_login/screens/splash_screen.dart';
import 'package:firebase_login/state/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './repository/user_repository.dart';
import 'blocs/bloc_logger.dart';
import 'blocs/login_bloc.dart';

void main() {
  // final user = User();
  // user.createUserWithEmailAndPassword('abcdef@gmail.com', '123456');
  // WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = BlocLogger();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _user = User();
    return MaterialApp(
        title: 'Firebase Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
          create: (context)
              // {
              //   final authenticationBloc = AuthenticationBloc(user: _user);
              //   authenticationBloc.add(AuthenticationEventStarted());
              //   return authenticationBloc;
              // }
              =>
              AuthenticationBloc(user: _user)
                ..add(AuthenticationEventStarted()),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, authState) {
            if (authState is AuthenticationStateSuccess) {
              return HomeScreen();
            } else if (authState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(user: _user),
                  child: LoginScreen(user: _user) //LoginPage,
                  );
            }
            return SplashScreen();
          }),
        ));
  }
}
