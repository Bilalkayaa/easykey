import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/custom/custom_color.dart';
import 'package:easykey/models/message.dart';
import 'package:flutter/material.dart';

import '../services/firebase_message_service.dart';

class chatPage extends StatefulWidget {
  const chatPage(
      {super.key,
      required this.id,
      required this.name,
      required this.userData});
  final String id;
  final String name;
  final userData;
  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  final TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: CustomColors.primaryColor,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userData['id'])
                .collection('chat')
                .doc(widget.id)
                .collection('messages')
                .orderBy('timestamp', descending: false)
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

              final messages = snapshot.data!.docs;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      curve: Curves.decelerate,
                      duration: Duration(milliseconds: 500));
                } else {
                  print("ScrollController has no clients.");
                }
              });
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        late bool myMessage;
                        final data = messages[index].data();
                        String message =
                            data['message']; // Mesaj alanından veriyi alın

                        if (data['senderID'] == widget.userData['id']) {
                          myMessage = true;
                        } else {
                          myMessage = false;
                        }
                        return Align(
                          alignment: myMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: message.length.toDouble() * 9 + 55 >
                                    MediaQuery.of(context).size.width * 0.8
                                ? MediaQuery.of(context).size.width * 0.8
                                : message.length.toDouble() * 9 + 55,
                            child: Card(
                                color: myMessage ? Colors.green : Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                margin: EdgeInsets.all(5),
                                child: ListTile(
                                  title: Text(
                                    message,
                                    textAlign: myMessage
                                        ? TextAlign.right
                                        : TextAlign.left,
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        // Metin girişi
                        Expanded(
                          child: TextFormField(
                            controller: _textController,

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: CustomColors.secondaryColor)),
                                hintText: 'Mesajınızı yazın...'),
                            // Klavye ile enter'a basılınca gönder
                            onFieldSubmitted: _handleSubmitted,
                          ),
                        ),
                        // Gönderme düğmesi
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _handleSubmitted(_textController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  void _handleSubmitted(String text) {
    // Burada metni işleyebilirsiniz, örneğin metni bir veritabanına kaydedebilirsiniz.
    Message _message = Message(
        senderID: widget.userData['id'],
        senderEmail: widget.userData['Email'],
        receiverId: widget.id,
        message: text,
        timestamp: Timestamp.now());
    print("Gönderilen mesaj: $text");
    _messageService.sendMessage(widget.userData['id'], widget.id, _message);
    _textController.clear(); // Text alanını temizle
  }
}
