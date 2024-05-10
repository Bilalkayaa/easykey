import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/Custom/custom_color.dart';
import 'package:easykey/screens/chat_page.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.userData});
  final userData;
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mesajlar")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userData['id'])
              .collection('chat')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Hata: ${snapshot.error}'),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              print("boş");
            }
            QuerySnapshot<Object?>? querySnapshot = snapshot.data;
            List<String> chatIds = [];
            List<String> chatNames = [];
            querySnapshot?.docs.forEach((doc) async {
              chatIds.add(doc.id);
              chatNames.add((await getUserNames(doc.id)));
            });

            print(chatNames);
            print(chatIds.length);
            return StreamBuilder(
              stream: _secondStream(chatIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Hata: ${snapshot.error}'),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: chatIds.length,
                  itemBuilder: (context, index) {
                    if (chatNames.isEmpty) {
                      // chatNames listesi boşsa
                      return Center(child: Text("Sohbet bulunamadı."));
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.all(10),
                      color: Colors.grey,
                      child: ListTile(
                        title: Text(chatNames[index]),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => chatPage(
                                        id: chatIds[index],
                                        name: chatNames[index],
                                        userID: widget.userData['id'],
                                      )));
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }

  Future<String> getUserNames(String userIds) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? userName;

    // Her bir kullanıcı kimliği için Firestore'dan belgeleri al

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('id', isEqualTo: userIds)
        .get();

    // Belge bulunduysa ve "Name" alanı varsa, kullanıcı adını al
    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

      if (userData.containsKey('Name')) {
        userName = userData['Name'];
      }
    }

    print(userName);
    return userName ?? "asdqw";
  }

  Stream<QuerySnapshot> _secondStream(List<String> chatIds) async* {
    // İkinci Firestore sorgusunu, ilk sorgunun sonucuna göre bir Stream olarak döndür

    for (var i = 0; i < chatIds.length; i++) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: chatIds[i])
          .get();
    }
  }
}
