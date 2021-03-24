import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HospitalInfo extends StatefulWidget {
  HospitalInfo({Key key}) : super(key: key);

  @override
  _HospitalInfoState createState() => _HospitalInfoState();
}

class _HospitalInfoState extends State<HospitalInfo> {
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

