import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];
  
  CollectionReference usersRef = db.collection('users');
  QuerySnapshot usersSnapshot = await usersRef.get();

  usersSnapshot.docs.forEach((doc) {
    users.add(doc.data());
  });

  return users;
}