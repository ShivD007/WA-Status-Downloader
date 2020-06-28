import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageVideoProviders with ChangeNotifier {
  List<String> _list = new List<String>();
  List<String> _list1 = new List<String>();

  List<String> get getlist {
    return [..._list];
  }

  List<String> get getvideoList {
    return [..._list1];
  }

  void getData(Directory dir) async {
    _list = [];
    _list = await dir
        .listSync()
        .map((e) => e.path)
        .where((element) => element.endsWith(".jpg"))
        .toList(growable: false);
    notifyListeners();
  }

  void getVid(Directory dir) async {
    _list1 = [];
    _list1 = await dir
        .listSync()
        .map((e) => e.path)
        .where((element) => element.endsWith(".mp4"))
        .toList();
    notifyListeners();
  }

  Future<void> delete(String filePath, int flag) async {
    try {
      await File(filePath).delete();
    } catch (e) {
      print(e);
    }
    if (flag == 0) {
      final imgtemp = _list.toList();
      imgtemp.removeAt(_list.indexOf(filePath));
      _list = imgtemp;
      notifyListeners();
    } else {
      final vidtemp = _list.toList();
      vidtemp.removeAt(_list.indexOf(filePath));
      _list = vidtemp;
      notifyListeners();
    }
  }
}
