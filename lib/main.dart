import 'package:easykey/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'intros/OnBoarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    print("Firebase Initialization Error: $error");
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? showOnboarding = prefs.getBool('showOnboarding');

  runApp(MyApp(showOnboarding: showOnboarding == null));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: showOnboarding ? OnBoarding() : LoginPage(),
    );
  }
}
