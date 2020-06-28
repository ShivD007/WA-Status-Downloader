import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:providert/Screens/homePage.dart';
import 'package:providert/Providers/imageVideoProvider.dart';
import 'package:providert/Providers/tabindexProvider.dart';
import 'package:providert/routes.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  





  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Directory _dir;
bool _isGranted = false;

  bool _isPathValid = true;

    @override
  void initState() {
    super.initState();
    _dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
    _checkPermissionStatus();
  }
  void _showDialog(title, content, actionButton, [launch]) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title, style: Theme.of(context).textTheme.headline6),
            content:
                Text(content, style: Theme.of(context).textTheme.bodyText1),
            actions: <Widget>[
              FlatButton(
                child: Text(actionButton[0],
                    style: Theme.of(context).textTheme.bodyText1),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              launch != null
                  ? FlatButton(
                      onPressed: () => OpenAppstore.launch(
                          androidAppId: "com.whatsapp&hl=en",
                          iOSAppId: "310633997"),
                      child: Text(actionButton[1],
                          style: Theme.of(context).textTheme.bodyText1))
                  : Container(),
            ],
          );
        });
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      //do nothing in this case
      setState(() {
        _isGranted = true;
      });
      _checkDir();
    } else if (status.isPermanentlyDenied) {
      _showDialog(
          "Open Phone Setting",
          "open phone setting to use the app by granting the required permission",
          ["Ok"]);
    } else {
      _askForPermission();
    }
  }

  Future<void> _askForPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      setState(() {
        _isGranted = true;
      });
      _checkDir(
          title: "Install Whatsapp",
          content:
              "You need to install Whatsapp to get access to your friend's status",
          actionButtons: ["Ok", "Download"],
          launch: "having4thpar");
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void _checkDir(
      {String title,
      String content,
      List<String> actionButtons,
      String launch}) {
    if (!Directory(_dir.path).existsSync()) {
      setState(() {
        _isPathValid = false;
      });
      _showDialog(title, content, actionButtons, launch);
    }
  }

  // Future<bool> _onBackPressed() async {
    

  //   return showDialog(
  //     context: context,
  //     builder: (context) => new AlertDialog(
  //       title: new Text('Are you sure?'),
  //       content: new Text('Do you want to exit from App'),
  //       actions: <Widget>[
  //         new GestureDetector(
  //           onTap: () => Navigator.of(context).pop(false),
  //           child: Text("NO"),
  //         ),
  //         SizedBox(height: 30),
  //         new GestureDetector(
  //           onTap: () => Navigator.of(context).pop(true),
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 10.0),
  //             child: Text("YES"),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }















  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider<ImageVideoProviders>(create: (ctx)=> ImageVideoProviders(),),
        ChangeNotifierProvider<TabIndexProvider>(create: (ctx)=> TabIndexProvider(),),
        
      ],
       
          child: MaterialApp(
        title: 'WA Status Downlaoder',
        theme: ThemeData(
         
          primarySwatch: white,
 
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/home",
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);



