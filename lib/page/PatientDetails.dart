import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/main.dart';
import 'package:my_app/provider/google_sign_in.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/page/NavPage.dart';


class PatientDetails extends StatefulWidget {
  PatientDetails({Key key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

  var fileUrl;
  File file;
  var fileNameText="No File Choosed";
  
  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  TextEditingController data3 = new TextEditingController();
  TextEditingController data4 = new TextEditingController();
  uploadReport() async {
    final _firebaseStorage = FirebaseStorage.instance;

    if (file != null) {
      //Upload to Firebase
      var snapshot =
          await _firebaseStorage.ref().child('patients/${FirebaseAuth.instance.currentUser.uid}/${Path.basename(file.path)}').putFile(file);
      fileUrl = await snapshot.ref.getDownloadURL();
      setState(() {
       
        uploadData();
      }
      
      );
    } else {
      print('No Image file Received');
    }
  }

  void uploadData() {
    print("in upload data");
    Map<String, dynamic> data = {
      "field1": data1,
      "field2": data2,
      "field3": data3,
      "field4": data4
    };
    FirebaseFirestore.instance.collection("patientinfo").doc(FirebaseAuth.instance.currentUser.uid).set({
      'age': data1.text,
      'address': data2.text,
      'contact': data3.text,
      'medical_history': data4.text,
      'report_url':fileUrl
    });
  }

  Future<void> chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      print(file.path);
      setState(() {
        fileNameText=Path.basename(file.path);
      });
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
                              ? Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    width: 100,
                                    height: 150,
                                    // decoration: BoxDecoration(color: Colors. red),
                                    image: AssetImage(
                                      'assets/images/pdfFile.png'),
                                    ),
                                  )
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    width: 100,
                                    height: 150,
                                    image: AssetImage(
                                      'assets/images/pdfAdd.png'),
                                    ),
                                  ),
                                ),
                                Text(fileNameText
                                ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed:(){
            uploadReport();
             Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavPage(),
                          ),
                        );
            
          }, child: Text("submit"))
        ],
      ),
    );
  }
}
