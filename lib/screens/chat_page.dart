import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  const chatPage(
      {super.key, required this.id, required this.name, required this.userID});
  final String id;
  final String name;
  final String userID;
  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userID)
                .collection('chat')
                .doc(widget.id)
                .collection('messages')
                .orderBy('timestamp', descending: true)
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
              final messages = snapshot.data!.docs;

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  late bool myMessage;
                  final data = messages[index].data();
                  final message =
                      data['message']; // Mesaj alanından veriyi alın

                  if (data['receiverID'] == widget.userID) {
                    myMessage = true;
                  } else {
                    myMessage = false;
                  }
                  return Card(
                      color: myMessage ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(
                          message,
                          textAlign:
                              myMessage ? TextAlign.right : TextAlign.left,
                        ),
                      ));
                },
              );
            }));
  }
}
