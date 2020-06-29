import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../Providers/imageVideoProvider.dart';

class Grid extends StatelessWidget {
  const Grid({Key key, @required this.provider, this.flag}) : super(key: key);

  final ImageVideoProviders provider;
  final int flag;

  @override
  Widget build(BuildContext context) {
    List<String> _tempList =
        flag == 0 ? provider.getlist : provider.getvideoList;

    return GridView.builder(
        shrinkWrap: true,
        itemCount: _tempList.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 140),
        itemBuilder: (ctx, index) {
          return flag == 0
              ? InkWell(
                  child: Container(
                      child: Hero(
                    tag: provider.getlist[index],
                    child: Image.file(
                      File(provider.getlist[index]),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                    ),
                  )),
                  onTap: () {
                    return Navigator.of(context).pushNamed("/view",
                        arguments: {"index": index, "flag": flag});
                  })
              : InkWell(
                  onTap: () {
                    return Navigator.of(context).pushNamed("/view",
                        arguments: {"index": index, "flag": flag});
                  },
                  child: ThumbNail(videoPath: _tempList[index]));
        });
  }
}

class ThumbNail extends StatefulWidget {
  final String videoPath;
  ThumbNail({this.videoPath});

  @override
  _ThumbNailState createState() => _ThumbNailState();
}

class _ThumbNailState extends State<ThumbNail> {
  VideoPlayerController _playerController;
  @override
  void initState() {
    super.initState();
    getThumbNail();
  }

  getThumbNail() async {
    _playerController = VideoPlayerController.file(File(widget.videoPath));

    await _playerController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _playerController.value.initialized
        ? VideoPlayer(_playerController)
        : Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ));
  }
}
