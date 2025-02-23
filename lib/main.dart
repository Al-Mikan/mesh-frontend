import 'package:flutter/material.dart';
import 'package:mesh_frontend/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '待ち合わせアプリ',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const HomePage(),
    );
  }
}