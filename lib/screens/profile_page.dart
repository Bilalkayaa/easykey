import 'package:easykey/screens/loginandsignup/login_page.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key, required this.uid, required this.userData});
  final String uid;
  final Map<String, dynamic> userData;

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late User user;
  @override
  void initState() {
    super.initState();
    user = User.fromMap(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            Text(
              'İsim',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.userData['Name'] + " " + widget.userData['Surname'] ??
                  'Bilinmeyen',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'E-posta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.userData['Email'] ?? 'Bilinmeyen',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Telefon numarası',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.userData['PhoneNumber'] ?? 'Bilinmeyen',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                },
                label: Text("Çıkış Yap"))
          ],
        ),
      ),
    );
  }
}
