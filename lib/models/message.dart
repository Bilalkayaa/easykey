import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late final String senderID;
  late final String senderEmail;
  late final String receiverId;
  late final String message;
  late final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderEmail,
      required this.receiverId,
      required this.message,
      required this.timestamp});
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverId,
      'message': message,
      'timestamp': timestamp
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        senderID: map['senderID'],
        senderEmail: map['senderEmail'],
        receiverId: map['recieverID'],
        message: map['message'],
        timestamp: map['timestamp']);
  }
}
