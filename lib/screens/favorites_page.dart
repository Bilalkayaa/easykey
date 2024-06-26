import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/bloc/favs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ads.dart';
import 'ad_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  final userData;

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
              padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: MediaQuery.of(context).size.height / 8,
                  bottom: 75),
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
                        !adSnapshot.data!.exists ||
                        adSnapshot.data!['isvisible'] != "1") {
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
                              builder: (context) => BlocProvider(
                                create: (context) => FavsBloc(
                                    firestore: FirebaseFirestore.instance,
                                    userId: widget.userData['id']),
                                child: adDetail(
                                  ad: ad,
                                  userData: widget.userData,
                                ),
                              ),
                            )),
                        contentPadding: EdgeInsets.all(0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                ad.images.isNotEmpty
                                    ? ad.images[0]
                                    : 'https://i.pinimg.com/736x/a1/59/97/a1599763f7d4a5200a7af45086abad3f.jpg',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.network(
                                    'https://i.pinimg.com/736x/a1/59/97/a1599763f7d4a5200a7af45086abad3f.jpg',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  );
                                },
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
}
