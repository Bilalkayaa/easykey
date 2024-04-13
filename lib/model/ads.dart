import 'package:cloud_firestore/cloud_firestore.dart';

class ads {
  List<String> images;
  String? uid;
  String? aid;
  final Timestamp? timestamp;
  String? address;
  String? title;
  String? description;
  String? price;

  ads({
    required this.images,
    required this.uid,
    required this.aid,
    required this.timestamp,
    required this.address,
    required this.description,
    required this.title,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'uid': uid,
      'aid': aid,
      'Timestamp': timestamp,
      'Address': address,
      'Title': title,
      'Description': description,
      'Price': price,
    };
  }

  factory ads.fromMap(Map<String, dynamic> map) {
    return ads(
      images: List<String>.from(map['images'] ?? []),
      uid: map['uid'],
      aid: map['aid'],
      timestamp:
          map['Timestamp'] != null ? (map['Timestamp'] as Timestamp) : null,
      address: map['Address'],
      description: map['Description'],
      title: map['Title'],
      price: map['Price'],
    );
  }
}
