import 'package:easykey/intros/intro_page1.dart';
import 'package:easykey/intros/intro_page2.dart';
import 'package:easykey/intros/intro_page3.dart';
import 'package:easykey/intros/intro_page4.dart';
import 'package:easykey/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Custom/custom_color.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _controller = PageController();

  bool onLastpage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastpage = (index == 3);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(3);
                    },
                    child: Text("Skip")),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: SwapEffect(
                    activeDotColor: CustomColors.secondaryColor,
                    type: SwapType.yRotation,
                    dotHeight: 15.0,
                    dotWidth: 15.0,
                  ),
                ),

                //next or done
                onLastpage
                    ? GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('showOnboarding', false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                        child: Text("Done"),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Next'),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
