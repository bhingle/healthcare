import 'package:flutter/material.dart';
import 'package:my_app/page/DoctorDetails.dart';
import 'package:my_app/page/DoctorDetails.dart';
import 'package:my_app/page/PatientDetails.dart';

class UserType extends StatelessWidget {
  const UserType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Who are you"),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetails(),
                      ),
                    );
                  },
                  child: Text("Doctor")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.indigo, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetails(),
                      ),
                    );
                  },
                  child: Text("Patient"))
            ],
          ),
        ),
      ),
    );
  }
}
