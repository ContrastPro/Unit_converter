import 'package:flutter/material.dart';
import 'package:unit_converter/back_layer/home.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurpleAccent[700],
        accentColor: Colors.deepPurple[100],
        splashColor: Colors.purpleAccent[100],
      ),
      home: MyHomePage(),
    );
  }
}
