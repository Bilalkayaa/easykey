import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Custom/custom_color.dart';

class IntroPage3 extends StatefulWidget {
  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 150.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/deal2.json',
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15.0),
            const Center(
              child: Text(
                "İstediğin an evlere ulaşma imkanı!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
