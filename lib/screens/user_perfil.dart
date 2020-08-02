import 'package:tanobolso/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserPerfilScreen extends StatefulWidget {
  UserPerfilScreen({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _UserPerfilScreenState createState() => _UserPerfilScreenState();
}

class _UserPerfilScreenState extends State<UserPerfilScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();

  bool _isLoading = false;
  Auth _firebaseAuth = Auth();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData(){
    widget.auth.getCurrentUserModel(widget.userId).then((value) {
      Map<String, dynamic> mapData = (value as DocumentSnapshot).data;
      setState(() {
        _nameController.text = mapData['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Perfil")),
      body:
      ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10,5,10,3),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Nome inválido";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: FlatButton(
                  color: Colors.blueAccent,
                  child: const Text('Salvar',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async{
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      DocumentSnapshot dynamicUserModel = await _firebaseAuth.getCurrentUserModel(widget.userId);
                      Map<String, dynamic> userData = dynamicUserModel.data;
                      userData["name"] = _nameController.text;

                      await _firebaseAuth.editUser(userData,widget.userId).then((result){
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
                ),
              ),
              _showCircularProgress()
            ],),
          ),
        ],
      ),
    );
  }

  void _onFail(message) {
    Navigator.pop(context, false);
  }

  void _onSuccess() {
    Navigator.pop(context, true);
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

