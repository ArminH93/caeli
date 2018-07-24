import 'package:flutter/material.dart';
import './ui/caeli.dart';

void main() async{
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Caeli',
    //default route of the app
    home: new Caeli(),
  ));
}