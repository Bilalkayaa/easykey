import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/Custom/custom_color.dart';
import 'package:flutter/material.dart';

import '../classes/ads.dart';
import '../classes/user.dart';

class adDetail extends StatefulWidget {
  const adDetail({super.key, required this.ad, required this.userData});
  final ads ad;
  final userData;
  @override
  State<adDetail> createState() => _adDetailState();
}

class _adDetailState extends State<adDetail> {
  late bool isfav = false;

  User? user;
  void initState() {
    _fetchUserData();
    getUserFromFirestore(widget.ad.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan Detayı'),
        backgroundColor: CustomColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlan resimlerini göster
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.ad.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Image.network(
                      widget.ad.images[index],
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // İlan başlığı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ad.title ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (isfav == true) {
                        setState(() {
                          isfav = false;

                          removeFromFavorites();
                        });
                      } else {
                        setState(() {
                          isfav = true;

                          addToFavorites();
                        });
                      }
                    },
                    icon: isfav
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border))
              ],
            ),
            SizedBox(height: 8),
            Text(user?.Name ?? ""),
            // İlan açıklaması
            Text(
              widget.ad.description ?? "",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            // İlan fiyatı
            Text(
              'Fiyat: ${widget.ad.price} TL',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // İlan UID'si
            Text(
              'Adres: ${widget.ad.address}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData['id'])
          .get();

      if (userSnapshot.exists) {
        // Favs alanı var mı kontrol et
        if (widget.userData.containsKey('Favs')) {
          var favs = widget.userData['Favs'];

          // Kontrol etmek istediğiniz değer
          var valueToCheck = widget.ad.aid ?? "";

          // Favs listesinde belirli bir değer var mı kontrol et
          if (favs.contains(valueToCheck)) {
            setState(() {
              // _userData = 'Favs alanı içinde $valueToCheck bulundu.';
              isfav = true;
              print(isfav);
            });
          } else {
            setState(() {
              // _userData = 'Favs alanı içinde $valueToCheck bulunamadı.';
              isfav = false;
              print("{$isfav}asdasd");
            });
          }
        } else {
          // Favs alanında değer yok
          setState(() {
            print("a");
            // _userData = 'Favs alanı bulunamadı.';
          });
        }
      } else {
        // Kullanıcının dökümanı yok
        setState(() {
          print('b');
          // _userData = 'Kullanıcı bulunamadı.';
        });
      }
    } catch (error) {
      print('Hata oluştu: $error');
    }
  }

  void addToFavorites() {
    // Firebase Firestore'daki favoriler koleksiyonuna ilan ID'sini ekleyin
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData['id'])
        .update({
      'Favs': FieldValue.arrayUnion([widget.ad.aid]),
    }).then((_) {
      print('Favorilere eklendi');
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  void removeFromFavorites() {
    // Firebase Firestore'daki favoriler koleksiyonundan ilan ID'sini kaldırın
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData['id'])
        .update({
      'Favs': FieldValue.arrayRemove([widget.ad.aid]),
    }).then((_) {
      print('Favorilerden kaldırıldı');
      print(widget.ad.aid);
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  Future<void> getUserFromFirestore(String? userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userRef = firestore.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data()! as Map<String, dynamic>?;
        setState(() {
          user = User.fromMap(userData!);
        });
      } else {
        print('Belirtilen kullanıcı bulunamadı.');
      }
    } catch (error) {
      print('Firestore veri alımı sırasında bir hata oluştu: $error');
    }
  }
}
