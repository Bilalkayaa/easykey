import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/Custom/custom_color.dart';
import 'package:easykey/screens/keycode_page.dart';
import 'package:easykey/services/firebase_post_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ads.dart';
import '../models/user.dart';
import 'chat_page.dart';

class adDetail extends StatefulWidget {
  const adDetail({super.key, required this.ad, required this.userData});
  final ads ad;
  final userData;
  @override
  State<adDetail> createState() => _adDetailState();
}

class _adDetailState extends State<adDetail> {
  User? user;
  late bool isfav = false;

  void initState() {
    super.initState();
    // _fetchUserData();
    getUserFromFirestore(widget.ad.uid);
    print("object");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    _fetchUserData();
    super.didChangeDependencies();
  }

  void dispose() {
    super.dispose();
    print('dispose çağrıldı');
  }

  Postservice _post = Postservice();
  @override
  Widget build(BuildContext context) {
    const double fontsize1 = 16;
    const double fontsize2 = 26;

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
                      width: 300,
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
                Expanded(
                  child: Text(
                    widget.ad.title ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (isfav == true) {
                        setState(() {
                          isfav = false;

                          _post.removeFromFavorites(
                              context, widget.ad.aid, widget.userData['id']);
                        });
                      } else {
                        setState(() {
                          isfav = true;

                          _post.addToFavorites(
                              context, widget.ad.aid, widget.userData['id']);
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
            Row(
              children: [
                Text(
                  "İlan sahibi: ",
                  style: TextStyle(fontSize: fontsize1),
                ),
                Text(
                  "${(user?.Name)?.toUpperCase()} ${(user?.Surname)?.toUpperCase()}",
                  style: TextStyle(
                      color: CustomColors.primaryColor, fontSize: fontsize1),
                ),
              ],
            ),

            SizedBox(height: 8),

            Row(
              children: [
                Text(
                  "Fiyat: ",
                  style: TextStyle(fontSize: fontsize1),
                ),
                Text(
                  '${widget.ad.price} TL',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontsize1),
                ),
              ],
            ),

            SizedBox(height: 8),
            // İlan UID'si
            Text(
              'Adres: ${widget.ad.address}',
              style: TextStyle(fontSize: fontsize1),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Kat: ${widget.ad.floor ?? ""}',
              style: TextStyle(fontSize: fontsize1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Numara: ${widget.ad.number ?? ""}',
              style: TextStyle(fontSize: fontsize1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Kasa Numarası: ${widget.ad.safeBoxNumber ?? ""}',
              style: TextStyle(fontSize: fontsize1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Kasa Kapı Numaras: ${widget.ad.boxDoorNumber ?? ""}',
              style: TextStyle(fontSize: fontsize1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "İlan açıklaması:",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: fontsize2),
            ),

            Center(
              child: Text(
                widget.ad.description ?? "",
                style: TextStyle(
                  fontSize: fontsize1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.phone),
                  onPressed: () async {
                    // ignore: deprecated_member_use
                    launch('tel:${user!.PhoneNumber}');
                  },
                  label: Text("Ara"),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.message),
                  onPressed: () async {
                    if (widget.ad.uid == widget.userData['id']) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Kendinize mesaj gönderemezsiniz.')));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => chatPage(
                                    id: widget.ad.uid ?? "",
                                    name: user!.Name ?? "",
                                    userData: widget.userData,
                                  )));
                    }
                  },
                  label: Text("Mesaj"),
                ),
              ],
            ),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.key),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => keycodePage(
                            safeBoxNumber: widget.ad.safeBoxNumber ?? "",
                            boxDoorNumber: widget.ad.boxDoorNumber ?? ""),
                      ));
                },
                label: Text("Ziyaret et!"),
              ),
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
          print("durak1");
          // Favs listesinde belirli bir değer var mı kontrol et
          if (favs.contains(valueToCheck) == true) {
            setState(() {
              print("durak2");
              // _userData = 'Favs alanı içinde $valueToCheck bulundu.';
              isfav = true;
              print(isfav);
            });
          } else {
            setState(() {
              print("durak3");
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
