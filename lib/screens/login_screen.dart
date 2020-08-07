import 'package:firebase_login/blocs/authentication_bloc.dart';
import 'package:firebase_login/blocs/login_bloc.dart';
import 'package:firebase_login/blocs/register_bloc.dart';
import 'package:firebase_login/events/authentication_event.dart';
import 'package:firebase_login/events/login_event.dart';
import 'package:firebase_login/repository/user_repository.dart';
import 'package:firebase_login/screens/buttons/google_login_button.dart';
import 'package:firebase_login/screens/buttons/login_button.dart';
import 'package:firebase_login/screens/buttons/register_button.dart';
import 'package:firebase_login/screens/register_screen.dart';
import 'package:firebase_login/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class LoginScreen extends StatefulWidget {
  final User _user;

  const LoginScreen({Key key, @required User user})
      : assert(user != null),
        _user = user,
        super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  User get _user => widget._user; //get _user from StatefulWidget LoginScreen
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      //when email is changed,this function is called !
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      //when password is changed,this function is called !
      _loginBloc
          .add(LoginEventPasswordChanged(password: _passwordController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated &&
      !loginState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
        if (loginState.isFailure) {
          print("Login failed");
        } else if (loginState.isSubmitting) {
          print("Logging in");
        } else if (loginState.isSuccess) {
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
                      icon: Icon(Icons.email), labelText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return loginState.isValidEmail
                        ? null
                        : 'Invalid email format';
                  }),
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Enter password'),
                  obscureText: true,
                  autovalidate: true,
                  autocorrect: false,
                  validator: (_) {
                    return loginState.isValidEmail
                        ? null
                        : 'Invalid password format';
                  }),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(loginState)
                              ? _onLoginEmailAndPassword
                              : null, //check is enabled ?
                        ),
                        RegisterButton(
                          onPressed: _onRegister,
                        ),
                        GoogleLoginButton()
                      ]))
            ],
          )),
        );
      }),
    );
  }

  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  void _onRegister() {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => RegisterScreen(user: _user)));onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(user: _user),
          child: RegisterScreen(user: _user));
    }));
  }
}
