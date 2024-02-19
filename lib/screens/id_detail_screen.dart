import 'package:easykey/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/extract_data_controller.dart';
import '../services/firebase_service.dart';

// ignore: must_be_immutable
class IdDetailPage extends StatelessWidget {
  IdDetailPage(
      {super.key,
      required this.Email,
      required this.Password,
      required this.Phonenumber});
  final String Email;
  final String Password;
  final String Phonenumber;
  ExtractDataController extractDataController =
      Get.put(ExtractDataController());

  TextStyle profileSettingsStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Color(0xff979797),
  );
  TextStyle userInfoStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.green,
  );

  bool flagvisible = true;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Card(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Center(
                  child: Text(
                    "DATA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "TC",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idTCKN.value == ''
                              ? "-"
                              : extractDataController.idTCKN.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Name Surname",
                              style: profileSettingsStyle,
                            )),
                        Expanded(
                          child: Text(
                            '${extractDataController.idName.value} ${extractDataController.idSurname.value}' ==
                                    ' '
                                ? '-'
                                : '${extractDataController.idName.value} ${extractDataController.idSurname.value}',
                            style: userInfoStyle,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Birthdate",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idBirthdate.value == ''
                              ? '-'
                              : extractDataController.idBirthdate.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Serial Number",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idSerialNumber.value == ''
                              ? '-'
                              : extractDataController.idSerialNumber.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color(0xFFEDECEC),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: Text(
                              "Valid Until",
                              style: profileSettingsStyle,
                            )),
                        Text(
                          extractDataController.idValidUntil.value == ''
                              ? "-"
                              : extractDataController.idValidUntil.value,
                          style: userInfoStyle,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lütfen kimlik bilgilerinizin doğruluğundan emin olunuz.Aksi halde tekrar fotoğraf çekiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const CircleBorder(),
                        elevation: 4,
                        shadowColor: Colors.green,
                        minimumSize: Size.fromRadius(24)),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                flagvisible
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          // onPressed: () {
                          //   _auth.signUp(context,
                          //       email: Email,
                          //       password: Password,
                          //       PhoneNumber: Phonenumber,
                          //       TCKN: "59308202616",
                          //       name: "bilal",
                          //       surname: "kaya",
                          //       Birthdate: "15.12.2000",
                          //       SerialNumber: "321",
                          //       ValidUntil: "123");
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => LoginPage(),
                          //       ));
                          // },
                          onPressed: () {
                            _auth.signUp(context,
                                email: Email,
                                password: Password,
                                PhoneNumber: Phonenumber,
                                TCKN: extractDataController.idTCKN.value,
                                name: extractDataController.idName.value,
                                surname: extractDataController.idSurname.value,
                                Birthdate:
                                    extractDataController.idBirthdate.value,
                                SerialNumber:
                                    extractDataController.idSerialNumber.value,
                                ValidUntil:
                                    extractDataController.idValidUntil.value);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },

                          child: Text(
                            'Giriş yap',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : Placeholder(
                        fallbackHeight: 20,
                        fallbackWidth: 20,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
