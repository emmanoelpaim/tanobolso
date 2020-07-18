import 'package:tanobolso/models/card.dart';
import 'package:tanobolso/screens/card.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardListScreen extends StatefulWidget {
  CardListScreen({Key key, this.auth, this.userId, this.processPayment})
      : super(key: key);

  final BaseAuth auth;
  final String userId;
  final bool processPayment;

  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> listCards = new Map<String,dynamic>();
  final Color btnConfigColor = Colors.black;
  final Color btnConfigBackgroundColor = Colors.white;


  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    widget.auth.getCardsFromCurrentUserModel(widget.userId).then((value) {
      List<DocumentSnapshot> cards = (value as QuerySnapshot).documents;
      if (cards != null) {
        setState(() {
          listCards.clear();
          cards.forEach((element) {
            listCards[element.documentID] = element.data;
          });
        });
      }
    });
  }

  void deleteCard(String cardId) {
    widget.auth.deleteUserCard(cardId, widget.userId);
  }

  void _onFailMessage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao salvar, tente novamente!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    ));

  }

  void _onSuccessMessage() {
    loadData();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Dados atualizados com sucesso!"),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 1),
    ));

  }

  Widget getCartaoItem(String cardId, String lastNumbers) {
    String numberText = "**** **** **** "+lastNumbers;
    return GestureDetector(
      onTap: (){
        AlertDialog alert = AlertDialog(
          title: Text(numberText),
          content: Text(widget.processPayment ? "Deseja selecionar este cartão para pagamento?" : "Deseja excluir este cartão?"),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed:  () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Confirmar"),
              onPressed:  () {
                if (widget.processPayment) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(listCards[cardId]['token']);
                } else {
                  deleteCard(cardId);
                  loadData();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
        //exibe o diálogo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: Card(
        color: btnConfigBackgroundColor,
        child: ListTile(
            title: Text(numberText, style: TextStyle(color: btnConfigColor))
        ),
      ),
    );
  }

  String getKeyFromIndex(int index) {
    return listCards.keys.toList()[index];
  }

  CardModel getValueFromIndex(int index) {
    return CardModel.fromMapObject(listCards[getKeyFromIndex(index)]);
  }

  Widget getFooterBtn() {
    return FlatButton(
      color: Colors.blueAccent,
      child: const Text('Cadastrar Novo Cartão',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CardScreen(auth: widget.auth, userId: widget.userId)))
            .then((value) {
          if (value != null) {
            value? _onSuccessMessage() : _onFailMessage();
          }
        }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: false,
          title: Text("Cartão de Crédito"),
        ),
        body: new ListView.builder
          (
            itemCount: listCards.length,
            itemBuilder: (BuildContext ctxt, int index) => getCartaoItem(getKeyFromIndex(index), getValueFromIndex(index).numberCard)
        ),
        bottomNavigationBar: widget.processPayment ? Container(child: Text("")) : SafeArea(child: getFooterBtn())
    );
  }
}