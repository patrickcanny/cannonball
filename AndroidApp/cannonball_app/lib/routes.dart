import 'package:flutter/material.dart';

class Routes {
  final routes = <String, WidgetBuilder>{

  };

  Routes () {
    runApp(new MaterialApp(
      title: 'Cannonall',
      routes: routes,
//      home: new SignIn(),
    ));
  }
}