import 'package:easykey/Custom/custom_color.dart';
import 'package:easykey/screens/loginandsignup/signup_page.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  void Chngvisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  final AuthService _auth = AuthService();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: CustomColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120),
                    )),
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        Container(
                          child: Text(
                            "EasyKey",
                            style: TextStyle(fontSize: 32, letterSpacing: 2),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      8.0), // Aralık eklemek için margin kullanıyoruz
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: "Kullanıcı adı",
                                    hintText: "",
                                    prefixIcon: Icon(Icons.person)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                obscureText: isHidden,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .black), // Focus olduğunda alt çizgi rengi
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  labelText: "Şifre",
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintText: "",
                                  prefixIcon: Icon(
                                    Icons.key,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: Chngvisibility,
                                      icon: isHidden
                                          ? Icon(
                                              Icons.visibility,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.visibility_off,
                                              color: Colors.black,
                                            )),
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Henüz üye değil misin?",
                                    textAlign: TextAlign.right,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupPage(),
                                        )),
                                    child: Text(
                                      "Tıkla Üye ol!",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading =
                                        true; // İşlem başladığında bekleme animasyonunu göster
                                  });
                                  await _auth.signIn(context,
                                      email: emailController.text,
                                      password: passwordController
                                          .text); // Giriş işlemini yap
                                  setState(() {
                                    _isLoading =
                                        false; // İşlem tamamlandığında bekleme animasyonunu kaldır
                                  });
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: CustomColors.secondaryColor,
                                      )
                                    : Text(
                                        'Giriş yap',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              )),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
    );
  }
}
