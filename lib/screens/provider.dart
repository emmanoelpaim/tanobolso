import 'package:tanobolso/services/authentication.dart';
import 'package:flutter/material.dart';



class ProviderScreen extends StatefulWidget {
  ProviderScreen({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen>  with SingleTickerProviderStateMixin{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  signOut();
                },
                child: Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Container(child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Text(
            "Cadastro Realizado com sucesso \nEntraremos em contato em breve.",style: TextStyle(fontSize: 20),
        ),
      ),),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
