import 'package:flutter/material.dart';
import 'screens/index.dart';

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