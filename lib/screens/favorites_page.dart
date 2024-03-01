import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../classes/ads.dart';
import '../classes/user.dart';
import 'ad_detail.page.dart';

class FavoritesPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const FavoritesPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData['id'])
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Kullanıcı bulunamadı.',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          List<dynamic> favoriteAds = snapshot.data!.get('Favs') ?? [];
          if (favoriteAds.isEmpty) {
            return Center(
                child: Text(
              'Henüz favori ilanınız yok.',
              style: TextStyle(fontSize: 20),
            ));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(5),
              itemCount: favoriteAds.length,
              itemBuilder: (context, index) {
                String adId = favoriteAds[index];
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('ads')
                      .doc(adId)
                      .get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> adSnapshot) {
                    if (adSnapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(); // Veri yüklenene kadar boş bir widget döndür
                    }
                    if (adSnapshot.hasError ||
                        !adSnapshot.hasData ||
                        !adSnapshot.data!.exists) {
                      return SizedBox(); // Hata durumunda veya ilan bulunamazsa boş bir widget döndür
                    }

                    ads ad = ads.fromMap(
                        adSnapshot.data!.data() as Map<String, dynamic>);
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => adDetail(
                                    ad: ad,
                                    userData: widget.userData,
                                  )),
                        ),
                        contentPadding: EdgeInsets.all(0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                ad.images.isNotEmpty ? ad.images[0] : '',
                                width: double
                                    .infinity, // Resmi genişliği ekrana sığacak şekilde ayarla
                                height:
                                    200, // Resmin yüksekliğini ayarla (isteğe bağlı)
                                fit: BoxFit
                                    .cover, // Resmi uygun şekilde boyutlandır
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${ad.title}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ad.title ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> checkFavorite(List<ads> adsList) async {
    try {
      // Kullanıcının belgesine erişmek için Firestore'dan belgeyi getirin
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData['id'])
          .get();

      // Kullanıcının belgesi varsa ve içeriği varsa devam edin
      if (userSnapshot.exists && userSnapshot.data() != null) {
        // Kullanıcı nesnesini oluşturun
        User user = User.fromMap(userSnapshot.data() as Map<String, dynamic>);

        // Kullanıcının favoriler listesini alın
        List<String> favorites = user.favs;

        // Eğer favoriler listesi varsa ve ilan ID'si listeye dahilse, ilan favorilerde bulunuyor demektir
        adsList.asMap().forEach((index, element) {
          // index: indeks, element: liste öğesi
          if (favorites.contains(element.aid)) {
            print("Index: $index, İlan favorilerde bulunuyor.");
          } else {
            print("Index: $index, İlan favorilerde bulunmuyor.");
          }
        });
      } else {
        print("Kullanıcı bulunamadı veya veri yok.");
      }
    } catch (error) {
      print("Hata: $error");
    }
  }

  void addToFavorites(String adId, String userId) {
    // Firebase Firestore'daki favoriler koleksiyonuna ilan ID'sini ekleyin
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favs': FieldValue.arrayUnion([adId]),
    }).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Favorilere eklendi.')));
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  void removeFromFavorites(String adId, String userId) {
    // Firebase Firestore'daki favoriler koleksiyonundan ilan ID'sini kaldırın
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favs': FieldValue.arrayRemove([adId]),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorilerden kaldırıldı.')));
    }).catchError((error) {
      print('Hata: $error');
    });
  }
}
