import 'package:flutter/material.dart';
import 'package:instagram/pages/instagram_main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      home: const InstagramMain(title: 'Instagram'),
    );
  }
}