import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
            onPressed: () {}, child: Icon(Icons.add_rounded)),
        appBar: AppBar(
          title: Text("EasyKey"),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(5),
            itemCount: 20,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(5),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/19451835/pexels-photo-19451835/free-photo-of-wooden-cabin-in-winter.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                          ),
                          Text(
                            "1.350.000 TL",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Bahçelievler satılı 3+1",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {}, child: Text("Ara"))),
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {}, child: Text("Mesaj"))),
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Whatsapp"))),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          elevation: 0,
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          child: TabBar(tabs: [
            Tab(
              text: "İlan Ara",
              icon: Icon(Icons.search),
            ),
            Tab(
              text: "Favorilerim",
              icon: Icon(Icons.favorite),
            ),
            Tab(
              text: "Kayıtlı Aramalar",
              icon: Icon(Icons.bookmark),
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
