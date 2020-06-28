import 'package:flutter/material.dart';
import 'package:providert/Screens/homePage.dart';
import 'package:providert/view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/home":
      return MaterialPageRoute(builder: (context) => MyHomePage());
    case "/view":
      final Map<String, dynamic> _argument = settings.arguments;
      final index = _argument["index"];
      final flag = _argument["flag"];
      return MaterialPageRoute(
          builder: (context) => View(
                
                index: index,
                flag: flag,
              ));
    default:
  }
}
