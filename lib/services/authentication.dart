import 'dart:async';
import 'package:tanobolso/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<void> saveUser(Map<String, dynamic> userData);

  Future<dynamic> getCurrentUserModel(String uid);

  Future<dynamic> getServicesList();
  Future<dynamic> getServicesListByUid(String uid);

  Future<dynamic> getCardsFromCurrentUserModel(String uid);

  Future<void> deleteUserCard(String cardId, String userId);

  Future<void> saveSchedule(Map<String, dynamic> scheduleData);

  Future<dynamic> getSchedulesList(String date, String serviceId);

  Future<dynamic> getSchedulesListByUser(DateTime date, String userId);

}

class Auth implements BaseAuth {

  Map<String, dynamic> userData = Map();
  Map<String, dynamic> cardData = Map();
  Map<String, dynamic> scheduleData = Map();
  Map<String, dynamic> addressData = Map();

  FirebaseUser firebaseUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<dynamic> getSchedulesList(String date, String serviceId) async {
    String resultado = "";

    var document = await Firestore.instance.collection('schedules').where("dateformat", isEqualTo: date).where("serviceId", isEqualTo: serviceId);

    return document.getDocuments();
  }

  Future<dynamic> getSchedulesListByUser(DateTime date, String userId) async {
    String resultado = "";

    var document = await Firestore.instance.collection('schedules').where("date", isGreaterThanOrEqualTo: date).where("userId", isEqualTo: userId).orderBy("date").orderBy("turnIndex");

    return document.getDocuments();
  }

  Future<void> saveSchedule(Map<String, dynamic> scheduleData) async {
    this.scheduleData = scheduleData;
    await Firestore.instance
        .collection("schedules")
        .add(scheduleData);
  }

  Future<dynamic> getServicesList() async {
    String resultado = "";

    var document = await Firestore.instance.collection('services').orderBy("name");

    return document.getDocuments();

  }

  Future<dynamic> getServicesListByUid(String uid) async {
    var document = await Firestore.instance.collection('services').where("user_create",isEqualTo: uid).orderBy("name");

    return document.getDocuments();

  }

  Future<dynamic> getCurrentUserModel(String uid) async {
    var document = await Firestore.instance.collection('users').document(uid);

    return document.get();

  }

  Future<dynamic> getCardsFromCurrentUserModel(String uid) async {
    String resultado = "";

    var document = await Firestore.instance.collection('users').document(uid).collection("cards");

    return document.getDocuments();

  }

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    firebaseUser = result.user;
    return user.uid;
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<void> saveService(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("services")
        .document()
        .setData(userData);
  }


  Future<void> editUser(Map<String, dynamic> userData, String userId) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .setData(userData);
  }

  Future<void> saveUserCard(Map<String, dynamic> cardData, String userId) async {
    this.cardData = cardData;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("cards")
        .add(cardData);
  }

  Future<void> deleteUserCard(String cardId, String userId) async {
    this.cardData = cardData;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("cards")
        .document(cardId)
        .delete();
  }

  Future<void> saveUserAddress(Map<String, dynamic> addressData, String userId) async {
    this.addressData = addressData;
    await Firestore.instance
        .collection("users")
        .document(userId)
        .setData(addressData);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}