import 'package:bandhanmitra/mainwrapper.dart';
import 'package:flutter/material.dart';
import 'screens/loginscreen.dart'; // Adjust the path if needed
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhoneLoginScreen(), // Replace with your main screen widget
    );
  }
}
