import 'package:cloud_firestore/cloud_firestore.dart';

class Visitservice {
  Future<void> registervisitor({
    required String visitorId,
    required String visitedadId,
    required String ownerId,
  }) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference docRef = await _firestore.collection('visitor').doc();

      final Timestamp timestamp = Timestamp.now();

      await docRef.set({
        'visitorId': visitorId,
        'visitedadId': visitedadId,
        'ownerId': ownerId,
        'timestamp': timestamp,
      });
    } catch (e) {
      // Kayıt işlemi sırasında oluşabilecek hataları ele alın
      print("Kullanıcı kaydı sırasında hata oluştu: $e");
    }
  }
}
