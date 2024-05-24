import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class keycodePage extends StatefulWidget {
  keycodePage(
      {super.key, required this.safeBoxNumber, required this.boxDoorNumber});
  String safeBoxNumber;

  String boxDoorNumber;
  @override
  State<keycodePage> createState() => _keycodePageState();
}

class _keycodePageState extends State<keycodePage> {
  late DatabaseReference _dbRef;

  late DatabaseReference _boolRef;
  late Future<void> _initFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dbRef = FirebaseDatabase.instance.ref().child(
        "safeboxes/${widget.safeBoxNumber}/${widget.boxDoorNumber}/keycode");

    _boolRef = FirebaseDatabase.instance.ref().child(
        "safeboxes/${widget.safeBoxNumber}/${widget.boxDoorNumber}/bool");
    _initFuture = _initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dbRef.set("");
    _boolRef.set("");
  }

  @override
  void setState(VoidCallback) {
    if (mounted) {
      super.setState(() {});
    }
  }

  Future<void> _initialize() async {
    var random = Random();
    int randomNumber = 1000 + random.nextInt(9000);
    await _dbRef.set(randomNumber.toString());

    return;
  }

  Future<DataSnapshot> _getRandomNumberSnapshot() async {
    DatabaseEvent event = await _dbRef.once();
    return event.snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "Lütfen Ekrandaki şifreyi kasasaya giriniz!",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
                FutureBuilder<DataSnapshot>(
                  future: _getRandomNumberSnapshot(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final randomNumber = snapshot.data!.value.toString();
                      return Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.green),
                          child: Center(
                              child: Text(
                            randomNumber,
                            style: TextStyle(fontSize: 32),
                          )));
                    } else {
                      return Text('Veri yok');
                    }
                  },
                ),
                StreamBuilder(
                  stream: _boolRef.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      Object? map = snapshot.data!.snapshot.value as dynamic;

                      return Text(map == "1" ? "Kasa başarıyla açıldı" : "");
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
