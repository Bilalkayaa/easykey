import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Postservice {
  Future<void> registerAds({
    required List<String> images,
    required String uid,
    required Timestamp timestamp,
    required String address,
    required String title,
    required String description,
    required String price,
    required String floor,
    required String number,
    required String safeBoxNumber,
    required String boxDoorNumber,
    required String isvisible,
  }) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference docRef = await _firestore.collection('ads').doc();
      String aid = docRef.id;

      await docRef.set({
        'images': images,
        'uid': uid,
        'aid': aid,
        'Timestamp': timestamp,
        'Address': address,
        'Title': title,
        'Description': description,
        'Price': price,
        'Floor': floor,
        'Number': number,
        'safeBoxNumber': safeBoxNumber,
        'boxDoorNumber': boxDoorNumber,
        'isvisible': "1",
      });
    } catch (e) {
      // Kayıt işlemi sırasında oluşabilecek hataları ele alın
      print("Kullanıcı kaydı sırasında hata oluştu: $e");
    }
  }

  void RemoveFromFavorites(String? adId) async {
    try {
      // Tüm kullanıcıları al ve favs alanından ilan ID'sini kaldır
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Tüm kullanıcılar üzerinde dönerken asenkron işlemlerin tamamlanmasını beklemek için Future.forEach kullanın
      await Future.forEach(usersSnapshot.docs, (userDoc) async {
        // Kullanıcının data alanını Map olarak belirtin
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('Favs')) {
          List<dynamic> favs = List.from(userData['Favs']);

          // Eğer ilan ID'si favs alanında varsa, kaldır
          if (favs.contains(adId)) {
            favs.remove(adId);
            // Kullanıcının favs alanını güncelle
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userDoc.id)
                .update({
              'Favs': favs,
            });
          }
        }
      });

      print('İlan kullanıcıların favorilerinden kaldırıldı.');
    } catch (error) {
      print('Hata oluştu: $error');
    }
  }

  void deleteAd(String? adId) {
    FirebaseFirestore.instance
        .collection('ads')
        .doc(adId)
        .delete()
        .then((value) => print('İlan silindi'))
        .catchError((error) => print('Hata: $error'));
  }

  void addToFavorites(context, dynamic aid, dynamic userDataid) {
    // Firebase Firestore'daki favoriler koleksiyonuna ilan ID'sini ekleyin
    FirebaseFirestore.instance.collection('users').doc(userDataid).update({
      'Favs': FieldValue.arrayUnion([aid]),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Favorilere eklendi.'),
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      print('Hata: $error');
    });
  }

  void removeFromFavorites(context, dynamic aid, dynamic userDataid) {
    // Firebase Firestore'daki favoriler koleksiyonundan ilan ID'sini kaldırın
    FirebaseFirestore.instance.collection('users').doc(userDataid).update({
      'Favs': FieldValue.arrayRemove([aid]),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Favorilerden kaldırıldı.'),
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      print('Hata: $error');
    });
  }
}
