import 'package:tanobolso/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserAddressScreen extends StatefulWidget {
  UserAddressScreen({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _UserAddressScreenState createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _complementController = TextEditingController();
  final _numberController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateinitialsController = TextEditingController();
  final _cityController = TextEditingController();
  final _countrynameController = TextEditingController();

  bool _isLoading = false;
  Auth _firebaseAuth = Auth();

  var cepMask = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  List<String> states = ['AC','AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];
  List<String> countrys = ['Brasil'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData(){
    widget.auth.getCurrentUserModel(widget.userId).then((value) {
      Map<String, dynamic> mapData = (value as DocumentSnapshot).data;
      print(mapData);
      if (mapData['address'] != null) {
        Map<String, dynamic> subObject = mapData['address'];
        setState(() {
          _cepController.text = subObject['cep'];
          _streetController.text = subObject['street'];
          _complementController.text = subObject['complement'];
          _numberController.text = subObject['number'];
          _neighborhoodController.text = subObject['neighborhood'];
          _stateinitialsController.text = subObject['stateinitials'];
          _cityController.text = subObject['city'];
          _countrynameController.text = subObject['country'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Endereço de Cobrança")),
      body:
      ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
            Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    controller: _cepController,
                    inputFormatters: [cepMask],
                    validator: (text) {
                      if (text.isEmpty) {
                        return "cep inválido";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'CEP',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    controller: _streetController,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Rua inválida";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Rua',
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,3,10,3),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.40,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            controller: _numberController,
                            validator: (text) {
                              if (text.isEmpty) {
                                return "Número inválido";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Número',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,3,10,3),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.40,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text,
                            controller: _complementController,
                            validator: (text) {
                              if (text.isEmpty) {
                                return "Complemento inválido";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Complemento',
                            ),
                          ),
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    controller: _neighborhoodController,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Bairro inválido";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    controller: _cityController,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Cidade inválido";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Cidade',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    controller: _stateinitialsController,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "UF inválido";
                      } else
                      if (!states.contains(text)) {
                        return "UF inválido";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'UF (Ex.: RJ, SP)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,3,10,3),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    controller: _countrynameController,
                    validator: (text) {
                      if (text.isEmpty) {
                        return "País inválido";
                      } else
                      if (!countrys.contains(text)) {
                        return "País inválido";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'País',
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
                        Map<String, dynamic> userAddressData = {
                          "cep" : _cepController.text.trim(),
                          "street" : _streetController.text.trim(),
                          "complement" : _complementController.text.trim(),
                          "number" : _numberController.text.trim(),
                          "neighborhood" : _neighborhoodController.text.trim(),
                          "stateinitials" : _stateinitialsController.text.trim(),
                          "city" : _cityController.text.trim(),
                          "country" : _countrynameController.text.trim(),
                        };

                        setState(() {
                          _isLoading = true;
                        });

                        DocumentSnapshot dynamicUserModel = await _firebaseAuth.getCurrentUserModel(widget.userId);
                        Map<String, dynamic> userData = dynamicUserModel.data;
                        userData["address"] = userAddressData;

                        await _firebaseAuth.saveUserAddress(userData,widget.userId).then((result){
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

