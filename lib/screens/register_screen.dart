import 'package:firebase_login/blocs/authentication_bloc.dart';
import 'package:firebase_login/blocs/register_bloc.dart';
import 'package:firebase_login/events/authentication_event.dart';
import 'package:firebase_login/events/register_event.dart';
import 'package:firebase_login/repository/user_repository.dart';
import 'package:firebase_login/state/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'buttons/register_button.dart';

class RegisterScreen extends StatefulWidget {
  final User _user;
  RegisterScreen({Key key, @required User user})
      : assert(user != null),
        _user = user,
        super(key: key);

  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  User get _user => widget._user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isValidEmailAndPassword && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(user: _user),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, registerState) {
              if (registerState.isFailure) {
                print('Registration Failed');
              } else if (registerState.isSubmitting) {
                print('Registration in progress...');
              } else if (registerState.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationEventLoggedIn());
              }
              return Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) {
                          return !registerState.isValidEmail
                              ? 'Invalid Email'
                              : null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) {
                          return !registerState.isValidPassword
                              ? 'Invalid Password'
                              : null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      RegisterButton(onPressed: () {
                        if (isRegisterButtonEnabled(registerState)) {
                          _registerBloc.add(
                            RegisterEventPressed(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
