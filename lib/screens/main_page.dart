import 'dart:io';

import 'package:easykey/screens/ads_add_page.dart';
import 'package:easykey/screens/advertisement_page.dart';
import 'package:easykey/screens/myads_page.dart';
import 'package:easykey/screens/profile_page.dart';
import 'package:easykey/services/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.uid, required this.userData});
  final String uid;
  final userData;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ScrollController scrollController;
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      print(scrollController.offset);
    });
    super.initState();
  }

  List<String> imageUrl = ["dasd", "ewqqe", "ewqeq"];
  List<String> imagePaths = [];
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addAdd(userData: widget.userData),
                  ));
            },
            // onPressed: () async {
            //   // ImagePicker imagePicker = ImagePicker();
            //   // XFile? file =
            //   //     await imagePicker.pickImage(source: ImageSource.gallery);
            //   List<XFile>? images = await ImagePicker().pickMultiImage();
            //   // print('${file?.path}');
            //   for (XFile image in images) {
            //     imagePaths.add(image.path);
            //   }
            //   print(imagePaths);
            //   //Import dart:core
            //   String uniqueFileName =
            //       DateTime.now().millisecondsSinceEpoch.toString();

            //   /*Step 2: Upload to Firebase storage*/
            //   //Install firebase_storage
            //   //Import the library

            //   //Get a reference to storage root
            //   Reference referenceRoot = FirebaseStorage.instance.ref();
            //   Reference referenceDirImages = referenceRoot.child('images');

            //   //Create a reference for the image to be stored
            //   Reference referenceImageToUpload =
            //       referenceDirImages.child('${uniqueFileName}.jpg');

            //   //Handle errors/success
            //   try {
            //     //Store the file

            //     // await referenceImageToUpload.putFile(File(file.path));
            //     for (String path in imagePaths) {
            //       await referenceImageToUpload.putFile(File(path));
            //       print('$path yüklendi.');
            //     }
            //     //Success: get the download URL
            //     // imageUrl = await referenceImageToUpload.getDownloadURL();
            //     imageUrl = ["asda", "eqwe"];
            //     _auth.registerAds(
            //       images: imageUrl,
            //       uid: widget.userData['id'],
            //     );
            //   } catch (error) {
            //     //Some error occurred
            //   }
            // },
            child: Icon(Icons.add_rounded)),
        appBar: AppBar(
          title: Text("EasyKey"),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(children: [
          advertPage(),
          Container(),
          myAdsPage(id: widget.uid),
          profilePage(uid: widget.uid, userData: widget.userData)
        ]),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          elevation: 0,
          notchMargin: 5,
          shape: CircularNotchedRectangle(),
          child: TabBar(tabs: [
            Tab(
              text: "İlanlar",
              icon: Icon(Icons.home),
            ),
            Tab(
              text: "Favorilerim",
              icon: Icon(Icons.favorite),
            ),
            Tab(
              text: "İlanlarım",
              icon: Icon(Icons.list),
            ),
            Tab(
              text: "Hesabım",
              icon: Icon(Icons.account_circle),
            )
          ]),
        ),
      ),
    );
  }
}
