import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/page/NavPage.dart';

class DoctorDetails extends StatefulWidget {
  DoctorDetails({Key key}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  var fileUrl;
  File file;
  var fileNameText = "No File Choosed";

  TextEditingController data1 = new TextEditingController();
  TextEditingController data2 = new TextEditingController();
  TextEditingController data3 = new TextEditingController();
  TextEditingController data4 = new TextEditingController();
    TextEditingController data5 = new TextEditingController();
  uploadReport() async {
    final _firebaseStorage = FirebaseStorage.instance;

    if (file != null) { 
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child(
              'doctors/${FirebaseAuth.instance.currentUser.uid}/${Path.basename(file.path)}')
          .putFile(file);
      fileUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        uploadData();
      });
    } else {
      print('No Image file Received');
    }
  }

  void uploadData() {
    final user = FirebaseAuth.instance.currentUser;
    String name = user.displayName;
    String email = user.email;
    print("in upload data");
    FirebaseFirestore.instance
        .collection("doctorinfo")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'speciality': data1.text,
      'hospital_name': data2.text,
      'contact': data3.text,
      'experience': data4.text,
      'degree_url': fileUrl,
      'name':name,
      'email':email,
      'degree':data5.text
    });
  }

  Future<void> chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      print(file.path);
      setState(() {
        fileNameText = Path.basename(file.path);
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
              hintText: 'eg.Dermatologist',
              labelText: 'Speciality Field  *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Speciality Field " : null);
            },
          ),
          TextFormField(
            controller: data2,
            decoration: const InputDecoration(
              icon: Icon(Icons.home),
              // hintText: 'What do people call you?',
              labelText: 'Hospital Name *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Hospital Name" : null);
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
              return (value.isEmpty ? "Please Enter contact no" : null);
            },
          ),
          TextFormField(
            controller: data4,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              hintText: 'in years',
              labelText: 'Experience *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Experience" : null);
            },
          ),
          TextFormField(
            controller: data5,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Degree *',
            ),
           
            validator: (value) {
              return (value.isEmpty ? "Please Enter Degree" : null);
            },
          ),
          Text("Upload Medical Degree Certificate", textAlign: TextAlign.end),
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
                                    image:
                                        AssetImage('assets/images/pdfFile.png'),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  child: Image(
                                    width: 100,
                                    height: 150,
                                    image:
                                        AssetImage('assets/images/pdfAdd.png'),
                                  ),
                                ),
                        ),
                        Text(fileNameText),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // background
                    onPrimary: Colors.white, // foreground
                  ),
              onPressed: () {
                uploadReport();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavPage(),
                  ),
                );
              },
              child: Text("submit"))
        ],
      ),
    );
  }
}
