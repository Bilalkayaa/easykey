import 'package:cloud_firestore/cloud_firestore.dart';

class visitor {
  String? visitorId;
  String? visitedadId;
  String? ownerId;
  Timestamp? timestamp;

  visitor({this.visitorId, this.visitedadId, this.ownerId, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'visitorId': visitorId,
      'visitedadId': visitedadId,
      'ownerId': ownerId,
      'timestamp': timestamp,
    };
  }

  factory visitor.fromMap(Map<String, dynamic> map) {
    return visitor(
        visitorId: map['visitorId'],
        visitedadId: map['visitedadId'],
        ownerId: map['ownerId'],
        timestamp: map['timestamp']);
  }
}
