import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../Custom/custom_color.dart';
import '../controllers/extract_data_controller.dart';
import 'id_detail_screen.dart';

class idScan extends StatefulWidget {
  const idScan(
      {super.key,
      required this.email,
      required this.password,
      required this.phonenumber});
  final String password;
  final String email;
  final String phonenumber;
  @override
  State<idScan> createState() => _idScanState();
}

bool isNumericString(String str) {
  if (str.isEmpty) {
    return false;
  }

  for (int i = 0; i < str.length; i++) {
    if (!isDigit(str.codeUnitAt(i))) {
      return false;
    }
  }

  return true;
}

bool isDigit(int codeUnit) {
  return codeUnit >= 48 &&
      codeUnit <= 57; // ASCII değerleri arasında rakamların aralığı
}

class _idScanState extends State<idScan> {
  @override
  void dispose() {
    super.dispose();
  }

  ExtractDataController extractDataController =
      Get.put(ExtractDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: Container(
          child: Text(
            "Kimlik Tarama",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Lütfen sizin ve tüm kullanıcılarımız güvenliği açısından kimliğinizi taratınız.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    (extractDataController.imagePaths.isEmpty)
                        ? Lottie.asset('assets/animations/id_card_scan.json')
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Visibility(
                              visible: extractDataController
                                  .imagePath.value.isNotEmpty,
                              child: SizedBox(
                                  height: 200,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          File(extractDataController
                                              .imagePaths.last),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                extractDataController
                                                    .idBirthdate.value = '';
                                                extractDataController
                                                    .idSerialNumber.value = '';
                                                extractDataController
                                                    .idValidUntil.value = '';
                                                extractDataController
                                                    .imagePath.value = '';
                                                extractDataController.imagePaths
                                                    .clear();
                                                extractDataController
                                                    .barcodeValue = '';
                                              });
                                              // deliveryDocumentController.imagePaths.removeAt(index);
                                              // deliveryDocumentController.capturedImageCount.value--;
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 30,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.054,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => CustomColors.primaryColor,
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                              ))),
                          child: const Text(
                            "Scan ID Card",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await extractDataController.getImage();
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => Visibility(
                        visible: extractDataController.imagePaths.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.054,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                      (states) => CustomColors.primaryColor,
                                    ),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(11)),
                                    ))),
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  await extractDataController.processImage();

                                  print(
                                      "VV:barcodeValue: ${extractDataController.barcodeValue}");
                                  print(
                                      "VV:idSerialNumber: ${extractDataController.idSerialNumber.value}");
                                  print(
                                      "VV:idBirthdate: ${extractDataController.idBirthdate.value}");
                                  print(
                                      "VV:idValidUntil: ${extractDataController.idValidUntil.value}");

                                  if (extractDataController.barcodeValue !=
                                          '' || // if back side
                                      extractDataController
                                              .idSerialNumber.value ==
                                          '' ||
                                      extractDataController.idBirthdate.value ==
                                          '' ||
                                      extractDataController.idValidUntil.value ==
                                          '' ||
                                      extractDataController.idName.value ==
                                          '' ||
                                      extractDataController.idSurname.value ==
                                          '' ||
                                      extractDataController.idTCKN == '' ||
                                      isNumericString(extractDataController
                                              .idTCKN.string) ==
                                          false ||
                                      extractDataController.idTCKN
                                              .toString()
                                              .length <
                                          11 ||
                                      extractDataController.idTCKN
                                              .toString()
                                              .length >
                                          11) {
                                    print("tck problemi");
                                    // Get.snackbar(
                                    //   'Hata',
                                    //   "Kimlik kartı fotoğrafından bazı veriler alınamadı. Lütfen fotoğraf kalitesini kontrol edip tekrar deneyin...",
                                    //   backgroundColor: Colors.red,
                                    //   colorText: Colors.white,
                                    // );
                                  } else {
                                    // Get.snackbar(
                                    //   'Başarılı',
                                    //   'Veriler kimlik kartı fotoğrafından başarıyla alındı.',
                                    //   backgroundColor: Colors.green,
                                    //   colorText: Colors.white,
                                    // );
                                  }
                                  await Get.to(IdDetailPage(
                                    Email: widget.email,
                                    Password: widget.password,
                                    Phonenumber: widget.phonenumber,
                                  ));
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Telefonunuzun kimliğinize dik bir şekilde olduğundan emin olun!",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
