import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/chatDB.dart';

bool existence;
Future<void> fetchData() async {
  try {
    await FirebaseFirestore.instance
        .collection('patientinfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      existence = value.exists;
    });
    await ChatDBFireStore.makeUserOnline(FirebaseAuth.instance.currentUser);
  } catch (e) {
    print(e);
  }
  if (existence == false) {
    try {
      await FirebaseFirestore.instance
          .collection('doctorinfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        existence = value.exists;
      });
    } catch (e) {
      print(e);
    }
  }
}
 