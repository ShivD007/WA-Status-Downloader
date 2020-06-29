import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providert/Screens/grid.dart';

import '../Providers/imageVideoProvider.dart';

class ImageScreen extends StatefulWidget {
  final int flag;
  final Directory dir;

  const ImageScreen({this.flag, this.dir, Key key}) : super(key: key);

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;

    Provider.of<ImageVideoProviders>(context, listen: false)
        .getData(widget.dir);

    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imglist = Provider.of<ImageVideoProviders>(context, listen: true);
    return !_isLoading
        ?  imglist.getlist.isEmpty ? Container(child: Image.asset("assets/images/nodata.png"),) :Grid(provider: imglist, flag: widget.flag)
        : Center(child: CircularProgressIndicator());
  }
}
