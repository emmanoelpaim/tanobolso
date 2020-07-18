import 'package:tanobolso/models/history_trip.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';

part 'retrofit.g.dart';

// EVER AFTER CHANGE THIS FILE, RUN "flutter pub run build_runner build"

@RestApi(baseUrl: "https://us-central1-celebra-6dd8b.cloudfunctions.net/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;


  @POST("sendMailUser")
  Future<String> postSendMail(@Body() JsonSendMail json);

  @POST("tokenizationCard")
  Future<String> postTokenizationCard(@Body() JsonTokenizationCard json);

  @POST("processPayment")
  Future<String> postProcessPayment(@Body() JsonProcessPayment json);

//  @POST("historyTripByUidUser")
//  Future<List<HistoryTrip>> postHistoryTripByUidUser(@Body() JsonUidUser json);
}

@JsonSerializable()
class JsonSendMail {
  String email;

  JsonSendMail(this.email);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email
  };
}

@JsonSerializable()
class JsonProcessPayment {
  String paymentType = "Credito";
  JsonCardProcessPayment jsonCard;
  String customer;
  List<JsonItemProcessPayment> listItem;

  JsonProcessPayment(this.jsonCard, this.customer, this.listItem);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'PaymentType': paymentType,
    'card': jsonCard.toJson(),
    'customer': customer,
    'listItems': listItem
  };
}

@JsonSerializable()
class JsonCardProcessPayment {
  String token;
  int installmentQuantity;

  JsonCardProcessPayment(this.token, this.installmentQuantity);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Token': token,
    'InstallmentQuantity': installmentQuantity

  };
}

@JsonSerializable()
class JsonItemProcessPayment {
  String code;
  String description;
  num value;
  int quantity;

  JsonItemProcessPayment(this.code,this.description,this.value, this.quantity);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'description': description,
    'value': value,
    'quantity': quantity
  };

  @override
  String toString() {
    return '{code: $code, description: $description, value: $value, quantity: $quantity}';
  }
}

@JsonSerializable()
class JsonTokenizationCard {
  String paymentType = "Credito";
  JsonCard jsonCard;

  JsonTokenizationCard(this.jsonCard);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'PaymentType': paymentType,
    'card': jsonCard.toJson()
  };
}

@JsonSerializable()
class JsonCard {
  String holder;
  String cardNumber;
  String expirationDate;
  String securityCode;
  int InstallmentQuantity = 1;

  JsonCard(this.holder, this.cardNumber, this.expirationDate, this.securityCode);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Holder': holder,
    'CardNumber': cardNumber,
    'ExpirationDate': expirationDate,
    'SecurityCode': securityCode,
    'InstallmentQuantity': InstallmentQuantity
  };
}


//@JsonSerializable()
//class JsonUidUser {
//
//  String uidUser;
//
//  JsonUidUser(this.uidUser);
//
//  Map<String, dynamic> toJson() => <String, dynamic>{
//    'uid': uidUser
//  };
//
//}
