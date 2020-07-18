class ServiceModel {
  String description;
  String name;
  String price;
  String type;
  int slots;

  ServiceModel({
    this.description,
    this.name,
    this.price,
    this.type,
    this.slots
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['description'] = description;
    map['name'] = name;
    map['price'] = price;
    map['type'] = type;
    map['slots'] = slots;

    return map;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return ServiceModel(
        description: json['description'] as String,
        name: json['name'] as String,
        price: json['price'] as String,
        type: json['type'] as String,
        slots: json['slots'] as int
    );
  }

  ServiceModel.fromMapObject(Map<String, dynamic> map) {
    this.description = map['description'];
    this.name = map['name'];
    this.price = map['price'].toString();
    this.type = map['type'];
    this.slots = map['slots'];
  }

}