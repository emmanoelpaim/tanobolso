import 'package:tanobolso/screens/root.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' hide Headers;


class ServiceAddScreen extends StatefulWidget {
  ServiceAddScreen({this.auth, this.loginCallback,this.userId});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final String userId;

  @override
  _ServiceAddScreenState createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _turnList =['Selecione','Manhã','Tarde','Noite','Todo Dia'];
  var _turnSelect = 'Selecione';

  bool _isLoading = true;
  Auth _firebaseAuth = Auth();

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Widget getDropDownBtnTurn() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _turnList.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._turnSelect = text;
          });
        },
        value: _turnSelect
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastrar Serviço'),
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
                          Icons.work,
                        ),
                        labelText: 'Digite nome serviço',
                      ),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _priceController,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Preço inválido";
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.attach_money,
                        ),
                        labelText: 'Digite o preço serviço',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _descriptionController,
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Descrição inválido";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Digite descrição serviço',
                      ),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    getDropDownBtnTurn(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.blueAccent)),
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> serviceData = {
                            "id" :  DateTime.now().millisecondsSinceEpoch,
                            "name" : _nameController.text,
                            "price" : _priceController.text,
                            "description" : _descriptionController.text,
                            "turn" : _turnSelect == "Selecione"
                                ? "" : _turnSelect,
                            "user_create" : widget.userId,
                            "date_create" : DateTime.now(),

                          };

                          setState(() {
                            _isLoading = true;
                          });

                          await _firebaseAuth.saveService(serviceData).then((result){
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
      content: Text("Falha ao criar serviço! \n $message"),
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
