import 'package:flutter/material.dart';
import 'package:pokedex/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Poke Idenfier',
      home: MySplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
