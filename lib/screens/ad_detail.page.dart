import 'package:flutter/material.dart';

import '../classes/ads.dart';

class adDetail extends StatefulWidget {
  const adDetail({super.key, required this.ad});
  final ads ad;
  @override
  State<adDetail> createState() => _adDetailState();
}

class _adDetailState extends State<adDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan Detayı'),
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
            Text(
              widget.ad.title ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8),
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
              'UID: ${widget.ad.uid}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
