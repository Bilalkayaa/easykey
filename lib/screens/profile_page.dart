import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key, required this.uid, required this.userData});
  final String uid;
  final Map<String, dynamic> userData;

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
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
              widget.userData['Name'] ?? 'Bilinmeyen',
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
          ],
        ),
      ),
    );
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    // return FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(widget.uid).get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }

    //     if (snapshot.hasData && !snapshot.data!.exists) {
    //       return Text("Document does not exist");
    //     }

    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       return Text("Full Name: ${data['full_name']} ${data['last_name']}");
    //     }

    //     return Text("loading");
    //   },
    // );
  }
}
