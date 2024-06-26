import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/bloc/favs_bloc.dart';
import 'package:easykey/bloc/favs_event.dart';
import 'package:easykey/bloc/favs_state.dart';
import 'package:easykey/custom/custom_color.dart';
import 'package:easykey/screens/keycode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
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
    super.didChangeDependencies();
  }

  void dispose() {
    super.dispose();
    print('dispose çağrıldı');
  }

  @override
  Widget build(BuildContext context) {
    const double fontsize1 = 16;
    const double fontsize2 = 26;
    final favsBloc = BlocProvider.of<FavsBloc>(context);
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
                BlocBuilder<FavsBloc, FavsState>(
                  builder: (context, state) {
                    var isFavorite = state.favorites.contains(widget.ad.aid);
                    return IconButton(
                      icon: Icon(
                        color: isFavorite ? Colors.red : null,
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          favsBloc
                              .add(RemoveFromFavorites(widget.ad.aid ?? ""));
                        } else {
                          favsBloc.add(AddToFavorites(widget.ad.aid ?? ""));
                        }
                      },
                    );
                    // return IconButton(
                    //     onPressed: () {
                    //       if (isfav == true) {
                    //         setState(() {
                    //           isfav = false;

                    //           _post.removeFromFavorites(context, widget.ad.aid,
                    //               widget.userData['id']);
                    //         });
                    //       } else {
                    //         setState(() {
                    //           isfav = true;

                    //           _post.addToFavorites(context, widget.ad.aid,
                    //               widget.userData['id']);
                    //         });
                    //       }
                    //     },
                    //     icon: isfav
                    //         ? Icon(
                    //             Icons.favorite,
                    //             color: Colors.red,
                    //           )
                    //         : Icon(Icons.favorite_border));
                  },
                )
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
              'Durumu: ${widget.ad.status ?? ""}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.key),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => keycodePage(
                              ad: widget.ad,
                              userData: widget.userData,
                              safeBoxNumber: widget.ad.safeBoxNumber ?? "",
                              boxDoorNumber: widget.ad.boxDoorNumber ?? ""),
                        ));
                  },
                  label: Text("Ziyaret Et!"),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.location_on),
                  onPressed: () async {
                    final availableMap = await MapLauncher.installedMaps;

                    if (widget.ad.safeBoxNumber == "1001") {
                      await availableMap.first.showMarker(
                          coords: Coords(41.095170, 28.865339),
                          title: "1001 Numaralı Kasa");
                    } else if (widget.ad.safeBoxNumber == "1002") {
                      await availableMap.first.showMarker(
                          coords: Coords(40.8724088, 29.2570002),
                          title: "1002 Numaralı Kasa");
                    } else if (widget.ad.safeBoxNumber == "1003") {
                      await availableMap.first.showMarker(
                          coords: Coords(41.0060047, 28.8851437),
                          title: "1003 Numaralı Kasa");
                    }
                    ;
                  },
                  label: Text("Yol Tarifi Al"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
