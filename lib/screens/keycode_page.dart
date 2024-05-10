import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class keycodePage extends StatefulWidget {
  const keycodePage({super.key});

  @override
  State<keycodePage> createState() => _keycodePageState();
}

class _keycodePageState extends State<keycodePage> {
  void initState() {
    super.initState();
    // Arka planda çalışmayı sağlayacak işlev
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChannels.lifecycle.setMessageHandler((msg) {
        if (msg == AppLifecycleState.resumed.toString()) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
        }
        return Future.value('');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşunun işlevsiz hale getirilmesi
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Text("Countdown"),
        ),
      ),
    );
  }
}
