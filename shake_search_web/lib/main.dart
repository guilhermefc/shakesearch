import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shake_search/presentation/home/home_page.dart';

void main() {
  runApp(const MyApp());
  RendererBinding.instance.setSemanticsEnabled(true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      home: const Scaffold(body: SafeArea(child: HomePage())),
    );
  }
}
