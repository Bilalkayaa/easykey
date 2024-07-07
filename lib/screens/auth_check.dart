import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/custom/custom_color.dart';
import 'package:easykey/screens/loginandsignup/login_page.dart';
import 'package:easykey/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatelessWidget {
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: CustomColors.primaryColor,
              child: Center(
                  child: CircularProgressIndicator(
                color: CustomColors.secondaryColor,
              )));
        } else if (snapshot.hasData) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: CustomColors.primaryColor,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: CustomColors.secondaryColor,
                    )));
              } else if (userSnapshot.hasData) {
                return MainPage(userData: userSnapshot.data!);
              } else {
                return LoginPage(); // Kullanıcı verisi çekilemezse giriş sayfasına yönlendir
              }
            },
          );
        } else {
          return LoginPage(); // Giriş sayfası widget'ınızı burada çağırın
        }
      },
    );
  }
}
