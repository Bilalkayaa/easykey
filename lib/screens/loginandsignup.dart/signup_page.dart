import 'package:easykey/Custom/custom_color.dart';
import 'package:easykey/screens/id_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isHidden = true;
  void Chngvisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              flex: 6,
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
                          height: 100,
                        ),
                        Container(
                          child: Text(
                            "Kayıt Ol",
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
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                focusNode: FocusNode(skipTraversal: false),
                                decoration: InputDecoration(
                                    hintText: "example@example.com",
                                    labelText: "Kullanıcı adını giriniz",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: Icon(Icons.person)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                obscureText: isHidden,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText:
                                      "Şifreniz minimum 6 haneli olmalıdır.",
                                  labelText: "Şifrenizi giriniz",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.normal),
                                  prefixIcon: Icon(Icons.key),
                                  suffixIcon: IconButton(
                                      onPressed: Chngvisibility,
                                      icon: isHidden
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical:
                                      8.0), // Aralık eklemek için margin kullanıyoruz
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 11,
                                decoration: InputDecoration(
                                    hintText:
                                        "11 haneli telefon numaranızı giriniz.",
                                    labelText: "Telefon numarası",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: Icon(Icons.phone)),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Geri',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (emailController.text.isEmpty ||
                                            passwordController.text.isEmpty ||
                                            phoneController.text.isEmpty ||
                                            phoneController.text.length < 11 ||
                                            passwordController.text.length <
                                                6 ||
                                            !isEmailValid(
                                                emailController.text)) {
                                          Get.snackbar(
                                            'Hata',
                                            "Lütfen bilgilerinizi eksiksiz ve doğru bir şekilde doldurunuz!",
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => idScan(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                phonenumber:
                                                    phoneController.text,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Devam et',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

  bool isEmailValid(String email) {
    // E-posta adresi için düzen ifadesi
    RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

    // Verilen e-posta adresini kontrol et
    if (emailRegExp.hasMatch(email)) {
      return true; // Geçerli e-posta adresi
    } else {
      return false; // Geçersiz e-posta adresi
    }
  }
}
