import 'package:tanobolso/models/user.dart';
import 'package:tanobolso/screens/home.dart';
import 'package:tanobolso/screens/login.dart';
import 'package:tanobolso/screens/provider.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _permissionSelect = "";
  String _termModify = "";
  String _lastTerm = "";

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });

  }

  void loginCallback() {

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:

        if (_userId.length > 0 && _userId != null) {

          widget.auth.getCurrentUserModel(_userId).then((result){
            User user =  User.fromJson(result.data);
            setState(() {
              _termModify = user.termModify;
              _permissionSelect = user.permissionSelect;
            });
          }).catchError((e)=> print("error fetching data: $e"));


           if(_permissionSelect == "Prestador de Serviços"){
            return new ProviderScreen(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } else {
            return new HomeScreen(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          }


        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}