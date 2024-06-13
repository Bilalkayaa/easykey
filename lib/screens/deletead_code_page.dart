import 'dart:async';
import 'dart:math';

import 'package:easykey/services/firebase_post_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class deleteAdCode extends StatefulWidget {
  deleteAdCode(
      {super.key,
      required this.safeBoxNumber,
      required this.boxDoorNumber,
      required this.adId});
  String safeBoxNumber;

  String boxDoorNumber;
  String adId;
  @override
  State<deleteAdCode> createState() => _deleteAdCodeState();
}

class _deleteAdCodeState extends State<deleteAdCode>
    with WidgetsBindingObserver {
  late DatabaseReference _dbRef;
  late DatabaseReference _boolRef;
  late Future<void> _initFuture;

  Postservice _post = Postservice();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dbRef = FirebaseDatabase.instance.ref().child(
        "safeboxes/${widget.safeBoxNumber}/${widget.boxDoorNumber}/deletecode");

    _boolRef = FirebaseDatabase.instance.ref().child(
        "safeboxes/${widget.safeBoxNumber}/${widget.boxDoorNumber}/deletebool");
    _initFuture = _initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dbRef.set("");
    _boolRef.set("");
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _resetDatabase();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _initialize();
      });
    }
  }

  Future<void> _resetDatabase() async {
    try {
      await _dbRef.set("");
      await _boolRef.set("");
      print("Veritabanı başarıyla sıfırlandı.");
    } catch (e) {
      print("Veritabanı sıfırlama sırasında hata oluştu: $e");
    }
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

                      if (map == "1") {
                        Future.microtask(() async {
                          await _post.deleteAd(widget.adId);
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Bilgilendirme'),
                                content: Text(
                                    'İlanınız başarıyla silindi. Anahtarınızı almayı unutmayınız!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Dialogu kapat
                                    },
                                    child: Text('Tamam'),
                                  ),
                                ],
                              );
                            },
                          );
                        });

                        return SizedBox.shrink(); // Boş bir widget döndür
                      } else {
                        return Text("Kodu girmeniz bekleniyor");
                      }
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
