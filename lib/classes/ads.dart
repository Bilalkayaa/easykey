class ads {
  List<String> images;
  String? uid;
  String? aid;
  String? date;
  String? hour;
  String? address;
  String? title;
  String? description;
  String? price;

  ads({
    required this.images,
    required this.uid,
    required this.aid,
    required this.date,
    required this.hour,
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
      'Date': date,
      'Hour': hour,
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
      date: map['Date'],
      hour: map['Hour'],
      address: map['Address'],
      description: map['Description'],
      title: map['Title'],
      price: map['Price'],
    );
  }
}
