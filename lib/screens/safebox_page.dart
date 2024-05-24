import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easykey/Custom/custom_color.dart';
import 'package:flutter/material.dart';

class safeBox extends StatefulWidget {
  const safeBox({super.key, required this.onUploadPressed});
  final Function(String, String) onUploadPressed;

  @override
  State<safeBox> createState() => _safeBoxState();
}

class _safeBoxState extends State<safeBox> {
  String? safeBoxNumber;
  String? boxDoorNumber;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kasa Numarası Seçiniz.",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: CustomColors.secondaryColor)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: CustomColors.secondaryColor))),
                value: safeBoxNumber,
                onChanged: (String? newValue) {
                  setState(() {
                    safeBoxNumber = newValue ?? "denemevalue1";
                  });
                  print('Yeni değer seçildi: $newValue');
                },
                items: <String>[
                  '1001',
                  '1002',
                  '1003',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Kasa Kapı Numarası Seçiniz.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: CustomColors.secondaryColor)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: CustomColors.secondaryColor))),
                value: boxDoorNumber,
                items: <String>[
                  '1',
                  '2',
                  '3',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    boxDoorNumber = newValue ?? "denemevalue2";
                  });
                  print('Yeni değer seçildi: $newValue');
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (boxDoorNumber == null && safeBoxNumber == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hata'),
                        content: Text(
                            'Kasa numarası veya Kasa kapı numarası boş olamaz!'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Firestore koleksiyonunu ve sorguyu kullanarak belirli bir safeBoxNumber'ı ara
                  checkthebox();
                },
                child: Text(
                  "İlan ver",
                )),
          ],
        ),
      ),
    );
  }

  Future<void> checkthebox() async {
    _handleButtonClick();
    var querySnapshot = await FirebaseFirestore.instance
        .collection('safebox')
        .where('safeboxnumber', isEqualTo: safeBoxNumber)
        .get();

    // Belirli bir safeBoxNumber'a karşılık gelen belge var mı kontrol et
    if (querySnapshot.docs.isNotEmpty) {
      // Belge bulunduğunda, boxDoorNumber değerini al
      var doc = querySnapshot.docs.first;
      var doorNumber;
      if (boxDoorNumber == "1") {
        doorNumber = doc['boxdoornumber1'];
      } else if (boxDoorNumber == "2") {
        doorNumber = doc['boxdoornumber2'];
      } else if (boxDoorNumber == "3") {
        doorNumber = doc['boxdoornumber3'];
      }

      // boxDoorNumber değeri 1 ise hata mesajı göster
      if (doorNumber == '1') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Seçmiş oldunuğunuz kasa dolu!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tamam'),
              ),
            ],
          ),
        );
        return;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Uyarı"),
              content: Text("Anahtarı kasaya bıraktığınızdan emin olun!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialogu kapat
                  },
                  child: Text("Tamam"),
                ),
              ],
            );
          },
        );
        // Eğer belirli bir safeBoxNumber bulunamadı veya boxDoorNumber 1 değilse, işlemi devam ettir
        widget.onUploadPressed(safeBoxNumber!, boxDoorNumber!);

        // boxDoorNumber değerini 1'e ayarla
        if (boxDoorNumber == "1") {
          await FirebaseFirestore.instance
              .collection('safebox')
              .doc(doc.id)
              .update({'boxdoornumber1': "1"});
        }
        if (boxDoorNumber == "2") {
          await FirebaseFirestore.instance
              .collection('safebox')
              .doc(doc.id)
              .update({'boxdoornumber2': "1"});
        }
        if (boxDoorNumber == "3") {
          await FirebaseFirestore.instance
              .collection('safebox')
              .doc(doc.id)
              .update({'boxdoornumber3': "1"});
        }
      }
    }
  }

  void _handleButtonClick() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {});
    setState(() {
      _isLoading = false;
    });
  }
}
