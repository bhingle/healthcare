import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/page/HospitalInfo.dart';
import 'package:my_app/page/Stories.dart';
import 'package:my_app/page/sign_up_page.dart';
import 'package:my_app/provider/dbdata.dart';
import 'package:my_app/page/UserType.dart';
import 'package:my_app/page/NavPage.dart';


// import 'package:firebase_auth_web/firebase_auth_web.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await fetchData();
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
        home: FirebaseAuth.instance.currentUser != null
          ? existence == true
              ? NavPage()
              : UserType()
          : SignUpWidget(),
      
      );
}
