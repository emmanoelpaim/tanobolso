import 'dart:async';
import 'package:tanobolso/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseServices {
  Future<List<dynamic>> getAllByFilters(String collection, Map<dynamic,Map<dynamic,dynamic>> filters);
  Future<List<dynamic>> getOneByUid(String collection, String uid);

}

class Services implements BaseServices {
  FirebaseUser firebaseUser;

  final Firestore _firestore = Firestore.instance;

  @override
  Future<List> getOneByUid(String collection, String uid) async{
    List one = new List();
    await _firestore.collection(collection).document(uid).get().then((result) {
        one.add(result.data);
    });
    return one;
  }

  @override
  Future<List> getAllByFilters(String collection, Map<dynamic, Map<dynamic, dynamic>> filters) async{
    List all = new List();


    CollectionReference collectionReference = _firestore.collection(collection);
    Query queryFilters;


    if(filters!=null){
      filters.forEach((key, value) {
        if (value.keys.first == "isEqualTo") {
          if(queryFilters == null){
            queryFilters = collectionReference.where(key,isEqualTo: value.values.first);
          } else {
            queryFilters = queryFilters.where(key,isEqualTo: value.values.first);
          }
        }
        if (value.keys.first == "isLessThan") {
          if(queryFilters == null){
            queryFilters = collectionReference.where(key,isLessThan: value.values.first);
          } else {
            queryFilters = queryFilters.where(key,isLessThan: value.values.first);
          }
        }
        if (value.keys.first == "isLessThanOrEqualTo") {
          if(queryFilters == null){
            queryFilters = collectionReference.where(key,isLessThanOrEqualTo: value.values.first);
          } else {
            queryFilters = queryFilters.where(key,isLessThanOrEqualTo: value.values.first);
          }
        }
        if (value.keys.first == "isGreaterThan") {
          if(queryFilters == null){
            queryFilters = collectionReference.where(key,isGreaterThan: value.values.first);
          } else {
            queryFilters = queryFilters.where(key,isGreaterThan: value.values.first);
          }
        }
        if (value.keys.first == "isGreaterThanOrEqualTo") {
          if(queryFilters == null){
            queryFilters = collectionReference.where(key,isGreaterThanOrEqualTo: value.values.first);
          } else {
            queryFilters = queryFilters.where(key,isGreaterThanOrEqualTo: value.values.first);
          }
        }
      });
    }

    await queryFilters
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => all.add(f.data));

    });
    return all;
  }


}