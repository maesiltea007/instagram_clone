import 'package:flutter/material.dart';
import 'package:instagram/pages/instagram_main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // 써도 되고, 빼도 됨. 어차피 밑에서 색 강제로 박음
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          surfaceTintColor: Colors.transparent, // 이거 안 없애면 살짝 물든다
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey, // 붉은기 싫으면 무난한 회색 정도
          brightness: Brightness.light,
        ),
      ),
      home: const InstagramMain(title: 'Instagram'),
    );
  }
}