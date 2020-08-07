import 'package:firebase_login/blocs/authentication_bloc.dart';
import 'package:firebase_login/events/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is HomePage'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedOut());
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'HomePage',
          style: TextStyle(fontSize: 22, color: Colors.green),
        ),
      ),
    );
  }
}
