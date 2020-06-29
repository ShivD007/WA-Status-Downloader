import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:providert/Screens/ImageScreen.dart';
import 'package:providert/Widgets/appDraw.dart';
import 'package:store_launcher/store_launcher.dart';
import '../Providers/tabindexProvider.dart';
import 'package:providert/value_function.dart';
import 'package:providert/Screens/videoScreen.dart';
import 'package:android_intent/android_intent.dart';             

//import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

 
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  final Directory dir =
      new Directory("/storage/emulated/0/WhatsApp/Media/.Statuses");
  final Directory savedir =
      new Directory('/storage/emulated/0/statusdownloader');
  int flag = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<TabIndexProvider>(context);

    _tabController.animateTo(index.index);

    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            Container(
                height: 60,
                width: 60,
                child: FlatButton(
                  child: Image.asset("assets/images/wa.png"),
                  onPressed: ()  {
                  
                  AndroidIntent intent = AndroidIntent( data:  Uri.encodeFull("https://api.whatsapp.com/"), action: "action_view" , package: "com.android.chrome");
    intent.launch();
 

                  },
                ))
          ],
          elevation: 0,
          //title: Text("WhatsApp Status"),
          leading: FlatButton(
              child: Image.asset("assets/images/menu.jpg"),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              }),
          title: TabBar(
              indicatorWeight: 3,
              isScrollable: false,
              indicatorColor: Colors.teal,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.teal,
              tabs: [
                Tab(
                  child: Text(
                    "Recents",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    "Saved",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Homebody(
                dir: dir,
                isdownload: false,
              ),
              Homebody(
                dir: savedir,
                isdownload: true,
              ),
            ]));
  }
}

class Homebody extends StatefulWidget {
  const Homebody({
    Key key,
    @required this.dir,
    this.isdownload,
  }) : super(key: key);

  final Directory dir;
  final bool isdownload;

  @override
  _HomebodyState createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
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
                      // onPressed: () => OpenAppstore.launch(
                      //     androidAppId: "com.whatsapp&hl=en",
                      //     iOSAppId: "310633997"),
                      onPressed: () {
                        final appId = Platform.isAndroid
                            ? "com.whatsapp&hl=en"
                            : "310633997";

                        try {
                          StoreLauncher.openWithStore(appId).catchError((e) {
                            print('ERROR> $e');
                          });
                        } on Exception catch (e) {
                          print('$e');
                        }
                      },
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

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit from App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 30),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text("YES"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = widget.isdownload;
    });

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: _isGranted && _isPathValid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Images",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: ImageScreen(flag: 0, dir: widget.dir)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Video",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: VideoScreen(
                      flag: 1,
                      dir: widget.dir,
                    ),
                  )
                ],
              )
            : Container());
  }
}
