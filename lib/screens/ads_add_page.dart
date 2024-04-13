import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/services/firebase_post_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Custom/custom_color.dart';
import '../services/firebase_auth_service.dart';

class addAdd extends StatefulWidget {
  const addAdd({super.key, required this.userData});
  final Map<String, dynamic> userData;
  @override
  State<addAdd> createState() => _addAddState();
}

List<String> _imageUrls = [];
bool flagphoto = false;
bool uploading = false;
List<File> selectedImages = [];
final picker = ImagePicker();

TextEditingController advertTitle = TextEditingController();

TextEditingController advertDescription = TextEditingController();

TextEditingController Address = TextEditingController();

TextEditingController advertPrice = TextEditingController();

Postservice _post = Postservice();

class _addAddState extends State<addAdd> {
  @override
  void dispose() {
    uploading = false;
    selectedImages.clear();
    _imageUrls.clear();
    advertTitle.clear();
    advertDescription.clear();
    advertPrice.clear();
    Address.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "İLAN BAŞLIĞI",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: customInputDecoration(),
                  controller: advertTitle,
                  maxLength: 50,
                  minLines: 1,
                  maxLines: 2,
                ),
                Text(
                  "İLAN AÇIKLAMASI",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: customInputDecoration(),
                  controller: advertDescription,
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ADRES",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: customInputDecoration(),
                  controller: Address,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "FİYAT",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: customInputDecoration(flag: true),
                  controller: advertPrice,
                  maxLength: 50,
                  minLines: 1,
                  maxLines: 2,
                ),
                selectedImages.isEmpty
                    ? SizedBox(
                        child: Text(
                          "Eklenecek Fotoğrafları seçin!",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : selectedImages.length > 10
                        ? SizedBox(
                            child: Text(
                              "Maximum 10 fotoğraf seçebilirsiniz!",
                              style: TextStyle(fontSize: 30),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "FOTOĞRAFLAR",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedImages.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  CustomColors.secondaryColor)),
                                      child: kIsWeb
                                          ? Image.network(
                                              selectedImages[index].path)
                                          : Image.file(selectedImages[index]),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        selectedImages.clear();
                        setState(() {});
                      },
                      child: Text(
                        "Fotoğrafları Temizle!",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // selectedImages.clear();

                        getImages();

                        setState(() {
                          flagphoto = true;
                        });
                      },
                      child: Text("Fotoğraf Seç"),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (!selectedImages.isEmpty &&
                          advertDescription.text != "" &&
                          advertTitle.text != "" &&
                          Address.text != "" &&
                          advertPrice.text != "" &&
                          isNumeric(advertPrice.text)) {
                        _uploadAds(Address.text, advertTitle.text,
                            advertDescription.text, advertPrice.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Lütfen boş alanları doldurunuz!')));
                      }
                    },
                    child: uploading
                        ? CircularProgressIndicator(
                            color: CustomColors.secondaryColor,
                          )
                        : Text("İlan Ver"))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool isNumeric(String str) {
    for (var i = 0; i < str.length; i++) {
      if (str.codeUnitAt(i) < 48 || str.codeUnitAt(i) > 57) {
        return false;
      }
    }
    return true;
  }

  InputDecoration customInputDecoration({bool flag = false}) {
    return InputDecoration(
        suffixText: flag ? "\u20BA" : "",
        suffixStyle:
            TextStyle(color: CustomColors.secondaryColor, fontSize: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: CustomColors.secondaryColor)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.secondaryColor)));
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Seçim yapılmadı')));
        }
      },
    );
  }

  Future<void> _uploadAds(
      String address, String title, String description, String price) async {
    setState(() {
      uploading = true;
    });
    final Timestamp timestamp = Timestamp.now();

    for (var image in selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _imageUrls.add(downloadUrl);
    }
    await _post.registerAds(
        images: _imageUrls,
        uid: widget.userData['id'],
        timestamp: timestamp,
        address: address,
        description: description,
        title: title,
        price: price);
    setState(() {
      uploading = false;
      selectedImages.clear();
      _imageUrls.clear();
      advertTitle.clear();
      advertDescription.clear();
      advertPrice.clear();
      Address.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlanınız başarıyla oluşturuldu')));
    });
  }
}
