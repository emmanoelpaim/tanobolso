import 'dart:convert';
import 'package:tanobolso/screens/login.dart';
import 'package:tanobolso/screens/root.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:tanobolso/services/retrofit.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  var telMask = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  var numberMask = new MaskTextInputFormatter(
      mask: '##', filter: {"#": RegExp(r'[0-9]')});

  var dataMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  var isServiceProvider = false;
  var isCommander = false;

  var _typePermission =['Selecione','Prestador de Serviços','Comandante'];
  var _permissionSelect = 'Selecione';

  var _typeService =[
    'Selecione',
    'SERVIÇOS DE APOIO DE ANCORAGEM E ATRACAGEM',
    'SERVIÇOS DE TRANSLADO',
    'SERVIÇOS DE FORNECIMENTO DE EQUIPAMENTOS NÁUTICOS',
    'SERVIÇOS DE ASSESSORAMENTO AO SERVIÇO CHARTER',
    'PRESTADOR DE SERVIÇO DE CHARTER',
    'PRESTADOR DE SERVIÇO DE CONDUTOR DE EMBARCAÇÃO',
    'PRESTADOR DE SERVIÇO DE MANUTENÇÃO',
    'PRESTADOR DE SERVIÇO DE HIGIENIZAÇÃO E LIMPEZA',
    'PRESTADOR DE SERVIÇO DE FORNECIMENTO DE EQUIPAMENTOS NÁUTICOS',
    'PRESTADOR DE SERVIÇO DE FORNECIMENTO DE ALIMENTAÇÃO E BEBIDAS',
    'PRESTADOR DE SERVIÇO DE TREINAMENTO E CAPACITAÇÃO NÁUTICA',
    'PRESTADOR DE SERVIÇO GUIA TURÍSTICO'
  ];
  var _typeServiceSelect = 'Selecione';

  var _typeLicense =['Selecione','Arrais-Amador','Capitão-Amador','Mestre Amador','Motonáutica'];
  var _licenseSelect = 'Selecione';


  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneWhatsappController = TextEditingController();
  final _serviceController = TextEditingController();
  final _boatMiudaController = TextEditingController();
  final _boatPequenaController = TextEditingController();
  final _boatMediaController = TextEditingController();
  final _boatGrandeController = TextEditingController();
  final _boatMotoController = TextEditingController();
  final _carretaEncalheController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _licenseExpireController = TextEditingController();

  bool _isLoading = true;
  Auth _firebaseAuth = Auth();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _boatMiudaController.text = "0";
    _boatPequenaController.text = "0";
    _boatMediaController.text = "0";
    _boatGrandeController.text = "0";
    _boatMotoController.text = "0";
    _carretaEncalheController.text = "0";
  }

  Widget getDropDownBtnTipoServico() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _typeService.map((
            String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._typeServiceSelect = text;
          });
        },
        value: _typeServiceSelect
    );
  }

  Widget getDropDownBtnTipoHabilitacao() {
    return DropdownButton<String>(
      isExpanded: true,
        items: _typeLicense.map((
            String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._licenseSelect = text;
          });
        },
        value: _licenseSelect
    );
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
            if (text != 'Prestador de Serviços' &&
                text != 'Comandante') {
              isCommander = false;
              isServiceProvider = false;
              _serviceController.text = '';
              _licenseNumberController.text = '';
              _licenseExpireController.text = '';
            }
            else if (text == 'Prestador de Serviços') {
              isServiceProvider = true;
              isCommander = false;
            }
            else {
              isCommander = true;
              isServiceProvider = false;
            }
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
                    TextFormField(
                      controller: _phoneController,
                      inputFormatters: [telMask],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                        labelText: 'Digite seu Telefone',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Telefone inválido";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _phoneWhatsappController,
                      inputFormatters: [telMask],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                        labelText: 'Digite seu Celular (WhatsApp, contato náutico)',
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Celular inválido";
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
                    isServiceProvider
                        ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[

                              Text(
                                'Tipo de Serviço?',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.91,
                                child: getDropDownBtnTipoServico(),
                              ),
                            ],
                          ),
                        ],)
                        : new Container(),
                    isCommander ?
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[

                            Text(
                              'Tipo de Habilitação?',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.91,
                              child: getDropDownBtnTipoHabilitacao(),
                            ),
                          ],
                        ),
                      ],
                    ) : Container(),
                    isCommander
                        ? Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _licenseNumberController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Nº Carteira de Habilitação Amador inválido";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                          labelText: 'Nº Carteira de Habilitação Amador',
                        ),
                      ),
                    )
                        : Container(),
                    isCommander ?
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      child: TextFormField(
                        inputFormatters: [
                          dataMask,
                        ],
                        keyboardType: TextInputType.phone,
                        controller: _licenseExpireController,
                        validator: (text) {
                          if (text.isEmpty) {
                            return "Data inválida";
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                          ),
                          labelText: 'Vencimento da Carteira de Habilitação',
                        ),
                      ),
                    ) :
                    Container(),
                    isCommander ?
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[

                            Text(
                              'Equipamento Náutico?',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('* Informe a quantidade')
                          ],
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Embarcação Miúda',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _boatMiudaController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Embarcação Pequena',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _boatPequenaController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Embarcação Média',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _boatMediaController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Embarcação Grande',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _boatGrandeController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Moto Aquática',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _boatMotoController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ) : Container(),
                    isCommander ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Carreta de Encalhe',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _carretaEncalheController,
                              inputFormatters: [numberMask],
                              keyboardType: TextInputType.phone,
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "Numero inválido";
                                }
                              },
                            ),
                          ),
                        ),
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
                            "phone": _phoneController.text,
                            "cellphone": _phoneWhatsappController.text,
//                            "service": _serviceController.text,
                            "service": _typeServiceSelect == "Selecione"
                                ? ""
                                : _typeServiceSelect,
                            "licenseExpire": _licenseExpireController.text,
                            "licenseNumber": _licenseNumberController.text,
                            "permissionSelect": _permissionSelect == "Selecione"
                                ? ""
                                : _permissionSelect,
                            "licenseSelect": _licenseSelect == "Selecione"
                                ? ""
                                : _licenseSelect,
                            "boatMiuda": _boatMiudaController.text,
                            "boatPequena": _boatPequenaController.text,
                            "boatMedia": _boatMediaController.text,
                            "boatGrande": _boatGrandeController.text,
                            "boatMoto": _boatMotoController.text,
                            "carretaEncalhe": _carretaEncalheController.text,
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
    if(_permissionSelect == 'Prestador de Serviços') {
      final dio = Dio();
      dio.options.connectTimeout = 15000;

      JsonSendMail jsonSendMail = JsonSendMail(_emailController.text);
      final client = RestClient(dio);
      client.postSendMail(jsonSendMail).then((requestResponse) {
        try {
          dynamic jsonDecoded = json.decode(requestResponse);
          print(jsonDecoded);
        } catch (e) {
          print(e.toString());
        }
      }).catchError((errorResponse) {
        String response = "";
        if (errorResponse.toString().contains("TIMEOUT")) {
          response = "Serviço indisponível!";
        }
        print(errorResponse);
      });
    }
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
