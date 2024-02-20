import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 150.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/searchHome.json',
              width: 250,
              height: 250,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15.0),
            const Center(
              child: Text(
                "İlgini çeken evleri inceleyebilirsin!",
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
