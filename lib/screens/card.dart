import 'dart:convert';

import 'package:tanobolso/services/authentication.dart';
import 'package:tanobolso/ui/widgets/profile_tile.dart';
import 'package:tanobolso/utils/uidata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dio/dio.dart' hide Headers;

class CardScreen extends StatefulWidget {
  CardScreen({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

  String _holderCard;
  String _numberCard;
  var numberMask = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  String _cvvCard;
  var cvvMask = new MaskTextInputFormatter(
      mask: '###', filter: {"#": RegExp(r'[0-9]')});
  String _expireCard;
  var expMask = new MaskTextInputFormatter(
      mask: '##/####', filter: {"#": RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _numberCardController = TextEditingController();
  final _expireCardController = TextEditingController();
  final _cvvCardController = TextEditingController();
  final _holderCardController = TextEditingController();

  bool _isLoading = false;
  Auth _firebaseAuth = Auth();

  @override
  void initState() {
    super.initState();
    _holderCard = "Seu Nome";
    _numberCard = "**** **** **** ****";
    _expireCard = "MM/YY";
    _cvvCard = "***";

    loadData();
  }

  void loadData(){
    widget.auth.getCurrentUserModel(widget.userId).then((value) {
      Map<String, dynamic> mapData = (value as DocumentSnapshot).data;
      if (mapData['card'] != null) {
        Map<String, dynamic> subObject = mapData['card'];
        print(subObject);
        setState(() {
          if (subObject['cvvCard'] != null) {
            _cvvCard = subObject['cvvCard'];
            _cvvCardController.text = _cvvCard;
          }
          if (subObject['expireCard'] != null) {
            _expireCard = subObject['expireCard'];
            _expireCardController.text = _expireCard;
          }
          if (subObject['holderCard'] != null) {
            _holderCard = subObject['holderCard'];
            _holderCardController.text = _holderCard;
          }
          if (subObject['numberCard'] != null) {
            _numberCard = subObject['numberCard'];
            _numberCardController.text = _numberCard;
          }
        });
      }
    });
  }

  Widget bodyData() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[creditCardWidget(), fillEntries(),_showCircularProgress()],
    ),
  );

  Widget creditCardWidget() {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height * 0.3,
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: UIData.kitGradients)),
              ),
              Opacity(
                opacity: 0.1,
//                child: Image.asset(
//                  "assets/images/map.png",
//                  fit: BoxFit.cover,
//                ),
              ),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? cardEntries()
                  : FittedBox(
                child: cardEntries(),
              ),
//              Positioned(
//                right: 10.0,
//                top: 10.0,
//                child: Icon(
//                  FontAwesomeIcons.ccVisa,
//                  size: 30.0,
//                  color: Colors.white,
//                ),
//              ),
              Positioned(
                right: 10.0,
                bottom: 10.0,
                child: StreamBuilder<String>(
                  initialData: _holderCard,
                  builder: (context, snapshot) => Text(
                    _holderCard,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: UIData.ralewayFont,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardEntries() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_numberCard,
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ProfileTile(
              textColor: Colors.white,
              title: "VAL",
              subtitle:
              _expireCard,
            ),
            SizedBox(
              width: 30.0,
            ),
            ProfileTile(
              textColor: Colors.white,
              title: "CVV",
              subtitle:
              _cvvCard,
            )
          ],
        ),
      ],
    ),
  );

  Widget getFieldNomeCartao() {
    return TextFormField(
      textCapitalization: TextCapitalization.characters,
      validator: (text) {
        if (text.isEmpty) {
          return "Nome inválido";
        }
      },
      keyboardType: TextInputType.text,
      maxLength: 20,
      controller: _holderCardController,
      style: TextStyle(
          fontFamily: UIData.ralewayFont, color: Colors.black),
      onChanged: (out){
        setState(() {
          _holderCard = out.toString();
        });
      },
      decoration: InputDecoration(
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelText: "Nome no cartão",
          border: OutlineInputBorder()),
    );
  }

  Widget getCVVLayout() {
    return TextFormField(
      validator: (text) {
        if (text.isEmpty) {
          return "Código inválido";
        }
      },
      controller: _cvvCardController,
      inputFormatters: [cvvMask],
      keyboardType: TextInputType.number,
      maxLength: 3,
      onChanged: (out){
        setState(() {
          _cvvCard = out.toString();
        });
      },
      style: TextStyle(
          fontFamily: UIData.ralewayFont, color: Colors.black),
      decoration: InputDecoration(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelText: "CVV",
          border: OutlineInputBorder()),
    );
  }

  Widget getExpireCardLayout() {
    return TextFormField(
      validator: (text) {
        if (text.isEmpty) {
          return "data inválida";
        } else {
          DateTime now = new DateTime.now();
          int mes = int.parse(text.split("/")[0]);
          int ano = int.parse(text.split("/")[1]);
          print(mes);
          if (mes > 12 || mes <= 0) {
            return "Mês inválido!";
          } else
          if (ano < now.year || (ano == now.year && mes < now.month)) {
            return "Cartão vencido!";
          }
        }

      },
      controller: _expireCardController,
      inputFormatters: [expMask],
      keyboardType: TextInputType.number,
      maxLength: 7,
      style: TextStyle(
          fontFamily: UIData.ralewayFont, color: Colors.black),
      onChanged: (out){
        setState(() {
          _expireCard = out.toString();
        });
      },
      decoration: InputDecoration(
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelText: "Data de Validade (Ex.: MM/AAAA)",
          border: OutlineInputBorder()),
    );
  }

  Widget getCardNumberLayout() {
    return TextFormField(
      validator: (text) {
        if (text.isEmpty) {
          return "Número inválido";
        }
      },
      controller: _numberCardController,
      keyboardType: TextInputType.number,
      onChanged: (out){
        setState(() {
          _numberCard = out.toString();
        });
      },
      inputFormatters: [numberMask],
      maxLength: 19,
      style: TextStyle(
          fontFamily: UIData.ralewayFont, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Número do Cartão de Crédito",
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder()),
    );
  }

  Widget getButtonSave() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        child: FlatButton(
          color: Colors.blueAccent,
          child: const Text('Salvar',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () {}
        )
    );
  }

  Widget fillEntries() => Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getFieldNomeCartao(),
          getCardNumberLayout(),
          getExpireCardLayout(),
          getCVVLayout(),
          getButtonSave(),
          Text('* Você está em um ambiente seguro.')
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text("Cartão de Crédito"),
      ),
      body: bodyData(),
    );
  }


  void _onFail(message) {
    Navigator.pop(context, false);
  }

  void _onSuccess() {
    Navigator.pop(context, true);
  }

  void showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blueAccent,
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

