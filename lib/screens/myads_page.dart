import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/screens/ad_detail.page.dart';
import 'package:flutter/material.dart';

import '../classes/ads.dart';

class myAdsPage extends StatefulWidget {
  const myAdsPage({super.key, required this.id, required this.userData});
  final String id;
  final userData;
  @override
  State<myAdsPage> createState() => _myAdsPageState();
}

class _myAdsPageState extends State<myAdsPage> {
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
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ads')
            .where('uid', isEqualTo: widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Bir hata oluştu: ${snapshot.error}');
          } else {
            List<QueryDocumentSnapshot> adsDocuments = snapshot.data!.docs;
            List<ads> adsList = adsDocuments
                .map((document) =>
                    ads.fromMap(document.data() as Map<String, dynamic>))
                .toList();

            return Column(
              children: [
                Expanded(
                  child: adsList.isEmpty
                      ? Center(
                          child: Text(
                            'Herhangi bir ilanınız yok',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(5),
                          itemCount: adsList.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            ads ad = adsList[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Uyarı"),
                                        content: Text(
                                            "Bu ilanı silmek istediğinize emin misiniz?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Dialogu kapat
                                            },
                                            child: Text("Hayır"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Firebase'den ilanı silme işlemi
                                              deleteAd(ad.aid ?? "");
                                              Navigator.of(context)
                                                  .pop(); // Dialogu kapat
                                            },
                                            child: Text("Evet"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => adDetail(
                                                ad: ad,
                                                userData: widget.userData,
                                              ))),
                                  contentPadding: EdgeInsets.all(0),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          ad.images.isNotEmpty
                                              ? ad.images[0]
                                              : '',
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${ad.title}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ad.price ?? "",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 80),
              ],
            );
          }
        },
      ),
    );
  }

  void deleteAd(String adId) {
    FirebaseFirestore.instance
        .collection('ads')
        .doc(adId)
        .delete()
        .then((value) => print('İlan silindi'))
        .catchError((error) => print('Hata: $error'));
  }
}
