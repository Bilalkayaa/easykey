import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .where('id', isEqualTo: uid)
            .get();

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(
                        userData: userData,
                      )));
        });
      }
    } catch (e) {
      Get.snackbar('Hata', "Girdiğiniz bilgilerin doğruluğundan emin olun!",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String TCKN,
    required String name,
    required String surname,
    required String Birthdate,
    required String SerialNumber,
    required String ValidUntil,
    required String PhoneNumber,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;
      if (userCredential.user != null) {
        await registerUser(
            email: email,
            TCKN: TCKN,
            name: name,
            surname: surname,
            Birthdate: Birthdate,
            SerialNumber: SerialNumber,
            ValidUntil: ValidUntil,
            PhoneNumber: PhoneNumber,
            uid: uid);
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.message ?? "An error occurred");
    }
  }

  Future<void> registerUser(
      {required String email,
      required String TCKN,
      required String name,
      required String surname,
      required String Birthdate,
      required String SerialNumber,
      required String ValidUntil,
      required String PhoneNumber,
      required String uid}) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection('users').doc(uid).set({
        "Email": email,
        "TCKN": TCKN,
        "Name": name,
        "Surname": surname,
        "Birthdate": Birthdate,
        "SerialNumber": SerialNumber,
        "ValidUntil": ValidUntil,
        "PhoneNumber": PhoneNumber,
        "id": uid,
        "Favs": []
      });
    } catch (e) {
      print("Kullanıcı kaydı sırasında hata oluştu: $e");
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
