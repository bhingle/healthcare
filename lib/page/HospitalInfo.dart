import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
     List<String> entries = [];
     return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
    
  }
}

