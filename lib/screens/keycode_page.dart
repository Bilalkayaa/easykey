import 'dart:math';

import 'package:flutter/material.dart';

class keycodePage extends StatefulWidget {
  const keycodePage({super.key});

  @override
  State<keycodePage> createState() => _keycodePageState();
}

class _keycodePageState extends State<keycodePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var random = Random();
    int randomNumber = 1000 + random.nextInt(9000);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Lütfen Ekrandaki şifreyi kasasaya giriniz")),
          Center(child: Text(randomNumber.toString()))
        ],
      ),
    );
  }
}
