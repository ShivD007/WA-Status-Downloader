import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:providert/Providers/imageVideoProvider.dart';
import 'package:providert/Providers/tabindexProvider.dart';
import 'package:providert/value_function.dart';
import 'package:path/path.dart' as path;
import 'package:providert/Widgets/videoplayer_widget.dart';
import 'package:share_extend/share_extend.dart';

class View extends StatefulWidget {
  // final  list;
  final index;
  final int flag;
  const View(
      {Key key,
      // this.list,
      this.index,
      this.flag})
      : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController controller;
  int positioned;
  var check;
  var tabindex;
  @override
  void initState() {
    controller = PageController(
      initialPage: widget.index,
    );
    positioned = widget.index;

    tabindex = Provider.of<TabIndexProvider>(context, listen: false);

    //check = Provider.of<CheckSaved>(context, listen: false);

    // TODO: implement initState
    super.initState();
  }

  List<String> _list = [];
  var provider;

  Future<void> _saveFile(
    BuildContext context,
  ) async {
    final _nameList = _list[positioned].split("/");
    final _fileName = _nameList[_nameList.length - 1];
    Directory _dir = Directory('/storage/emulated/0/statusdownloader');
    if (!_dir.existsSync()) {
      _dir = await _dir.create(recursive: true);
    }

    Uint8List _byteList = await File(_list[positioned]).readAsBytes();

    await File(Directory(path.join(_dir.path, _fileName)).path)
        .writeAsBytes(_byteList);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('File saved to InternalStorage/statusdownloader'),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    widget.flag == 0
        ? _list = Provider.of<ImageVideoProviders>(context).getlist
        : _list = Provider.of<ImageVideoProviders>(context).getvideoList;

    return WillPopScope(
      onWillPop: () async {
        if (isLoading.value == true) {
          tabindex.getindx(1);
        } else {
          tabindex.getindx(0);
        }

        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              PageView.builder(
                controller: controller,
                key: Key(_list.length
                    .toString()), // whenever something changes it forces the PageView to rebuild
                onPageChanged: (int page) {
                  setState(() {
                    positioned = page;
                  });
                },
                itemCount: _list.length,
                itemBuilder: (context, positioned) {
                  // final int position = widget.index;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: Center(
                      child: widget.flag == 0
                          ? Hero(
                              tag: _list[positioned],
                              child: Image.file(File(_list[positioned])))

                          // Hero(tag: position, child:  )
                          : VideoViewer(path: _list[positioned]),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      positioned.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await ShareExtend.share(_list[positioned],
                            widget.flag == 0 ? "image" : "video");

                        //  final ByteData bytes =
                        //     await rootBundle.load(_list[positioned]);
                        // final tempList =
                        //     _list[positioned].toString().split("/");
                        // final filename = tempList[tempList.length - 1];
                        // print(filename + "ggggggggggggggggggggggggggggggg");
                        // await Share.file(
                        //     'esys image',
                        //     filename,
                        //     bytes.buffer.asUint8List(),
                        //     "${widget.flag == 0 ? "image/*" : "video/*"}",
                        //     text:
                        //         'Send by WA Status Downloader. To share mre status like this go and downlaod');
                      },
                    )),
              ),
              ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) {
                    if (value == false) {
                      return Align(
                          alignment: Alignment.topRight + Alignment(-0.3, 0),
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: IconButton(
                                icon: Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await _saveFile(context);
                                },
                              )));
                    } else {
                      return Align(
                        alignment: Alignment.topRight + Alignment(-0.3, 0),
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Provider.of<ImageVideoProviders>(context,
                                        listen: false)
                                    .delete(_list[positioned], widget.flag);

                                if (_list.length == 1) {
                                  if (isLoading.value == true) {
                                    tabindex.getindx(1);
                                  }

                                  Navigator.of(context).pop();
                                } else if (positioned == _list.length) {
                                  positioned -= 1;
                                }

                                //  if(positioned == 0 && _list.isNotEmpty ){
                                //     positioned = positioned + 1;

                                //  }else{
                                //positioned = positioned -1;

                                //  }
                              },
                            )),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
