import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/homepage.dart';
import 'screens/walkthrough.dart';
import 'services/dbdata.dart';
import 'utils/getdiseases.dart';



void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Retrieve the device cameras

  } on Exception catch (e) {
    print(e);
  }

  await Firebase.initializeApp();
  await fetchData();
  await fetchList();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AarogyaSheti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryIconTheme: IconThemeData(color: Colors.black)
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? HomePage()
          :WalkThrough(),
    );
  }
}

