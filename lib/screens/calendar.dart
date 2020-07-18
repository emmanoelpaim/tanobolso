import 'dart:convert';

import 'package:tanobolso/models/service.dart';
import 'package:tanobolso/screens/card_list.dart';
import 'package:tanobolso/services/authentication.dart';
import 'package:tanobolso/services/retrofit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:dio/dio.dart' hide Headers;

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key, this.title, this.auth, this.userId, this.serviceModelItem, this.serviceId}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final String userId;
  final String serviceId;
  final ServiceModel serviceModelItem;

  @override
  _CalendarScreenState createState() => new _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _currentDate2 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String _currentMonth = DateFormat.yMMM().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  DateTime _targetDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int _IdTransaction = 0;
  bool _isLoading = false;

  var _installmentQuantityList =[
    "1","2","3","4","5","6","7","8","9","10"
  ];

  String _installmentQuantitySelected = "1";

  var _turnList =[
    "Selecione",
    'Turno Manhã (08h às 12h)',
    'Turno Tarde (12h às 18h)',
    'Turno Noite (18h às 22h)'
  ];
  var _turnListEmpty =[
    "Selecione"
  ];

  var _hourList =[
    "Selecione"
  ];
  var _hourListEmpty =[
    "Selecione"
  ];
  var _turnListOriginal =[
    'Turno Manhã (08h às 12h)',
    'Turno Tarde (12h às 18h)',
    'Turno Noite (18h às 22h)'
  ];

  var _hourListOriginalTurn1 =[
    '08:00',
    '09:00',
    '10:00',
    '11:00'
  ];

  var _hourListOriginalTurn2 =[
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];

  var _hourListOriginalTurn3 =[
    '18:00',
    '19:00',
    '20:00',
    '21:00'
  ];

  var _15minutesListOriginalTurn1 =[
    '08:00', '08:15', '08:30', '08:45',
    '09:00', '09:15', '09:30', '09:45',
    '10:00', '10:15', '10:30', '10:45',
    '11:00', '11:15', '11:30', '11:45'
  ];

  var _15minutesListOriginalTurn2 =[
    '12:00', '12:15', '12:30', '12:45',
    '13:00', '13:15', '13:30', '13:45',
    '14:00', '14:15', '14:30', '14:45',
    '15:00', '15:15', '15:30', '15:45',
    '16:00', '16:15', '16:30', '16:45',
    '17:00', '17:15', '17:30', '17:45',
  ];

  var _15minutesListOriginalTurn3 =[
    '18:00', '18:15', '18:30', '18:45',
    '19:00', '19:15', '19:30', '19:45',
    '20:00', '20:15', '20:30', '20:45',
    '21:00', '21:15', '21:30', '21:45'
  ];

  var _30minutesListOriginalTurn1 =[
    '08:00', '08:30',
    '09:00', '09:30',
    '10:00', '10:30',
    '11:00', '11:30',
  ];

  var _30minutesListOriginalTurn2 =[
    '12:00', '12:30',
    '13:00', '13:30',
    '14:00', '14:30',
    '15:00', '15:30',
    '16:00', '16:30',
    '17:00', '17:30'
  ];

  var _30minutesListOriginalTurn3 =[
    '18:00', '18:30',
    '19:00', '19:30',
    '20:00', '20:30',
    '21:00', '21:30'
  ];

  String _turnSelect = "Selecione";
  String _hourSelect = "Selecione";
  String _card = "";
  bool _cardSelected = false;

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blueAccent, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.black,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
//    addEvent(_currentDate, "TESTE");
    super.initState();
  }

  void addEvent(DateTime date, String title) {
    _markedDateMap.add(
        date,
        new Event(
          date: date,
          title: title,
          icon: _eventIcon,
        ));
  }

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() {
      _currentDate2 = date;
      _turnSelect = "Selecione";
      _hourSelect = "Selecione";
    });
    events.forEach((event) => print(event.title));
  }

  void onMonthChanged(DateTime date) {
    this.setState(() {
      _targetDateTime = date;
      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    });
  }

//  void showTimePickerModal() {
//    showTimePicker(
//      initialTime: TimeOfDay.now(),
//      context: context,
//    ).then((value) {
//      setState(() {
//        _hourSelected = true;
//        _hour = value;
//      });
//    });
//  }

  Widget getDropDownBtnTurn() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _turnList.map((
            String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._turnSelect = text;
            verifySchedulesAtDay();
          });
        },
        value: _turnSelect
    );
  }

  Widget getDropDownBtnHour() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _hourList.map((
            String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._hourSelect = text;
          });
        },
        value: _hourSelect
    );
  }

  String getInstallmentQuantityText(String InstallmentQuantity) {
    int installmentQuantityInt = int.parse(InstallmentQuantity);

    double valuePerInstallment = num.parse(widget.serviceModelItem.price) / installmentQuantityInt;

    return InstallmentQuantity + "x de R\$ "+valuePerInstallment.toStringAsFixed(2);
  }

  Widget getDropDownBtnInstallmentQuantity() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _installmentQuantityList.map((
            String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(getInstallmentQuantityText(dropDownStringItem), textAlign: TextAlign.center,),
          );
        }).toList(),
        onChanged: (String text) {
          setState(() {
            this._installmentQuantitySelected = text;
          });
        },
        value: _installmentQuantitySelected
    );
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

  Widget getHourLayout() {
    print(widget.serviceModelItem.type);
    return Container(child: Column(children: <Widget>[
//      widget.serviceModelItem.type.toLowerCase() == "turno" ?  getDropDownBtnTurn() : Text(""),
      getDropDownBtnTurn(),
      _turnSelect != "Selecione" ? getDropDownBtnHour() : Text(""),
//      Text(_cardSelected ? "Cartão escolhido: "+ _card : "")
    ]));
  }

  Widget getInstallmentQuantityLayout() {
    return Container(child: Column(children: <Widget>[
//      _cardSelected ? Text("Selecione a quantidade de parcelas:") : Text(""),
      _cardSelected ?  getDropDownBtnInstallmentQuantity() : Text("")
//      Text(_cardSelected ? "Cartão escolhido: "+ _card : "")
    ]));
  }

  Widget getCalendarLayout() {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        onDayPressed(date, events);
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: TextStyle(
        color: Colors.blueAccent,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(
          side: BorderSide(color: Colors.grey)
      ),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blueAccent,
      ),
      showHeader: false,
      selectedDayBorderColor: Colors.blueAccent,
      selectedDayButtonColor: Colors.blueAccent,
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.grey,
      todayBorderColor: Colors.grey,
      todayTextStyle: TextStyle(
        color: Colors.black,
      ),
      weekdayTextStyle: TextStyle(
        color: Colors.black,
      ),
      weekDayFormat: WeekdayFormat.short,
//      customWeekDayBuilder: (weekday, weekdayName) => {[1, "Segunda"]},
      selectedDayTextStyle: TextStyle(
        color: Colors.black,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.blueGrey,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        onMonthChanged(date);
      },
      onDayLongPressed: (day) {},
    );
  }

  List<String> getListOriginal() {
    String serviceType = widget.serviceModelItem.type.toLowerCase();
    if (serviceType == "turno") {
      switch (_turnSelect) {
        case 'Turno Manhã (08h às 12h)':
          return _hourListOriginalTurn1;
        case 'Turno Tarde (12h às 18h)':
          return _hourListOriginalTurn2;
        case 'Turno Noite (18h às 22h)':
          return _hourListOriginalTurn3;
      }
    } else
    if (serviceType == "livre") {
      switch (_turnSelect) {
        case 'Turno Manhã (08h às 12h)':
          return _15minutesListOriginalTurn1;
        case 'Turno Tarde (12h às 18h)':
          return _15minutesListOriginalTurn2;
        case 'Turno Noite (18h às 22h)':
          return _15minutesListOriginalTurn3;
      }
    } else
    if (serviceType == "livre2") {
      switch (_turnSelect) {
        case 'Turno Manhã (08h às 12h)':
          return _30minutesListOriginalTurn1;
        case 'Turno Tarde (12h às 18h)':
          return _30minutesListOriginalTurn2;
        case 'Turno Noite (18h às 22h)':
          return _30minutesListOriginalTurn3;
      }
    }
  }

  void verifySchedulesAtDay() {
    _hourSelect = "Selecione";

    _hourList.clear();
    _hourList.addAll(_hourListEmpty);

    if (_turnSelect != "Selecione") {
      String dateParameter = DateFormat.yMd("ptBR").format(_currentDate2);
      widget.auth.getSchedulesList(dateParameter, widget.serviceId).then((value) {
        List<DocumentSnapshot> schedules = (value as QuerySnapshot).documents;
        if (schedules != null) {
          setState(() {
            print (getListOriginal());
            getListOriginal().forEach((elementTurn) {
              int countServices = 0;
              schedules.forEach((elementService) {
                var mapData = elementService.data;
                if (mapData['turn'] == elementTurn){
                  countServices++;
                }
              });
              if (countServices < widget.serviceModelItem.slots) {
                _hourList.add(elementTurn);
              }
            });
          });
        }
      });
    }
  }

  void saveSchedule() {
    Map<String, dynamic> scheduleData = {
      "dateformat": DateFormat.yMd("ptBR").format(_currentDate2),
      "date": _currentDate2,
      "tokenPayment": _card,
      "userId": widget.userId,
      "serviceId": widget.serviceId,
      "idTransaction": _IdTransaction,
      "service": widget.serviceModelItem.toMap()
    };

//    if (widget.serviceModelItem.type.toLowerCase() == "turno") {
      scheduleData["turn"] = _hourSelect;
      scheduleData["turnIndex"] = _hourList.indexOf(_hourSelect);
//    }

    widget.auth.saveSchedule(scheduleData);
  }

  void finishSchedule() {
    saveSchedule();
    Navigator.of(context).pop(true);
  }

  void processPayment() {
    List<JsonItemProcessPayment> listJsonItemProcessPayment = new List<JsonItemProcessPayment>();
    var jsonItemProcessPayment = new JsonItemProcessPayment(
        widget.serviceId,
        widget.serviceModelItem.name,
        int.parse(widget.serviceModelItem.price),
        1);

    listJsonItemProcessPayment.add(jsonItemProcessPayment);
    var jsonProcessPayment = new JsonProcessPayment(new JsonCardProcessPayment(_card, int.parse(_installmentQuantitySelected)), widget.userId, listJsonItemProcessPayment);
    print (jsonProcessPayment.toJson());
    final dio = Dio();
    dio.options.connectTimeout = 15000;

    final client = RestClient(dio);

    client.postProcessPayment(jsonProcessPayment).then((requestResponse) {
      dynamic jsonDecoded = json.decode(requestResponse);
//      print(jsonDecoded);
      if (jsonDecoded['HasError'] != null) {
        if (jsonDecoded['HasError'] == true) {
          jsonDecoded['Error'] =
              jsonDecoded['Error'].toString().replaceAll(
                  "tokenização", "validação do cartão");
          showMessage(jsonDecoded['Error']);
          setState(() {
            _isLoading = false;
          });
        } else {
          _IdTransaction = jsonDecoded['ResponseDetail']['IdTransaction'];
          finishSchedule();
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 5),
    ));
  }

  Widget getFooterBtn() {
    return FlatButton(
        color: Colors.blueAccent,

        child: Text(_cardSelected ? 'Efetuar Pagamento': 'Selecionar Cartão',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        onPressed: () {
          if (_cardSelected) {
            if (_hourSelect != "Selecione") {
              if (!_isLoading) {
                setState(() {
                  _isLoading = true;
                });
                processPayment();
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Por favor, selecione um turno antes de efetuar pagamento!"),
                backgroundColor: Colors.blueAccent,
                duration: Duration(seconds: 3),
              ));
            }
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CardListScreen(auth: widget.auth, userId: widget.userId, processPayment: true)))
                .then((value) {
              if (value != null) {
                setState(() {
                  _cardSelected = true;
                  _card = value;
                });
              }
            });
          }
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        bottomNavigationBar: SafeArea(child: getFooterBtn()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          _currentMonth,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        )),
                    FlatButton(
                      child: Text('<'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month -1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('>'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month +1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    children: <Widget>[
                      getCalendarLayout(),
                      getHourLayout(),
//                      getInstallmentQuantityLayout(),
                      _showCircularProgress()
                    ]
                ),
              ), //
            ],
          ),
        ));
  }
}