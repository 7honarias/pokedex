import 'package:flutter/material.dart';
import 'package:pokedex/dbpokemon.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  //ImageProvider logo = AssetImage("assets/pokemon.png");
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MyHomePage(),
      image: Image.asset("assets/pokemon.png"),
      photoSize: 220.0,
      title: Text(
        'Bienvenido',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(
            0xFFFFFF,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
