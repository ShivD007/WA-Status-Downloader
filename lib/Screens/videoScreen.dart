import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providert/Screens/grid.dart';

import '../Providers/imageVideoProvider.dart';

class VideoScreen extends StatefulWidget {
  final int flag;
  final Directory dir;
  VideoScreen({Key key, this.flag, this.dir}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;

    Provider.of<ImageVideoProviders>(context, listen: false).getVid(widget.dir);

    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vidlist = Provider.of<ImageVideoProviders>(context, listen: true);
    final g =
        Provider.of<ImageVideoProviders>(context, listen: true).getvideoList;

    return Container(
        child: !_isLoading
            ? g.length == 0
                ?   Container(
                    child: Center(
                    child: Image.asset("assets/images/nodata.png"),
                  ))
                : Grid(
                    provider: vidlist,
                    flag: widget.flag,
                  )
            : Center(child: new CircularProgressIndicator()));
  }
}
