class CardModel {
  String numberCard;
  String token;
  String holderCard;

  CardModel({
    this.numberCard,
    this.token,
    this.holderCard
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['numberCard'] = numberCard;
    map['token'] = token;
    map['holderCard'] = holderCard;

    return map;
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return CardModel(
        numberCard: json['numberCard'] as String,
        token: json['token'] as String,
        holderCard: json['holderCard'] as String
    );
  }

  CardModel.fromMapObject(Map<String, dynamic> map) {
    this.numberCard = map['numberCard'];
    this.token = map['token'];
    this.holderCard = map['holderCard'];
  }

}