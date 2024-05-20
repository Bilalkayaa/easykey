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
            Container(
              width: 150,
              child: DropdownButtonFormField(
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
            Container(
              width: 150,
              child: DropdownButtonFormField(
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
            ElevatedButton(
              onPressed: () async {
                // Firestore koleksiyonunu ve sorguyu kullanarak belirli bir safeBoxNumber'ı ara
                checkthebox();
              },
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: CustomColors.secondaryColor,
                    )
                  : Text(
                      "İlan ver",
                    ),
            ),
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
      }
      if (boxDoorNumber == "2") {
        doorNumber = doc['boxdoornumber2'];
      }
      if (boxDoorNumber == "3") {
        doorNumber = doc['boxdoornumber3'];
      }

      // boxDoorNumber değeri 1 ise hata mesajı göster
      if (doorNumber == '1') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Kasa dolu'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tamam'),
              ),
            ],
          ),
        );
        return;
      }

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

  void _handleButtonClick() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
