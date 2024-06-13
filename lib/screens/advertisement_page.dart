import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/screens/ad_detail_page.dart';
import 'package:flutter/material.dart';

import '../models/ads.dart';

class advertPage extends StatefulWidget {
  const advertPage({super.key, required this.userData});
  final userData;

  @override
  State<advertPage> createState() => _advertPageState();
}

class _advertPageState extends State<advertPage> {
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
            .where('isvisible', isEqualTo: "1")
            // .orderBy('Timestamp', descending: true)
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
                            'Herhangi bir ilan yok',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: MediaQuery.of(context).size.height / 8,
                                    bottom: 75),
                                itemCount: adsList.length,
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  ads ad = adsList[index];

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    margin: EdgeInsets.all(5),
                                    child: ListTile(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => adDetail(
                                                    ad: ad,
                                                    userData: widget.userData,
                                                  ))).whenComplete(() {
                                        setState(() {});
                                      }),
                                      contentPadding: EdgeInsets.all(0),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.network(
                                              ad.images.isNotEmpty
                                                  ? ad.images[0]
                                                  : 'https://i.pinimg.com/736x/a1/59/97/a1599763f7d4a5200a7af45086abad3f.jpg',
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${ad.title}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${ad.price} TL",
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
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
