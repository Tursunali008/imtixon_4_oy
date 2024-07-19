import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* _firestore.collection('users').snapshots();
  }

  Future<void> addUser(String name) async {

    Map<String, dynamic> data = {
      "user-name": name,
      'user-email': FirebaseAuth.instance.currentUser!.email,
      'user-token': await FirebaseMessaging.instance.getToken(),
    };
    _firestore.collection('users').add(data);
  }
}