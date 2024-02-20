import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Custom/custom_color.dart';
import '../services/firebase_service.dart';

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

AuthService _auth = AuthService();

class _addAddState extends State<addAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "İlan başlığı",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: advertTitle,
                  maxLength: 50,
                  minLines: 1,
                  maxLines: 2,
                ),
                Text(
                  "İlan açıklaması",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: advertDescription,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 6,
                ),
                Text(
                  "Adres",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: Address,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 6,
                ),
                Text(
                  "Fiyat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextFormField(
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
                                          border:
                                              Border.all(color: Colors.red)),
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
                        "fotoğrafları temizle",
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
                      child: Text("fotoğraf seç"),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (!selectedImages.isEmpty &&
                          advertDescription.text != "" &&
                          advertTitle.text != "" &&
                          Address.text != "" &&
                          advertPrice.text != "") {
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
                        ? CircularProgressIndicator()
                        : Text("İlan ver"))
              ],
            ),
          ),
        ]),
      ),
    );
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
    DateTime now = DateTime.now();
    String month = now.month.toString().padLeft(2, '0');
    String date = '${now.day}.${month}.${now.year}';
    String hour = '${now.hour}:${now.minute}:${now.second}';

    for (var image in selectedImages) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _imageUrls.add(downloadUrl);
    }
    await _auth.registerAds(
        images: _imageUrls,
        uid: widget.userData['id'],
        date: date,
        hour: hour,
        address: address,
        description: description,
        title: title,
        price: price);
    setState(() {
      uploading = false;
      selectedImages.clear();
      _imageUrls.clear();
      Navigator.pop(context);
    });
  }
}
