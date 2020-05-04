import 'package:flutter/material.dart';
import 'package:flutterbubblegame/src/Home.dart';
import 'package:flutterbubblegame/src/Provider/ShootingProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider<ShootingProvider>(create:(_)=>ShootingProvider(),child: MaterialApp(home : HomePlate())));
}

