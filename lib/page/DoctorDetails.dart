import 'package:flutter/material.dart';


class DoctorDetails extends StatefulWidget {
  DoctorDetails({Key key}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         children: [
           Text("Enter your details"),
           TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.school),
              // hintText: 'What do people call you?',
              labelText: 'Qualification *',
            ),
            // onSaved: (String? value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            validator: (value) {
              return (value.isEmpty ? "Please Enter Qualification" : null);
            },
          ),
         ],
       ),
    );
  }
}