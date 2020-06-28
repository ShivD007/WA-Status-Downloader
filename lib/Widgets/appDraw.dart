import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/tabindexProvider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TabController _tabController;
    final y = Provider.of<TabIndexProvider>(context);
    return Drawer(
        child: ListView(
      // shrinkWrap: true,

      children: <Widget>[
        _drawHeader(context),
        Container(
          child: _drawItem(context, y),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 0.05),
                colors: [Color(0xFF00E676), Colors.white10]),
          ),
        )
      ],
    ));
  }

  Widget _drawHeader(BuildContext context) {
    return DrawerHeader(
        child: Container(),
        margin: EdgeInsets.only(bottom: 0.0, top: 0),
        curve: Curves.bounceInOut,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wahead.png'),
            fit: BoxFit.cover,
          ),
        ));
  }

//
  Widget _drawItem(BuildContext context, var y) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        InkWell(
          child: ListTile(
            leading: Icon(Icons.image),
            title: Text("Status"),
          ),
          onTap: () {
            Navigator.pop(context);
            y.getindx(0);
            
          },
        ),
        InkWell(
          child: ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Saved"),
          ),
          onTap: () {
            Navigator.pop(context);
            y.getindx(1);
            
          },
        ),
      ],
    );
  }
}
