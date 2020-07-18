class User {
  String uid;
  String name;
  String email;
  String phone;
  String service;
  String licenseExpire;
  String licenseNumber;
  String permissionSelect;
  String licenseSelect;
  String boatMiuda;
  String boatPequena;
  String boatMedia;
  String boatGrande;
  String boatMoto;
  String termModify;

  User({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.service,
    this.licenseExpire,
    this.licenseNumber,
    this.permissionSelect,
    this.licenseSelect,
    this.boatMiuda,
    this.boatMedia,
    this.boatGrande,
    this.boatMoto,
    this.termModify
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = uid;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['service'] = service;
    map['licenseExpire'] = licenseExpire;
    map['licenseNumber'] = licenseNumber;
    map['permissionSelect'] = permissionSelect;
    map['licenseSelect'] = licenseSelect;
    map['boatMiuda'] = boatMiuda;
    map['boatMedia'] = boatMedia;
    map['boatGrande'] = boatGrande;
    map['boatMoto'] = boatMoto;
    map['termModify'] = termModify;

    return map;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return User(
        uid: json['uid'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        service: json['service'] as String,
        licenseExpire: json['licenseExpire'] as String,
        licenseNumber: json['licenseNumber'] as String,
        permissionSelect: json['permissionSelect'] as String,
        licenseSelect: json['licenseSelect'] as String,
        boatMiuda: json['boatMiuda'] as String,
        boatMedia: json['boatMedia'] as String,
        boatGrande: json['boatGrande'] as String,
        boatMoto: json['boatMoto'] as String,
        termModify: json['termModify'] as String
    );
  }

  User.fromMapObject(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.name = map['name'];
    this.email = map['email'];
    this.phone = map['phone'];
    this.service = map['service'];
    this.licenseExpire = map['licenseExpire'];
    this.licenseNumber = map['licenseNumber'];
    this.permissionSelect = map['permissionSelect'];
    this.licenseSelect = map['licenseSelect'];
    this.boatMiuda = map['boatMiuda'];
    this.boatMedia = map['uiboatMedia'];
    this.boatGrande = map['boatGrande'];
    this.boatMoto = map['boatMoto'];
    this.termModify = map['termModify'];

  }


}