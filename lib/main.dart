import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageVideoProviders>(
          create: (ctx) => ImageVideoProviders(),
        ),
        ChangeNotifierProvider<TabIndexProvider>(
          create: (ctx) => TabIndexProvider(),
        ),
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
