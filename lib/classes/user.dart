class User {
  String? TCKN;
  String? Name;
  String? Surname;
  String? Birthdate;
  String? SerialNumber;
  String? ValidUntil;
  String? Email;
  String? Password;
  String uid;
  String? PhoneNumber;
  List<String> favs;

  User(
      {this.SerialNumber,
      this.Birthdate,
      this.TCKN,
      this.Name,
      this.Surname,
      this.ValidUntil,
      this.Email,
      this.Password,
      required this.uid,
      this.PhoneNumber,
      required this.favs});

  Map<String, dynamic> toMap() {
    return {
      'SerialNumber': SerialNumber,
      'Birthdate': Birthdate,
      'TCKN': TCKN,
      'Name': Name,
      'Surname': Surname,
      'ValidUntil': ValidUntil,
      'Email': Email,
      'Password': Password,
      'PhoneNumber': PhoneNumber,
      'Favs': favs
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      SerialNumber: map['SerialNumber'],
      Birthdate: map['Birthdate'],
      TCKN: map['TCKN'],
      Name: map['Name'],
      Surname: map['Surname'],
      ValidUntil: map['ValidUntil'],
      Email: map['Email'],
      Password: map['Password'],
      uid: map['id'],
      PhoneNumber: map['PhoneNumber'],
      favs: List<String>.from(map['Favs'] ?? []),
    );
  }
}
