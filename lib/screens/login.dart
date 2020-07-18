import 'package:tanobolso/services/authentication.dart';
import 'package:tanobolso/utils/uidata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = true;
  bool _showPassword = true;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
      ),
    );
  }

  loginBody() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[_showCircularProgress(), loginHeader(), loginFields()],
    ),
  );

  loginHeader() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlutterLogo(
        colors: Colors.blue,
        size: 80.0,
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        "Bem vindo ao ${UIData.appName}",
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blueAccent),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        "Faça login para continuar",
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );

  loginFields() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                controller: _emailController,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "E-mail invalido";
                },
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Digite seu e-mail",
                  labelText: "E-mail",
                ),
              ),
            ),
              Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextFormField(
              controller: _passController,
              validator: (text) {
                if (text.isEmpty) {
                  return "Senha inválida";
                }
              },
              maxLines: 1,
              obscureText: _showPassword,
              decoration: InputDecoration(
                hintText: "Digite sua senha",
                labelText: "Senha",
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                ),
              ),
              )],)
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "ENTRAR",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueAccent,
              onPressed: () async {
                login();
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterScreen()));
          },
          child: Text(
            "REGISTRAR",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            forgetPassword();
          },
          child: Text(
            "ESQUECI MINHA SENHA",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    ),
  );

  void login() async {
    print(_emailController.text);
    print(_passController.text);
    print(widget.auth);
    setState(() {
      _isLoading = true;
    });
    try {
      String userId = await widget.auth.signIn(
          _emailController.text, _passController.text);
      setState(() {
        _isLoading = false;
      });
      _onSuccess();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _formKey.currentState.reset();
      });
      _onFail(e);
    }
  }
  void forgetPassword() {
    if (_emailController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Insira seu email para recuperação!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    } else {
      // model.recoverPass(_emailController.text);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Confira seu Email"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ));
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
  }

  void _onSuccess() {
    widget.loginCallback();
  }

  void _onFail(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha no login! \n $message"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 5),
    ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
