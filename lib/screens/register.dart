import 'dart:convert';
import 'package:tanobolso/screens/root.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' hide Headers;
import 'home.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var isServiceProvider = false;
  var isUser = false;

  var _typePermission =['Selecione','Prestador de Serviços','Usuário'];
  var _permissionSelect = 'Selecione';


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _isLoading = true;
  Auth _firebaseAuth = Auth();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Widget getDropDownBtnTipoCadastro() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _typePermission.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._permissionSelect = text;
          });
        },
        value: _permissionSelect
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastrar'),
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        leading: Builder(builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Container(
              child: Icon(Icons.arrow_back),
              padding: new EdgeInsets.all(7.0),
            ),
          );
        }),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Nome inválido";
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        labelText: 'Digite seu Nome',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                        ),
                        labelText: 'Digite seu Email',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Email inválido";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _passController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        labelText: 'Digite sua Senha',
                      ),
                      validator: (text) {
                        if (text.isEmpty || text.length < 6) {
                          return "Senha inválida";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[

                        Text(
                          'Tipo de Cadastro?',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.91,
                          child: getDropDownBtnTipoCadastro(),
                        ),
                      ],
                    ),
                    isUser ?
                    Column(
                      children: <Widget>[
                      ],
                    ) : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.blueAccent)),
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "permissionSelect": _permissionSelect == "Selecione"
                                ? ""
                                : _permissionSelect,
                          };

                          setState(() {
                            _isLoading = true;
                          });

                          await _firebaseAuth.signUp(
                              _emailController.text, _passController.text)
                              .then((result){
                            setState(() {
                              userId = result;
                            });
                          })
                              .catchError((e){
                            setState(() {
                              _isLoading = false;
                            });
                            _onFail(e);
                          });
                          await _firebaseAuth.saveUser(userData).then((result){
                            _onSuccess();
                          })
                              .catchError((e){
                            setState(() {
                              _isLoading = false;
                            });

                            _onFail(e);
                          });

                        }
                      },
                      color: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        //
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Salvar",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }

  void _onSuccess() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RootPage(auth:_firebaseAuth)));
  }

  void _onFail(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário! \n $message"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 5),
    ));
  }

  void resetForm() {
    _formKey.currentState.reset();
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
