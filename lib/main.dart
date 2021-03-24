import 'package:flutter/material.dart';
import 'package:my_app/page/FirstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/page/HospitalInfoView.dart';
import 'package:my_app/page/HospitalInfo.dart';


// import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:my_app/page/UserType.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        // home: HomePage(),
        home:FirstPage(),
      
      );
}
