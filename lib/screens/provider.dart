import 'package:tanobolso/screens/service_add.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:tanobolso/models/service.dart';
import 'package:tanobolso/models/user.dart';
import 'package:tanobolso/screens/user_perfil.dart';
import 'package:tanobolso/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderScreen extends StatefulWidget {
  ProviderScreen({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _tabController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Auth _firebaseAuth = Auth();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color btnConfigColor = Colors.black;
  final Color btnConfigBackgroundColor = Colors.white;
  Map<String, dynamic> serviceList = new Map<String, dynamic>();
  Map<String, dynamic> schedulesList = new Map<String, dynamic>();

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
        // Tab Changed tapping on new tab
        setState(() {
          _currentIndex = _tabController.index;
          _tabController.animateTo(_currentIndex);
        });
      else if (_tabController.index != _tabController.previousIndex)
        // Tab Changed swiping to a new tab
        setState(() {
          _currentIndex = _tabController.index;
          _tabController.animateTo(_currentIndex);
        });
    });
    loadSchedules();
    loadServices();
  }

  void loadSchedules() {
//    String dateParameter = DateFormat.yMd("ptBR").format(DateTime.now());
//    DateTime dateFilter = DateTime.now();
//    var newValue = 0;
//    dateFilter = dateFilter.toLocal();
//   dateFilter = new DateTime(
//        dateFilter.year,
//        dateFilter.month,
//        dateFilter.day,
//        newValue, newValue, newValue, newValue, newValue);
//    print(dateFilter);
//    widget.auth.getSchedulesListByUser(dateFilter, widget.userId).then((value) {
//      List<DocumentSnapshot> schedulesDocuments = (value as QuerySnapshot).documents;
//      setState(() {
//        schedulesList.clear();
//        schedulesDocuments.forEach((element) {
//          schedulesList[element.documentID] = element.data;
//        });
//      });
//      print (schedulesList);
//    });
  }

  void loadServices() {
    widget.auth.getServicesList().then((value) {
      List<DocumentSnapshot> servicesDocuments =
          (value as QuerySnapshot).documents;
      serviceList.clear();
      servicesDocuments.forEach((element) {
        serviceList[element.documentID] = element.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Chamando o service
    Services _services = Services();

    Future getPrestadorDeServico() async {
      List<dynamic> listUser = new List<dynamic>();

      listUser = await _services.getOneByUid("users", widget.userId);

      return listUser;
    }

    void _onFailMessage() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao salvar, tente novamente!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
      ));
    }

    void _onSuccessMessage() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Dados atualizados com sucesso!"),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 1),
      ));
    }

    void _onSuccessCustomMessage(String message) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 1),
      ));
    }

    Widget getInformacoesPessoaisItem() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserPerfilScreen(
                      auth: _firebaseAuth,
                      userId: widget.userId))).then((value) {
            if (value != null) {
              value ? _onSuccessMessage() : _onFailMessage();
            }
          });
        },
        child: Card(
          color: btnConfigBackgroundColor,
          child: ListTile(
              title: Text("Informações Pessoais",
                  style: TextStyle(color: btnConfigColor))),
        ),
      );
    }

    Widget getSairItem() {
      return GestureDetector(
        onTap: () {
          signOut();
        },
        child: Card(
          color: btnConfigBackgroundColor,
          child: ListTile(
              title: Text("Sair", style: TextStyle(color: btnConfigColor))),
        ),
      );
    }

    Widget containerUserFuture() {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: projectSnap.data != null ? projectSnap.data.length : 0,
              itemBuilder: (context, index) {
                User user = User.fromJson(projectSnap.data[index]);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      getInformacoesPessoaisItem(),
                      getSairItem(),
                    ],
                  ),
                );
              });
        },
        future: getPrestadorDeServico(),
      );
    }

    String getKeyFromIndex(int index) {
      return serviceList.keys.toList()[index];
    }

    ServiceModel getValueFromIndex(int index) {
      return ServiceModel.fromMapObject(serviceList[getKeyFromIndex(index)]);
    }

    String getScheduleKeyFromIndex(int index) {
      return schedulesList.keys.toList()[index];
    }

    Map<String, dynamic> getScheduleValueFromIndex(int index) {
      return schedulesList[getScheduleKeyFromIndex(index)];
    }

    Widget getServiceItem(ServiceModel serviceModel, int index) {
      return Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(serviceModel.name),
                      subtitle: Text(serviceModel.description),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("R\$ " + serviceModel.price),
                        ],
                      )),
                ),
              ],
            ),
          ));
    }

    Widget getScheduleItem(Map<String, dynamic> scheduleModel, int index) {
      return Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                      onTap: () {},
                      title: Text(scheduleModel['service']['name']),
                      subtitle: Text(scheduleModel['turn']),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(scheduleModel['dateformat']),
                        ],
                      )
//                        leading: CircleAvatar(
//                          backgroundColor: Colors.grey,
//                          child: Icon(Icons.directions_boat),
//                        ),
                      ),
                ),
              ],
            ),
          ));
    }

    /*
  * Lista de serviços
  * */
    Widget listServicesWidget() {
      print(serviceList);
      return Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: serviceList.length,
              itemBuilder: (BuildContext ctxt, int index) =>
                  getServiceItem(getValueFromIndex(index), index)),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceAddScreen(
                              auth: _firebaseAuth, userId: widget.userId)));
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget textServicesEmpty() {
      return SafeArea(
        child: Text(
          "Você ainda não possui serviços agendados para hoje!",
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget listSchedulesWidget() {
      return new ListView.builder(
          itemCount: schedulesList.length,
          itemBuilder: (BuildContext ctxt, int index) =>
              getScheduleItem(getScheduleValueFromIndex(index), index));
    }

    return Scaffold(
      key: _scaffoldKey,
      body: TabBarView(
        controller: _tabController,
        children: [
          schedulesList.length > 0
              ? listSchedulesWidget()
              : textServicesEmpty(),
          listServicesWidget(),
          containerUserFuture()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
          setState(() {
            _currentIndex = currentIndex;
            _tabController.animateTo(_currentIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Início"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Serviços"),
            icon: Icon(Icons.work),
          ),
          BottomNavigationBarItem(
            title: Text("Configurações"),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  signOut() async {
    try {
      await _firebaseAuth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
