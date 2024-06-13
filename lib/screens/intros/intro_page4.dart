import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../custom/custom_color.dart';

class IntroPage4 extends StatefulWidget {
  @override
  _IntroPage4State createState() => _IntroPage4State();
}

class _IntroPage4State extends State<IntroPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 150.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/deal1.json',
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15.0),
            const Center(
              child: Text(
                "Sat, satın al, kirala!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Center(
              child: Text("Detaylı açıklama yazılabilir."),
            )
          ],
        ),
      ),
    );
  }
}
