import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/models/message.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(
      String senderID, String? receiverID, Message message) async {
    await _firestore
        .collection('users')
        .doc(senderID)
        .collection('chat')
        .doc(receiverID)
        .set({
      "senderid": senderID,
      "receiverid": receiverID,
    });

    await _firestore
        .collection('users')
        .doc(senderID)
        .collection('chat')
        .doc(receiverID)
        .collection('messages')
        .add(message.toMap());

    await _firestore
        .collection('users')
        .doc(receiverID)
        .collection('chat')
        .doc(senderID)
        .set({
      "senderid": senderID,
      "receiverid": receiverID,
    });

    await _firestore
        .collection('users')
        .doc(receiverID)
        .collection('chat')
        .doc(senderID)
        .collection('messages')
        .add(message.toMap());
  }
}
