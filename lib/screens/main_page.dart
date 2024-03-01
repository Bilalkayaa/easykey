import 'package:easykey/Custom/custom_color.dart';
import 'package:easykey/screens/ads_add_page.dart';
import 'package:easykey/screens/advertisement_page.dart';
import 'package:easykey/screens/favorites_page.dart';
import 'package:easykey/screens/myads_page.dart';
import 'package:easykey/screens/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.uid, required this.userData});
  final String uid;
  final userData;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ScrollController scrollController;
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      print(scrollController.offset);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: CustomColors.primaryColor,
            foregroundColor: CustomColors.secondaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addAdd(userData: widget.userData),
                  ));
            },
            child: Icon(Icons.add_rounded)),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          automaticallyImplyLeading: false,
          title: Text("EasyKey"),
          backgroundColor: CustomColors.primaryColor,
        ),
        body: TabBarView(children: [
          advertPage(userData: widget.userData),
          FavoritesPage(userData: widget.userData),
          myAdsPage(id: widget.uid, userData: widget.userData),
          profilePage(uid: widget.uid, userData: widget.userData)
        ]),
        bottomNavigationBar: BottomAppBar(
          elevation: 99,
          color: CustomColors.primaryColor,
          clipBehavior: Clip.antiAlias,
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          child: TabBar(
              unselectedLabelColor: CustomColors.secondaryColor,
              labelColor: Colors.lightBlueAccent,
              indicator: BoxDecoration(),
              tabs: [
                Tab(
                  text: "İlanlar",
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: "Favorilerim",
                  icon: Icon(Icons.favorite),
                ),
                Tab(
                  text: "İlanlarım",
                  icon: Icon(Icons.list),
                ),
                Tab(
                  text: "Hesabım",
                  icon: Icon(Icons.account_circle),
                )
              ]),
        ),
      ),
    );
  }
}
