import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void onPressed() {
  FirebaseFirestore.instance.collection("hospitals").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.data()['hospital_name']);
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return Container(
       child: ElevatedButton(onPressed: onPressed, child: Text("Test")),
    );
    
  }
}

