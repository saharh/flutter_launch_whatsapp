import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  void whatsAppOpen(String app) async {
    bool whatsapp = await FlutterLaunch.hasApp(name: app);

    if (whatsapp) {
      await FlutterLaunch.launchApp(app: app, phone: "5534992016545", message: "Hello");
    } else {
      print("$app not installed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Whatsapp",
                  )
                ],
              ),
              onPressed: () {
                whatsAppOpen(App.WHATSAPP);
              },
            ),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Whatsapp Business",
                  )
                ],
              ),
              onPressed: () {
                whatsAppOpen(App.WHATSAPP_BUSINESS);
              },
            ),
          ],
        )),
      ),
    );
  }
}
