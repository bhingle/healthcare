import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/provider/google_sign_in.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PatientDetails extends StatefulWidget {
  PatientDetails({Key key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  TextEditingController data3 = new TextEditingController();
  TextEditingController data4 = new TextEditingController();

  File file;
  var imageUrl;
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;

    if (file != null) {
      //Upload to Firebase
      var snapshot =
          await _firebaseStorage.ref().child('files/fileName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image file Received');
    }
  }

  Future<void> chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      print(file);
      setState(() {});
    } else {
      // User canceled the picker

    }
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Enter Your Details"),
          TextFormField(
            controller: data1,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              // hintText: 'What do people call you?',
              labelText: 'Age *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Age" : null);
            },
          ),
          TextFormField(
            controller: data2,
            decoration: const InputDecoration(
              icon: Icon(Icons.home),
              // hintText: 'What do people call you?',
              labelText: 'Address *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Address" : null);
            },
          ),
          TextFormField(
            controller: data3,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              // hintText: 'What do people call you?',
              labelText: 'contact *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Address" : null);
            },
          ),
          TextFormField(
            controller: data4,
            decoration: const InputDecoration(
              icon: Icon(Icons.local_hospital),
              // hintText: 'What do people call you?',
              labelText: 'Medical History ',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  chooseFile();
                },
                child: Card(
                  elevation: 10,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    //padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: file != null
                              ? Image.file(
                                  file,
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    width: 100,
                                    height: 150,
                                    image: NetworkImage(
                                      'https://cdn.onlinewebfonts.com/svg/img_133373.png',
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed: (){
            Map<String,dynamic>data ={"field1":data1,"field2":data2,"field3":data3,"field4":data4};
            FirebaseFirestore.instance.collection("patientinfo").add({'age':data1.text,'address':data2.text,'contact':data3.text,'medical_history':data4.text});
          }, child: Text("submit"))
        ],
      ),
    );
  }
}
