class HistoryTrip {
  String uid;
  String uidUser;
  String data;
  String destino;
  String partida;
  double valor;

  HistoryTrip({this.uid, this.uidUser, this.data, this.destino, this.partida, this.valor});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    map['uidUser'] = uidUser;
    map['data'] = data;
    map['destino'] = destino;
    map['partida'] = partida;
    map['valor'] = valor;

    return map;
  }

  factory HistoryTrip.fromJson(Map<String, dynamic> json) {
    return HistoryTrip(
        uid: json['uid'] as String,
        uidUser: json['uidUser'] as String,
        data: json['data'] as String,
        destino: json['destino'] as String,
        partida: json['partida'] as String,
        valor: json['valor'].toDouble() as double
    );
  }

  HistoryTrip.fromMapObject(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.uidUser = map['uidUser'];
    this.data = map['data'];
    this.destino = map['destino'];
    this.partida = map['partida'];
    this.valor = map['valor'];
  }


}