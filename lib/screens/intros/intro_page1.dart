import 'package:easykey/custom/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatefulWidget {
  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 150.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/forSale3.json',
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15.0),
            const Center(
              child: Text(
                "Evini müşterilere sunabilirsin!",
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
