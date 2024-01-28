import 'package:flutter/material.dart';

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
                    color: Colors.green,
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
                                focusNode: FocusNode(skipTraversal: false),
                                decoration: InputDecoration(
                                    hintText: "Kullanıcı adını giriniz",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: Icon(Icons.person)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                obscureText: isHidden,
                                decoration: InputDecoration(
                                  hintText: "Şifrenizi giriniz",
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
                                keyboardType: TextInputType.number,
                                maxLength: 11,
                                decoration: InputDecoration(
                                    hintText: "Telefon numarası",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    prefixIcon: Icon(Icons.phone)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Kayıt ol',
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
