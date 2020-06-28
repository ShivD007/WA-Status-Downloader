import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providert/Screens/ImageScreen.dart';
import 'package:providert/Widgets/appDraw.dart';
import '../Providers/tabindexProvider.dart';

import 'package:providert/value_function.dart';
import 'package:providert/Screens/videoScreen.dart';

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

  

  final Directory dir = new Directory("/storage/emulated/0/WhatsApp/Media/.Statuses");
  final Directory savedir = new Directory('/storage/emulated/0/statusdownloader'); 
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
            Container( height: 60,
                       width: 60, 
              child: FlatButton(child: Image.asset("assets/images/wa.png"), onPressed: (){

           
              },))
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
                  child: Text("Recents", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
                Tab(
                  child: Text("Saved",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              ]),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController, children: [
          Homebody(dir: dir, isdownload: false,),
          Homebody(dir: savedir,isdownload: true,) ,
        ]));
  }
}

class Homebody extends StatefulWidget {
  const Homebody({
    Key key,
    @required this.dir, this.isdownload,
  }) : super(key: key);

  final Directory dir;
  final bool isdownload;

  @override
  _HomebodyState createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
   bool _isVideo = true;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){isLoading.value = widget.isdownload;});
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
   
          Padding(
          padding: const EdgeInsets.all(10),
          child: Text("Images",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
          Expanded(child: ImageScreen(flag: 0, dir: widget.dir)),
    
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text("Video",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: VideoScreen(
            flag: 1,
            dir: widget.dir,
          ),
        )
      ],
    );
  }
}
