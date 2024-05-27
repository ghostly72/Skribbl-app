import 'package:flutter/material.dart';
import 'package:skribbl/create_room_screen.dart';
import 'package:skribbl/home_screen.dart';
// import 'package:skribbl/home_screen.dart';
import 'package:skribbl/paintscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skribbl',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
